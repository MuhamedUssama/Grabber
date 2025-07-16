import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:grabber/core/l10n/localization/app_localizations.dart';

import '../view_model/home_screen_view_model.dart';

class DownloadButtonsWidget extends StatelessWidget {
  const DownloadButtonsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final AppLocalizations locale = AppLocalizations.of(context)!;
    final TextTheme textTheme = Theme.of(context).textTheme;
    return Wrap(
      spacing: 16,
      runSpacing: 16,
      alignment: WrapAlignment.center,
      children: [
        ElevatedButton(
          onPressed: () {
            context.read<HomeScreenViewModel>().getVideoInfo();
          },
          child: Text(locale.getInfo, style: textTheme.labelLarge),
        ),

        ElevatedButton(
          onPressed: () {
            context.read<HomeScreenViewModel>().downloadAudio();
          },
          child: Text(locale.downloadAudio, style: textTheme.labelLarge),
        ),

        ElevatedButton(
          onPressed: () {
            context.read<HomeScreenViewModel>().downloadVideo();
          },
          child: Text(locale.downloadVideo, style: textTheme.labelLarge),
        ),

        ElevatedButton(
          onPressed: () {
            context.read<HomeScreenViewModel>().downloadVideoWithoutAudio();
          },
          child: Text(
            locale.downloadVideoWithoutAudio,
            style: textTheme.labelLarge,
          ),
        ),
      ],
    );
  }
}
