import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:grabber/core/theme/app_colors.dart';

abstract class AppTheme {
  static ThemeData darkTheme = ThemeData(
    scaffoldBackgroundColor: AppColors.dark,

    textTheme: TextTheme(
      displayLarge: GoogleFonts.righteous(
        color: AppColors.darkTextColor,
        fontSize: 56,
        fontWeight: FontWeight.bold,
      ),
      labelLarge: GoogleFonts.poppins(
        color: AppColors.dark,
        fontSize: 16,
        fontWeight: FontWeight.w400,
      ),
      bodySmall: GoogleFonts.poppins(
        color: AppColors.darkTextColor,
        fontSize: 12,
        fontWeight: FontWeight.w400,
      ),
    ),

    textSelectionTheme: TextSelectionThemeData(
      cursorColor: AppColors.darkTextColor,
      selectionColor: AppColors.darkTextColor.withValues(alpha: 0.2),
    ),

    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ButtonStyle(
        backgroundColor: WidgetStateProperty.all(AppColors.darkTextColor),
        foregroundColor: WidgetStateProperty.all(AppColors.dark),
        shape: WidgetStateProperty.all<RoundedRectangleBorder>(
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
        padding: WidgetStateProperty.all<EdgeInsetsGeometry>(
          EdgeInsets.symmetric(vertical: 16, horizontal: 24),
        ),
        overlayColor: WidgetStateProperty.all(
          AppColors.dark.withValues(alpha: 0.1),
        ),
      ),
    ),

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
        borderSide: const BorderSide(color: AppColors.darkTextColor),
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
