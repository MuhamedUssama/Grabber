// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:grabber/core/l10n/localization/app_localizations.dart';
import 'package:grabber/core/utils/snakbar_utils.dart';

abstract class AppServices {
  static void pasteFromClipboard({
    required BuildContext context,
    required TextEditingController controller,
  }) async {
    final ClipboardData? clipboardData = await Clipboard.getData('text/plain');
    if (clipboardData != null && clipboardData.text != null) {
      controller.text = clipboardData.text!;

      SnakBarUtils.showSnakbar(
        context,
        Icons.paste,
        AppLocalizations.of(context)!.paste,
      );
    } else {
      return;
    }
  }
}
