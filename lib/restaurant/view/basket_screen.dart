import 'package:actual/common/const/colors.dart';
import 'package:actual/common/layout/default_layout.dart';
import 'package:actual/order/provider/order_provider.dart';
import 'package:actual/order/view/order_done_screen.dart';
import 'package:actual/product/component/product_card.dart';
import 'package:actual/product/provider/product_provider.dart';
import 'package:actual/user/provider/basket_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class BasketScreen extends ConsumerWidget {
  static String get routeName => 'basket';

  const BasketScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final basket = ref.watch(basketProvider);

    if (basket.isEmpty) {
      return DefaultLayout(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                '장바구니가 텅~',
                textAlign: TextAlign.center,
              ),
              SizedBox(
                height: 8.0,
              ),
              ElevatedButton(
                onPressed: (){
                  context.pop();
                },
                child: Text('돌아가기'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: PRIMARY_COLOR,
                ),
              ),
            ],
          ),
        ),
      );
    }

    final productsTotal =
        basket.fold(0, (p, c) => p + c.product.price * c.count);
    final deliveryFee = basket.first.product.restaurant.deliveryFee;
    final totalPrice = productsTotal + deliveryFee;

    return DefaultLayout(
      title: '장바구니',
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            children: [
              Expanded(
                child: ListView.separated(
                  itemCount: basket.length,
                  separatorBuilder: (BuildContext context, int index) =>
                      Divider(
                    height: 32.0,
                  ),
                  itemBuilder: (_, index) {
                    final model = basket[index];
                    return ProductCard.fromProductModel(
                      model: model.product,
                      onAdd: () {
                        ref
                            .read(basketProvider.notifier)
                            .addToBasket(product: model.product);
                      },
                      onSubtract: () {
                        ref
                            .read(basketProvider.notifier)
                            .removeFromBasket(product: model.product);
                      },
                    );
                  },
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '장바구니 금액',
                        style: TextStyle(
                          color: BODY_TEXT_COLOR,
                        ),
                      ),
                      Text('₩ $productsTotal'),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '배달비',
                        style: TextStyle(
                          color: BODY_TEXT_COLOR,
                        ),
                      ),
                      if (basket.length > 0) Text('₩ $deliveryFee'),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '총액',
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Text('₩ $totalPrice')
                    ],
                  ),
                  ElevatedButton(
                      onPressed: () async {
                        final orderSuccess =
                        await ref.read(orderProvider.notifier).postOrder();
                        if (orderSuccess)
                          context.goNamed(OrderDoneScreen.routeName);
                        else
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('결제 실패!'),
                            ),
                          );
                      },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: PRIMARY_COLOR,
                    ),
                    child: Text(
                      '결제하기',
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
