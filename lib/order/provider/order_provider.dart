import 'package:actual/order/model/post_order_body.dart';
import 'package:actual/user/provider/basket_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

import '../model/order_model.dart';
import '../repository/order_repository.dart';

final orderProvider =
    StateNotifierProvider<OrderStateNotifier, List<OrderModel>>(
        (ref) => OrderStateNotifier(ref: ref));

class OrderStateNotifier extends StateNotifier<List<OrderModel>> {
  final Ref ref;

  OrderStateNotifier({
    required this.ref,
  }) : super([]);

  Future<bool> postOrder() async {
    try {
      final uuid = Uuid();
      final id = uuid.v4();
      final state = ref.read(basketProvider);
      final repository = ref.read(orderRepositoryProvider);

      final products = state
          .map((e) =>
              PostOrderBodyProduct(productId: e.product.id, count: e.count))
          .toList();
      final totalPrice = state.fold(0, (p, c) => p + c.count * c.product.price);

      await repository.postOrder(
        body: PostOrderBody(
          id: id,
          products: products,
          totalPrice: totalPrice,
          createdAt: DateTime.now().toString(),
        ),
      );
      return true;
    } on Exception catch (e) {
      print('[ERR] $e');
      return false;
    }
  }
}
