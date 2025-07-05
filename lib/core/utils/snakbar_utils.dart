import 'package:flutter/material.dart';
import 'package:grabber/core/theme/app_colors.dart';

abstract class SnakBarUtils {
  static void showSnakbar(BuildContext context, IconData icon, String message) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(icon, color: AppColors.darkTextColor),
            const SizedBox(width: 8),
            Text(message),
          ],
        ),
      ),
    );
  }
}
