import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:grabber/core/theme/app_colors.dart';

abstract class AppTheme {
  static ThemeData darkTheme = ThemeData(
    scaffoldBackgroundColor: AppColors.dark,

    textTheme: TextTheme(),

    inputDecorationTheme: InputDecorationTheme(
      hintStyle: GoogleFonts.poppins(
        color: AppColors.darkHeadTextColor,
        fontSize: 18,
        fontWeight: FontWeight.w400,
      ),
      border: OutlineInputBorder(
        borderSide: const BorderSide(color: AppColors.darkTextColor),
        borderRadius: BorderRadius.circular(16),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: AppColors.darkTextColor),
        borderRadius: BorderRadius.circular(16),
      ),
      enabledBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: AppColors.darkHeadTextColor),
        borderRadius: BorderRadius.circular(16),
      ),
      errorBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: AppColors.error),
        borderRadius: BorderRadius.circular(16),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: AppColors.error),
        borderRadius: BorderRadius.circular(16),
      ),
    ),

    snackBarTheme: SnackBarThemeData(
      backgroundColor: AppColors.darkWithOpacity,
    ),
  );
}
