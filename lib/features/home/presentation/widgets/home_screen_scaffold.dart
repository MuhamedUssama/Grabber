import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
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
            Text(locale.appName, style: textTheme.displayLarge)
                .animate()
                .fadeIn(duration: 600.ms)
                .slideX(begin: -0.1, end: 0, curve: Curves.easeOutQuad),
            const UrlAndBrowseWidget()
                .animate()
                .fadeIn(delay: 200.ms, duration: 600.ms)
                .slideY(begin: 0.1, end: 0),
            const FolderPathWidget()
                .animate()
                .fadeIn(delay: 300.ms, duration: 600.ms)
                .slideY(begin: 0.1, end: 0),
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
                              curr is GetVideoInfoErrorState ||
                              curr is OptionsUpdatedState,
                      builder: (context, state) {
                        final vm = context.read<HomeScreenViewModel>();

                        Widget content;
                        if (state is GetVideoInfoSuccessState) {
                          content = VideoInfoCard(
                            key: ValueKey(
                              state.videoInfo.data.entries.firstOrNull?.url ??
                                  'video',
                            ),
                            info: state.videoInfo,
                          );
                        } else if (state is OptionsUpdatedState &&
                            vm.currentVideoInfo != null) {
                          content = VideoInfoCard(
                            key: ValueKey(
                              vm
                                      .currentVideoInfo!
                                      .data
                                      .entries
                                      .firstOrNull
                                      ?.url ??
                                  'video-updated',
                            ),
                            info: vm.currentVideoInfo!,
                          );
                        } else if (state is GetVideoInfoLoadingState) {
                          content = Center(
                            key: const ValueKey('loading'),
                            child: LottieBuilder.asset(
                              AppAnimations.dynamicLoading,
                            ),
                          );
                        } else if (state is GetVideoInfoErrorState) {
                          content = Center(
                            child: LottieBuilder.asset(AppAnimations.error),
                          );
                        } else {
                          content = const SizedBox.shrink();
                        }

                        return content
                            .animate(key: ValueKey(state.runtimeType))
                            .fadeIn(duration: 400.ms)
                            .scale(begin: const Offset(0.98, 0.98));
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
                              return const OptionsSelector()
                                  .animate()
                                  .fadeIn(duration: 400.ms)
                                  .slideX(begin: 0.1, end: 0);
                            }
                            return const SizedBox.shrink();
                          },
                        ),
                        BlocBuilder<HomeScreenViewModel, HomeScreenStates>(
                          builder: (context, state) {
                            Widget? content;
                            if (state is DownloadProgressState) {
                              content = DownloadProgressSection(
                                key: const ValueKey('progress'),
                                progress: state.progress,
                                status: state.status,
                              );
                            } else if (context
                                    .read<HomeScreenViewModel>()
                                    .videoTitle !=
                                null) {
                              content = DownloadButtonsWidget(
                                key: const ValueKey('buttons'),
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

                            if (content != null) {
                              return content
                                  .animate(key: ValueKey(content.runtimeType))
                                  .fadeIn(duration: 400.ms)
                                  .slideY(begin: 0.1, end: 0);
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
            ).animate().fadeIn(delay: 1.seconds),
          ],
        ),
      ),
    );
  }
}
