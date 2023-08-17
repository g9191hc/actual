import 'package:actual/common/model/model_with_id.dart';
import 'package:actual/common/repository/base_pagination_repository.dart';
import 'package:debounce_throttle/debounce_throttle.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../model/cursor_pagination_model.dart';
import '../model/pagination_params.dart';

class _PaginationInfo {
  final int fetchCount;
  final bool fetchMore;
  final bool forceRefetch;

  _PaginationInfo({
    //한번에 가져올 요소 갯수
    this.fetchCount = 20,
    //true : CursorPaginationFetchingMore(추가데이터 요청)
    //false : CursorPaginationRefetching(새로고침(현재상태 덮어씌움))
    this.fetchMore = false,
    //true : CursorPaginationLoading(초기화)
    this.forceRefetch = false,
  });
}

class PaginationProvider<T extends IModelWithId,
        U extends IBasePaginationRepository<T>>
    extends StateNotifier<CursorPaginationBase> {
  final U repository;
  final paginationThrottle = Throttle(
    const Duration(seconds: 3),
    initialValue: _PaginationInfo(),
    checkEquality: false,
  );

  PaginationProvider({
    required this.repository,
  }) : super(CursorPaginationLoading()) {
    paginate();
    paginationThrottle.values.listen((state) {
      _throttledPagination(state);
    });
  }

  Future<void> paginate({
    //한번에 가져올 요소 갯수
    int fetchCount = 20,
    //true : CursorPaginationFetchingMore(추가데이터 요청)
    //false : CursorPaginationRefetching(새로고침(현재상태 덮어씌움))
    bool fetchMore = false,
    //true : CursorPaginationLoading(초기화)
    bool forceRefetch = false,
  }) async {
    //1개의 값만 전달이 가능하므로, 값이 여러개 일 경우 클래스를 만들어 그 인스턴스를 전달
    paginationThrottle.setValue(
      _PaginationInfo(
          fetchMore: fetchMore,
          fetchCount: fetchCount,
          forceRefetch: forceRefetch),
    );
  }

  Future<void> _throttledPagination(_PaginationInfo info) async {
    //5가지 상태
    // 1) CursorPagination - 정상데이터가 있는상태
    // 2) CursorPaginationLoading - 최초데이터 요청하여 로딩중 상태(현재 캐시 없음)
    // 3) CursorPaginationError - 에러가 있는 상태
    // 4) CursorPaginationRefetching - 첫페이지부터 다시 요청하여 로딩중 상태(현재 캐시 있음)
    // 5) CursorPaginationFetchingMore - 추가데이터를 요청하여 로딩중 상태(현재 캐시 있음)

    final fetchCount = info.fetchCount;
    final fetchMore = info.fetchMore;
    final forceRefetch = info.forceRefetch;

    try {
      // 1. 데이터 요청을 거부해야 하는 경우
      // 1-1. 현재 데이터가 있고(= 이미 요청한 적이 있고) 강제로 처음페이지를 받아야 하는 경우가 아닌 상태에서(forceRefetch = false)
      if (state is CursorPagination && !forceRefetch) {
        //state는 CursorPaginationBase이므로, 데이터에 접근이 가능한 CursorPagination 형태로 캐스팅 해줘야 함.
        //현재 데이터가 있으면서 데이터요청을 하지 않는 상태
        final pState = state as CursorPagination;

        // hasMore의 값이 false인 경우
        // (= 서버에서 더이상 가져올 데이터가 없는 경우)
        if (!pState.meta.hasMore) {
          return;
        }
      }
      //1-2. 세가지 로딩상태 중 하나이면서 fetchMore의 값이 true인 경우
      //    (= 이미 데이터요청을 해서 기다리고 있는데 그 상태에서 추가데이터 요청이 들어오는 경우, 그 추가데이터 요청은 무시
      final isLoading = state is CursorPaginationLoading;
      final isRefetching = state is CursorPaginationRefetching;
      final isFetchingMore = state is CursorPaginationFetchingMore;

      if (fetchMore && (isLoading || isRefetching || isFetchingMore)) {
        return;
      }

      // 2. 로직 시작
      // 2-1. PaginationParmas생성
      PaginationParams paginationParams = PaginationParams(
        count: fetchCount,
      );

      // 2-2. fetchMore(데이터 추가요청) = 현재 데이터가 있으며, 요청시 after(마지막요소ID)가 포함되어야 함
      // 2-2-1. 따라서 현재상태를 fetchingMore객체로 변경하고, 보낼 파라미터모델에 after를 추가함
      if (fetchMore) {
        //state는 CursorPaginationBase이므로, 데이터에 접근이 가능한 CursorPagination 형태로 캐스팅 해줘야 함.
        final pState = state as CursorPagination<T>;

        state = CursorPaginationFetchingMore(
          meta: pState.meta,
          data: pState.data,
        );

        paginationParams = paginationParams.copyWith(
          after: pState.data.last.id,
        );

        //데이터를 처음부터 가져오는 상황
      } else {
        //만약 데이터가 있는 상황인데 새로고침을 요청하는 경우
        // 기존데이터를 보존한 상태로 fetch 요청
        if (state is CursorPagination && !forceRefetch) {
          final pState = state as CursorPagination<T>;
          state = CursorPaginationRefetching<T>(
              meta: pState.meta, data: pState.data);
        } else {
          state = CursorPaginationLoading();
        }
      }

      // 요청 및 기다림(paginationParams에 after가 있으면 추가요청, 없으면 처음부터 가져옴)
      final resp =
          await repository.paginate(paginationParams: paginationParams);

      // 추가요청이었으면, 응답받은 데이터를 기존데이터와 합침
      if (state is CursorPaginationFetchingMore<T>) {
        final pState = state as CursorPaginationFetchingMore<T>;

        //응답받은 응답(resp)에서 data부만, 기존data에 응답data를 합치도록 함
        state = resp.copyWith(data: [
          ...pState.data,
          ...resp.data,
        ]);
        // 추가요청이 아니었으면, 응답으로 기존데이터를 덮어씌움
      } else {
        state = resp;
      }
    } catch (e, stack) {
      print(e);
      print(stack);
      state = CursorPaginationError(errMessage: '데이터를 가져오지 못 했습니다.');
    }
  }
}
