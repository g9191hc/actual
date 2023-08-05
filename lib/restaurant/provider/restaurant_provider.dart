import 'package:actual/common/model/cursor_pagination_model.dart';
import 'package:actual/common/provider/pagination_provider.dart';
import 'package:actual/restaurant/model/restaurant_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:collection/collection.dart';

import '../repository/restaurant_repository.dart';

final restaurantDetailProvider =
    Provider.family<RestaurantModel?, String>((ref, id) {
  final state = ref.watch(restaurantProvider);

  if (state is! CursorPagination) {
    return null;
  }

  //여기부터는 state가 CursorPagination이므로 data가 있음
  //만약 RestaurantModel이 null이면 예외를 던지지 않고 null을 반환하도록 함
  //그런경우는, ProductModel에서 restaurant id로 레스토랑에 접근하려고 하는데, RestaurantModel에는 데이터가 없는 경우임)
  return state.data.firstWhereOrNull((element) => element.id == id);
});

final restaurantProvider =
    StateNotifierProvider<RestaurantStateNotifier, CursorPaginationBase>(
  (ref) => RestaurantStateNotifier(
    repository: ref.watch(
      restaurantRepositoryProvider,
    ),
  ),
);

class RestaurantStateNotifier
    extends PaginationProvider<RestaurantModel, RestaurantRepository> {
  // PaginationProvider가 StateNotifier를 상속하는, StateNotifierProvider가 아닌 StateNotifier이며,
  // PaginationProvider에 정의해 놓은 것 처럼 RestaurantModel과 그 Model을 제네릭으로 받는 RestaurantRepository를 제네릭에 넣음
  RestaurantStateNotifier({
    required super.repository,
  });

  getDetail({
    required String id,
  }) async {
    //아직 데이터가 없는 상태인 경우(= CursorPagination이 아님) 데이터 가져오기 요청
    if (state is! CursorPagination<RestaurantModel>) {
      await paginate();
    }

    //요청시도 했음에도 아직 데이터가 없는 상태인 경우 null반환
    if (state is! CursorPagination<RestaurantModel>) return null;

    //본문(여기부터는 무조건 CursorPagination 상태)
    final pState = state as CursorPagination<RestaurantModel>;

    final resp = await repository.getRestaurantDetail(id: id);

    //해당하는 rid의 레스토랑이 현재 캐시(CursorPaginationModel의 data(=List<T>))로 없을 경우,
    //해당 rid의 레스토랑detail페이지(=레스토랑페이지의 인스턴스)만 요청해서 뒤에 붙여넣음
    //이 경우는 ProductScreen에서 제품 클릭시 해당 레스토랑의 detail페이지를 요청하는데,
    //레스토랑페이지의 캐시에는 해당 RestaurantModel이 없는 경우임
    if (pState.data.where((e) => e.id == id).isEmpty) {
      state = pState.copyWith(
        data: [
          ...pState.data,
          resp,
        ],
      );

    // '홈'탭의 레스토랑을 통해 레스토랑페이지를 요청하는 일반적인 경우로,
    // 이미 캐시에 존재하는 해당 RestaurantModel만을 RestaurantDetailModel로 변경
    } else {
      state = pState.copyWith(
        data: pState.data
            .map<RestaurantModel>(
              (e) => e.id == id ? resp : e,
            )
            .toList(),
      );
    }
  }
}
