// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cancel_response_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CancelResponseModel _$CancelResponseModelFromJson(Map<String, dynamic> json) =>
    CancelResponseModel(
      message: json['message'] as String,
      success: json['success'] as bool,
    );

Map<String, dynamic> _$CancelResponseModelToJson(
  CancelResponseModel instance,
) => <String, dynamic>{
  'message': instance.message,
  'success': instance.success,
};
