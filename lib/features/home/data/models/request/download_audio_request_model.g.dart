// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'download_audio_request_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DownloadAudioRequestModel _$DownloadAudioRequestModelFromJson(
  Map<String, dynamic> json,
) => DownloadAudioRequestModel(
  url: json['url'] as String?,
  outputDir: json['output_dir'] as String?,
);

Map<String, dynamic> _$DownloadAudioRequestModelToJson(
  DownloadAudioRequestModel instance,
) => <String, dynamic>{'url': instance.url, 'output_dir': instance.outputDir};
