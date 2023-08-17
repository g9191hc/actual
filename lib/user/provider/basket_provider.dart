import 'package:actual/common/dio/dio.dart';
import 'package:actual/product/model/product_model.dart';
import 'package:actual/user/model/basket_item_model.dart';
import 'package:actual/user/model/patch_basket_body.dart';
import 'package:actual/user/repository/user_me_repository.dart';
import 'package:debounce_throttle/debounce_throttle.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

//리스트의 firstWhereOrNull 메서드를 사용하기 위해 collection라이브러리 import
import 'package:collection/collection.dart';

final basketProvider =
StateNotifierProvider<BasketProvider, List<BasketItemModel>>((ref) {
  final repository = ref.watch(userMeRepositoryProvider);
  return BasketProvider(repository: repository);
});

class BasketProvider extends StateNotifier<List<BasketItemModel>> {
  final UserMeRepository repository;
  final updateBasketDebounce = Debouncer(
    const Duration(seconds: 1),
    initialValue: null,
    checkEquality: false,
  );

  //state 추가
  BasketProvider({required this.repository}) : super([]) {
    updateBasketDebounce.values.listen((state) {
      patchBasket();
    });
  }

  //장바구니에 물건을 1개 추가하는 메서드
  //기존에 장바구니에 있었으면 count +=1(만약 있었는데 count가 1 미만이었으면 1로 변경), 없었으면 추가하면서 count = 1
  Future<void> addToBasket({
    required ProductModel product,
  }) async {
    final exsits =
        state.firstWhereOrNull((e) => e.product.id == product.id) != null;

    if (exsits) {
      final exsistingProduct =
      state.firstWhere((e) => e.product.id == product.id);
      if (exsistingProduct.count < 1) {
        state.map((e) => e.product.id == product.id ? e.copyWith(count: 1) : e);
      } else {
        state = state
            .map((e) =>
        e.product.id == product.id ? e.copyWith(count: e.count + 1) : e)
            .toList();
      }
    } else {
      state = [
        ...state,
        BasketItemModel(product: product, count: 1),
      ];
    }

    //Optimistic Response
    //Debouncer는 observable의 자손으로, setValue함수를 통해 등록되어 있는 listen메서드를 실행
    updateBasketDebounce.setValue(null);
  }

  //장바구니에서 물건을 1개 빼거나 삭제하는 메서드
  // 기존에 장바구니에 없었으면 그냥 함수종료,
  // 있었는데 1개이하였거나 isDelete가 true면 제거,
  // 1개보다 많았으면 count -= 1
  Future<void> removeFromBasket({
    required ProductModel product,
    bool isDelete = false,
  }) async {
    final exsits =
        state.firstWhereOrNull((e) => e.product.id == product.id) != null;

    if (!exsits) return;

    final exsitingProduct = state.firstWhere((e) => e.product.id == product.id);
    if (exsitingProduct.count <= 1 || isDelete) {
      state = state.where((e) => e.product.id != product.id).toList();
    } else {
      state = state
          .map((e) =>
      e.product.id == product.id ? e.copyWith(count: e.count - 1) : e)
          .toList();
    }
    //Optimistic Response
    updateBasketDebounce.setValue(null);
  }

  Future<void> patchBasket() async {
    await repository.patchBasket(
      body: PatchBasketBody(
        basket: state
            .map(
              (e) =>
              PatchBasketBodyBasket(
                productId: e.product.id,
                count: e.count,
              ),
        )
            .toList(),
      ),
    );
  }
}
