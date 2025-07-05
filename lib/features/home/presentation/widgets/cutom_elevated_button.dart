import 'package:flutter/material.dart';
import 'package:grabber/core/theme/app_colors.dart';

class CutomElevatedButton extends StatelessWidget {
  final void Function()? onPressed;
  final String title;
  const CutomElevatedButton({super.key, this.onPressed, required this.title});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.darkWithOpacity,
        foregroundColor: AppColors.darkHeadTextColor,
        padding: EdgeInsets.symmetric(vertical: 16, horizontal: 24),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
      child: Text(
        title,
        style: Theme.of(
          context,
        ).textTheme.labelLarge?.copyWith(color: AppColors.darkHeadTextColor),
      ),
    );
  }
}
