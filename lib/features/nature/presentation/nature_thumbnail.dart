import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import '../../../core/services/wikipedia_image_service.dart';
import '../../../core/theme/app_colors.dart';
import '../data/models/nature_entry.dart';

/// Shows a real photo of [entry] fetched from Wikipedia (see
/// WikipediaImageService), cached on-device after the first successful
/// load so it displays instantly (and works offline) afterwards. Falls
/// back to a big emoji on a soft color background while loading or if
/// the photo can't be fetched (e.g. no internet, first time offline).
class NatureThumbnail extends StatelessWidget {
  final NatureEntry entry;
  final double borderRadius;

  const NatureThumbnail({super.key, required this.entry, this.borderRadius = 24});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(borderRadius),
      child: FutureBuilder<String?>(
        future: WikipediaImageService.instance.fetchThumbnail(entry.wikipediaTitle),
        builder: (context, snapshot) {
          final url = snapshot.data;
          if (snapshot.connectionState != ConnectionState.done || url == null) {
            return _Placeholder(emoji: entry.emoji, loading: snapshot.connectionState != ConnectionState.done);
          }
          return CachedNetworkImage(
            imageUrl: url,
            fit: BoxFit.cover,
            width: double.infinity,
            height: double.infinity,
            placeholder: (context, _) => _Placeholder(emoji: entry.emoji, loading: true),
            errorWidget: (context, url, error) => _Placeholder(emoji: entry.emoji, loading: false),
          );
        },
      ),
    );
  }
}

class _Placeholder extends StatelessWidget {
  final String emoji;
  final bool loading;
  const _Placeholder({required this.emoji, required this.loading});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.background,
      alignment: Alignment.center,
      child: loading
          ? const SizedBox(
              width: 22,
              height: 22,
              child: CircularProgressIndicator(strokeWidth: 2.4),
            )
          : Text(emoji, style: const TextStyle(fontSize: 40)),
    );
  }
}
