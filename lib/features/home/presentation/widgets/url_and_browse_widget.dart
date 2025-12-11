import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/l10n/localization/app_localizations.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/app_services.dart';
import '../../../../core/widgets/custom_text_field.dart';
import '../view_model/home_screen_view_model.dart';

class UrlAndBrowseWidget extends StatelessWidget {
  const UrlAndBrowseWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final AppLocalizations locale = AppLocalizations.of(context)!;
    final TextTheme textTheme = Theme.of(context).textTheme;
    return Row(
      children: [
        Expanded(
          child: CustomTextField(
            hintText: locale.url,
            controller: context.read<HomeScreenViewModel>().controller,
            suffixIcon: IconButton(
              onPressed: () {
                AppServices.pasteFromClipboard(
                  context: context,
                  controller: context.read<HomeScreenViewModel>().controller,
                );
                Future.delayed(Duration(milliseconds: 500), () {
                  if (context.mounted) {
                    context.read<HomeScreenViewModel>().getVideoInfo();
                  }
                });
              },
              color: AppColors.darkTextColor,
              splashColor: AppColors.darkHeadTextColor,
              disabledColor: AppColors.darkHeadTextColor,
              splashRadius: 20,
              icon: const Icon(Icons.content_paste_rounded),
            ),
          ),
        ),
        const SizedBox(width: 16),
        ElevatedButton(
          onPressed: () {
            context.read<HomeScreenViewModel>().getVideoInfo();
          },
          child: Text(locale.getInfo, style: textTheme.labelLarge),
        ),
        const SizedBox(width: 8),
        IconButton(
          tooltip: locale.pickFolder,
          onPressed: () {
            context.read<HomeScreenViewModel>().pickFolderPath();
          },
          icon: const Icon(
            Icons.folder,
            size: 24,
            color: AppColors.darkTextColor,
          ),
        ),
      ],
    );
  }
}
