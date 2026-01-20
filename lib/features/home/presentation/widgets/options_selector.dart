import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:grabber/core/theme/app_colors.dart';
import 'package:grabber/features/home/presentation/enums/download_type.dart';
import 'package:grabber/features/home/presentation/view_model/home_screen_states.dart';
import 'package:grabber/features/home/presentation/view_model/home_screen_view_model.dart';

class OptionsSelector extends StatelessWidget {
  const OptionsSelector({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeScreenViewModel, HomeScreenStates>(
      buildWhen:
          (previous, current) =>
              current is OptionsUpdatedState ||
              current is GetVideoInfoSuccessState ||
              current is GetVideoInfoEmptyState ||
              current is HomeScreenInitialState,
      builder: (context, state) {
        final cubit = context.read<HomeScreenViewModel>();

        final List<String> resolutions = cubit.availableResolutions;
        final selectedType = cubit.selectedType;
        final selectedQuality = cubit.selectedQuality;
        final selectedFormat = cubit.selectedFormat;
        final selectedLang = cubit.selectedLang;

        return Column(
          children: [
            Container(
                  height: 64,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: Theme.of(context).dividerColor),
                  ),
                  child: Stack(
                    children: [
                      // Sliding background indicator
                      AnimatedAlign(
                        duration: const Duration(milliseconds: 400),
                        curve: Curves.easeOutQuart,
                        alignment: _getAlignment(selectedType),
                        child: FractionallySizedBox(
                          widthFactor: 1 / 3,
                          child: Container(
                            margin: const EdgeInsets.all(4),
                            decoration: BoxDecoration(
                              color: AppColors.darkTextColor,
                              borderRadius: BorderRadius.circular(12),
                              boxShadow: [
                                BoxShadow(
                                  color: AppColors.darkTextColor.withValues(
                                    alpha: 0.15,
                                  ),
                                  blurRadius: 10,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      // Tab labels and interactions
                      Row(
                        children: [
                          _buildTypeTab(
                            context,
                            cubit,
                            DownloadType.video,
                            "Video",
                            Icons.videocam_rounded,
                            0,
                          ),
                          _buildTypeTab(
                            context,
                            cubit,
                            DownloadType.audio,
                            "Audio",
                            Icons.audiotrack_rounded,
                            1,
                          ),
                          _buildTypeTab(
                            context,
                            cubit,
                            DownloadType.subtitle,
                            "Subtitles",
                            Icons.subtitles_rounded,
                            2,
                          ),
                        ],
                      ),
                    ],
                  ),
                )
                .animate()
                .fadeIn(duration: 800.ms, curve: Curves.easeOutQuart)
                .scale(
                  begin: const Offset(0.98, 0.98),
                  curve: Curves.easeOutQuart,
                )
                .slideY(begin: 0.05, end: 0, curve: Curves.easeOutQuart),
            const SizedBox(height: 16),
            Column(
                  key: ValueKey(selectedType),
                  children: [
                    if (selectedType == DownloadType.video) ...[
                      _buildDropdown(
                        context,
                        label: "Quality",
                        value: selectedQuality,
                        items: resolutions,
                        index: 0,
                        onChanged: (val) {
                          if (val != null) {
                            cubit.changeQuality(val);
                          }
                        },
                      ),
                      const SizedBox(height: 12),
                      _buildDropdown(
                        context,
                        label: "Format",
                        value: selectedFormat,
                        items: const [
                          'mp4',
                          'webm',
                          'mkv',
                          'avi',
                          'mov',
                          'flv',
                          'wmv',
                        ],
                        index: 1,
                        onChanged: (val) {
                          if (val != null) {
                            cubit.changeFormat(val);
                          }
                        },
                      ),
                    ],
                    if (selectedType == DownloadType.audio) ...[
                      _buildDropdown(
                        context,
                        label: "Format",
                        value: selectedFormat,
                        items: const [
                          'mp3',
                          'm4a',
                          'webm',
                          'opus',
                          'flac',
                          'wav',
                        ],
                        index: 0,
                        onChanged: (val) {
                          if (val != null) {
                            cubit.changeFormat(val);
                          }
                        },
                      ),
                    ],
                    if (selectedType == DownloadType.subtitle) ...[
                      _buildDropdown(
                        context,
                        label: "Languages",
                        value: selectedLang,
                        items: const ['en,ar', 'en', 'ar'],
                        index: 0,
                        onChanged: (val) {
                          if (val != null) {
                            cubit.changeLanguage(val);
                          }
                        },
                      ),
                    ],
                  ],
                )
                .animate(key: ValueKey(selectedType))
                .fadeIn(duration: 600.ms, curve: Curves.easeOutQuart)
                .slideY(begin: 0.02, end: 0, curve: Curves.easeOutQuart),
          ],
        );
      },
    );
  }

  Alignment _getAlignment(DownloadType type) {
    switch (type) {
      case DownloadType.video:
        return Alignment.centerLeft;
      case DownloadType.audio:
        return Alignment.center;
      case DownloadType.subtitle:
        return Alignment.centerRight;
    }
  }

  Widget _buildTypeTab(
    BuildContext context,
    HomeScreenViewModel cubit,
    DownloadType type,
    String label,
    IconData icon,
    int index,
  ) {
    final isSelected = cubit.selectedType == type;

    return Expanded(
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () => cubit.changeDownloadType(type),
        child: Container(
          color: Colors.transparent,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TweenAnimationBuilder<Color?>(
                    duration: const Duration(milliseconds: 300),
                    tween: ColorTween(
                      begin: AppColors.darkTextColor,
                      end:
                          isSelected ? AppColors.dark : AppColors.darkTextColor,
                    ),
                    builder: (context, color, child) {
                      return Icon(icon, size: 20, color: color);
                    },
                  )
                  .animate(target: isSelected ? 1 : 0)
                  .scale(
                    begin: const Offset(1, 1),
                    end: const Offset(1.1, 1.1),
                    duration: 400.ms,
                    curve: Curves.easeInOutCubic,
                  ),
              const SizedBox(height: 2),
              TweenAnimationBuilder<Color?>(
                duration: const Duration(milliseconds: 300),
                tween: ColorTween(
                  begin: AppColors.darkTextColor,
                  end: isSelected ? AppColors.dark : AppColors.darkTextColor,
                ),
                builder: (context, color, child) {
                  return Text(
                    label,
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight:
                          isSelected ? FontWeight.bold : FontWeight.w500,
                      color: color,
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ).animate().fadeIn(delay: (400 + (100 * index)).ms, duration: 600.ms),
    );
  }

  Widget _buildDropdown(
    BuildContext context, {
    required String label,
    required String? value,
    required List<String> items,
    required int index,
    required Function(String?) onChanged,
  }) {
    return Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          decoration: BoxDecoration(
            color: AppColors.dark,
            border: Border.all(color: AppColors.darkWithOpacity),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Row(
            children: [
              Text(
                "$label:",
                style: const TextStyle(
                  fontWeight: FontWeight.w500,
                  color: AppColors.darkTextColor,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: (items.contains(value)) ? value : null,
                    hint: Text(
                      "Select",
                      style: Theme.of(
                        context,
                      ).textTheme.bodyMedium?.copyWith(fontSize: 14),
                    ),
                    isExpanded: true,
                    dropdownColor: AppColors.dark,
                    iconEnabledColor: AppColors.darkWithOpacity,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                    items:
                        items
                            .map(
                              (e) => DropdownMenuItem(value: e, child: Text(e)),
                            )
                            .toList(),
                    onChanged: onChanged,
                  ),
                ),
              ),
            ],
          ),
        )
        .animate()
        .fadeIn(
          delay: (200 * index).ms,
          duration: 800.ms,
          curve: Curves.easeOutQuart,
        )
        .slideY(begin: 0.05, end: 0, curve: Curves.easeOutQuart);
  }
}
