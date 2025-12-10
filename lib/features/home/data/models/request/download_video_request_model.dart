import 'package:json_annotation/json_annotation.dart';

part 'download_video_request_model.g.dart';

@JsonSerializable()
class DownloadVideoRequestModel {
  @JsonKey(name: 'url')
  final String url;
  @JsonKey(name: 'quality')
  final String quality;
  @JsonKey(name: 'output_dir')
  final String? outputDir;
  @JsonKey(name: 'with_audio')
  final bool withAudio;
  @JsonKey(name: 'output_format')
  final String? outputFormat;

  DownloadVideoRequestModel({
    required this.url,
    required this.quality,
    required this.outputDir,
    required this.withAudio,
    required this.outputFormat,
  });

  factory DownloadVideoRequestModel.fromJson(Map<String, dynamic> json) =>
      _$DownloadVideoRequestModelFromJson(json);
  Map<String, dynamic> toJson() => _$DownloadVideoRequestModelToJson(this);
}
