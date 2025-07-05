import 'package:json_annotation/json_annotation.dart';

part 'get_video_info_model.g.dart';

@JsonSerializable()
class GetVideoInfoModel {
  @JsonKey(name: "streams")
  final List<Streams>? streams;
  @JsonKey(name: "title")
  final String? title;

  GetVideoInfoModel ({
    this.streams,
    this.title,
  });

  factory GetVideoInfoModel.fromJson(Map<String, dynamic> json) {
    return _$GetVideoInfoModelFromJson(json);
  }

  Map<String, dynamic> toJson() {
    return _$GetVideoInfoModelToJson(this);
  }
}

@JsonSerializable()
class Streams {
  @JsonKey(name: "best_format")
  final BestFormat? bestFormat;
  @JsonKey(name: "resolution")
  final String? resolution;

  Streams ({
    this.bestFormat,
    this.resolution,
  });

  factory Streams.fromJson(Map<String, dynamic> json) {
    return _$StreamsFromJson(json);
  }

  Map<String, dynamic> toJson() {
    return _$StreamsToJson(this);
  }
}

@JsonSerializable()
class BestFormat {
  @JsonKey(name: "bitrate")
  final int? bitrate;
  @JsonKey(name: "codec")
  final Codec? codec;
  @JsonKey(name: "duration")
  final int? duration;
  @JsonKey(name: "frame_rate")
  final double? frameRate;
  @JsonKey(name: "size")
  final int? size;
  @JsonKey(name: "type")
  final String? type;

  BestFormat ({
    this.bitrate,
    this.codec,
    this.duration,
    this.frameRate,
    this.size,
    this.type,
  });

  factory BestFormat.fromJson(Map<String, dynamic> json) {
    return _$BestFormatFromJson(json);
  }

  Map<String, dynamic> toJson() {
    return _$BestFormatToJson(this);
  }
}

@JsonSerializable()
class Codec {
  @JsonKey(name: "audio")
  final String? audio;
  @JsonKey(name: "video")
  final String? video;

  Codec ({
    this.audio,
    this.video,
  });

  factory Codec.fromJson(Map<String, dynamic> json) {
    return _$CodecFromJson(json);
  }

  Map<String, dynamic> toJson() {
    return _$CodecToJson(this);
  }
}


