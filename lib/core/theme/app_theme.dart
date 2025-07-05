import 'package:flutter/material.dart';
import 'package:grabber/core/theme/app_colors.dart';

abstract class AppTheme {
  static ThemeData darkTheme = ThemeData(
    scaffoldBackgroundColor: AppColors.dark,

    snackBarTheme: SnackBarThemeData(
      backgroundColor: AppColors.darkWithOpacity,
    ),
  );
}
