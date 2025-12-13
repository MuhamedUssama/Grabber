import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:grabber/features/home/data/models/response/get_info_response_model.dart';
import 'package:grabber/features/home/presentation/view_model/home_screen_states.dart';
import 'package:grabber/features/home/presentation/view_model/home_screen_view_model.dart';

class VideoListItem extends StatelessWidget {
  final Entries entry;

  const VideoListItem({super.key, required this.entry});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeScreenViewModel, HomeScreenStates>(
      builder: (context, state) {
        return Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Theme.of(context).dividerColor),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Checkbox(
                value: context
                    .read<HomeScreenViewModel>()
                    .selectedVideoUrls
                    .contains(entry.url),
                onChanged: (value) {
                  context.read<HomeScreenViewModel>().toggleVideoSelection(
                    entry.url,
                  );
                },
              ),
              const SizedBox(width: 8),
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Image.network(
                      entry.thumbnail,
                      width: 100,
                      height: 65,
                      fit: BoxFit.cover,
                      errorBuilder:
                          (context, error, stackTrace) => Container(
                            width: 100,
                            height: 65,
                            color:
                                Theme.of(
                                  context,
                                ).colorScheme.surfaceContainerHighest,
                            child: Icon(
                              Icons.broken_image_rounded,
                              color: Theme.of(context).iconTheme.color,
                            ),
                          ),
                    ),
                    Builder(
                      builder: (context) {
                        final cubit = context.read<HomeScreenViewModel>();
                        final taskId = cubit.urlToTaskId[entry.url];
                        final taskStatus =
                            taskId != null ? cubit.tasksStatus[taskId] : null;

                        if (taskStatus == null) return const SizedBox.shrink();

                        if (taskStatus.status == 'processing' ||
                            taskStatus.status == 'pending') {
                          return Container(
                            width: 100,
                            height: 65,
                            color: Colors.black.withValues(alpha: 0.6),
                            child: Center(
                              child: SizedBox(
                                width: 24,
                                height: 24,
                                child: CircularProgressIndicator(
                                  value:
                                      taskStatus.status == 'pending'
                                          ? null
                                          : taskStatus.progress,
                                  strokeWidth: 2,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          );
                        } else if (taskStatus.status == 'completed') {
                          return Container(
                            width: 100,
                            height: 65,
                            color: Colors.black.withValues(alpha: 0.6),
                            child: const Center(
                              child: Icon(
                                Icons.check_circle_rounded,
                                color: Colors.green,
                                size: 32,
                              ),
                            ),
                          );
                        } else if (taskStatus.status == 'failed') {
                          return Container(
                            width: 100,
                            height: 65,
                            color: Colors.black.withValues(alpha: 0.6),
                            child: const Center(
                              child: Icon(
                                Icons.error_rounded,
                                color: Colors.red,
                                size: 32,
                              ),
                            ),
                          );
                        }
                        return const SizedBox.shrink();
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      entry.title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    if (entry.channelName != null) ...[
                      Row(
                        children: [
                          Icon(
                            Icons.person_rounded,
                            size: 14,
                            color: Theme.of(context).primaryColor,
                          ),
                          const SizedBox(width: 4),
                          Expanded(
                            child: Text(
                              entry.channelName!,
                              overflow: TextOverflow.ellipsis,
                              style: Theme.of(context).textTheme.bodySmall
                                  ?.copyWith(fontWeight: FontWeight.w500),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                    ],
                    Wrap(
                      spacing: 12,
                      runSpacing: 4,
                      children: [
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.remove_red_eye_rounded,
                              size: 14,
                              color:
                                  Theme.of(context).textTheme.bodySmall?.color,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              entry.viewsText,
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                          ],
                        ),
                        if (entry.dateText.isNotEmpty)
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.calendar_today_rounded,
                                size: 14,
                                color:
                                    Theme.of(
                                      context,
                                    ).textTheme.bodySmall?.color,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                entry.dateText,
                                style: Theme.of(context).textTheme.bodySmall,
                              ),
                            ],
                          ),
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.access_time_rounded,
                              size: 14,
                              color:
                                  Theme.of(context).textTheme.bodySmall?.color,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              entry.durationText,
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
