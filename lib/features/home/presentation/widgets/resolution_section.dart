import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:grabber/features/home/presentation/view_model/home_screen_states.dart';
import 'package:grabber/features/home/presentation/view_model/home_screen_view_model.dart';

import 'custom_video_quality_button.dart';

class ResolutionSection extends StatelessWidget {
  const ResolutionSection({super.key});

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;

    return BlocBuilder<HomeScreenViewModel, HomeScreenStates>(
      buildWhen:
          (previous, current) =>
              current is GetAvalibleResloutionsState ||
              current is GetVideoInfoLoadingState ||
              current is GetVideoInfoEmptyState ||
              current is GetVideoInfoErrorState,
      builder: (context, state) {
        if (state is GetVideoInfoLoadingState) {
          return Expanded(
            child: Center(
              child: CircularProgressIndicator(
                color: Theme.of(context).primaryColor,
              ),
            ),
          );
        } else if (state is GetVideoInfoEmptyState) {
          return Center(
            child: Text(state.message, style: textTheme.bodyMedium),
          );
        } else if (state is GetAvalibleResloutionsState) {
          final resolutions = state.resolutions;

          return Wrap(
            spacing: 16,
            runSpacing: 16,
            alignment: WrapAlignment.center,
            children:
                resolutions
                    .map((res) => CustomVideoQualityButton(quality: res))
                    .toList(),
          );
        } else {
          return const SizedBox();
        }
      },
    );
  }
}
