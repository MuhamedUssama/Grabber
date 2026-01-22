import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:grabber/core/l10n/localization/app_localizations.dart';
import 'package:grabber/core/theme/app_colors.dart';
import 'package:grabber/features/home/presentation/view_model/home_screen_view_model.dart';

class DownloadProgressSection extends StatelessWidget {
  final double progress;
  final String status;

  const DownloadProgressSection({
    super.key,
    required this.progress,
    required this.status,
  });

  @override
  Widget build(BuildContext context) {
    final locale = AppLocalizations.of(context)!;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColor.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Theme.of(context).primaryColor.withValues(alpha: 0.1),
        ),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                status.toUpperCase(),
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: AppColors.darkTextColor,
                  letterSpacing: 1.0,
                ),
              ),
              Text(
                "${(progress * 100).toInt()}%",
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ],
          ),
          const SizedBox(height: 12),
          LinearProgressIndicator(
            value: progress > 0 ? progress : null,
            backgroundColor: AppColors.darkWithOpacity,
            color: AppColors.darkTextColor,
            borderRadius: BorderRadius.circular(8),
            minHeight: 8,
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: () {
                context.read<HomeScreenViewModel>().cancelCurrentDownload();
              },
              icon: const Icon(Icons.close_rounded, size: 18),
              label: Text(locale.cancel),
              style: OutlinedButton.styleFrom(
                foregroundColor: AppColors.error,
                side: const BorderSide(color: AppColors.error),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.symmetric(vertical: 16),
                minimumSize: const Size.fromHeight(56),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
