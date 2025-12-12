import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:grabber/core/l10n/localization/app_localizations.dart';
import 'package:grabber/core/utils/app_assets.dart';
import 'package:grabber/features/home/presentation/enums/download_type.dart';

import 'package:grabber/features/home/presentation/view_model/home_screen_states.dart';
import 'package:grabber/features/home/presentation/view_model/home_screen_view_model.dart';
import 'package:grabber/features/home/presentation/widgets/download_buttons_widget.dart';
import 'package:grabber/features/home/presentation/widgets/download_progress_section.dart';
import 'package:grabber/features/home/presentation/widgets/folder_path_widget.dart';
import 'package:grabber/features/home/presentation/widgets/options_selector.dart';
import 'package:grabber/features/home/presentation/widgets/url_and_browse_widget.dart';
import 'package:grabber/features/home/presentation/widgets/video_info_card.dart';
import 'package:lottie/lottie.dart';

class HomeScreenScaffold extends StatefulWidget {
  const HomeScreenScaffold({super.key});

  @override
  State<HomeScreenScaffold> createState() => _HomeScreenScaffoldState();
}

class _HomeScreenScaffoldState extends State<HomeScreenScaffold> {
  @override
  Widget build(BuildContext context) {
    final AppLocalizations locale = AppLocalizations.of(context)!;
    final TextTheme textTheme = Theme.of(context).textTheme;

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          spacing: 24,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(locale.appName, style: textTheme.displayLarge),
            const UrlAndBrowseWidget(),
            const FolderPathWidget(),
            Expanded(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: 24,
                children: [
                  Expanded(
                    flex: 2,
                    child: BlocBuilder<HomeScreenViewModel, HomeScreenStates>(
                      buildWhen:
                          (prev, curr) =>
                              curr is GetVideoInfoSuccessState ||
                              curr is GetVideoInfoEmptyState ||
                              curr is HomeScreenInitialState ||
                              curr is GetVideoInfoLoadingState ||
                              curr is OptionsUpdatedState,
                      builder: (context, state) {
                        final vm = context.read<HomeScreenViewModel>();
                        if (state is GetVideoInfoSuccessState) {
                          return VideoInfoCard(info: state.videoInfo);
                        } else if (state is OptionsUpdatedState &&
                            vm.currentVideoInfo != null) {
                          return VideoInfoCard(info: vm.currentVideoInfo!);
                        } else if (state is GetVideoInfoLoadingState) {
                          return Center(
                            child: LottieBuilder.asset(
                              AppAnimations.dynamicLoading,
                            ),
                          );
                        }
                        return const SizedBox.shrink();
                      },
                    ),
                  ),

                  Expanded(
                    flex: 1,
                    child: Column(
                      spacing: 24,
                      children: [
                        BlocBuilder<HomeScreenViewModel, HomeScreenStates>(
                          buildWhen:
                              (prev, curr) =>
                                  curr is GetVideoInfoSuccessState ||
                                  curr is GetVideoInfoEmptyState ||
                                  curr is HomeScreenInitialState,
                          builder: (context, state) {
                            if (state is GetVideoInfoSuccessState) {
                              return const OptionsSelector();
                            }
                            return const SizedBox.shrink();
                          },
                        ),

                        BlocBuilder<HomeScreenViewModel, HomeScreenStates>(
                          builder: (context, state) {
                            if (state is DownloadProgressState) {
                              return DownloadProgressSection(
                                progress: state.progress,
                                status: state.status,
                              );
                            }

                            if (context
                                    .read<HomeScreenViewModel>()
                                    .videoTitle !=
                                null) {
                              return DownloadButtonsWidget(
                                onDownloadPressed: () {
                                  final cubit =
                                      context.read<HomeScreenViewModel>();
                                  final quality = cubit.selectedQuality;
                                  final type = cubit.selectedType;
                                  final format = cubit.selectedFormat;
                                  final lang = cubit.selectedLang;

                                  if (type == DownloadType.video &&
                                      quality != null) {
                                    cubit.downloadVideo(
                                      withAudio: true,
                                      outputFormat: format,
                                    );
                                  } else if (type == DownloadType.audio) {
                                    cubit.downloadAudio(
                                      outputFormat:
                                          format == 'original' ? null : format,
                                    );
                                  } else if (type == DownloadType.subtitle) {
                                    cubit.downloadSubtitle(lang: lang);
                                  }
                                },
                              );
                            }
                            return const SizedBox.shrink();
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Text(
              locale.appVersion,
              style: textTheme.bodySmall,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
