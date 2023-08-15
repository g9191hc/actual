// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'order_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

OrderProductModel _$OrderProductModelFromJson(Map<String, dynamic> json) =>
    OrderProductModel(
      id: json['id'] as String,
      name: json['name'] as String,
      detail: DataUtils.pathToUrl(json['detail'] as String),
      imgUrl: json['imgUrl'] as String,
      price: json['price'] as int,
    );

Map<String, dynamic> _$OrderProductModelToJson(OrderProductModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'detail': instance.detail,
      'imgUrl': instance.imgUrl,
      'price': instance.price,
    };

OrderProductAndCountModel _$OrderProductAndCountModelFromJson(
        Map<String, dynamic> json) =>
    OrderProductAndCountModel(
      product:
          OrderProductModel.fromJson(json['product'] as Map<String, dynamic>),
      count: json['count'] as int,
    );

Map<String, dynamic> _$OrderProductAndCountModelToJson(
        OrderProductAndCountModel instance) =>
    <String, dynamic>{
      'product': instance.product,
      'count': instance.count,
    };

OrderModel _$OrderModelFromJson(Map<String, dynamic> json) => OrderModel(
      id: json['id'] as String,
      restaurant:
          RestaurantModel.fromJson(json['restaurant'] as Map<String, dynamic>),
      totalPrice: json['totalPrice'] as int,
      products: (json['products'] as List<dynamic>)
          .map((e) =>
              OrderProductAndCountModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      createdAt: DataUtils.stringToDateTime(json['createdAt'] as String),
    );

Map<String, dynamic> _$OrderModelToJson(OrderModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'restaurant': instance.restaurant,
      'totalPrice': instance.totalPrice,
      'products': instance.products,
      'createdAt': instance.createdAt.toIso8601String(),
    };
