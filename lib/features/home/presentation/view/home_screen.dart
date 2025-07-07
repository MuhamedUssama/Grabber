import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:grabber/core/l10n/localization/app_localizations.dart';
import 'package:grabber/core/utils/snakbar_utils.dart';
import 'package:grabber/features/home/presentation/widgets/folder_path_widget.dart';

import '../view_model/home_screen_states.dart';
import '../view_model/home_screen_view_model.dart';
import '../widgets/download_builder_widget.dart';
import '../widgets/download_buttons_widget.dart';
import '../widgets/resolution_section.dart';
import '../widgets/url_and_browse_widget.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final AppLocalizations locale = AppLocalizations.of(context)!;
    final TextTheme textTheme = Theme.of(context).textTheme;
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
        } else if (state is DownloadAudioFailureState) {
          SnakBarUtils.showSnakbar(
            context,
            Icons.error_rounded,
            state.error ?? locale.somethingWentWorng,
          );
        } else if (state is DownloadVideoFailureState) {
          SnakBarUtils.showSnakbar(
            context,
            Icons.error_rounded,
            state.error ?? locale.somethingWentWorng,
          );
        } else if (state is DownloadVideoWithoutAudioFailureState) {
          SnakBarUtils.showSnakbar(
            context,
            Icons.error_rounded,
            state.error ?? locale.somethingWentWorng,
          );
        } else if (state is DownloadAudioSuccessState) {
          SnakBarUtils.showSnakbar(
            context,
            Icons.check_circle_outline_rounded,
            'Audio downloaded successfully in ${context.read<HomeScreenViewModel>().path}',
          );
        } else if (state is DownloadVideoSuccessState) {
          SnakBarUtils.showSnakbar(
            context,
            Icons.check_circle_outline_rounded,
            'Video downloaded successfully in ${context.read<HomeScreenViewModel>().path}',
          );
        } else if (state is DownloadVideoWithoutAudioSuccessState) {
          SnakBarUtils.showSnakbar(
            context,
            Icons.check_circle_outline_rounded,
            'Video downloaded successfully in ${context.read<HomeScreenViewModel>().path}',
          );
        } else if (state is GetDownloadsDirectoryFailureState) {
          SnakBarUtils.showSnakbar(context, Icons.error_rounded, state.error);
        }
      },
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            spacing: 24,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  spacing: 24,
                  children: [
                    Row(
                      children: [
                        Text(locale.appName, style: textTheme.displayLarge),
                      ],
                    ),
                    const UrlAndBrowseWidget(),
                    const FolderPathWidget(),
                    DownloadButtonsWidget(),
                    ResolutionSection(),
                    const DownloadBuilderWidget(),
                  ],
                ),
              ),
              Text(locale.appVersion, style: textTheme.bodySmall),
            ],
          ),
        ),
      ),
    );
  }
}
