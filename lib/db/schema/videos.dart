import 'package:isar/isar.dart';

part 'videos.g.dart';

@collection
class Videos {
  Id id = Isar.autoIncrement;
  String? name;
  int? duration;
  String? codecs;
  String? resolution;

  // tracking
  int? watchedDuration;

  // path
  String? filePath;
  String? directoryPath;
  String? thumbnailPath;
}
