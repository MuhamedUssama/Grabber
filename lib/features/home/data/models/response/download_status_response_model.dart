import 'package:json_annotation/json_annotation.dart';

part 'download_status_response_model.g.dart';

@JsonSerializable()
class DownloadStatusResponseModel {
  @JsonKey(name: 'data')
  final Data? data;
  @JsonKey(name: 'error')
  final Error? error;
  @JsonKey(name: 'success')
  final bool success;

  DownloadStatusResponseModel({
    required this.data,
    this.error,
    required this.success,
  });

  factory DownloadStatusResponseModel.fromJson(Map<String, dynamic> json) =>
      _$DownloadStatusResponseModelFromJson(json);
  Map<String, dynamic> toJson() => _$DownloadStatusResponseModelToJson(this);
}

@JsonSerializable()
class Error {
  @JsonKey(name: 'code')
  final String code;
  @JsonKey(name: 'message')
  final String message;

  Error({required this.code, required this.message});

  factory Error.fromJson(Map<String, dynamic> json) => _$ErrorFromJson(json);
  Map<String, dynamic> toJson() => _$ErrorToJson(this);
}

@JsonSerializable()
class Data {
  @JsonKey(name: 'error')
  final String? error;
  @JsonKey(name: 'progress')
  final double? progress;
  @JsonKey(name: 'result')
  final String? result;
  @JsonKey(name: 'status')
  final String? status;
  @JsonKey(name: 'total_size')
  final int? totalSize;
  @JsonKey(name: 'speed')
  final double? speed;
  @JsonKey(name: 'eta')
  final int? eta;

  Data({
    required this.error,
    required this.progress,
    required this.result,
    required this.status,
    required this.totalSize,
    required this.speed,
    required this.eta,
  });

  factory Data.fromJson(Map<String, dynamic> json) => _$DataFromJson(json);
  Map<String, dynamic> toJson() => _$DataToJson(this);
}
