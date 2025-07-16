import 'package:json_annotation/json_annotation.dart';

part 'download_video_response_model.g.dart';

@JsonSerializable()
class DownloadVideoResponseModel {
  @JsonKey(name: "file_path")
  final String? filePath;

  DownloadVideoResponseModel ({
    this.filePath,
  });

  factory DownloadVideoResponseModel.fromJson(Map<String, dynamic> json) {
    return _$DownloadVideoResponseModelFromJson(json);
  }

  Map<String, dynamic> toJson() {
    return _$DownloadVideoResponseModelToJson(this);
  }
}


