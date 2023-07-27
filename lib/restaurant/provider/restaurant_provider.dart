import 'package:actual/common/model/cursor_pagination_model.dart';
import 'package:actual/restaurant/model/restaurant_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../repository/restaurant_repository.dart';

final restaurantProvider =
    StateNotifierProvider<RestaurantStateNotifier, CursorPaginationBase>(
  (ref) => RestaurantStateNotifier(
    repository: ref.watch(
      restaurantRepositoryProvider,
    ),
  ),
);

class RestaurantStateNotifier extends StateNotifier<CursorPaginationBase> {
  final RestaurantRepository repository;

  RestaurantStateNotifier({
    required this.repository,
  }) : super(CursorPaginationLoading()) {
    //생성자 호출시 실행될 함수를 바디에 추가
    paginate();
  }

  void paginate({
    //한번에 가져올 요소 갯수
    int fetchCount = 20,

    //true : CursorPaginationFetchingMore(추가데이터 요청)
    //false : CursorPaginationRefetching(새로고침(현재상태 덮어씌움))
    fetchMore = false,

    //true : CursorPaginationLoading(초기화)
    bool forceRefetch = false,
  }) async {
    //5가지 상태
    // 1) CursorPagination - 정상데이터가 있는상태
    // 2) CursorPaginationLoading - 최초데이터 요청하여 로딩중 상태(현재 캐시 없음)
    // 3) CursorPaginationError - 에러가 있는 상태
    // 4) CursorPaginationRefetching - 첫페이지부터 다시 요청하여 로딩중 상태(현재 캐시 있음)
    // 5) CursorPaginationFetchingMore - 추가데이터를 요청하여 로딩중 상태(현재 캐시 있음)

    // 1. 데이터 요청을 하지 않는 경우
    // 1-1. 현재 데이터가 있고(= 이미 요청한 적이 있고) 강제로 처음페이지를 받아야 하는 경우가 아닌 상태에서(forceRefetch = false)
    if (state is CursorPagination && !forceRefetch) {
      final pState = state as CursorPagination; //CursorPagination상속객체를 제외시킴

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
  }
}
