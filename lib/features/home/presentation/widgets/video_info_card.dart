import 'package:flutter/material.dart';
import 'package:grabber/features/home/data/models/response/get_info_response_model.dart';

class VideoInfoCard extends StatelessWidget {
  final GetInfoResponseModel info;

  const VideoInfoCard({super.key, required this.info});

  @override
  Widget build(BuildContext context) {
    final isPlaylist = info.data.isPlaylist;
    final title =
        isPlaylist
            ? (info.data.playlistTitle ?? "Unknown Playlist")
            : (info.data.entries.isNotEmpty
                ? info.data.entries.first.title
                : "Unknown Title");

    final thumbnail =
        info.data.entries.isNotEmpty ? info.data.entries.first.thumbnail : "";

    final duration =
        info.data.entries.isNotEmpty
            ? info.data.entries.first.durationText
            : "";

    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      padding: const EdgeInsets.all(12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.network(
              thumbnail,
              width: 120,
              height: 90,
              fit: BoxFit.cover,
              errorBuilder:
                  (context, error, stackTrace) => Container(
                    width: 120,
                    height: 90,
                    color: Colors.grey.shade300,
                    child: const Icon(Icons.broken_image_rounded),
                  ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (isPlaylist)
                  Container(
                    margin: const EdgeInsets.only(bottom: 4),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: Theme.of(
                        context,
                      ).primaryColor.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      'PLAYLIST',
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                  ),
                Text(
                  title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Icon(
                      Icons.access_time_rounded,
                      size: 14,
                      color: Colors.grey,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      duration,
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
