import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:grabber/core/l10n/localization/app_localizations.dart';
import 'package:grabber/core/theme/app_colors.dart';
import 'package:grabber/features/home/presentation/view_model/home_screen_states.dart';
import 'package:grabber/features/home/presentation/view_model/home_screen_view_model.dart';
import 'package:grabber/core/utils/formatters.dart';
import 'package:grabber/features/home/domain/entites/task_status.dart';

class DownloadButtonsWidget extends StatelessWidget {
  final VoidCallback onDownloadPressed;

  const DownloadButtonsWidget({super.key, required this.onDownloadPressed});

  @override
  Widget build(BuildContext context) {
    final locale = AppLocalizations.of(context)!;
    final textTheme = Theme.of(context).textTheme;

    return BlocBuilder<HomeScreenViewModel, HomeScreenStates>(
      buildWhen:
          (previous, current) =>
              current is DownloadRequestLoadingState ||
              current is DownloadProgressState ||
              current is DownloadCompletedState ||
              current is DownloadFailureState ||
              current is DownloadCancelledState ||
              current is DownloadProgressUpdatedState ||
              current is OptionsUpdatedState,
      builder: (context, state) {
        final cubit = context.read<HomeScreenViewModel>();
        final tasks = cubit.tasksStatus.values.toList();

        final hasActiveTasks = tasks.isNotEmpty;

        if (hasActiveTasks) {
          final bool areAllTerminal = tasks.every(
            (task) =>
                task.status == 'completed' ||
                task.status == 'failed' ||
                task.status == 'cancelled',
          );

          return Container(
            constraints: const BoxConstraints(maxHeight: 400),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.darkWithOpacity),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Flexible(
                  child: ListView.separated(
                    shrinkWrap: true,
                    itemCount: tasks.length,
                    separatorBuilder:
                        (context, index) => const Divider(height: 24),
                    itemBuilder: (context, index) {
                      final task = tasks[index];
                      final isSingle = tasks.length == 1;

                      return Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (task.thumbnailUrl != null) ...[
                            Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(
                                  color: AppColors.darkWithOpacity.withValues(
                                    alpha: 0.1,
                                  ),
                                ),
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: Image.network(
                                  task.thumbnailUrl!,
                                  width: 80,
                                  height: 55,
                                  fit: BoxFit.cover,
                                  errorBuilder:
                                      (_, __, ___) => const SizedBox(),
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                          ],
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    const Icon(
                                      Icons.download,
                                      size: 18,
                                      color: AppColors.darkHeadTextColor,
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: Text(
                                        task.title,
                                        style: textTheme.bodySmall?.copyWith(
                                          fontWeight: FontWeight.bold,
                                        ),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                    if (task.status != 'completed' &&
                                        task.status != 'failed' &&
                                        task.status != 'cancelled')
                                      Text(
                                        "${(task.progress * 100).toInt()}%",
                                        style: textTheme.bodySmall,
                                      ),
                                  ],
                                ),
                                const SizedBox(height: 8),
                                Row(
                                  children: [
                                    Expanded(
                                      child: LinearProgressIndicator(
                                        value:
                                            task.status == 'pending'
                                                ? null
                                                : task.progress,
                                        backgroundColor: AppColors
                                            .darkWithOpacity
                                            .withValues(alpha: 0.2),
                                        borderRadius: BorderRadius.circular(4),
                                        minHeight: 8,
                                        color: _getStatusColor(context, task),
                                      ),
                                    ),
                                    if (!isSingle) ...[
                                      const SizedBox(width: 8),
                                      if (task.status == 'processing' ||
                                          task.status == 'pending')
                                        IconButton(
                                          constraints: const BoxConstraints(),
                                          padding: EdgeInsets.zero,
                                          iconSize: 20,
                                          onPressed: () {
                                            cubit.cancelTask(task.taskId);
                                          },
                                          icon: const Icon(
                                            Icons.cancel_outlined,
                                            color: AppColors.error,
                                          ),
                                        )
                                      else if (task.status == 'completed')
                                        const Icon(
                                          Icons.check_circle,
                                          size: 20,
                                          color: Colors.green,
                                        )
                                      else if (task.isSubtitleMissingError)
                                        Icon(
                                          Icons.subtitles_off_outlined,
                                          size: 20,
                                          color: Colors.amber[700],
                                        )
                                      else if (task.status == 'failed')
                                        const Icon(
                                          Icons.error,
                                          size: 20,
                                          color: Colors.red,
                                        ),
                                    ],
                                  ],
                                ),
                                if (task.status == 'processing')
                                  Padding(
                                    padding: const EdgeInsets.only(top: 6),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          "${Formatter.formatBytes(task.speed)}/s",
                                          style: textTheme.bodySmall?.copyWith(
                                            color: AppColors.darkHeadTextColor,
                                            fontSize: 11,
                                          ),
                                        ),
                                        Text(
                                          "${Formatter.formatBytes((task.totalSize ?? 0) * task.progress)} / ${Formatter.formatBytes(task.totalSize)}",
                                          style: textTheme.bodySmall?.copyWith(
                                            color: AppColors.darkHeadTextColor,
                                            fontSize: 11,
                                          ),
                                        ),
                                        Text(
                                          "ETA: ${Formatter.formatDuration(task.eta)}",
                                          style: textTheme.bodySmall?.copyWith(
                                            color: AppColors.darkHeadTextColor,
                                            fontSize: 11,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                if (isSingle &&
                                    (task.status == 'processing' ||
                                        task.status == 'pending'))
                                  Padding(
                                    padding: const EdgeInsets.only(top: 12.0),
                                    child: OutlinedButton.icon(
                                      onPressed:
                                          () => cubit.cancelTask(task.taskId),
                                      style: OutlinedButton.styleFrom(
                                        foregroundColor: AppColors.error,
                                        side: const BorderSide(
                                          color: AppColors.error,
                                        ),
                                        padding: const EdgeInsets.symmetric(
                                          vertical: 12,
                                        ),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                            8,
                                          ),
                                        ),
                                        minimumSize: const Size.fromHeight(56),
                                      ),
                                      icon: const Icon(Icons.close_rounded),
                                      label: Text(locale.cancel),
                                    ),
                                  ),
                                if (task.error != null)
                                  Padding(
                                    padding: const EdgeInsets.only(top: 4),
                                    child: Row(
                                      spacing: 6,
                                      children: [
                                        Icon(
                                          Icons.error_outline,
                                          size: 16,
                                          color:
                                              task.isSubtitleMissingError
                                                  ? Colors.amber[700]
                                                  : AppColors.error,
                                        ),
                                        Text(
                                          task.isSubtitleMissingError
                                              ? "No subtitles available"
                                              : task.error!,
                                          style: textTheme.bodySmall?.copyWith(
                                            color:
                                                task.isSubtitleMissingError
                                                    ? Colors.amber[700]
                                                    : AppColors.error,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ),
                if (areAllTerminal)
                  Padding(
                    padding: const EdgeInsets.only(top: 16.0),
                    child: ElevatedButton(
                      onPressed: cubit.clearTasks,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.success,
                        foregroundColor: Colors.white,
                        minimumSize: const Size(double.infinity, 56),
                      ),
                      child: Text("Done"),
                    ),
                  ),
              ],
            ),
          );
        }

        return ElevatedButton.icon(
          onPressed: onDownloadPressed,
          icon:
              state is DownloadRequestLoadingState
                  ? null
                  : const Icon(Icons.download_rounded),
          label:
              state is DownloadRequestLoadingState
                  ? const CircularProgressIndicator()
                  : Text(locale.startDownload, style: textTheme.labelLarge),
          style: ElevatedButton.styleFrom(
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(16)),
            ),
            minimumSize: const Size.fromHeight(64),
          ),
        );
      },
    );
  }

  Color _getStatusColor(BuildContext context, TaskStatus task) {
    if (task.isSubtitleMissingError) return Colors.amber[700]!;

    switch (task.status) {
      case 'completed':
        return Colors.green;
      case 'failed':
        return AppColors.error;
      case 'cancelled':
        return Colors.grey;
      default:
        return Theme.of(context).primaryColor;
    }
  }
}

extension TaskStatusUIX on TaskStatus {
  bool get isSubtitleMissingError {
    if (status != 'failed') return false;
    final err = error?.toLowerCase() ?? '';
    return err.contains('no subtitles');
  }
}
