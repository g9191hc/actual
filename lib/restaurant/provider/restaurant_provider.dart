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

  paginate({
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
  }
}
