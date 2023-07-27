import 'package:actual/restaurant/model/restaurant_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../repository/restaurant_repository.dart';

final restaurantProvider =
    StateNotifierProvider<RestaurantStateNotifier, List<RestaurantModel>>(
  (ref) => RestaurantStateNotifier(
    repository: ref.watch(
      restaurantRepositoryProvider,
    ),
  ),
);

class RestaurantStateNotifier extends StateNotifier<List<RestaurantModel>> {
  final RestaurantRepository repository;

  RestaurantStateNotifier({
    required this.repository,
  }) : super([]) {
    //생성자 호출시 실행될 함수를 바디에 추가
    paginate();
  }

  paginate() async {
    //repository의 페이지네이션 실행;
    final resp = await repository.paginate();

    //관리하고 있는 객체에 받아온 값을 대입;
    state = resp.data;
  }
}
