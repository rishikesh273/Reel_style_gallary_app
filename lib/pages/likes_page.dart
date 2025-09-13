import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:video_thumbnail/video_thumbnail.dart';

import '../state/video_provider.dart';
import 'video_fullscreen_page.dart';

class LikesPage extends StatefulWidget {
  const LikesPage({super.key});

  @override
  State<LikesPage> createState() => _LikesPageState();
}

class _LikesPageState extends State<LikesPage> {
  // Simple in-memory cache for thumbnails so we don't regenerate repeatedly.
  final Map<String, Uint8List?> _thumbCache = {};

  Future<Uint8List?> _getThumbnail(String videoPath) async {
    if (_thumbCache.containsKey(videoPath)) return _thumbCache[videoPath];

    try {
      final bytes = await VideoThumbnail.thumbnailData(
        video: videoPath,
        imageFormat: ImageFormat.JPEG,
        maxWidth: 512, // keeps size reasonable
        quality: 70,
      );
      _thumbCache[videoPath] = bytes;
      return bytes;
    } catch (e) {
      // If thumbnail generation fails, cache null to avoid repeated attempts.
      _thumbCache[videoPath] = null;
      debugPrint('Thumbnail error for $videoPath: $e');
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    final videoProvider = Provider.of<VideoProvider>(context);
    // get liked videos from provider (change according to your provider API)
    final likedVideos = videoProvider.videos.where((v) => v.isLiked).toList();

    return Scaffold(
      appBar: AppBar(title: const Text('Liked Videos'), centerTitle: true),
      body: likedVideos.isEmpty
          ? const Center(child: Text('No liked videos yet.'))
          : GridView.builder(
              padding: const EdgeInsets.all(8),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 8,
                mainAxisSpacing: 8,
                childAspectRatio: 9 / 16, // tall tiles for videos
              ),
              itemCount: likedVideos.length,
              itemBuilder: (context, index) {
                final video = likedVideos[index];
                return GestureDetector(
                  onTap: () {
                    // Open fullscreen player for only the tapped video.
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) =>
                            VideoFullscreenPage(videoPath: video.path),
                      ),
                    );
                  },
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: FutureBuilder<Uint8List?>(
                      future: _getThumbnail(video.path),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Container(
                            color: Colors.black12,
                            child: const Center(
                                child: CircularProgressIndicator()),
                          );
                        }

                        if (snapshot.hasData && snapshot.data != null) {
                          return Stack(
                            fit: StackFit.expand,
                            children: [
                              Image.memory(
                                snapshot.data!,
                                fit: BoxFit.cover,
                              ),
                              // Play icon overlay
                              const Align(
                                alignment: Alignment.center,
                                child: Icon(Icons.play_circle_fill,
                                    color: Colors.white, size: 48),
                              ),
                            ],
                          );
                        }

                        // fallback: simple placeholder
                        return Container(
                          color: Colors.black26,
                          child: const Center(
                            child: Icon(Icons.videocam, size: 40),
                          ),
                        );
                      },
                    ),
                  ),
                );
              },
            ),
    );
  }
}
