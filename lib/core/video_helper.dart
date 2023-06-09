import 'dart:io';

import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

import 'package:ffmpeg_kit_flutter_video/ffmpeg_kit.dart';
import 'package:ffmpeg_kit_flutter_video/ffprobe_kit.dart';
import 'package:ffmpeg_kit_flutter_video/return_code.dart';

import 'package:logger/logger.dart';

import 'generic_helper.dart';

var logger =
    Logger(printer: PrettyPrinter(noBoxingByDefault: false, printTime: false));

final List<String> commonVideoFormat = [
  ".webm",
  ".mov",
  ".mp4",
  ".avi",
  ".mkv",
  ".m4a",
];

Future<String?> generateThumbnail(String filePath) async {
  try {
    final String thumbnailDirectory =
        (await getExternalStorageDirectory())!.path;
    final String thumbnailName = generateRandomString(32);
    String file = join(thumbnailDirectory, thumbnailName);

    final ffmpegArgs = [
      "-y",
      "-i",
      filePath,
      "-ss",
      "00:00:01.000",
      "-vframes",
      "1",
      "$file.jpeg",
    ];

    return FFmpegKit.executeWithArguments(ffmpegArgs)
        .then((session) async {
      final returnCode = await session.getReturnCode();
      logger.d(await session.getAllLogsAsString());

      return ReturnCode.isSuccess(returnCode) ? "$file.jpeg" : null;
    });
  } catch (_) {
    return null;
  }
}

Future<String> getVideoResolution(String filePath) async {
  final getVideoResolutionArgs = [
    "-v",
    "error",
    "-select_streams",
    "v:0",
    "-show_entries",
    "stream=width,height",
    "-of",
    "csv=s=x:p=0",
    filePath,
  ];

  return FFprobeKit.executeWithArguments(getVideoResolutionArgs)
      .then((value) async {
    final resolution = await value.getLogsAsString();

    return resolution.trim();
  });
}

Future<String> getVideoFormat(String filePath) async {
  final getVideoFormatArgs = [
    "-v",
    "error",
    "-select_streams",
    "v:0",
    "-show_entries",
    "stream=codec_name",
    "-of",
    "default=noprint_wrappers=1:nokey=1",
    filePath,
  ];

  return FFprobeKit.executeWithArguments(getVideoFormatArgs)
      .then((value) async {
    final format = await value.getLogsAsString();

    return format.trim();
  });
}

Future<int> getVideoDuration(String path) async {
  final ffprobe = await FFprobeKit.getMediaInformation(path);
  final mediaInfo = ffprobe.getMediaInformation();

  return double.parse(mediaInfo?.getDuration() ?? "0").toInt();
}

// Future<int> getVideoDuration(String path) async {
//   final args = [
//     "-v",
//     "error",
//     "-select_streams",
//     "v:0",
//     "-show_entries",
//     "stream=duration",
//     "-of",
//     "default=noprint_wrappers=1:nokey=1",
//     path,
//   ];
//
//   return FFprobeKit.executeWithArguments(args).then((value) async {
//     logger.wtf(path);
//     final duration = await value.getLogsAsString();
//
//     try {
//       return double.parse(duration.trim()).toInt();
//     } catch (e) {
//       return int.parse(duration.trim());
//     }
//   });
// }

Future<VideoMetadataInfo> getVideoMetadata(String filePath) async {
  final String format = await getVideoFormat(filePath);
  final int duration = await getVideoDuration(filePath);
  final String resolution = await getVideoResolution(filePath);

  return VideoMetadataInfo(format, duration, resolution);
}

class VideoMetadataInfo {
  final String format;
  final int duration;
  final String resolution;

  VideoMetadataInfo(
    this.format,
    this.duration,
    this.resolution,
  );

  @override
  String toString() {
    return "FORMAT: $format\nDURATION: $duration\nRESOLUTION: $resolution";
  }
}

String getVideoFilename(String filePath) {
  return File(filePath).uri.pathSegments.last;
}
