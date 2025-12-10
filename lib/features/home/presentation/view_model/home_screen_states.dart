import 'package:grabber/features/home/data/models/response/get_info_response_model.dart';

sealed class HomeScreenStates {}

final class HomeScreenInitialState extends HomeScreenStates {}

// Info States
final class GetVideoInfoLoadingState extends HomeScreenStates {}

final class GetVideoInfoSuccessState extends HomeScreenStates {
  final GetInfoResponseModel videoInfo;
  GetVideoInfoSuccessState(this.videoInfo);
}

final class GetVideoInfoErrorState extends HomeScreenStates {
  final String error;
  GetVideoInfoErrorState(this.error);
}

final class GetVideoInfoEmptyState extends HomeScreenStates {
  final String message;
  GetVideoInfoEmptyState(this.message);
}

// Download States (Unified for Video, Audio, Subtitle)
final class DownloadRequestLoadingState extends HomeScreenStates {}

final class DownloadProgressState extends HomeScreenStates {
  final double progress;
  final String status;
  final String taskId;

  DownloadProgressState({
    required this.progress,
    required this.status,
    required this.taskId,
  });
}

final class DownloadCompletedState extends HomeScreenStates {
  final String filePath; // Or result object from backend
  DownloadCompletedState(this.filePath);
}

final class DownloadCancelledState extends HomeScreenStates {}

final class DownloadFailureState extends HomeScreenStates {
  final String error;
  DownloadFailureState(this.error);
}

// UI Utility States
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

final class GetDownloadsDirectoryFailureState extends HomeScreenStates {
  final String error;
  GetDownloadsDirectoryFailureState(this.error);
}

final class UpdateQualityValueState extends HomeScreenStates {
  final String quality;
  UpdateQualityValueState(this.quality);
}
