import 'package:json_annotation/json_annotation.dart';

part 'get_info_response_model.g.dart';

@JsonSerializable()
class GetInfoResponseModel {
  @JsonKey(name: 'data')
  final Data data;
  @JsonKey(name: 'success')
  final bool success;

  GetInfoResponseModel({required this.data, required this.success});

  factory GetInfoResponseModel.fromJson(Map<String, dynamic> json) =>
      _$GetInfoResponseModelFromJson(json);
  Map<String, dynamic> toJson() => _$GetInfoResponseModelToJson(this);
}

@JsonSerializable()
class Data {
  @JsonKey(name: 'entries')
  final List<Entries> entries;
  @JsonKey(name: 'is_playlist')
  final bool isPlaylist;
  @JsonKey(name: 'playlist_title')
  final String? playlistTitle;

  Data({
    required this.entries,
    required this.isPlaylist,
    required this.playlistTitle,
  });

  factory Data.fromJson(Map<String, dynamic> json) => _$DataFromJson(json);
  Map<String, dynamic> toJson() => _$DataToJson(this);
}

@JsonSerializable()
class Entries {
  @JsonKey(name: 'channel_name')
  final String? channelName;
  @JsonKey(name: 'channel_url')
  final String? channelUrl;
  @JsonKey(name: 'date_text')
  final String dateText;
  @JsonKey(name: 'duration_text')
  final String durationText;
  @JsonKey(name: 'options')
  final List<Options>? options;
  @JsonKey(name: 'thumbnail')
  final String? thumbnail;
  @JsonKey(name: 'title')
  final String title;
  @JsonKey(name: 'url')
  final String url;
  @JsonKey(name: 'views_text')
  final String viewsText;

  Entries({
    required this.channelName,
    this.channelUrl,
    required this.dateText,
    required this.durationText,
    required this.options,
    this.thumbnail,
    required this.title,
    required this.url,
    required this.viewsText,
  });

  factory Entries.fromJson(Map<String, dynamic> json) =>
      _$EntriesFromJson(json);
  Map<String, dynamic> toJson() => _$EntriesToJson(this);
}

@JsonSerializable()
class Options {
  @JsonKey(name: 'resolution')
  final String? resolution;
  @JsonKey(name: 'size_text')
  final String? sizeText;
  @JsonKey(name: 'type')
  final String type;

  Options({this.resolution, required this.sizeText, required this.type});

  factory Options.fromJson(Map<String, dynamic> json) =>
      _$OptionsFromJson(json);
  Map<String, dynamic> toJson() => _$OptionsToJson(this);
}
