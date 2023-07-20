import 'package:actual/restaurant/model/restaurant_model.dart';
import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';

import '../../common/const/data.dart';
import '../../common/utils/data_utils.dart';

part 'restaurant_detail_model.g.dart';

@JsonSerializable()
class utils extends RestaurantModel {
  final String detail;
  final List<RestaurantProductModel> products;

  utils({
    required super.id,
    required super.name,
    @JsonKey(fromJson: DataUtils.pathToUrl)
    required super.thumbUrl,
    required super.tags,
    required super.priceRange,
    required super.ratings,
    required super.ratingsCount,
    required super.deliveryTime,
    required super.deliveryFee,
    required this.detail,
    required this.products,
  });

  factory utils.fromJson(Map<String, dynamic> json){
      return _$RestaurantDetailModelFromJson(json);
  }
}
@JsonSerializable()
class RestaurantProductModel {
  final String id;
  final String name;
  final String imgUrl;
  final String detail;
  final int price;

  RestaurantProductModel({
    required this.id,
    required this.name,
    required this.imgUrl,
    required this.detail,
    required this.price,
  });

  factory RestaurantProductModel.fromJson(Map<String, dynamic> json){
      return _$RestaurantProductModelFromJson(json);
  }
}
