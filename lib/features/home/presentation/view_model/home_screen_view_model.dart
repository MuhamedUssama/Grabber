import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:grabber/features/home/data/models/request/get_video_info_request.dart';
import 'package:grabber/features/home/domain/usecases/get_video_info_usecase.dart';
import 'package:injectable/injectable.dart';

import 'home_screen_states.dart';

@injectable
class HomeScreenViewModel extends Cubit<HomeScreenStates> {
  final GetVideoInfoUsecase _videoInfoUsecase;
  HomeScreenViewModel(this._videoInfoUsecase) : super(HomeScreenInitialState());

  final TextEditingController controller = TextEditingController();

  Future<void> getVideoInfo() async {
    try {
      emit(GetVideoInfoLoadingState());

      final GetVideoInfoRequest request = GetVideoInfoRequest(
        url: controller.text,
      );

      final result = await _videoInfoUsecase(request);

      result.fold(
        (error) => emit(GetVideoInfoErrorState(error.message!)),
        (videoInfo) => emit(GetVideoInfoSuccessState(videoInfo)),
      );
    } catch (exception) {
      emit(GetVideoInfoErrorState(exception.toString()));
    }
  }
}
