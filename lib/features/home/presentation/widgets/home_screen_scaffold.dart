import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:grabber/core/l10n/localization/app_localizations.dart';
import 'package:grabber/features/home/presentation/view_model/home_screen_states.dart';
import 'package:grabber/features/home/presentation/view_model/home_screen_view_model.dart';
import 'package:grabber/features/home/presentation/widgets/download_builder_widget.dart';
import 'package:grabber/features/home/presentation/widgets/download_buttons_widget.dart';
import 'package:grabber/features/home/presentation/widgets/download_progress_section.dart';
import 'package:grabber/features/home/presentation/widgets/options_selector.dart';
import 'package:grabber/features/home/presentation/widgets/url_and_browse_widget.dart';
import 'package:grabber/features/home/presentation/widgets/video_info_card.dart';

class HomeScreenScaffold extends StatefulWidget {
  const HomeScreenScaffold({super.key});

  @override
  State<HomeScreenScaffold> createState() => _HomeScreenScaffoldState();
}

class _HomeScreenScaffoldState extends State<HomeScreenScaffold> {
  DownloadType _selectedType = DownloadType.video;
  String? _selectedQuality;
  String _selectedFormat = 'mp4';
  String _selectedLang = 'en,ar';

  @override
  Widget build(BuildContext context) {
    final AppLocalizations locale = AppLocalizations.of(context)!;
    final TextTheme textTheme = Theme.of(context).textTheme;

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          spacing: 24,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  spacing: 24,
                  children: [
                    Text(locale.appName, style: textTheme.displayLarge),
                    const UrlAndBrowseWidget(),
                    BlocBuilder<HomeScreenViewModel, HomeScreenStates>(
                      buildWhen:
                          (prev, curr) =>
                              curr is GetVideoInfoSuccessState ||
                              curr is GetVideoInfoEmptyState ||
                              curr is HomeScreenInitialState,
                      builder: (context, state) {
                        if (state is GetVideoInfoSuccessState) {
                          return Column(
                            spacing: 24,
                            children: [
                              VideoInfoCard(info: state.videoInfo),
                              OptionsSelector(
                                onOptionChanged: (type, quality, format, lang) {
                                  setState(() {
                                    _selectedType = type;
                                    _selectedQuality = quality;
                                    _selectedFormat = format;
                                    _selectedLang = lang;
                                  });
                                },
                              ),
                            ],
                          );
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
                        } else if (state is DownloadRequestLoadingState) {
                          // return const Center(
                          //   child: CircularProgressIndicator(),
                          // );
                          return const DownloadBuilderWidget();
                        }

                        if (context.read<HomeScreenViewModel>().videoTitle !=
                            null) {
                          return DownloadButtonsWidget(
                            onDownloadPressed: () {
                              final cubit = context.read<HomeScreenViewModel>();
                              final quality = _selectedQuality;
                              if (_selectedType == DownloadType.video &&
                                  quality != null) {
                                cubit.quality = quality;
                                cubit.downloadVideo(
                                  withAudio: true,
                                  outputFormat: _selectedFormat,
                                );
                              } else if (_selectedType == DownloadType.audio) {
                                cubit.downloadAudio(
                                  outputFormat:
                                      _selectedFormat == 'original'
                                          ? null
                                          : _selectedFormat,
                                );
                              } else if (_selectedType ==
                                  DownloadType.subtitle) {
                                cubit.downloadSubtitle(lang: _selectedLang);
                              }
                            },
                          );
                        }
                        return const SizedBox.shrink();
                      },
                    ),

                    const DownloadBuilderWidget(),
                  ],
                ),
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
