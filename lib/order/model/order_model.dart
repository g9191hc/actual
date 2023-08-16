import 'package:actual/common/model/model_with_id.dart';
import 'package:actual/common/utils/data_utils.dart';
import 'package:actual/restaurant/model/restaurant_model.dart';
import 'package:json_annotation/json_annotation.dart';

part 'order_model.g.dart';

// https://$ip/order
@JsonSerializable()
class OrderProductModel {
  final String id;
  final String name;
  @JsonKey(fromJson: DataUtils.pathToUrl)
  final String detail;
  final String imgUrl;
  final int price;

  OrderProductModel({
    required this.id,
    required this.name,
    required this.detail,
    required this.imgUrl,
    required this.price,
  });

  factory OrderProductModel.fromJson(Map<String, dynamic> json) =>
      _$OrderProductModelFromJson(json);

  Map<String, dynamic> toJson() => _$OrderProductModelToJson(this);
}


@JsonSerializable()
class OrderProductAndCountModel {
  final OrderProductModel product;
  final int count;

  OrderProductAndCountModel({
    required this.product,
    required this.count,
  });

  factory OrderProductAndCountModel.fromJson(Map<String, dynamic> json) =>
      _$OrderProductAndCountModelFromJson(json);

  Map<String, dynamic> toJson() =>
      _$OrderProductAndCountModelToJson(this);
}

@JsonSerializable()
class OrderModel implements IModelWithId {
  final String id;
  final RestaurantModel restaurant;
  final int totalPrice;
  final List<OrderProductAndCountModel> products;
  @JsonKey(fromJson: DataUtils.stringToDateTime)
  final DateTime createdAt;

  OrderModel({
    required this.id,
    required this.restaurant,
    required this.totalPrice,
    required this.products,
    required this.createdAt,
  });

  factory OrderModel.fromJson(Map<String, dynamic> json) =>
      _$OrderModelFromJson(json);

  Map<String, dynamic> toJson() => _$OrderModelToJson(this);
}
