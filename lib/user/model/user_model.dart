import 'package:json_annotation/json_annotation.dart';

import '../../common/utils/data_utils.dart';

part 'user_model.g.dart';

abstract class UserModelBase {}

class UserModelLoading extends UserModelBase {}

class UserModelError extends UserModelBase {
  final String errorMessage;

  UserModelError({
    required this.errorMessage,
  });
}

@JsonSerializable()
class UserModel extends UserModelBase {
  final String id;
  final String username;
  @JsonKey(
    fromJson: DataUtils.pathToUrl,
  )
  final String imageUrl;

  UserModel({
    required this.id,
    required this.username,
    required this.imageUrl,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);
}
