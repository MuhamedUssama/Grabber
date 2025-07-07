import 'package:grabber/features/home/data/models/response/download_audio_response_model.dart';
import 'package:grabber/features/home/data/models/response/download_video_response_model.dart';
import 'package:grabber/features/home/data/models/response/get_video_info_model.dart';

sealed class HomeScreenStates {}

final class HomeScreenInitialState extends HomeScreenStates {}

final class GetVideoInfoLoadingState extends HomeScreenStates {}

final class GetVideoInfoSuccessState extends HomeScreenStates {
  final GetVideoInfoModel videoInfo;
  GetVideoInfoSuccessState(this.videoInfo);
}

final class GetVideoInfoErrorState extends HomeScreenStates {
  final String error;
  GetVideoInfoErrorState(this.error);
}

final class ValidateUrlState extends HomeScreenStates {
  final String message;
  ValidateUrlState(this.message);
}

final class SelectFolderPathSuccessState extends HomeScreenStates {}

final class SelectFolderPathFailureState extends HomeScreenStates {
  final String? message;
  SelectFolderPathFailureState(this.message);
}

final class GetAvalibleResloutionsState extends HomeScreenStates {
  final List<String> resolutions;
  GetAvalibleResloutionsState(this.resolutions);
}

final class GetVideoInfoEmptyState extends HomeScreenStates {
  final String message;
  GetVideoInfoEmptyState(this.message);
}

final class DownloadAudioLoadingState extends HomeScreenStates {}

final class DownloadAudioSuccessState extends HomeScreenStates {
  DownloadAudioResponseModel audioResponse;
  DownloadAudioSuccessState(this.audioResponse);
}

final class DownloadAudioFailureState extends HomeScreenStates {
  final String? error;
  DownloadAudioFailureState(this.error);
}

final class DownloadVideoLoadingState extends HomeScreenStates {}

final class DownloadVideoSuccessState extends HomeScreenStates {
  DownloadVideoResponseModel videoResponse;
  DownloadVideoSuccessState(this.videoResponse);
}

final class DownloadVideoFailureState extends HomeScreenStates {
  final String? error;
  DownloadVideoFailureState(this.error);
}

final class DownloadVideoWithoutAudioLoadingState extends HomeScreenStates {}

final class DownloadVideoWithoutAudioSuccessState extends HomeScreenStates {
  DownloadVideoResponseModel videoResponse;
  DownloadVideoWithoutAudioSuccessState(this.videoResponse);
}

final class DownloadVideoWithoutAudioFailureState extends HomeScreenStates {
  final String? error;
  DownloadVideoWithoutAudioFailureState(this.error);
}
