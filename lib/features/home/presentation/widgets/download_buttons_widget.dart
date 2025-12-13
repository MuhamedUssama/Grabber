import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:grabber/core/l10n/localization/app_localizations.dart';
import 'package:grabber/core/theme/app_colors.dart';
import 'package:grabber/features/home/presentation/view_model/home_screen_states.dart';
import 'package:grabber/features/home/presentation/view_model/home_screen_view_model.dart';

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

        if (state is DownloadRequestLoadingState) {
          return ElevatedButton(
            onPressed: null,
            style: ElevatedButton.styleFrom(
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(16)),
              ),
              maximumSize: const Size(64, double.infinity),
            ),
            child: const CircularProgressIndicator(color: AppColors.dark),
          );
        }

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

                      return Column(
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
                                  backgroundColor: AppColors.darkWithOpacity
                                      .withValues(alpha: 0.2),
                                  borderRadius: BorderRadius.circular(4),
                                  minHeight: 8,
                                  color: _getStatusColor(context, task.status),
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
                                else if (task.status == 'failed')
                                  const Icon(
                                    Icons.error,
                                    size: 20,
                                    color: Colors.red,
                                  ),
                              ],
                            ],
                          ),
                          if (isSingle &&
                              (task.status == 'processing' ||
                                  task.status == 'pending'))
                            Padding(
                              padding: const EdgeInsets.only(top: 12.0),
                              child: SizedBox(
                                width: double.infinity,
                                child: OutlinedButton(
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
                                  ),
                                  child: Text(locale.cancel),
                                ),
                              ),
                            ),
                          if (task.error != null)
                            Padding(
                              padding: const EdgeInsets.only(top: 4),
                              child: Text(
                                task.error!,
                                style: textTheme.bodySmall?.copyWith(
                                  color: AppColors.error,
                                ),
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
                    child: SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: cubit.clearTasks,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.success,
                          foregroundColor: Colors.white,
                        ),
                        child: Text("Done"),
                      ),
                    ),
                  ),
              ],
            ),
          );
        }

        return SizedBox(
          width: double.infinity,
          child: ElevatedButton.icon(
            onPressed: onDownloadPressed,
            icon: const Icon(Icons.download_rounded),
            label: Text(locale.startDownload, style: textTheme.labelLarge),
            style: ElevatedButton.styleFrom(
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(16)),
              ),
              minimumSize: const Size.fromHeight(64),
            ),
          ),
        );
      },
    );
  }

  Color _getStatusColor(BuildContext context, String status) {
    switch (status) {
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
