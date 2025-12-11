import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:grabber/features/home/presentation/view_model/home_screen_states.dart';
import 'package:grabber/features/home/presentation/view_model/home_screen_view_model.dart';

// Enum for internal UI selection
enum DownloadType { video, audio, subtitle }

class OptionsSelector extends StatefulWidget {
  final Function(DownloadType type, String? quality, String format, String lang)
  onOptionChanged;

  const OptionsSelector({super.key, required this.onOptionChanged});

  @override
  State<OptionsSelector> createState() => _OptionsSelectorState();
}

class _OptionsSelectorState extends State<OptionsSelector> {
  DownloadType _selectedType = DownloadType.video;
  String? _selectedQuality;
  String _selectedFormat = 'mp4';
  String _selectedLang = 'en,ar';

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeScreenViewModel, HomeScreenStates>(
      builder: (context, state) {
        final cubit = context.read<HomeScreenViewModel>();

        // Re-trigger callbacks to ensure parent has default values
        // Note: Ideally do this in logic, but for UI sync this is quick refactor

        List<String> resolutions = [
          "144p",
          "240p",
          "360p",
          "480p",
          "720p",
          "1080p",
          "2160p",
          "4320p",
        ];
        if (state is GetAvalibleResloutionsState) {
          resolutions = state.resolutions;
          if (!resolutions.contains(_selectedQuality) &&
              resolutions.isNotEmpty) {
            _selectedQuality = resolutions.first;
            // Notify parent of auto-selection
            Future.microtask(
              () => widget.onOptionChanged(
                _selectedType,
                _selectedQuality,
                _selectedFormat,
                _selectedLang,
              ),
            );
          }
        }

        return Column(
          children: [
            // Type Selector
            Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: Theme.of(context).dividerColor.withValues(alpha: 0.1),
                ),
              ),
              child: Row(
                children: [
                  _buildTypeTab(
                    context,
                    DownloadType.video,
                    "Video",
                    Icons.videocam_rounded,
                  ),
                  _buildTypeTab(
                    context,
                    DownloadType.audio,
                    "Audio",
                    Icons.audiotrack_rounded,
                  ),
                  _buildTypeTab(
                    context,
                    DownloadType.subtitle,
                    "Subs",
                    Icons.subtitles_rounded,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Contextual Options
            if (_selectedType == DownloadType.video) ...[
              _buildDropdown(
                context,
                label: "Quality",
                value: _selectedQuality,
                items: resolutions,
                onChanged: (val) {
                  setState(() => _selectedQuality = val);
                  cubit.updateQualityValue(val!);
                  widget.onOptionChanged(
                    _selectedType,
                    _selectedQuality,
                    _selectedFormat,
                    _selectedLang,
                  );
                },
              ),
              const SizedBox(height: 12),
              _buildDropdown(
                context,
                label: "Format",
                value: _selectedFormat,
                items: const ['mp4', 'original'],
                onChanged: (val) {
                  setState(() => _selectedFormat = val!);
                  widget.onOptionChanged(
                    _selectedType,
                    _selectedQuality,
                    _selectedFormat,
                    _selectedLang,
                  );
                },
              ),
            ],

            if (_selectedType == DownloadType.audio) ...[
              _buildDropdown(
                context,
                label: "Format",
                value: 'mp3',
                items: const ['mp3', 'm4a', 'original'],
                onChanged: (val) {
                  setState(() => _selectedFormat = val!);
                  widget.onOptionChanged(
                    _selectedType,
                    _selectedQuality,
                    _selectedFormat,
                    _selectedLang,
                  );
                },
              ),
            ],

            if (_selectedType == DownloadType.subtitle) ...[
              _buildDropdown(
                context,
                label: "Languages",
                value: 'en,ar',
                items: const ['en,ar', 'en', 'ar'],
                onChanged: (val) {
                  setState(() => _selectedLang = val!);
                  widget.onOptionChanged(
                    _selectedType,
                    _selectedQuality,
                    _selectedFormat,
                    _selectedLang,
                  );
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
    DownloadType type,
    String label,
    IconData icon,
  ) {
    final isSelected = _selectedType == type;
    final theme = Theme.of(context);

    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            _selectedType = type;
            // Notify parent immediately
            widget.onOptionChanged(
              _selectedType,
              _selectedQuality,
              _selectedFormat,
              _selectedLang,
            );
          });
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color:
                isSelected
                    ? theme.primaryColor.withValues(alpha: 0.1)
                    : Colors.transparent,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            children: [
              Icon(
                icon,
                size: 20,
                color:
                    isSelected
                        ? theme.primaryColor
                        : theme.iconTheme.color?.withValues(alpha: 0.5),
              ),
              const SizedBox(height: 4),
              Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                  color:
                      isSelected
                          ? theme.primaryColor
                          : theme.textTheme.bodySmall?.color,
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
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      decoration: BoxDecoration(
        color: theme.inputDecorationTheme.fillColor,
        border: Border.all(color: theme.dividerColor),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Text(
            "$label:",
            style: theme.textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w500,
              color: theme.hintColor,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: (items.contains(value)) ? value : null,
                hint: Text(
                  "Select",
                  style: theme.inputDecorationTheme.hintStyle,
                ),
                isExpanded: true,
                dropdownColor: theme.cardColor,
                iconEnabledColor: theme.iconTheme.color,
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
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
