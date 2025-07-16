// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'get_video_info_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GetVideoInfoModel _$GetVideoInfoModelFromJson(Map<String, dynamic> json) =>
    GetVideoInfoModel(
      streams:
          (json['streams'] as List<dynamic>?)
              ?.map((e) => Streams.fromJson(e as Map<String, dynamic>))
              .toList(),
      title: json['title'] as String?,
    );

Map<String, dynamic> _$GetVideoInfoModelToJson(GetVideoInfoModel instance) =>
    <String, dynamic>{'streams': instance.streams, 'title': instance.title};

Streams _$StreamsFromJson(Map<String, dynamic> json) => Streams(
  bestFormat:
      json['best_format'] == null
          ? null
          : BestFormat.fromJson(json['best_format'] as Map<String, dynamic>),
  resolution: json['resolution'] as String?,
);

Map<String, dynamic> _$StreamsToJson(Streams instance) => <String, dynamic>{
  'best_format': instance.bestFormat,
  'resolution': instance.resolution,
};

BestFormat _$BestFormatFromJson(Map<String, dynamic> json) => BestFormat(
  bitrate: (json['bitrate'] as num?)?.toInt(),
  codec:
      json['codec'] == null
          ? null
          : Codec.fromJson(json['codec'] as Map<String, dynamic>),
  duration: (json['duration'] as num?)?.toInt(),
  frameRate: (json['frame_rate'] as num?)?.toDouble(),
  size: (json['size'] as num?)?.toInt(),
  type: json['type'] as String?,
);

Map<String, dynamic> _$BestFormatToJson(BestFormat instance) =>
    <String, dynamic>{
      'bitrate': instance.bitrate,
      'codec': instance.codec,
      'duration': instance.duration,
      'frame_rate': instance.frameRate,
      'size': instance.size,
      'type': instance.type,
    };

Codec _$CodecFromJson(Map<String, dynamic> json) =>
    Codec(audio: json['audio'] as String?, video: json['video'] as String?);

Map<String, dynamic> _$CodecToJson(Codec instance) => <String, dynamic>{
  'audio': instance.audio,
  'video': instance.video,
};
