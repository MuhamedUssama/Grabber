import 'package:flutter/material.dart';
import 'package:grabber/core/theme/app_colors.dart';

class CustomVideoQualityButton extends StatelessWidget {
  final String quality;
  const CustomVideoQualityButton({super.key, required this.quality});

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;

    return OutlinedButton(
      onPressed: () {},
      child: Text(
        quality,
        style: textTheme.labelLarge?.copyWith(color: AppColors.darkTextColor),
      ),
    );
  }
}
