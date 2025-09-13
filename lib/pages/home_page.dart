import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/video_item.dart';
import '../state/video_provider.dart';
import '../widgets/video_player_widget.dart';
import 'settings_page.dart';
import 'likes_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final PageController _pageController = PageController();

  Future<void> _addVideo(BuildContext context) async {
    try {
      FilePickerResult? result =
          await FilePicker.platform.pickFiles(type: FileType.video);

      if (result != null && result.files.single.path != null) {
        final filePath = result.files.single.path!;
        final video = VideoItem(path: filePath);
        await Provider.of<VideoProvider>(context, listen: false).addVideo(video);
      }
    } catch (e) {
      debugPrint("Error picking video: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    final videoProvider = Provider.of<VideoProvider>(context);

    return Scaffold(
      appBar: AppBar(title: const Text("Reels"), centerTitle: true),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(color: Color.fromARGB(223, 1, 63, 90)),
              child: Center(
                child: Text(
                  "Menu",
                  style: TextStyle(color: Colors.white, fontSize: 25),
                ),
              ),
            ),
            ListTile(
              title: const Text("Home"),
              onTap: () => Navigator.pop(context),
            ),
            ListTile(
              title: const Text("Liked Videos"),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const LikesPage()),
                );
              },
            ),
            ListTile(
              title: const Text("Settings"),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const SettingsPage()),
                );
              },
            ),
          ],
        ),
      ),
      body: videoProvider.videos.isEmpty
          ? const Center(child: Text("No videos yet. Tap + to add one."))
          : PageView.builder(
              controller: _pageController,
              scrollDirection: Axis.vertical,
              itemCount: videoProvider.videos.length,
              onPageChanged: (index) => videoProvider.setCurrentIndex(index),
              itemBuilder: (context, index) {
                final video = videoProvider.videos[index];
                final isPlaying = index == videoProvider.currentIndex;

                return Stack(
                  fit: StackFit.expand, // makes children fill the page
                  children: [
                    // Fullscreen video player (fills below AppBar)
                    SizedBox.expand(
                      child: VideoPlayerWidget(path: video.path, play: isPlaying),
                    ),
                    // Like button overlay
                    Positioned(
                      bottom: 80,
                      right: 16,
                      child: IconButton(
                        icon: Icon(
                          video.isLiked
                              ? Icons.favorite
                              : Icons.favorite_border,
                          color: video.isLiked ? Colors.red : Colors.white,
                          size: 32,
                        ),
                        onPressed: () => videoProvider.toggleLike(index),
                      ),
                    ),
                  ],
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _addVideo(context),
        child: const Icon(Icons.add),
      ),
    );
  }
}
