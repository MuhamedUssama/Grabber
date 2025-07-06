import 'dart:developer';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:grabber/features/home/data/models/request/get_video_info_request.dart';
import 'package:grabber/features/home/data/models/response/get_video_info_model.dart';
import 'package:grabber/features/home/domain/usecases/get_video_info_usecase.dart';
import 'package:injectable/injectable.dart';

import 'home_screen_states.dart';

@injectable
class HomeScreenViewModel extends Cubit<HomeScreenStates> {
  final GetVideoInfoUsecase _videoInfoUsecase;
  HomeScreenViewModel(this._videoInfoUsecase) : super(HomeScreenInitialState());

  final TextEditingController controller = TextEditingController();

  String? path;
  String? videoTitle;
  String? quality;
  List<Streams> streams = [];

  Future<void> getVideoInfo() async {
    try {
      emit(GetVideoInfoLoadingState());

      final String? validationMessage = _urlValidator(controller.text);
      if (validationMessage != null) {
        emit(ValidateUrlState(validationMessage));
        return;
      }

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
}
