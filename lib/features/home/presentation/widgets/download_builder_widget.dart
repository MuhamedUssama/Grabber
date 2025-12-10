import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:grabber/core/utils/app_assets.dart';
import 'package:grabber/features/home/presentation/view_model/home_screen_states.dart';
import 'package:grabber/features/home/presentation/view_model/home_screen_view_model.dart';
import 'package:lottie/lottie.dart';

class DownloadBuilderWidget extends StatelessWidget {
  const DownloadBuilderWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeScreenViewModel, HomeScreenStates>(
      buildWhen:
          (previous, current) =>
              current is DownloadRequestLoadingState ||
              current is DownloadProgressState ||
              current is DownloadCompletedState ||
              current is DownloadFailureState ||
              current is DownloadCancelledState,
      builder: (context, state) {
        if (state is DownloadRequestLoadingState) {
          return Center(
            child: LottieBuilder.asset(AppAnimations.dynamicLoading),
          );
        }
        return const SizedBox.shrink();
      },
    );
  }
}
