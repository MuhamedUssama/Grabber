import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:grabber/core/theme/app_colors.dart';

import '../view_model/home_screen_view_model.dart';

class CustomVideoQualityButton extends StatelessWidget {
  final String quality;
  const CustomVideoQualityButton({super.key, required this.quality});

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;

    return OutlinedButton(
      onPressed: () {
        context.read<HomeScreenViewModel>().quality = quality;
      },
      child: Text(
        quality,
        style: textTheme.labelLarge?.copyWith(color: AppColors.darkTextColor),
      ),
    );
  }
}
