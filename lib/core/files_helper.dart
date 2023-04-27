import 'dart:io';

import 'package:avp/db/video_provider.dart';
import 'package:external_path/external_path.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';

final _logger = Logger();
final _videoProvider = Get.find<VideoProvider>();

class FilesHelper {
  static void scanFiles() async {
    final storagePath = await ExternalPath.getExternalStorageDirectories();

    for (var path in storagePath) {
      final storages = Directory(path);
      final storage = storages.listSync(recursive: false);

      for (var dir in storage) {
        if (!dir.toString().contains("Android")) {
          recursiveFileLookup(dir);
        }
      }
    }

    return null;
  }
}

void recursiveFileLookup(FileSystemEntity path) {
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

    if (!dirException.any(pathString.contains) &&
        !(await findPathInDb(pathString))) {
      _logger.d(path);
    }
  }
}

Future<bool> findPathInDb(String path) async {
  return await _videoProvider.queryFindFilePath(path).isNotEmpty;
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

// String getDirectoryPath(String filePath) {
//   List<String> splitFilePath = filePath.split("/");
//   splitFilePath.removeLast();

//   return splitFilePath.join("/");
// }
