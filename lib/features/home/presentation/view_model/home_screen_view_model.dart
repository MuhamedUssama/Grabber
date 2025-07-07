import 'dart:developer';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:grabber/features/home/data/models/request/download_audio_request_model.dart';
import 'package:grabber/features/home/data/models/request/download_video_request_model.dart';
import 'package:grabber/features/home/data/models/request/get_video_info_request.dart';
import 'package:grabber/features/home/data/models/response/get_video_info_model.dart';
import 'package:grabber/features/home/domain/usecases/download_audio_usecase.dart';
import 'package:grabber/features/home/domain/usecases/download_video_usecase.dart';
import 'package:grabber/features/home/domain/usecases/download_video_without_audio_usecase.dart';
import 'package:grabber/features/home/domain/usecases/get_video_info_usecase.dart';
import 'package:injectable/injectable.dart';
import 'package:path_provider/path_provider.dart';

import 'home_screen_states.dart';

@injectable
class HomeScreenViewModel extends Cubit<HomeScreenStates> {
  final GetVideoInfoUsecase _videoInfoUsecase;
  final DownloadAudioUsecase _audioUsecase;
  final DownloadVideoUsecase _videoUsecase;
  final DownloadVideoWithoutAudioUsecase _videoWithoutAudioUsecase;

  HomeScreenViewModel(
    this._videoInfoUsecase,
    this._audioUsecase,
    this._videoUsecase,
    this._videoWithoutAudioUsecase,
  ) : super(HomeScreenInitialState());

  String? path;
  String? videoTitle;
  String? quality;
  List<Streams> streams = [];

  final TextEditingController controller = TextEditingController();

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
        videoTitle = videoInfo.title;
        streams.addAll(videoInfo.streams ?? []);
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
    if (streams.isNotEmpty) {
      final List<String> resolutions =
          streams
              .map((stream) => stream.resolution)
              .where((res) {
                if (res == null || res.isEmpty) return false;
                if (res.toLowerCase() == "audio") return false;

                final String numPart = res.replaceAll('p', '');
                final int? resolutionValue = int.tryParse(numPart);

                if (resolutionValue == null) return false;
                return resolutionValue >= 144;
              })
              .cast<String>()
              .toSet()
              .toList();

      emit(GetAvalibleResloutionsState(resolutions));
    } else {
      emit(GetVideoInfoEmptyState('There is no available data of this video'));
    }
  }

  Future<void> downloadAudio() async {
    try {
      final String? validationMessage = _urlValidator(controller.text);
      if (validationMessage != null) {
        emit(ValidateUrlState(validationMessage));
        return;
      }

      emit(DownloadAudioLoadingState());

      await _getDownloadDirectory();

      DownloadAudioRequestModel request = DownloadAudioRequestModel(
        url: controller.text,
        outputDir: path,
      );

      final result = await _audioUsecase(request);

      result.fold(
        (error) => emit(DownloadAudioFailureState(error.toString())),
        (audioResponse) => emit(DownloadAudioSuccessState(audioResponse)),
      );
    } catch (error) {
      emit(DownloadAudioFailureState(error.toString()));
    }
  }

  Future<void> downloadVideo() async {
    try {
      final String? validationMessage = _urlValidator(controller.text);
      if (validationMessage != null) {
        emit(ValidateUrlState(validationMessage));
        return;
      }

      log('Quality of video is: $quality');

      if (quality == null) {
        emit(
          DownloadVideoFailureState(
            'Choose the quality which you preffer first',
          ),
        );
        return;
      }

      emit(DownloadVideoLoadingState());

      await _getDownloadDirectory();

      final DownloadVideoRequestModel request = DownloadVideoRequestModel(
        url: controller.text,
        outputDir: path,
        quality: quality,
      );

      final result = await _videoUsecase(request);

      result.fold(
        (error) => emit(DownloadVideoFailureState(error.toString())),
        (videoResponse) => emit(DownloadVideoSuccessState(videoResponse)),
      );
    } catch (error) {
      emit(DownloadVideoFailureState(error.toString()));
    }
  }

  Future<void> downloadVideoWithoutAudio() async {
    try {
      final String? validationMessage = _urlValidator(controller.text);
      if (validationMessage != null) {
        emit(ValidateUrlState(validationMessage));
        return;
      }

      log('Quality of video without audio is: $quality');

      if (quality == null) {
        emit(
          DownloadVideoWithoutAudioFailureState(
            'Choose the quality which you preffer first',
          ),
        );
        return;
      }

      emit(DownloadVideoWithoutAudioLoadingState());

      await _getDownloadDirectory();

      final DownloadVideoRequestModel request = DownloadVideoRequestModel(
        url: controller.text,
        outputDir: path,
        quality: quality,
      );

      final result = await _videoWithoutAudioUsecase(request);

      result.fold(
        (error) =>
            emit(DownloadVideoWithoutAudioFailureState(error.toString())),
        (videoResponse) =>
            emit(DownloadVideoWithoutAudioSuccessState(videoResponse)),
      );
    } catch (error) {
      emit(DownloadVideoWithoutAudioFailureState(error.toString()));
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
