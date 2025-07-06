import 'package:json_annotation/json_annotation.dart';

part 'download_video_request_model.g.dart';

@JsonSerializable()
class DownloadVideoRequestModel {
  @JsonKey(name: "url")
  final String? url;
  @JsonKey(name: "quality")
  final String? quality;
  @JsonKey(name: "output_dir")
  final String? outputDir;

  DownloadVideoRequestModel ({
    this.url,
    this.quality,
    this.outputDir,
  });

  factory DownloadVideoRequestModel.fromJson(Map<String, dynamic> json) {
    return _$DownloadVideoRequestModelFromJson(json);
  }

  Map<String, dynamic> toJson() {
    return _$DownloadVideoRequestModelToJson(this);
  }
}


