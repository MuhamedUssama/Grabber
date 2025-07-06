import 'package:json_annotation/json_annotation.dart';

part 'download_audio_response_model.g.dart';

@JsonSerializable()
class DownloadAudioResponseModel {
  @JsonKey(name: "file_path")
  final String? filePath;

  DownloadAudioResponseModel ({
    this.filePath,
  });

  factory DownloadAudioResponseModel.fromJson(Map<String, dynamic> json) {
    return _$DownloadAudioResponseModelFromJson(json);
  }

  Map<String, dynamic> toJson() {
    return _$DownloadAudioResponseModelToJson(this);
  }
}


