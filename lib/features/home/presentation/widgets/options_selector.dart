import 'package:flutter/material.dart';
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
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Theme.of(context).dividerColor),
              ),
              child: Row(
                children: [
                  _buildTypeTab(
                    context,
                    cubit,
                    DownloadType.video,
                    "Video",
                    Icons.videocam_rounded,
                  ),
                  _buildTypeTab(
                    context,
                    cubit,
                    DownloadType.audio,
                    "Audio",
                    Icons.audiotrack_rounded,
                  ),
                  _buildTypeTab(
                    context,
                    cubit,
                    DownloadType.subtitle,
                    "Subtitles",
                    Icons.subtitles_rounded,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            if (selectedType == DownloadType.video) ...[
              _buildDropdown(
                context,
                label: "Quality",
                value: selectedQuality,
                items: resolutions,
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
                items: const ['mp4', 'webm', 'mkv', 'avi', 'mov', 'flv', 'wmv'],
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
                items: const ['mp3', 'm4a', 'webm', 'opus', 'flac', 'wav'],
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
                onChanged: (val) {
                  if (val != null) {
                    cubit.changeLanguage(val);
                  }
                },
              ),
            ],
          ],
        );
      },
    );
  }

  Widget _buildTypeTab(
    BuildContext context,
    HomeScreenViewModel cubit,
    DownloadType type,
    String label,
    IconData icon,
  ) {
    final isSelected = cubit.selectedType == type;

    return Expanded(
      child: GestureDetector(
        onTap: () => cubit.changeDownloadType(type),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: isSelected ? AppColors.darkTextColor : AppColors.transparent,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            children: [
              Icon(
                icon,
                size: 20,
                color: isSelected ? AppColors.dark : AppColors.darkTextColor,
              ),
              const SizedBox(height: 4),
              Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                  color: isSelected ? AppColors.dark : AppColors.darkTextColor,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDropdown(
    BuildContext context, {
    required String label,
    required String? value,
    required List<String> items,
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
            style: TextStyle(
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
                style: TextStyle(fontWeight: FontWeight.bold),
                items:
                    items
                        .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                        .toList(),
                onChanged: onChanged,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
