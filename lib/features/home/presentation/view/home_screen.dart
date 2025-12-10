import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:grabber/core/l10n/localization/app_localizations.dart';
import 'package:grabber/core/utils/snakbar_utils.dart';

import '../view_model/home_screen_states.dart';
import '../view_model/home_screen_view_model.dart';
import '../widgets/home_screen_scaffold.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final AppLocalizations locale = AppLocalizations.of(context)!;
    return BlocListener<HomeScreenViewModel, HomeScreenStates>(
      listener: (context, state) {
        if (state is ValidateUrlState) {
          SnakBarUtils.showSnakbar(context, Icons.error_rounded, state.message);
        } else if (state is GetVideoInfoErrorState) {
          SnakBarUtils.showSnakbar(context, Icons.error, state.error);
        } else if (state is SelectFolderPathSuccessState) {
          SnakBarUtils.showSnakbar(
            context,
            Icons.folder,
            locale.folderSelected,
          );
        } else if (state is SelectFolderPathFailureState) {
          SnakBarUtils.showSnakbar(
            context,
            Icons.error_rounded,
            state.message ?? locale.noFolderSelected,
          );
        } else if (state is DownloadFailureState) {
          SnakBarUtils.showSnakbar(context, Icons.error_rounded, state.error);
        } else if (state is DownloadCompletedState) {
          SnakBarUtils.showSnakbar(
            context,
            Icons.check_circle_outline_rounded,
            'Download Completed: ${state.filePath}',
          );
        } else if (state is DownloadCancelledState) {
          SnakBarUtils.showSnakbar(
            context,
            Icons.info_outline_rounded,
            locale.cancel,
          );
        } else if (state is GetDownloadsDirectoryFailureState) {
          SnakBarUtils.showSnakbar(context, Icons.error_rounded, state.error);
        }
      },
      child: const HomeScreenScaffold(),
    );
  }
}
