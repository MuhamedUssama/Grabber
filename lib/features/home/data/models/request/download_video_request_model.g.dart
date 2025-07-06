// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'download_video_request_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DownloadVideoRequestModel _$DownloadVideoRequestModelFromJson(
  Map<String, dynamic> json,
) => DownloadVideoRequestModel(
  url: json['url'] as String?,
  quality: json['quality'] as String?,
  outputDir: json['output_dir'] as String?,
);

Map<String, dynamic> _$DownloadVideoRequestModelToJson(
  DownloadVideoRequestModel instance,
) => <String, dynamic>{
  'url': instance.url,
  'quality': instance.quality,
  'output_dir': instance.outputDir,
};
