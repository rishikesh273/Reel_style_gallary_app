import 'package:flutter/material.dart';
import '../widgets/video_player_widget.dart';

class VideoFullscreenPage extends StatelessWidget {
  final String videoPath;
  const VideoFullscreenPage({super.key, required this.videoPath});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      // Using AppBar gives an automatic "back" button.
      appBar: AppBar(
        backgroundColor: Colors.black87,
        elevation: 0,
        title: const Text(''),
      ),
      body: SafeArea(
        child: Stack(
          fit: StackFit.expand,
          children: [
            // Fullscreen video (fills available space)
            VideoPlayerWidget(path: videoPath, play: true),

            // Optional: a visible floating like or other UI could be added here.
          ],
        ),
      ),
    );
  }
}


