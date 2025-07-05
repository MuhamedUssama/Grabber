import 'package:flutter/material.dart';
import 'package:grabber/core/l10n/localization/app_localizations.dart';
import 'package:grabber/core/utils/app_validator.dart';
import 'package:grabber/core/widgets/custom_text_field.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final AppLocalizations locale = AppLocalizations.of(context)!;
    return Scaffold(
      body: Center(
        child: CustomTextField(
          hintText: locale.url,
          controller: TextEditingController(),
          validator: (value) => AppValidator.urlValidator(value),
        ),
      ),
    );
  }
}
