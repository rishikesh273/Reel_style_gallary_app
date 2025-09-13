import 'package:hive/hive.dart';

part 'video_item.g.dart'; // <-- must be relative, NOT package import

@HiveType(typeId: 0)
class VideoItem extends HiveObject {
  @HiveField(0)
  String path;

  @HiveField(1)
  bool isLiked;

  @HiveField(2)
  int views;

  VideoItem({
    required this.path,
    this.isLiked = false,
    this.views = 0,
  });
}

