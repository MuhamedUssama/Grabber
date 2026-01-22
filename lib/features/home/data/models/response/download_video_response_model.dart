import 'package:json_annotation/json_annotation.dart';

part 'download_video_response_model.g.dart';

@JsonSerializable()
class DownloadVideoResponseModel {
  @JsonKey(name: 'data')
  final Data data;
  @JsonKey(name: 'success')
  final bool success;

  DownloadVideoResponseModel({
    required this.data,
    required this.success,
  });

  factory DownloadVideoResponseModel.fromJson(Map<String, dynamic> json) => _$DownloadVideoResponseModelFromJson(json);
  Map<String, dynamic> toJson() => _$DownloadVideoResponseModelToJson(this);
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