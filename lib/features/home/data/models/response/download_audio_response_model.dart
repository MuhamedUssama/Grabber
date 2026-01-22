import 'package:json_annotation/json_annotation.dart';

part 'download_audio_response_model.g.dart';

@JsonSerializable()
class DownloadAudioResponseModel {
  @JsonKey(name: 'data')
  final Data data;
  @JsonKey(name: 'success')
  final bool success;

  DownloadAudioResponseModel({required this.data, required this.success});

  factory DownloadAudioResponseModel.fromJson(Map<String, dynamic> json) =>
      _$DownloadAudioResponseModelFromJson(json);
  Map<String, dynamic> toJson() => _$DownloadAudioResponseModelToJson(this);
}

@JsonSerializable()
class Data {
  @JsonKey(name: 'message')
  final String message;
  @JsonKey(name: 'task_id')
  final String taskId;

  Data({required this.message, required this.taskId});

  factory Data.fromJson(Map<String, dynamic> json) => _$DataFromJson(json);
  Map<String, dynamic> toJson() => _$DataToJson(this);
}
