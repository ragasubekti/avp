// ignore_for_file: prefer_const_constructors

import 'dart:io';
import 'dart:ui';

import 'package:avp/constants/translation.dart';
import 'package:avp/core/files_helper.dart';
import 'package:avp/core/generic_helper.dart';
import 'package:avp/core/video_helper.dart';
import 'package:avp/db/schema/videos.dart';
import 'package:avp/db/videos_provider.dart';
import 'package:avp/screens/home/home_sort_widget.dart';
import 'package:avp/screens/home/home_view_option_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:isar/isar.dart';

class HomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => HomeController());
  }
}

class HomeController extends GetxController {
  final isar = Get.find<VideosProvider>().isar;
  var viewOptions = 0.obs;
  var sortOptions = 0.obs;
  var videos = [].obs;

  TextEditingController searchController = TextEditingController();

  @override
  void onInit() async {
    super.onInit();
    videos.addAll(await isar.collection<Videos>().where().findAll());
  }

  onSortPressed(BuildContext context) {
    showModalBottomSheet(
      useRootNavigator: true,
      context: context,
      builder: (BuildContext context) => HomeSortWidget(),
    );
  }

  onViewOptionPressed(BuildContext context) {
    showModalBottomSheet(
      useRootNavigator: true,
      context: context,
      builder: (BuildContext context) => HomeViewOptionWidget(),
    );
  }
}

class HomePage extends GetView<HomeController> {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          FilesHelper().scanFiles();
        },
      ),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(8, 8, 8, 0),
              child: SearchBar(
                controller: controller.searchController,
                leading: IconButton(onPressed: null, icon: Icon(Icons.search)),
                hintText: homeSearchHint.tr,
                trailing: [
                  IconButton(
                    onPressed: () => controller.onViewOptionPressed(context),
                    icon: Icon(Icons.grid_view),
                  ),
                  IconButton(
                    onPressed: () => controller.onSortPressed(context),
                    icon: Icon(Icons.sort),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Obx(() => GridView.count(
                    shrinkWrap: true,
                    crossAxisCount: 2,
                    childAspectRatio: 1.15,
                    children: controller.videos
                        .map((video) => videoThumbnail(context, video))
                    .toList(),
                  )),
            ),
          ],
        ),
      ),
    );
  }

  Widget videoThumbnail(BuildContext context, Videos video) {
    final textTheme = Theme.of(context).textTheme;
    final duration = video.duration ?? 0;

    var durationText = intToTimeLeft(duration, showHours: duration >= 3600);

    return Padding(
      padding: EdgeInsets.all(4),
      child: InkWell(
        borderRadius: BorderRadius.all(Radius.circular(8)),
        onTap: () {
          // Get.snackbar("V ideo", "Pressed Video");
        },
        child: Container(
          width: 180,
          padding: EdgeInsets.all(8),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Stack(
                children: [
                  // Container(
                  //   decoration: BoxDecoration(
                  //     borderRadius: BorderRadius.circular(8),
                  //     color: Colors.black12,
                  //   ),
                  //   width: 200,
                  //   height: 117,
                  //   child: Icon(Icons.broken_image),
                  // ),
                  VideoThumbnail(
                      image: FileImage(File(video.thumbnailPath ?? ''))),
                  Positioned(
                    bottom: 0,
                    left: 0,
                    child: Container(
                      margin: EdgeInsets.all(4),
                      padding: EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.5),
                        borderRadius: BorderRadius.all(Radius.circular(4)),
                      ),
                      child: Text(
                        durationText,
                        style:
                            textTheme.bodySmall?.copyWith(color: Colors.white),
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: InkWell(
                      onTap: () {
                        Get.toNamed("/player");
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: ClipRRect(
                          borderRadius: BorderRadius.all(Radius.circular(8)),
                          child: ClipRect(
                            child: BackdropFilter(
                              filter: ImageFilter.blur(sigmaX: 3, sigmaY: 3),
                              child: Container(
                                padding: EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: Colors.black.withOpacity(0.3),
                                ),
                                child: Icon(
                                  Icons.play_arrow,
                                  size: 32,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Text(
                video.name ?? "",
                style: textTheme.titleSmall,
                maxLines: 2,
                textAlign: TextAlign.left,
                overflow: TextOverflow.visible,
              ).paddingOnly(top: 4),
            ],
          ),
        ),
      ),
    );
  }
}

class VideoThumbnail extends StatelessWidget {
  ImageProvider image;

  VideoThumbnail({super.key, required this.image});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: const BorderRadius.all(
        Radius.circular(8),
      ),
      child: Image(
        image: image,
        fit: BoxFit.cover,
        width: 200,
        height: 117,
      ),
    );
  }
}
