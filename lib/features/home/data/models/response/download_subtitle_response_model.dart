import 'package:json_annotation/json_annotation.dart';

part 'download_subtitle_response_model.g.dart';

@JsonSerializable()
class DownloadSubtitleResponseModel {
  @JsonKey(name: 'data')
  final Data data;
  @JsonKey(name: 'success')
  final bool success;

  DownloadSubtitleResponseModel({
    required this.data,
    required this.success,
  });

  factory DownloadSubtitleResponseModel.fromJson(Map<String, dynamic> json) => _$DownloadSubtitleResponseModelFromJson(json);
  Map<String, dynamic> toJson() => _$DownloadSubtitleResponseModelToJson(this);
}

@JsonSerializable()
class Data {
  @JsonKey(name: 'message')
  final String message;
  @JsonKey(name: 'task_id')
  final String taskId;

  Data({
    required this.message,
    required this.taskId,
  });

  factory Data.fromJson(Map<String, dynamic> json) => _$DataFromJson(json);
  Map<String, dynamic> toJson() => _$DataToJson(this);
}