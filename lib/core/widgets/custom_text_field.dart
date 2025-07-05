import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:grabber/core/theme/app_colors.dart';
import 'package:grabber/core/utils/app_services.dart';
import 'package:grabber/features/home/presentation/view_model/home_screen_view_model.dart';

class CustomTextField extends StatelessWidget {
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
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      cursorColor: AppColors.darkTextColor,
      cursorRadius: Radius.circular(16),
      style: GoogleFonts.poppins(
        color: AppColors.white,
        fontSize: 18,
        fontWeight: FontWeight.w400,
      ),
      textInputAction: TextInputAction.done,
      validator: validator,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      decoration: InputDecoration(
        hintText: hintText,
        suffixIcon: _pasteButton(context),
      ),
    );
  }

  IconButton _pasteButton(BuildContext context) {
    return IconButton(
      onPressed: () {
        AppServices.pasteFromClipboard(
          context: context,
          controller: controller,
        );
        context.read<HomeScreenViewModel>().getVideoInfo();
      },
      color: AppColors.darkTextColor,
      splashColor: AppColors.darkHeadTextColor,
      disabledColor: AppColors.darkHeadTextColor,
      splashRadius: 20,
      icon: const Icon(Icons.content_paste_rounded),
    );
  }
}
