import 'package:flutter/material.dart';
import 'package:grabber/core/theme/app_colors.dart';
import 'package:grabber/features/home/data/models/response/get_info_response_model.dart';
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
                child: Text(
                  info.data.playlistTitle!,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: AppColors.darkTextColor,
                  ),
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

    // Single Video Layout
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
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.network(
              thumbnail,
              width: double.infinity,
              height: 200,
              fit: BoxFit.cover,
              errorBuilder:
                  (context, error, stackTrace) => Container(
                    width: double.infinity,
                    height: 200,
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
          Row(
            children: [
              Icon(
                Icons.access_time_rounded,
                size: 16,
                color: Theme.of(context).textTheme.bodySmall?.color,
              ),
              const SizedBox(width: 4),
              Text(duration, style: Theme.of(context).textTheme.bodyMedium),
            ],
          ),
        ],
      ),
    );
  }
}
