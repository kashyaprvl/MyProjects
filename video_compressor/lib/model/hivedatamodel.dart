import 'package:hive/hive.dart';

part 'hivedatamodel.g.dart';
@HiveType(typeId: 0)
class VideoHistory {
  @HiveField(0)
  final String originalPath;

  @HiveField(1)
  final String compressedPath;

  @HiveField(2)
  final DateTime timestamp;

  VideoHistory({
    required this.originalPath,
    required this.compressedPath,
    required this.timestamp,
  });
}
