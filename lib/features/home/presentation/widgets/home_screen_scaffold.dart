import 'package:flutter/material.dart';
import 'package:grabber/core/l10n/localization/app_localizations.dart';

import 'download_builder_widget.dart';
import 'download_buttons_widget.dart';
import 'folder_path_widget.dart';
import 'resolution_section.dart';
import 'url_and_browse_widget.dart';

class HomeScreenScaffold extends StatelessWidget {
  const HomeScreenScaffold({super.key});

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
    );
  }
}
