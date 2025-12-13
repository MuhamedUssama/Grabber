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
import 'package:grabber/features/home/data/models/response/get_info_response_model.dart';
import 'package:grabber/features/home/domain/usecases/cancel_task_usecase.dart';
import 'package:grabber/features/home/domain/usecases/download_audio_usecase.dart';
import 'package:grabber/features/home/domain/usecases/download_subtitle_usecase.dart';
import 'package:grabber/features/home/domain/usecases/download_video_usecase.dart';
import 'package:grabber/features/home/domain/usecases/get_task_status_usecase.dart';
import 'package:grabber/features/home/domain/usecases/get_video_info_usecase.dart';
import 'package:grabber/features/home/presentation/enums/download_type.dart';
import 'package:grabber/features/home/domain/entites/task_status.dart';
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

  DownloadType selectedType = DownloadType.video;
  List<String> availableResolutions = [];
  String? selectedQuality;
  String selectedFormat = 'mp4';
  String selectedLang = 'en,ar';

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

        currentVideoInfo = videoInfo;
        currentEntries = videoInfo.data.entries;
        selectedVideoUrls = currentEntries.map((e) => e.url as String).toSet();

        _parseResolutions();
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

  GetInfoResponseModel? currentVideoInfo;

  void _parseResolutions() {
    if (options.isNotEmpty) {
      availableResolutions =
          options
              .where((opt) => opt.type == 'video')
              .map((opt) => opt.resolution as String)
              .toSet()
              .toList();

      if (availableResolutions.isNotEmpty) {
        if (selectedQuality == null ||
            !availableResolutions.contains(selectedQuality)) {
          selectedQuality = availableResolutions.first;
        }
      } else {
        selectedQuality = null;
      }
    } else {
      availableResolutions = [];
      selectedQuality = null;
    }
  }

  void changeDownloadType(DownloadType type) {
    selectedType = type;

    if (type == DownloadType.audio) {
      const audioFormats = ['mp3', 'm4a', 'webm', 'flac', 'wav', 'ogg', 'aac'];
      if (!audioFormats.contains(selectedFormat)) {
        selectedFormat = 'webm';
      }
    } else if (type == DownloadType.video) {
      const videoFormats = ['mp4', 'webm', 'mkv', 'avi', 'mov', 'flv', 'wmv'];
      if (!videoFormats.contains(selectedFormat)) {
        selectedFormat = 'mp4';
      }
    } else if (type == DownloadType.subtitle) {
      const subtitleLangs = ['en,ar', 'en', 'ar'];
      if (!subtitleLangs.contains(selectedLang)) {
        selectedLang = 'en,ar';
      }
    }

    emit(OptionsUpdatedState());
  }

  void changeQuality(String quality) {
    selectedQuality = quality;
    emit(OptionsUpdatedState());
  }

  void changeFormat(String format) {
    selectedFormat = format;
    emit(OptionsUpdatedState());
  }

  Set<String> selectedVideoUrls = {};

  bool get isAllSelected {
    if (options.isEmpty) return false;
    return currentEntries.isNotEmpty &&
        selectedVideoUrls.length == currentEntries.length;
  }

  // Store current entries to manage selection
  List<dynamic> currentEntries = [];

  void toggleVideoSelection(String url) {
    if (selectedVideoUrls.contains(url)) {
      selectedVideoUrls.remove(url);
    } else {
      selectedVideoUrls.add(url);
    }
    emit(OptionsUpdatedState());
  }

  void selectAllVideos() {
    selectedVideoUrls = currentEntries.map((e) => e.url as String).toSet();
    emit(OptionsUpdatedState());
  }

  void deselectAllVideos() {
    selectedVideoUrls.clear();
    emit(OptionsUpdatedState());
  }

  void changeLanguage(String lang) {
    selectedLang = lang;
    emit(OptionsUpdatedState());
  }

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
    log('Quality of video is: $selectedQuality');

    if (selectedQuality == null) {
      emit(DownloadFailureState('Choose the quality which you preffer first'));
      return;
    }

    Set<String> urlsToDownload = {};
    if (selectedVideoUrls.isNotEmpty) {
      urlsToDownload = selectedVideoUrls;
    } else {
      urlsToDownload = {controller.text};
    }

    final String? validationMessage = _urlValidator(controller.text);

    if (urlsToDownload.isEmpty && validationMessage != null) {
      emit(ValidateUrlState(validationMessage));
      return;
    }

    await _getDownloadDirectory();
    // emit(DownloadRequestLoadingState()); // Maybe emit loading?

    List<Future> futures = [];
    for (String url in urlsToDownload) {
      futures.add(_initiateDownload(url, withAudio, outputFormat));
    }

    await Future.wait(futures);
    _startPolling();
  }

  Future<void> _initiateDownload(
    String url,
    bool withAudio,
    String? outputFormat,
  ) async {
    try {
      final DownloadVideoRequestModel request = DownloadVideoRequestModel(
        url: url,
        outputDir: path,
        quality: selectedQuality!,
        withAudio: withAudio,
        outputFormat: outputFormat,
      );
      final result = await _videoUsecase(request);
      result.fold(
        (error) {
          log("Failed to initiate download for $url: ${error.message}");
        },
        (taskId) {
          urlToTaskId[url] = taskId;
          tasksStatus[taskId] = TaskStatus(
            taskId: taskId,
            status: 'pending',
            progress: 0.0,
          );
        },
      );
    } catch (e) {
      log("Exception initiating download for $url: $e");
    }
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
        // Adapt single task (Audio/Subtitle) to new map system
        // Note: Audio/Subtitle don't have URL tracking in the same way, but we can store them.
        tasksStatus[taskId] = TaskStatus(
          taskId: taskId,
          status: 'pending',
          progress: 0.0,
        );
        _startPolling();
      });
    } catch (error) {
      emit(DownloadFailureState(error.toString()));
    }
  }

  Map<String, String> urlToTaskId = {};
  Map<String, TaskStatus> tasksStatus = {};

  void _startPolling() {
    _stopPolling();

    _pollingTimer = Timer.periodic(const Duration(seconds: 1), (timer) async {
      if (tasksStatus.isEmpty) {
        _stopPolling();
        return;
      }

      bool anyActive = false;

      // Iterating over a copy of values to avoid concurrent modification logic issues if we were removing
      // but we are just updating.
      for (final currentStatus in tasksStatus.values) {
        final status = currentStatus.status;
        if (status == 'completed' ||
            status == 'failed' ||
            status == 'cancelled') {
          continue;
        }

        anyActive = true;
        final taskId = currentStatus.taskId;
        final result = await _taskStatusUsecase(taskId);

        result.fold(
          (error) {
            tasksStatus[taskId] = currentStatus.copyWith(
              status: 'failed',
              error: error.message,
            );
          },
          (statusResponse) {
            final data = statusResponse.data;
            if (data != null) {
              final newStatus = data.status ?? 'processing';
              final progress = (data.progress ?? 0.0) / 100.0;

              if (newStatus == 'completed') {
                tasksStatus[taskId] = currentStatus.copyWith(
                  status: 'completed',
                  progress: 1.0,
                  resultPath: data.result,
                );
              } else if (newStatus == 'failed') {
                tasksStatus[taskId] = currentStatus.copyWith(
                  status: 'failed',
                  error: data.error,
                );
              } else if (newStatus == 'cancelled') {
                tasksStatus[taskId] = currentStatus.copyWith(
                  status: 'cancelled',
                );
              } else {
                tasksStatus[taskId] = currentStatus.copyWith(
                  status: newStatus,
                  progress: progress,
                );
              }
            }
          },
        );
      }

      emit(DownloadProgressUpdatedState());

      if (!anyActive) {
        _stopPolling();
      }
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
