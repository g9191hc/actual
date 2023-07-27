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
    //5가지 경우
    // 1) CursorPagination - 정상데이터가 있는상태
    // 2) CursorPaginationLoading - 데이터 로딩중 상태(현재 캐시 없음)
    // 3) CursorPaginationError - 에러가 있는 상태
    // 4) CursorPaginationRefetching - 첫페이지부터 다시 가져올 때(현재 캐시 있음)
    // 5) CursorPaginationFetchingMore - 추가데이터 요청을 받았을 때

    // 아무런 요청을 하지 않는 경우
    // 현재 데이터가 있고(= 이미 요청한 적이 있고) 그 중 fetchMore의 값이 false(서버에서 더이상 뒤에 데이터가 없는경우에 false)이면서
    // 강제로 처음페이지를 받아야 하는 경우(forceRefetch = true)가 아니라면, 아무런 요청을 하지 않음
    if (state is CursorPagination && !forceRefetch) {
      //CursorPagination을 상속받는 클래스가 아닌 정확히 CursorPagination임을 암시
      final pState = state as CursorPagination;

      if (!pState.meta.hasMore) {
        return;
      }
    }
  }
}
