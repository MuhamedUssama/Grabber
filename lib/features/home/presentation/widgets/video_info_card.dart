import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:grabber/core/theme/app_colors.dart';
import 'package:grabber/features/home/data/models/response/get_info_response_model.dart';
import 'package:grabber/features/home/presentation/view_model/home_screen_view_model.dart';
import 'package:grabber/features/home/presentation/widgets/video_list_item.dart';

class VideoInfoCard extends StatelessWidget {
  final GetInfoResponseModel info;

  const VideoInfoCard({super.key, required this.info});

  @override
  Widget build(BuildContext context) {
    final isPlaylist = info.data.isPlaylist;

    if (isPlaylist) {
      return Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.darkWithOpacity),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (info.data.playlistTitle != null)
              Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        info.data.playlistTitle!,
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: AppColors.darkTextColor,
                        ),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        final cubit = context.read<HomeScreenViewModel>();
                        if (cubit.isAllSelected) {
                          cubit.deselectAllVideos();
                        } else {
                          cubit.selectAllVideos();
                        }
                      },
                      child: Text(
                        context.read<HomeScreenViewModel>().isAllSelected
                            ? "Deselect all"
                            : "Select all",
                      ),
                    ),
                  ],
                ),
              ),
            const Divider(color: AppColors.darkWithOpacity),
            Expanded(
              child: ListView.separated(
                padding: const EdgeInsets.only(
                  bottom: 16,
                  top: 8,
                  left: 16,
                  right: 16,
                ),
                itemCount: info.data.entries.length,
                separatorBuilder: (context, index) {
                  return const SizedBox(height: 16);
                },
                itemBuilder: (context, index) {
                  return VideoListItem(entry: info.data.entries[index]);
                },
              ),
            ),
          ],
        ),
      );
    }

    final title =
        info.data.entries.isNotEmpty
            ? info.data.entries.first.title
            : "Unknown Title";

    final thumbnail =
        info.data.entries.isNotEmpty ? info.data.entries.first.thumbnail : "";

    final duration =
        info.data.entries.isNotEmpty
            ? info.data.entries.first.durationText
            : "";

    return Align(
      alignment: AlignmentDirectional.topStart,
      child: Container(
        width: double.infinity,
        constraints: const BoxConstraints(maxWidth: 600),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.darkWithOpacity),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.network(
                thumbnail ?? '',
                width: double.infinity,
                height: MediaQuery.of(context).size.height * 0.3,
                fit: BoxFit.cover,
                errorBuilder:
                    (context, error, stackTrace) => Container(
                      width: double.infinity,
                      height: MediaQuery.of(context).size.height * 0.3,
                      color: Theme.of(
                        context,
                      ).disabledColor.withValues(alpha: 0.3),
                      child: Icon(
                        Icons.broken_image_rounded,
                        size: 50,
                        color: Theme.of(context).iconTheme.color,
                      ),
                    ),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              title,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            if (info.data.entries.isNotEmpty &&
                info.data.entries.first.channelName != null) ...[
              Row(
                children: [
                  Icon(
                    Icons.person_rounded,
                    size: 18,
                    color: Theme.of(context).primaryColor,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    info.data.entries.first.channelName!,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
            ],
            if (info.data.entries.isNotEmpty)
              Row(
                children: [
                  if (info.data.entries.first.viewsText.isNotEmpty) ...[
                    _buildStatItem(
                      context,
                      Icons.remove_red_eye_rounded,
                      info.data.entries.first.viewsText,
                    ),
                    _buildDot(context),
                  ],
                  if (info.data.entries.first.dateText.isNotEmpty) ...[
                    _buildStatItem(
                      context,
                      Icons.calendar_today_rounded,
                      info.data.entries.first.dateText,
                    ),
                    _buildDot(context),
                  ],
                  _buildStatItem(context, Icons.access_time_rounded, duration),
                ],
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem(BuildContext context, IconData icon, String text) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          icon,
          size: 14,
          color: Theme.of(context).textTheme.bodySmall?.color,
        ),
        const SizedBox(width: 4),
        Text(text, style: Theme.of(context).textTheme.bodySmall),
      ],
    );
  }

  Widget _buildDot(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Text('•', style: Theme.of(context).textTheme.bodySmall),
    );
  }
}
