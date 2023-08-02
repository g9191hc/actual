import 'package:actual/common/model/cursor_pagination_model.dart';
import 'package:actual/common/model/pagination_params.dart';
import 'package:actual/common/provider/pagination_provider.dart';
import 'package:actual/restaurant/model/restaurant_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../repository/restaurant_repository.dart';

final restaurantDetailProvider =
    Provider.family<RestaurantModel?, String>((ref, id) {
  final state = ref.watch(restaurantProvider);

  if (state is! CursorPagination) {
    return null;
  }

  //state is CursorPagination
  return state.data.firstWhere((element) => element.id == id);
});

final restaurantProvider =
    StateNotifierProvider<RestaurantStateNotifier, CursorPaginationBase>(
  (ref) => RestaurantStateNotifier(
    repository: ref.watch(
      restaurantRepositoryProvider,
    ),
  ),
);

class RestaurantStateNotifier extends PaginationProvider<RestaurantModel, RestaurantRepository> {

  //PaginationProvider가 StateNotifier를 상속하도록 했으며, repository를 가지고 있으므로, 그 repository를 사용
  RestaurantStateNotifier({
    required super.repository,
  });

  getDetail({
    required String id,
  }) async {
    //아직 데이터가 없는 상태인 경우(= CursorPagination이 아님) 데이터 가져오기 요청
    if (state is! CursorPagination) {
      await paginate();
    }

    //요청시도 했음에도 아직 데이터가 없는 상태인 경우 null반환
    if (state is! CursorPagination) return null;

    //본문(여기부터는 무조건 CursorPagination 상태)
    final pState = state as CursorPagination;

    final resp = await repository.getRestaurantDetail(id: id);

    state = pState.copyWith(
      data: pState.data
          .map<RestaurantModel>(
            (e) => e.id == id ? resp : e,
          )
          .toList(),
    );
  }
}
