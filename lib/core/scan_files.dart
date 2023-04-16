import 'dart:io';

import 'package:external_path/external_path.dart';
import 'package:mpvxd/core/video_database.dart';
import 'package:mpvxd/core/video_helper.dart';
import 'package:mpvxd/models/video_database_models.dart';

Future<List<String>> scanFiles() async {
  List<String> thumbnailPath = [];
  final vd = VideoDatabase();
  final db = await vd.initializeDatabase();

  var path = await ExternalPath.getExternalStorageDirectories();

  for (var d in path) {
    Directory dir = Directory(d);
    final files = await dir.list().toList();
    for (var item in files) {
      if (!item.path.contains("Android")) {
        final fileList =
            Directory(item.path).listSync(recursive: true, followLinks: false);
        for (var item in fileList) {
          if (commonVideoFormat.any(item.path.contains)) {
            final isExistsInDb = await vd.isVideoExists(db, item.path);

            if (!isExistsInDb) {
              try {
                String directoryPath = getDirectoryPath(item.path);
                VideoMetadataInfo metadata = await getVideoMetadata(item.path);
                String videoThumbnail =
                    (await generateThumbnail(item.path)) ?? "";

                final VideoDatabaseModel videoDetail = VideoDatabaseModel(
                    filePath: item.path,
                    directoryPath: directoryPath,
                    thumbnailPath: videoThumbnail,
                    watchedDuration: 0,
                    duration: metadata.duration,
                    resolution: metadata.resolution,
                    mimetype: metadata.format);

                await vd.addVideoDetail(db, videoDetail);
              } catch (_) {}
            }
          }
        }
      }
    }
  }
  return thumbnailPath;
}

String getDirectoryPath(String filePath) {
  List<String> splitFilePath = filePath.split("/");
  splitFilePath.removeLast();

  return splitFilePath.join("/");
}
