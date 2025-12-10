import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:grabber/features/home/data/models/request/download_audio_request_model.dart';
import 'package:grabber/features/home/data/models/request/download_subtitle_request_model.dart';
import 'package:grabber/features/home/data/models/request/download_video_request_model.dart';
import 'package:grabber/features/home/data/models/request/get_video_info_request.dart';
import 'package:grabber/features/home/domain/usecases/cancel_task_usecase.dart';
import 'package:grabber/features/home/domain/usecases/download_audio_usecase.dart';
import 'package:grabber/features/home/domain/usecases/download_subtitle_usecase.dart';
import 'package:grabber/features/home/domain/usecases/download_video_usecase.dart';
import 'package:grabber/features/home/domain/usecases/get_task_status_usecase.dart';

import 'package:grabber/features/home/domain/usecases/get_video_info_usecase.dart';
import 'package:injectable/injectable.dart';
import 'package:path_provider/path_provider.dart';

import 'home_screen_states.dart';

@injectable
class HomeScreenViewModel extends Cubit<HomeScreenStates> {
  final GetVideoInfoUsecase _videoInfoUsecase;
  final DownloadVideoUsecase _videoUsecase;
  final DownloadAudioUsecase _audioUsecase;
  final DownloadSubtitleUsecase _subtitleUsecase;
  final GetTaskStatusUseCase _taskStatusUsecase;
  final CancelTaskUseCase _cancelTaskUsecase;

  HomeScreenViewModel(
    this._videoInfoUsecase,
    this._videoUsecase,
    this._audioUsecase,
    this._subtitleUsecase,
    this._taskStatusUsecase,
    this._cancelTaskUsecase,
  ) : super(HomeScreenInitialState());

  Timer? _pollingTimer;
  String? _currentTaskId;
  String? path;
  String? videoTitle;
  String? quality;
  List<dynamic> options = [];

  final TextEditingController controller = TextEditingController();

  @override
  Future<void> close() {
    _stopPolling();
    return super.close();
  }

  Future<void> getVideoInfo() async {
    try {
      final String? validationMessage = _urlValidator(controller.text);
      if (validationMessage != null) {
        emit(ValidateUrlState(validationMessage));
        return;
      }

      emit(GetVideoInfoLoadingState());

      final GetVideoInfoRequest request = GetVideoInfoRequest(
        url: controller.text,
      );

      final result = await _videoInfoUsecase(request);

      result.fold((error) => emit(GetVideoInfoErrorState(error.message!)), (
        videoInfo,
      ) {
        if (videoInfo.data.isPlaylist) {
          videoTitle = videoInfo.data.playlistTitle ?? "Playlist";
          if (videoInfo.data.entries.isNotEmpty) {
            options = videoInfo.data.entries.first.options ?? [];
          }
        } else {
          if (videoInfo.data.entries.isNotEmpty) {
            videoTitle = videoInfo.data.entries.first.title;
            options = videoInfo.data.entries.first.options ?? [];
          }
        }

        getResolutions();
        emit(GetVideoInfoSuccessState(videoInfo));
      });
    } catch (exception) {
      emit(GetVideoInfoErrorState(exception.toString()));
    }
  }

  Future<void> pickFolderPath() async {
    try {
      String? selectedDirectory = await FilePicker.platform.getDirectoryPath();

      if (selectedDirectory != null) {
        path = selectedDirectory;
        emit(SelectFolderPathSuccessState());
      } else {
        emit(SelectFolderPathFailureState(null));
      }
    } catch (error) {
      log("Error from pick folder: $error");
    }
  }

  Future<void> getResolutions() async {
    if (options.isNotEmpty) {
      final List<String> resolutions =
          options
              .where((opt) => opt.type == 'video')
              .map((opt) => opt.resolution as String)
              .toSet()
              .toList();

      if (resolutions.isNotEmpty) {
        emit(GetAvalibleResloutionsState(resolutions));
      } else {
        emit(
          GetVideoInfoEmptyState(
            'There is no available resolutions of this video',
          ),
        );
      }
    } else {
      emit(GetVideoInfoEmptyState('There is no available data of this video'));
    }
  }

  // --- Download Logic ---

  Future<void> downloadAudio({String? outputFormat}) async {
    await _startDownloadProcess(() async {
      DownloadAudioRequestModel request = DownloadAudioRequestModel(
        url: controller.text,
        outputDir: path,
        outputFormat: outputFormat,
      );
      final result = await _audioUsecase(request);
      return result;
    });
  }

  Future<void> downloadVideo({
    bool withAudio = true,
    String? outputFormat,
  }) async {
    log('Quality of video is: $quality');

    if (quality == null) {
      emit(DownloadFailureState('Choose the quality which you preffer first'));
      return;
    }

    await _startDownloadProcess(() async {
      final DownloadVideoRequestModel request = DownloadVideoRequestModel(
        url: controller.text,
        outputDir: path,
        quality: quality!,
        withAudio: withAudio,
        outputFormat: outputFormat,
      );
      final result = await _videoUsecase(request);
      return result;
    });
  }

  Future<void> downloadSubtitle({String lang = 'en,ar'}) async {
    await _startDownloadProcess(() async {
      final DownloadSubtitleRequestModel request = DownloadSubtitleRequestModel(
        url: controller.text,
        outputDir: path,
        lang: lang,
      );
      final result = await _subtitleUsecase(request);
      return result;
    });
  }

  Future<void> _startDownloadProcess(
    Future<dynamic> Function() usecaseCall,
  ) async {
    try {
      final String? validationMessage = _urlValidator(controller.text);
      if (validationMessage != null) {
        emit(ValidateUrlState(validationMessage));
        return;
      }

      await _getDownloadDirectory();

      emit(DownloadRequestLoadingState());

      final result = await usecaseCall();

      result.fold((error) => emit(DownloadFailureState(error.toString())), (
        taskId,
      ) {
        _currentTaskId = taskId;
        _startPolling(taskId);
      });
    } catch (error) {
      emit(DownloadFailureState(error.toString()));
    }
  }

  void _startPolling(String taskId) {
    _stopPolling();

    _pollingTimer = Timer.periodic(const Duration(seconds: 1), (timer) async {
      final result = await _taskStatusUsecase(taskId);

      result.fold(
        (error) {
          _stopPolling();
          emit(DownloadFailureState("Polling Failed: ${error.message}"));
        },
        (statusResponse) {
          final data = statusResponse.data;
          if (data == null) return;

          final status = data.status;
          final progress = data.progress ?? 0.0;

          if (status == 'processing' ||
              status == 'pending' ||
              status == 'canceling') {
            emit(
              DownloadProgressState(
                progress: progress / 100.0,
                status: status ?? 'processing',
                taskId: taskId,
              ),
            );
          } else if (status == 'completed') {
            _stopPolling();
            final resultPath = data.result ?? "Unknown Path";
            emit(DownloadCompletedState(resultPath));
          } else if (status == 'cancelled') {
            _stopPolling();
            emit(DownloadCancelledState());
          } else if (status == 'failed') {
            _stopPolling();
            emit(DownloadFailureState(data.error ?? "Unknown Error"));
          }
        },
      );
    });
  }

  void _stopPolling() {
    _pollingTimer?.cancel();
    _pollingTimer = null;
  }

  Future<void> cancelCurrentDownload() async {
    if (_currentTaskId != null) {
      await _cancelTaskUsecase(_currentTaskId!);
    }
  }

  void updateQualityValue(String updatedQuality) {
    quality = updatedQuality;
    emit(UpdateQualityValueState(updatedQuality));
  }

  String? _urlValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'This field can not be empty';
    }

    final RegExp urlRegex = RegExp(
      r'^(https?://)?([\w-]+\.)+[\w-]+(/[\w-./?%&=]*)?$',
      caseSensitive: false,
    );

    if (!urlRegex.hasMatch(value)) {
      return 'Invalid url';
    }
    return null;
  }

  Future<void> _getDownloadDirectory() async {
    if (path == null) {
      final Directory? directory = await getDownloadsDirectory();
      if (directory == null) {
        emit(
          GetDownloadsDirectoryFailureState(
            'Unable to access Downloads folder',
          ),
        );
        return;
      }
      path = directory.path;
    }
  }
}
