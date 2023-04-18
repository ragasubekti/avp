class VideoDatabaseModel {
  int? id;
  final String filePath;
  final String fileName;
  final String directoryPath;
  final String thumbnailPath;
  final int watchedDuration;
  final int duration;
  final String resolution;
  final String mimetype;

  VideoDatabaseModel(
      {required this.filePath,
      required this.directoryPath,
      required this.thumbnailPath,
      required this.watchedDuration,
      required this.duration,
      required this.resolution,
      required this.mimetype,
      required this.fileName,
      this.id});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'file_path': filePath,
      'directory_path': directoryPath,
      'thumbnail_path': thumbnailPath,
      'watched_duration': watchedDuration,
      'duration': duration,
      'resolution': resolution,
      'mimetype': mimetype,
      'file_name': fileName
    };
  }

  @override
  String toString() {
    return "FILE_PATH: $filePath | THUMB_PATH: $thumbnailPath | DIR_PATH: $directoryPath";
  }
}
