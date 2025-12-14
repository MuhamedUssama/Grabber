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

        _urlToDataMap.clear();
        for (final entry in currentEntries) {
          _urlToDataMap[entry.url] = entry;
        }

        selectedVideoUrls = currentEntries.map((e) => e.url).toSet();

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
      const audioFormats = ['mp3', 'm4a', 'webm', 'opus', 'flac', 'wav'];
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
  List<Entries> currentEntries = [];
  final Map<String, Entries> _urlToDataMap = {};

  void toggleVideoSelection(String url) {
    if (selectedVideoUrls.contains(url)) {
      selectedVideoUrls.remove(url);
    } else {
      selectedVideoUrls.add(url);
    }
    emit(OptionsUpdatedState());
  }

  void selectAllVideos() {
    selectedVideoUrls = currentEntries.map((e) => e.url).toSet();
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
    emit(DownloadRequestLoadingState());

    List<Future> futures = [];
    for (String url in urlsToDownload) {
      futures.add(_initiateAudioDownload(url, outputFormat));
    }

    await Future.wait(futures);
    emit(DownloadProgressUpdatedState());
    _startPolling();
  }

  Future<void> _initiateAudioDownload(String url, String? outputFormat) async {
    try {
      final String? formatToSend = outputFormat == 'webm' ? null : outputFormat;
      final DownloadAudioRequestModel request = DownloadAudioRequestModel(
        url: url,
        outputDir: path,
        outputFormat: formatToSend,
      );
      final result = await _audioUsecase(request);
      result.fold(
        (error) {
          log("Failed to initiate audio download for $url: ${error.message}");
        },
        (taskId) {
          urlToTaskId[url] = taskId;
          String title = _getTitleForUrl(url);
          String? thumbnail = _getThumbnailForUrl(url);

          tasksStatus[taskId] = TaskStatus(
            taskId: taskId,
            title: title,
            url: url,
            status: 'pending',
            progress: 0.0,
            thumbnailUrl: thumbnail,
          );
        },
      );
    } catch (e) {
      log("Exception initiating audio download for $url: $e");
    }
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
    emit(DownloadRequestLoadingState());

    List<Future> futures = [];
    for (String url in urlsToDownload) {
      futures.add(_initiateDownload(url, withAudio, outputFormat));
    }

    await Future.wait(futures);
    emit(DownloadProgressUpdatedState());
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

          String title = "Video";
          String? thumbnail;
          if (_urlToDataMap.containsKey(url)) {
            title = _urlToDataMap[url]!.title;
            thumbnail = _urlToDataMap[url]!.thumbnail;
          } else if (controller.text == url && videoTitle != null) {
            title = videoTitle!;
            if (currentVideoInfo != null &&
                currentVideoInfo!.data.entries.isNotEmpty) {
              thumbnail = currentVideoInfo!.data.entries.first.thumbnail;
            }
          }

          tasksStatus[taskId] = TaskStatus(
            taskId: taskId,
            title: title,
            url: url,
            status: 'pending',
            progress: 0.0,
            thumbnailUrl: thumbnail,
          );
        },
      );
    } catch (e) {
      log("Exception initiating download for $url: $e");
    }
  }

  Future<void> downloadSubtitle({String lang = 'en,ar'}) async {
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
    emit(DownloadRequestLoadingState());

    List<Future> futures = [];
    for (String url in urlsToDownload) {
      futures.add(_initiateSubtitleDownload(url, lang));
    }

    await Future.wait(futures);
    emit(DownloadProgressUpdatedState());
    _startPolling();
  }

  Future<void> _initiateSubtitleDownload(String url, String lang) async {
    try {
      final DownloadSubtitleRequestModel request = DownloadSubtitleRequestModel(
        url: url,
        outputDir: path,
        lang: lang,
      );
      final result = await _subtitleUsecase(request);
      result.fold(
        (error) {
          log(
            "Failed to initiate subtitle download for $url: ${error.message}",
          );
        },
        (taskId) {
          urlToTaskId[url] = taskId;
          String title = _getTitleForUrl(url);
          String? thumbnail = _getThumbnailForUrl(url);

          tasksStatus[taskId] = TaskStatus(
            taskId: taskId,
            title: title,
            url: url,
            status: 'pending',
            progress: 0.0,
            thumbnailUrl: thumbnail,
          );
        },
      );
    } catch (e) {
      log("Exception initiating subtitle download for $url: $e");
    }
  }

  String _getTitleForUrl(String url) {
    if (_urlToDataMap.containsKey(url)) {
      return _urlToDataMap[url]!.title;
    } else if (controller.text == url && videoTitle != null) {
      return videoTitle!;
    }
    return "Download";
  }

  String? _getThumbnailForUrl(String url) {
    if (_urlToDataMap.containsKey(url)) {
      return _urlToDataMap[url]!.thumbnail;
    } else if (controller.text == url &&
        currentVideoInfo != null &&
        currentVideoInfo!.data.entries.isNotEmpty) {
      return currentVideoInfo!.data.entries.first.thumbnail;
    }
    return null;
  }

  Map<String, String> urlToTaskId = {};
  Map<String, TaskStatus> tasksStatus = {};

  void _startPolling() {
    _stopPolling();

    _pollingTimer = Timer.periodic(const Duration(milliseconds: 500), (
      timer,
    ) async {
      if (tasksStatus.isEmpty) {
        _stopPolling();
        return;
      }

      bool anyActive = false;

      for (final TaskStatus currentStatus in tasksStatus.values) {
        final String status = currentStatus.status;
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
                  speed: data.speed,
                  eta: data.eta,
                  totalSize: data.totalSize,
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

  Future<void> cancelTask(String taskId) async {
    try {
      await _cancelTaskUsecase(taskId);
    } catch (e) {
      log("Error cancelling task: $e");
    }

    if (tasksStatus.containsKey(taskId)) {
      tasksStatus[taskId] = tasksStatus[taskId]!.copyWith(status: 'cancelled');
      emit(DownloadProgressUpdatedState());
    }

    // Check if we should stop polling if all are now terminal
    bool anyActive = tasksStatus.values.any(
      (task) =>
          task.status != 'completed' &&
          task.status != 'failed' &&
          task.status != 'cancelled',
    );

    if (!anyActive) {
      _stopPolling();
    }
  }

  void clearTasks() {
    tasksStatus.clear();
    _currentTaskId = null;
    emit(DownloadProgressUpdatedState());
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
