import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:grabber/core/l10n/localization/app_localizations.dart';
import 'package:grabber/core/theme/app_colors.dart';
import 'package:grabber/core/utils/snakbar_utils.dart';

class CustomTextField extends StatefulWidget {
  final TextEditingController controller;
  final String hintText;
  final String? Function(String?)? validator;

  const CustomTextField({
    super.key,
    required this.controller,
    required this.validator,
    required this.hintText,
  });

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  void pasteFromClipboard(BuildContext context) async {
    final ClipboardData? clipboardData = await Clipboard.getData('text/plain');
    if (clipboardData != null && clipboardData.text != null) {
      widget.controller.text = clipboardData.text!;

      SnakBarUtils.showSnakbar(
        // ignore: use_build_context_synchronously
        context,
        Icons.paste,
        // ignore: use_build_context_synchronously
        AppLocalizations.of(context)!.paste,
      );
    } else {
      return;
    }
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      cursorColor: AppColors.darkTextColor,
      cursorRadius: Radius.circular(16),
      style: GoogleFonts.poppins(
        color: AppColors.white,
        fontSize: 18,
        fontWeight: FontWeight.w400,
      ),
      textInputAction: TextInputAction.done,
      validator: widget.validator,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      decoration: InputDecoration(
        hintText: widget.hintText,
        suffixIcon: _pasteButton(context),
      ),
    );
  }

  IconButton _pasteButton(BuildContext context) {
    return IconButton(
      onPressed: () {
        setState(() {
          pasteFromClipboard(context);
        });
      },
      color: AppColors.darkTextColor,
      splashColor: AppColors.darkHeadTextColor,
      disabledColor: AppColors.darkHeadTextColor,
      splashRadius: 20,
      icon: const Icon(Icons.content_paste_rounded),
    );
  }
}
