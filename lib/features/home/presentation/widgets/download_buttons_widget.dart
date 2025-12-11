import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:grabber/core/l10n/localization/app_localizations.dart';
import 'package:grabber/core/theme/app_colors.dart';
import 'package:grabber/features/home/presentation/view_model/home_screen_states.dart';
import 'package:grabber/features/home/presentation/view_model/home_screen_view_model.dart';

class DownloadButtonsWidget extends StatelessWidget {
  final VoidCallback onDownloadPressed;

  const DownloadButtonsWidget({super.key, required this.onDownloadPressed});

  @override
  Widget build(BuildContext context) {
    final locale = AppLocalizations.of(context)!;
    final textTheme = Theme.of(context).textTheme;

    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          child: BlocBuilder<HomeScreenViewModel, HomeScreenStates>(
            buildWhen:
                (previous, current) =>
                    current is DownloadRequestLoadingState ||
                    current is DownloadProgressState ||
                    current is DownloadCompletedState ||
                    current is DownloadFailureState ||
                    current is DownloadCancelledState,
            builder: (context, state) {
              return ElevatedButton.icon(
                onPressed: onDownloadPressed,
                icon:
                    state is DownloadRequestLoadingState
                        ? null
                        : const Icon(Icons.download_rounded),
                label:
                    state is DownloadRequestLoadingState
                        ? const CircularProgressIndicator(color: AppColors.dark)
                        : Text(
                          locale.startDownload,
                          style: textTheme.labelLarge,
                        ),
                style: ElevatedButton.styleFrom(
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(16)),
                  ),
                  minimumSize: const Size.fromHeight(64),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
