// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'get_info_response_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GetInfoResponseModel _$GetInfoResponseModelFromJson(
  Map<String, dynamic> json,
) => GetInfoResponseModel(
  data: Data.fromJson(json['data'] as Map<String, dynamic>),
  success: json['success'] as bool,
);

Map<String, dynamic> _$GetInfoResponseModelToJson(
  GetInfoResponseModel instance,
) => <String, dynamic>{'data': instance.data, 'success': instance.success};

Data _$DataFromJson(Map<String, dynamic> json) => Data(
  entries:
      (json['entries'] as List<dynamic>)
          .map((e) => Entries.fromJson(e as Map<String, dynamic>))
          .toList(),
  isPlaylist: json['is_playlist'] as bool,
  playlistTitle: json['playlist_title'] as String?,
);

Map<String, dynamic> _$DataToJson(Data instance) => <String, dynamic>{
  'entries': instance.entries,
  'is_playlist': instance.isPlaylist,
  'playlist_title': instance.playlistTitle,
};

Entries _$EntriesFromJson(Map<String, dynamic> json) => Entries(
  channelName: json['channel_name'] as String?,
  channelUrl: json['channel_url'] as String,
  dateText: json['date_text'] as String,
  durationText: json['duration_text'] as String,
  options:
      (json['options'] as List<dynamic>)
          .map((e) => Options.fromJson(e as Map<String, dynamic>))
          .toList(),
  thumbnail: json['thumbnail'] as String,
  title: json['title'] as String,
  url: json['url'] as String,
  viewsText: json['views_text'] as String,
);

Map<String, dynamic> _$EntriesToJson(Entries instance) => <String, dynamic>{
  'channel_name': instance.channelName,
  'channel_url': instance.channelUrl,
  'date_text': instance.dateText,
  'duration_text': instance.durationText,
  'options': instance.options,
  'thumbnail': instance.thumbnail,
  'title': instance.title,
  'url': instance.url,
  'views_text': instance.viewsText,
};

Options _$OptionsFromJson(Map<String, dynamic> json) => Options(
  resolution: json['resolution'] as String,
  sizeText: json['size_text'] as String,
  type: json['type'] as String,
);

Map<String, dynamic> _$OptionsToJson(Options instance) => <String, dynamic>{
  'resolution': instance.resolution,
  'size_text': instance.sizeText,
  'type': instance.type,
};
