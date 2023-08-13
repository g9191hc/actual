import 'package:actual/common/const/colors.dart';
import 'package:actual/restaurant/model/restaurant_detail_model.dart';
import 'package:actual/user/provider/basket_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../common/const/data.dart';
import '../model/product_model.dart';

class ProductCard extends ConsumerWidget {
  final Image image;
  final String name;
  final String detail;
  final int price;
  final String id;
  final VoidCallback? onAdd;
  final VoidCallback? onSubtract;

  ProductCard({
    required this.image,
    required this.name,
    required this.detail,
    required this.price,
    required this.id,
    this.onAdd,
    this.onSubtract,
    super.key,
  });

  factory ProductCard.fromRestaurantProductModel({
    required RestaurantProductModel model,
    VoidCallback? onAdd,
    VoidCallback? onSubtract,
  }) {
    return ProductCard(
      image: Image.network(
        model.imgUrl,
        width: 110,
        height: 110,
        fit: BoxFit.cover,
      ),
      name: model.name,
      detail: model.detail,
      price: model.price,
      id: model.id,
      onAdd: onAdd,
      onSubtract: onSubtract,
    );
  }

  factory ProductCard.fromProductModel({
    required ProductModel model,
    VoidCallback? onAdd,
    VoidCallback? onSubtract,
  }) {
    return ProductCard(
      image: Image.network(
        model.imgUrl,
        width: 110,
        height: 110,
        fit: BoxFit.cover,
      ),
      name: model.name,
      detail: model.detail,
      price: model.price,
      id: model.id,
      onAdd: onAdd,
      onSubtract: onSubtract,
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final basket = ref.watch(basketProvider);

    return IntrinsicHeight(
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8.0),
            child: image,
          ),
          const SizedBox(
            width: 16.0,
          ),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  name,
                  style: TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  detail,
                  style: TextStyle(
                    color: BODY_TEXT_COLOR,
                    fontSize: 14.0,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  '₩$price',
                  style: TextStyle(
                    color: PRIMARY_COLOR,
                    fontSize: 12.0,
                    fontWeight: FontWeight.w500,
                  ),
                  textAlign: TextAlign.right,
                ),
              ],
            ),
          ),
          if (onSubtract != null && onAdd != null)
            _Footer(
              total: (basket.firstWhere((e) => e.product.id == id).count *
                      basket
                          .firstWhere((e) => e.product.id == id)
                          .product
                          .price)
                  .toString(),
              count: basket.firstWhere((e) => e.product.id == id).count,
              onAdd: onAdd!,
              onSubtract: onSubtract!,
            ),
        ],
      ),
    );
  }
}

class _Footer extends StatelessWidget {
  final String total;
  final int count;
  final VoidCallback onAdd;
  final VoidCallback onSubtract;

  const _Footer({
    super.key,
    required this.total,
    required this.count,
    required this.onAdd,
    required this.onSubtract,
  });

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  '총액 ₩$total',
                  style: TextStyle(
                    color: PRIMARY_COLOR,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              Row(
                children: [
                  renderButton(icon: Icons.remove, onTap: onAdd),
                  Text(
                    count.toString(),
                    style: TextStyle(
                      color: PRIMARY_COLOR,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  renderButton(icon: Icons.add, onTap: onSubtract),
                ],
              )
            ],
          ),
        ],
      ),
    );
  }

  Widget renderButton({
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(
          8.0,
        ),
        border: Border.all(
          color: PRIMARY_COLOR,
          width: 1.0,
        ),
      ),
      child: InkWell(
        onTap: onTap,
        child: Icon(
          icon,
          color: PRIMARY_COLOR,
        ),
      ),
    );
  }
}
