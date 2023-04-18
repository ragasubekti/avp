import 'package:another_vp/models/video_database_models.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class VideoDatabase {
  Future<Database>? database;

  Future<Database> initializeDatabase() async {
    final databasePath =
        join(getExternalStorageDirectory().toString(), "avp_store.db");
    // print(databasePath);
    return openDatabase(databasePath, onCreate: (db, version) {
      return db.execute("""
        CREATE TABLE video_database (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          file_path TEXT,
          file_name TEXT,
          thumbnail_path TEXT,
          directory_path TEXT,
          watched_duration INTEGER,
          duration INTEGER,
          resolution TEXT,
          mimetype TEXT
        )
      """);
    }, version: 1, onOpen: (db) {});
  }

  Future<int> addVideoDetail(
      Database db, VideoDatabaseModel videoDetail) async {
    return db.insert("video_database", videoDetail.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<int> isVideoExists(Database db, String filePath) async {
    final query =
        await db.query("video_database", where: "file_path = \"$filePath\"");

    if (query.isNotEmpty) {
      return query[0]['id'] as int;
    } else {
      return 0;
    }
  }

  Future<VideoDatabaseModel?> findById(Database db, int id) async {
    final query = await db.query("video_database", where: "id = $id");

    if (query.isNotEmpty) {
      final e = query[0];
      return mapFromDb(e);
    }

    return null;
  }

  VideoDatabaseModel mapFromDb(Map<String, Object?> video) {
    return VideoDatabaseModel(
        filePath: video['file_path'] as String,
        directoryPath: video['directory_path'] as String,
        thumbnailPath: video['thumbnail_path'] as String,
        watchedDuration: video['watched_duration'] as int,
        duration: video['duration'] as int,
        resolution: video['resolution'] as String,
        mimetype: video['mimetype'] as String,
        fileName: video['file_name'] as String);
  }

  Future<int> updateThumbnailPath(
      Database db, int id, String thumbnailPath) async {
    return await db.update("video_database", {"thumbnail_path": thumbnailPath},
        where: "id = $id");
  }
}
