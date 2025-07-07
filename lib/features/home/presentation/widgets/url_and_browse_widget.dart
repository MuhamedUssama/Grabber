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
      spacing: 16,
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
              },
              color: AppColors.darkTextColor,
              splashColor: AppColors.darkHeadTextColor,
              disabledColor: AppColors.darkHeadTextColor,
              splashRadius: 20,
              icon: const Icon(Icons.content_paste_rounded),
            ),
          ),
        ),
        ElevatedButton(
          onPressed: () {
            context.read<HomeScreenViewModel>().pickFolderPath();
          },
          child: Text(locale.browse, style: textTheme.labelLarge),
        ),
      ],
    );
  }
}
