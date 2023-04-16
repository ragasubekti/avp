import 'dart:io';

import 'package:external_path/external_path.dart';
import 'package:mpvxd/db/video_database.dart';
import 'package:mpvxd/core/video_helper.dart';
import 'package:mpvxd/models/video_database_models.dart';

Future<List<String>> scanFiles(
    Function(VideoDatabaseModel) onNewVideoAdded) async {
  List<String> thumbnailPath = [];
  final vd = VideoDatabase();
  final db = await vd.initializeDatabase();

  var path = await ExternalPath.getExternalStorageDirectories();

  for (var d in path) {
    Directory dir = Directory(d);
    final files = await dir.list().toList();
    for (var item in files) {
      if (!item.path.contains("Android")) {
        final fileList = Directory(item.path)
            .listSync(recursive: true, followLinks: false)
            .where((element) => commonVideoFormat.any(element.path.contains));

        for (var item in fileList) {
          final findVideoId = await vd.isVideoExists(db, item.path);
          final videoInfo = await vd.findById(db, findVideoId);

          if (findVideoId <= 0) {
            String directoryPath = getDirectoryPath(item.path);
            try {
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
                  mimetype: metadata.format,
                  fileName: getVideoFilename(item.path));

              await vd.addVideoDetail(db, videoDetail);
              onNewVideoAdded(videoDetail);
            } catch (_) {}
          } else if (videoInfo != null) {
            final isThumbnailExists =
                await File(videoInfo.thumbnailPath).exists();

            if (!isThumbnailExists) {
              String videoThumbnail =
                  (await generateThumbnail(item.path)) ?? "";
              final updateThumb =
                  await vd.updateThumbnailPath(db, findVideoId, videoThumbnail);

              if (updateThumb <= 0) {
                logger.e("Error Updating DB");
              }
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
