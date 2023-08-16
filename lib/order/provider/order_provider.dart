import 'package:actual/common/provider/pagination_provider.dart';
import 'package:actual/order/model/post_order_body.dart';
import 'package:actual/user/provider/basket_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

import '../../common/model/cursor_pagination_model.dart';
import '../model/order_model.dart';
import '../repository/order_repository.dart';

final orderProvider = StateNotifierProvider<OrderStateNotifier,
    CursorPaginationBase>(
  (ref) {
    final repo = ref.watch(orderRepositoryProvider);
    return OrderStateNotifier(
      ref: ref, repository: repo,
    );
  },
);

class OrderStateNotifier
    extends PaginationProvider<OrderModel, OrderRepository> {
  final Ref ref;

  OrderStateNotifier({
    required this.ref,
    required super.repository,
  });

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
