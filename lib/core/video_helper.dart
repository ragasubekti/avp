import 'package:ffmpeg_kit_flutter_video/ffmpeg_kit.dart';
import 'package:ffmpeg_kit_flutter_video/ffprobe_kit.dart';
import 'package:ffmpeg_kit_flutter_video/return_code.dart';
import 'package:logger/logger.dart';
import 'package:mpvxd/core/random_string.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

var logger =
    Logger(printer: PrettyPrinter(noBoxingByDefault: false, printTime: false));

final List<String> commonVideoFormat = [
  ".webm",
  ".mov",
  ".mp4",
  ".avi",
  ".mkv",
  ".m4a"
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
      "$file.jpeg"
    ];

    return FFmpegKit.executeWithArguments(ffmpegArgs).then((session) async {
      final returnCode = await session.getReturnCode();
      logger.d(await session.getAllLogsAsString());

      if (ReturnCode.isSuccess(returnCode)) {
        return "$file.jpeg";
      } else {
        return null;
      }
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
    filePath
  ];

  return FFprobeKit.executeWithArguments(getVideoResolutionArgs)
      .then((value) async {
    final resolution = await value.getLogsAsString();
    return resolution;
  });
}

Future<VideoMetadataInfo> getVideoMetadata(String filePath) async {
  final ffprobe = await FFprobeKit.getMediaInformation(filePath);
  final mediaInfo = ffprobe.getMediaInformation();

  final String format = mediaInfo!.getFormat() ?? "Unknown";
  final int duration = double.parse(mediaInfo.getDuration() ?? "0").toInt();
  String resolution = (await getVideoResolution(filePath)).trim();

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
