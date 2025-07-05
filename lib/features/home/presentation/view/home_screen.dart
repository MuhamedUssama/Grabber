import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:grabber/core/l10n/localization/app_localizations.dart';
import 'package:grabber/core/theme/app_colors.dart';
import 'package:grabber/core/utils/app_services.dart';
import 'package:grabber/core/utils/app_validator.dart';
import 'package:grabber/core/widgets/custom_text_field.dart';

import '../view_model/home_screen_view_model.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final AppLocalizations locale = AppLocalizations.of(context)!;
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            CustomTextField(
              hintText: locale.url,
              controller: context.read<HomeScreenViewModel>().controller,
              validator: (value) => AppValidator.urlValidator(value),
              suffixIcon: IconButton(
                onPressed: () {
                  AppServices.pasteFromClipboard(
                    context: context,
                    controller: context.read<HomeScreenViewModel>().controller,
                  );
                  Future.delayed(Duration(seconds: 1), () {
                    // ignore: use_build_context_synchronously
                    context.read<HomeScreenViewModel>().getVideoInfo();
                  });
                },
                color: AppColors.darkTextColor,
                splashColor: AppColors.darkHeadTextColor,
                disabledColor: AppColors.darkHeadTextColor,
                splashRadius: 20,
                icon: const Icon(Icons.content_paste_rounded),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
