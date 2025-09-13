import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import '../models/video_item.dart';

class VideoProvider extends ChangeNotifier {
  late Box<VideoItem> _videoBox;
  int currentIndex = 0;

  VideoProvider() {
    _init();
  }

  Future<void> _init() async {
    _videoBox = Hive.box<VideoItem>('videos'); 
    notifyListeners();
  }

  List<VideoItem> get videos => _videoBox.values.toList();

  Future<void> addVideo(VideoItem video) async {
    await _videoBox.add(video);
    notifyListeners();
  }

  void toggleLike(int index) {
    final video = _videoBox.getAt(index);
    if (video != null) {
      video.isLiked = !video.isLiked;
      video.save();
      notifyListeners();
    }
  }

  void setCurrentIndex(int index) {
    currentIndex = index;
    notifyListeners();
  }

  List<VideoItem> get likedVideos =>
      _videoBox.values.where((v) => v.isLiked).toList();
}
