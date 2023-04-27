import 'package:avp/db/schema/video.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:sqflite/sqflite.dart';

class VideoProvider extends GetxService {
  static const _dbName = "videos.db";
  static const _dbVersion = 1;
  static const _table = "videos";

  late Database _db;

  Future<VideoProvider> init() async {
    _db = await openDatabase(_dbName, version: _dbVersion, onCreate: _onCreate);

    return this;
  }

  Future _onCreate(Database db, int _) async {
    final sql = await rootBundle.loadString("sql/create_videos_db.sql");

    await db.execute(sql);
  }

  queryFindFilePath(String path) async {
    return await _db.query(_table, where: "file_path = \"$path\"");
  }

  insertFile(VideoSchema video) async {
    final _video = video.toMap();

    await _db.insert(_table, _video);
  } 
}
