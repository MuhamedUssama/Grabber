import 'package:json_annotation/json_annotation.dart';

part 'download_subtitle_request_model.g.dart';

@JsonSerializable()
class DownloadSubtitleRequestModel {
  @JsonKey(name: 'url')
  final String url;
  @JsonKey(name: 'lang')
  final String lang;
  @JsonKey(name: 'output_dir')
  final String outputDir;

  DownloadSubtitleRequestModel({
    required this.url,
    required this.lang,
    required this.outputDir,
  });

  factory DownloadSubtitleRequestModel.fromJson(Map<String, dynamic> json) => _$DownloadSubtitleRequestModelFromJson(json);
  Map<String, dynamic> toJson() => _$DownloadSubtitleRequestModelToJson(this);
}