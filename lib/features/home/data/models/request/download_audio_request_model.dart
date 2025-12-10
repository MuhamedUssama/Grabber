import 'package:json_annotation/json_annotation.dart';

part 'download_audio_request_model.g.dart';

@JsonSerializable()
class DownloadAudioRequestModel {
  @JsonKey(name: 'url')
  final String url;
  @JsonKey(name: 'output_dir')
  final String outputDir;
  @JsonKey(name: 'output_format')
  final String outputFormat;

  DownloadAudioRequestModel({
    required this.url,
    required this.outputDir,
    required this.outputFormat,
  });

  factory DownloadAudioRequestModel.fromJson(Map<String, dynamic> json) =>
      _$DownloadAudioRequestModelFromJson(json);
  Map<String, dynamic> toJson() => _$DownloadAudioRequestModelToJson(this);
}
