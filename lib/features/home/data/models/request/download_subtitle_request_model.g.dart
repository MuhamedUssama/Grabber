// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'download_subtitle_request_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DownloadSubtitleRequestModel _$DownloadSubtitleRequestModelFromJson(
  Map<String, dynamic> json,
) => DownloadSubtitleRequestModel(
  url: json['url'] as String,
  lang: json['lang'] as String,
  outputDir: json['output_dir'] as String?,
);

Map<String, dynamic> _$DownloadSubtitleRequestModelToJson(
  DownloadSubtitleRequestModel instance,
) => <String, dynamic>{
  'url': instance.url,
  'lang': instance.lang,
  'output_dir': instance.outputDir,
};
