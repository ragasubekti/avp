import 'package:avp/db/schema/videos.dart';
import 'package:get/get.dart';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';

class VideosProvider extends GetxService {
  late final Isar isar;

  Future<VideosProvider> init() async {
    final dir = await getApplicationSupportDirectory();
    isar = await Isar.open([VideosSchema], directory: dir.path);

    return this;
  }
}
