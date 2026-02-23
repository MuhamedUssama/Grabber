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
import 'package:queue/queue.dart';

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
  bool _isPolling = false;
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

  Queue _downloadQueue = Queue(parallel: 3);

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
              .where((opt) => opt.type == 'video' && opt.resolution != null)
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

    int count = 0;
    for (String url in urlsToDownload) {
      count++;
      final tempTaskId = 'queued_${url.hashCode}';
      String title = _getTitleForUrl(url);
      String? thumbnail = _getThumbnailForUrl(url);

      tasksStatus[tempTaskId] = TaskStatus(
        taskId: tempTaskId,
        title: title,
        url: url,
        status: 'queued',
        progress: 0.0,
        thumbnailUrl: thumbnail,
      );

      _downloadQueue.add(
        () => _initiateAudioDownload(url, outputFormat, tempTaskId),
      );

      if (count % 5 == 0) {
        emit(DownloadProgressUpdatedState());
        await Future.delayed(Duration.zero);
      }
    }

    emit(DownloadProgressUpdatedState());
    _startPolling();
  }

  Future<void> _initiateAudioDownload(
    String url,
    String? outputFormat,
    String tempTaskId,
  ) async {
    // If the task was cancelled while in queue, don't start it
    if (tasksStatus[tempTaskId]?.status == 'cancelled') return;

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
          // Update status to failed
          if (tasksStatus.containsKey(tempTaskId)) {
            tasksStatus[tempTaskId] = tasksStatus[tempTaskId]!.copyWith(
              status: 'failed',
              error: error.message,
            );
          }
        },
        (taskId) {
          urlToTaskId[url] = taskId;

          // Remove temp task and add real task
          // We preserve the thumbnail and title from the temp task if possible
          final tempTask = tasksStatus[tempTaskId];

          tasksStatus.remove(tempTaskId);

          tasksStatus[taskId] = TaskStatus(
            taskId: taskId,
            title: tempTask?.title ?? "Audio",
            url: url,
            status: 'pending',
            progress: 0.0,
            thumbnailUrl: tempTask?.thumbnailUrl,
          );
        },
      );
      // emit(DownloadProgressUpdatedState());
    } catch (e) {
      log("Exception initiating audio download for $url: $e");
      if (tasksStatus.containsKey(tempTaskId)) {
        tasksStatus[tempTaskId] = tasksStatus[tempTaskId]!.copyWith(
          status: 'failed',
          error: e.toString(),
        );
      }
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

    int count = 0;
    for (String url in urlsToDownload) {
      count++;
      final tempTaskId = 'queued_${url.hashCode}';

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

      tasksStatus[tempTaskId] = TaskStatus(
        taskId: tempTaskId,
        title: title,
        url: url,
        status: 'queued',
        progress: 0.0,
        thumbnailUrl: thumbnail,
      );

      _downloadQueue.add(
        () => _initiateDownload(url, withAudio, outputFormat, tempTaskId),
      );

      if (count % 5 == 0) {
        emit(DownloadProgressUpdatedState());
        await Future.delayed(Duration.zero);
      }
    }

    emit(DownloadProgressUpdatedState());
    _startPolling();
  }

  Future<void> _initiateDownload(
    String url,
    bool withAudio,
    String? outputFormat,
    String tempTaskId,
  ) async {
    // If cancelled in queue
    if (tasksStatus[tempTaskId]?.status == 'cancelled') return;

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
          if (tasksStatus.containsKey(tempTaskId)) {
            tasksStatus[tempTaskId] = tasksStatus[tempTaskId]!.copyWith(
              status: 'failed',
              error: error.message,
            );
          }
        },
        (taskId) {
          urlToTaskId[url] = taskId;
          final tempTask = tasksStatus[tempTaskId];
          tasksStatus.remove(tempTaskId);

          tasksStatus[taskId] = TaskStatus(
            taskId: taskId,
            title: tempTask?.title ?? "Video",
            url: url,
            status: 'pending',
            progress: 0.0,
            thumbnailUrl: tempTask?.thumbnailUrl,
          );
        },
      );
      // emit(DownloadProgressUpdatedState());
    } catch (e) {
      log("Exception initiating download for $url: $e");
      if (tasksStatus.containsKey(tempTaskId)) {
        tasksStatus[tempTaskId] = tasksStatus[tempTaskId]!.copyWith(
          status: 'failed',
          error: e.toString(),
        );
      }
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

    int count = 0;
    for (String url in urlsToDownload) {
      count++;
      final tempTaskId = 'queued_${url.hashCode}';
      String title = _getTitleForUrl(url);
      String? thumbnail = _getThumbnailForUrl(url);

      tasksStatus[tempTaskId] = TaskStatus(
        taskId: tempTaskId,
        title: title,
        url: url,
        status: 'queued',
        progress: 0.0,
        thumbnailUrl: thumbnail,
      );
      _downloadQueue.add(
        () => _initiateSubtitleDownload(url, lang, tempTaskId),
      );

      if (count % 5 == 0) {
        emit(DownloadProgressUpdatedState());
        await Future.delayed(Duration.zero);
      }
    }

    emit(DownloadProgressUpdatedState());
    _startPolling();
  }

  Future<void> _initiateSubtitleDownload(
    String url,
    String lang,
    String tempTaskId,
  ) async {
    if (tasksStatus[tempTaskId]?.status == 'cancelled') return;

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
          if (tasksStatus.containsKey(tempTaskId)) {
            tasksStatus[tempTaskId] = tasksStatus[tempTaskId]!.copyWith(
              status: 'failed',
              error: error.message,
            );
          }
        },
        (taskId) {
          urlToTaskId[url] = taskId;
          final tempTask = tasksStatus[tempTaskId];
          tasksStatus.remove(tempTaskId);

          tasksStatus[taskId] = TaskStatus(
            taskId: taskId,
            title: tempTask?.title ?? "Subtitle",
            url: url,
            status: 'pending',
            progress: 0.0,
            thumbnailUrl: tempTask?.thumbnailUrl,
          );
        },
      );
      // emit(DownloadProgressUpdatedState());
    } catch (e) {
      log("Exception initiating subtitle download for $url: $e");
      if (tasksStatus.containsKey(tempTaskId)) {
        tasksStatus[tempTaskId] = tasksStatus[tempTaskId]!.copyWith(
          status: 'failed',
          error: e.toString(),
        );
      }
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
      if (_isPolling) return;

      if (tasksStatus.isEmpty) {
        _stopPolling();
        return;
      }

      _isPolling = true;

      try {
        bool anyActive = false;

        for (final TaskStatus currentStatus in tasksStatus.values) {
          final String status = currentStatus.status;
          if (status == 'completed' ||
              status == 'failed' ||
              status == 'cancelled' ||
              status == 'queued') {
            continue;
          }

          // Keep polling for 'canceling', 'pending', and 'processing' states
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
      } finally {
        _isPolling = false;
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

  Future<void> cancelAllTasks() async {
    _downloadQueue.cancel();
    _downloadQueue = Queue(parallel: 3);

    final activeTasks =
        tasksStatus.values
            .where(
              (task) =>
                  task.status == 'pending' ||
                  task.status == 'processing' ||
                  task.status == 'queued',
            )
            .toList();

    if (activeTasks.isEmpty) return;

    // Store original statuses before updating
    final tasksNeedingBackendCancel =
        activeTasks
            .where(
              (task) =>
                  task.status != 'queued' && !task.taskId.startsWith('queued_'),
            )
            .toList();

    // Update UI immediately for queued tasks
    for (var task in activeTasks) {
      if (task.status == 'queued') {
        tasksStatus[task.taskId] = task.copyWith(status: 'cancelled');
      }
    }
    emit(DownloadProgressUpdatedState());

    // Cancel backend tasks - polling will handle status updates
    final List<Future> futures = [];
    for (var task in tasksNeedingBackendCancel) {
      futures.add(_cancelTaskUsecase(task.taskId));
    }

    try {
      await Future.wait(futures);
    } catch (e) {
      log("Error while cancelling all: $e");
    }

    // Polling will continue until all tasks reach terminal state
  }

  Future<void> cancelTask(String taskId) async {
    try {
      await _cancelTaskUsecase(taskId);
      // Don't set status to 'cancelled' immediately - let the polling
      // handle the status transition from 'canceling' -> 'cancelled'
      // This ensures the UI updates properly when backend confirms cancellation
    } catch (e) {
      log("Error cancelling task: $e");
      // On error, mark as cancelled locally
      if (tasksStatus.containsKey(taskId)) {
        tasksStatus[taskId] = tasksStatus[taskId]!.copyWith(
          status: 'cancelled',
        );
        emit(DownloadProgressUpdatedState());
      }
    }

    // Polling will continue until backend confirms 'cancelled' status
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
