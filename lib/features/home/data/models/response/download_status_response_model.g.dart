// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'download_status_response_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DownloadStatusResponseModel _$DownloadStatusResponseModelFromJson(
  Map<String, dynamic> json,
) => DownloadStatusResponseModel(
  data: Data.fromJson(json['data'] as Map<String, dynamic>),
  error: Error.fromJson(json['error'] as Map<String, dynamic>),
  success: json['success'] as bool,
);

Map<String, dynamic> _$DownloadStatusResponseModelToJson(
  DownloadStatusResponseModel instance,
) => <String, dynamic>{
  'data': instance.data,
  'error': instance.error,
  'success': instance.success,
};

Error _$ErrorFromJson(Map<String, dynamic> json) =>
    Error(code: json['code'] as String, message: json['message'] as String);

Map<String, dynamic> _$ErrorToJson(Error instance) => <String, dynamic>{
  'code': instance.code,
  'message': instance.message,
};

Data _$DataFromJson(Map<String, dynamic> json) => Data(
  error: json['error'] as String,
  progress: (json['progress'] as num).toDouble(),
  result: json['result'] as String,
  status: json['status'] as String,
);

Map<String, dynamic> _$DataToJson(Data instance) => <String, dynamic>{
  'error': instance.error,
  'progress': instance.progress,
  'result': instance.result,
  'status': instance.status,
};
