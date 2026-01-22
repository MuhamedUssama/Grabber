// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'download_video_response_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DownloadVideoResponseModel _$DownloadVideoResponseModelFromJson(
  Map<String, dynamic> json,
) => DownloadVideoResponseModel(
  data: Data.fromJson(json['data'] as Map<String, dynamic>),
  success: json['success'] as bool,
);

Map<String, dynamic> _$DownloadVideoResponseModelToJson(
  DownloadVideoResponseModel instance,
) => <String, dynamic>{'data': instance.data, 'success': instance.success};

Data _$DataFromJson(Map<String, dynamic> json) =>
    Data(message: json['message'] as String, taskId: json['task_id'] as String);

Map<String, dynamic> _$DataToJson(Data instance) => <String, dynamic>{
  'message': instance.message,
  'task_id': instance.taskId,
};
