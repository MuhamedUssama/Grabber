import 'package:json_annotation/json_annotation.dart';

part 'download_audio_request_model.g.dart';

@JsonSerializable()
class DownloadAudioRequestModel {
  @JsonKey(name: "url")
  final String? url;
  @JsonKey(name: "output_dir")
  final String? outputDir;

  DownloadAudioRequestModel ({
    this.url,
    this.outputDir,
  });

  factory DownloadAudioRequestModel.fromJson(Map<String, dynamic> json) {
    return _$DownloadAudioRequestModelFromJson(json);
  }

  Map<String, dynamic> toJson() {
    return _$DownloadAudioRequestModelToJson(this);
  }
}


