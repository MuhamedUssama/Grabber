import 'package:flutter/material.dart';
import 'package:grabber/core/l10n/localization/app_localizations.dart';

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
          child: ElevatedButton.icon(
            onPressed: onDownloadPressed,
            icon: const Icon(Icons.download_rounded),
            label: Text(locale.startDownload, style: textTheme.labelLarge),
            style: ElevatedButton.styleFrom(
              minimumSize: const Size.fromHeight(64),
            ),
          ),
        ),
      ],
    );
  }
}
