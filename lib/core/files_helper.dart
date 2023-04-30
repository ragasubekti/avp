import 'dart:io';

import 'package:avp/core/video_helper.dart';
import 'package:avp/db/schema/videos.dart';
import 'package:avp/db/videos_provider.dart';
import 'package:external_path/external_path.dart';
import 'package:get/get.dart';
import 'package:isar/isar.dart';
import 'package:logger/logger.dart';

final _logger = Logger();
final _isar = Get.find<VideosProvider>();

class FilesHelper {
  final isar = _isar.isar;

  void scanFiles() async {
    final storagePath = await ExternalPath.getExternalStorageDirectories();

    for (var path in storagePath) {
      final storages = Directory(path);
      final storage = storages.listSync(recursive: false);

      for (var dir in storage) {
        if (!dir.toString().contains("Android")) {
          _recursiveFileLookup(dir);
        }
      }
    }

    return null;
  }

  void _recursiveFileLookup(FileSystemEntity path) {
    if (path is Directory) {
      final list = path.listSync(recursive: true, followLinks: false).toList();
      if (list.isNotEmpty) {
        addFilesToDb(list);
      }
    } else {
      _logger.d("PATH `$path` IS FILE");
    }
  }

  void addFilesToDb(List<FileSystemEntity> list) async {
    const exception = [".nomedia", '.thumbnails'];
    List<String> dirException = [];

    for (var path in list) {
      final pathString = path.path;

      if (exception.any(pathString.contains)) {
        dirException.add(pathString);
      }

      if (_isExcluded(dirException, pathString) &&
          path is File &&
          _isVideoFormat(pathString)) {
        final existsInDb = await _findPathInDb(pathString);
        logger.w("EXISTS_IN_DB: $existsInDb");

        if (existsInDb) {
          // final metadata = await getVideoMetadata(pathString);
          // _logger.w(metadata);
          // _processFile(pathString);
        } else {
          // await _processFile(pathString);
        }
      }
    }
  }

  Future _processFile(String path) async {
    final metadata = await getVideoMetadata(path);
    final thumbnail = await generateThumbnail(path);

    final newFile = Videos()
      ..filePath = path
      ..codecs = metadata.format
      ..resolution = metadata.resolution
      ..duration = metadata.duration
      ..thumbnailPath = thumbnail
      ..watchedDuration = 0
      ..name = getVideoFilename(path)
      ..directoryPath = _getDirectoryPath(path);

    await isar.writeTxn(() async {
      final result = await isar.collection<Videos>().put(newFile);
      _logger.d(result);
    });
  }

  bool _isExcluded(List<String> exclusion, String path) {
    return !exclusion.any(path.contains);
  }

  bool _isVideoFormat(String path) {
    return commonVideoFormat.any(path.contains);
  }

  Future<bool> _findPathInDb(String path) async {
    final query = isar.collection<Videos>().filter().filePathEqualTo(path);

    return (await query.count()) > 0;
  }

  String _getDirectoryPath(String path) {
    List<String> splitFilePath = path.split("/");
    splitFilePath.removeLast();

    return splitFilePath.join("/");
  }
}



// import 'dart:io';
// // import 'package:sqflite/sqflite.dart';

// import 'package:avp/core/video_helper.dart';
// import 'package:external_path/external_path.dart';
// import 'package:logger/logger.dart';

// final _logger = Logger();

// Future<void> processVideoFile(
//   String filePath,
// ) async {
//   final videoMetadata = await getVideoMetadata(filePath);
//   _logger.d(
//     "DURATION: ${videoMetadata.duration}, FORMAT: ${videoMetadata.format}, RESOLUTION: ${videoMetadata.resolution}",
//   );
// }

// Future<List<File>> getVideoFiles(Directory directory) async {
//   final videoFiles = await directory
//       .list(recursive: true, followLinks: false)
//       .where((element) => commonVideoFormat.any(element.path.contains))
//       .map((file) => File(file.path))
//       .toList();

//   return videoFiles;
// }

// Future<List<String>> scanFiles() async {
//   final storagePath = await ExternalPath.getExternalStorageDirectories();
//   final thumbnailPath = <String>[];

//   for (String path in storagePath) {
//     final directory = Directory(path);
//     final isExists = await directory.exists();
//     final isNotAndroid = !path.contains("Android");

//     if (isNotAndroid && isExists) {
//       final videoFiles = await getVideoFiles(path);

//       for (var file in videoFiles) {
//         await processVideoFile(file.path);
//       }
//     }
//   }

//   return thumbnailPath;
// }
