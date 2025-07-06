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
