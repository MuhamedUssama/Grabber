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
    // final TextTheme textTheme = Theme.of(context).textTheme;

    return BlocBuilder<HomeScreenViewModel, HomeScreenStates>(
      buildWhen:
          (previous, current) =>
              current is DownloadAudioLoadingState ||
              current is DownloadAudioSuccessState,
      builder: (context, state) {
        if (state is DownloadAudioLoadingState) {
          return Expanded(
            child: LottieBuilder.asset(AppAnimations.dynamicLoading),
          );
        } else if (state is DownloadAudioSuccessState) {
          return Visibility(
            visible: false,
            child: const SizedBox(height: 0, width: 0),
          );
        } else {
          return const SizedBox(height: 0, width: 0);
        }
      },
    );
  }
}
