import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:grabber/core/theme/app_colors.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final String? Function(String?)? validator;
  final Widget? suffixIcon;

  const CustomTextField({
    super.key,
    required this.controller,
    required this.hintText,
    this.validator,
    this.suffixIcon,
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
      decoration: InputDecoration(hintText: hintText, suffixIcon: suffixIcon),
    );
  }
}
