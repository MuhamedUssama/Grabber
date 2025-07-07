import 'package:json_annotation/json_annotation.dart';

part 'get_video_info_request.g.dart';

@JsonSerializable()
class GetVideoInfoRequest {
  @JsonKey(name: "url")
  final String? url;

  GetVideoInfoRequest({this.url});

  factory GetVideoInfoRequest.fromJson(Map<String, dynamic> json) {
    return _$GetVideoInfoRequestFromJson(json);
  }

  Map<String, dynamic> toJson() {
    return _$GetVideoInfoRequestToJson(this);
  }
}
