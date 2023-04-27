class VideoSchema {
  VideoSchema({
    required this.name,
    required this.codecs,
    required this.resolution,
    required this.duration,
    required this.watchedDuration,
    required this.filePath,
    required this.thumbnailPath,
    required this.directory,
    this.id,
  });

  int? id;
  String name;
  String codecs;
  String resolution;
  int duration;
  int watchedDuration;
  String filePath;
  String thumbnailPath;
  String directory;

  VideoSchema copyWith({
    String? name,
    String? codecs,
    String? resolution,
    int? duration,
    int? watchedDuration,
    String? filePath,
    String? thumbnailPath,
    String? directory,
  }) {
    return VideoSchema(
      name: name ?? this.name,
      codecs: codecs ?? this.codecs,
      resolution: resolution ?? this.resolution,
      duration: duration ?? this.duration,
      watchedDuration: watchedDuration ?? this.watchedDuration,
      filePath: filePath ?? this.filePath,
      thumbnailPath: thumbnailPath ?? this.thumbnailPath,
      directory: directory ?? this.directory,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'codecs': codecs,
      'resolution': resolution,
      'duration': duration,
      'watched_duration': watchedDuration,
      'file_path': filePath,
      'thumbnail_path': thumbnailPath,
      'directory': directory,
    };
  }

  @override
  String toString() {
    return 'VideoSchema{id=$id, name=$name, codecs=$codecs, resolution=$resolution, duration=$duration, watchedDuration=$watchedDuration, filePath=$filePath, thumbnailPath=$thumbnailPath, directory=$directory}';
  }
}
