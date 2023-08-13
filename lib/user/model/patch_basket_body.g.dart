// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'patch_basket_body.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PatchBasketBody _$PatchBasketBodyFromJson(Map<String, dynamic> json) =>
    PatchBasketBody(
      body: (json['body'] as List<dynamic>)
          .map((e) => PatchBasketBodyBasket.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$PatchBasketBodyToJson(PatchBasketBody instance) =>
    <String, dynamic>{
      'body': instance.body,
    };

PatchBasketBodyBasket _$PatchBasketBodyBasketFromJson(
        Map<String, dynamic> json) =>
    PatchBasketBodyBasket(
      productId: json['productId'] as String,
      count: json['count'] as int,
    );

Map<String, dynamic> _$PatchBasketBodyBasketToJson(
        PatchBasketBodyBasket instance) =>
    <String, dynamic>{
      'productId': instance.productId,
      'count': instance.count,
    };
