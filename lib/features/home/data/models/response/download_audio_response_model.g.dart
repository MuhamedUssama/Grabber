// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'download_audio_response_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DownloadAudioResponseModel _$DownloadAudioResponseModelFromJson(
  Map<String, dynamic> json,
) => DownloadAudioResponseModel(
  data: Data.fromJson(json['data'] as Map<String, dynamic>),
  success: json['success'] as bool,
);

Map<String, dynamic> _$DownloadAudioResponseModelToJson(
  DownloadAudioResponseModel instance,
) => <String, dynamic>{'data': instance.data, 'success': instance.success};

Data _$DataFromJson(Map<String, dynamic> json) =>
    Data(message: json['message'] as String, taskId: json['task_id'] as String);

Map<String, dynamic> _$DataToJson(Data instance) => <String, dynamic>{
  'message': instance.message,
  'task_id': instance.taskId,
};
