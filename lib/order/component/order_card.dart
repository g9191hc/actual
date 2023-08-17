import 'package:actual/common/const/colors.dart';
import 'package:flutter/material.dart';

import '../model/order_model.dart';

class OrderCard extends StatelessWidget {
  final DateTime orderDate;
  final Image image;
  final String name;
  final String productsDetail;
  final int price;

  const OrderCard({
    super.key,
    required this.orderDate,
    required this.image,
    required this.name,
    required this.productsDetail,
    required this.price,
  });

  factory OrderCard.fromModel({required OrderModel model}) {
    // OrderCard가 있다는 것은 제품이 최소 1개 이상이라는 뜻
    // 1개면 해당제품만, 2개이상이면 첫번째 제품 외 (n-1)개라고 표시
    final productsDetail = model.products.length == 1
        ? model.products.first.product.name
        : '${model.products.first.product.name}외 ${model.products.length - 1}개';

    return OrderCard(
      orderDate: model.createdAt,
      image: Image.network(
        model.restaurant.thumbUrl,
        height: 50,
        width: 50,
      ),
      name: model.restaurant.name,
      productsDetail: productsDetail,
      price: model.totalPrice,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
            '${orderDate.year}.${orderDate.month.toString().padLeft(2, '0')}.${orderDate.day.toString().padLeft(2, '0')} 주문완료'),
        const SizedBox(height: 8.0,),
        Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(16.0),
              child: image,
            ),
            const SizedBox(
              width: 16.0,
            ),
            IntrinsicWidth(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    name,
                    style: TextStyle(
                      fontSize: 14.0,
                    ),
                  ),
                  Text(
                    '$productsDetail $price원',
                    style: TextStyle(
                      color: BODY_TEXT_COLOR,
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                ],
              ),
            )
          ],
        )
      ],
    );
  }
}
