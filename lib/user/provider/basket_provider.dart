import 'package:actual/product/model/product_model.dart';
import 'package:actual/user/model/basket_item_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

//리스트의 firstWhereOrNull 메서드를 사용하기 위해 collection라이브러리 import
import 'package:collection/collection.dart';

class BasketProvider extends StateNotifier<List<BasketItemModel>> {
  //state 추가
  BasketProvider() : super([]);

  //장바구니에 물건을 1개 추가하는 메서드
  //기존에 장바구니에 있었으면 count +=1, 없었으면 추가하고 count = 1
  Future<void> addToBasket({
    required ProductModel product,
  }) async {
    final exsits =
        state.firstWhereOrNull((e) => e.product.id == product.id) != null;

    if (exsits) {
      state = state
          .map((e) =>
              e.product.id == product.id ? e.copyWith(count: e.count + 1) : e)
          .toList();
    } else {
      state = [
        ...state,
        BasketItemModel(product: product, count: 1),
      ];
    }
  }

  //장바구니에서 물건을 1개 빼거나 삭제하는 메서드
  //기존에 장바구니에 없었으면 그냥 함수종료, 있었는데 1개였으면 제거, 1개보다 많았으면 count -= 1
  //만약 isDelete가 true면 무조건 제거

  Future<void> removeFromBasket({
    required ProductModel product,
    required bool isDelete,
  }) async {
    final exsits =
        state.firstWhereOrNull((e) => e.product.id == product.id) != null;

    if (!exsits) return;

    final exsitingProduct = state.firstWhere((e) => e.product.id == product.id);
    if (exsitingProduct.count == 1 || isDelete) {
      state = state.where((e) => e.product.id != product.id).toList();
    } else {
      state = state
          .map((e) =>
              e.product.id == product.id ? e.copyWith(count: e.count - 1) : e)
          .toList();
    }
  }
}
