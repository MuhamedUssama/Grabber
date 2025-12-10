import 'package:json_annotation/json_annotation.dart';

part 'cancel_response_model.g.dart';

@JsonSerializable()
class CancelResponseModel {
  @JsonKey(name: 'message')
  final String message;
  @JsonKey(name: 'success')
  final bool success;

  CancelResponseModel({required this.message, required this.success});

  factory CancelResponseModel.fromJson(Map<String, dynamic> json) =>
      _$CancelResponseModelFromJson(json);
  Map<String, dynamic> toJson() => _$CancelResponseModelToJson(this);
}
