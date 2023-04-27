// ignore_for_file: prefer_const_constructors

import 'dart:ui';

import 'package:avp/core/files_helper.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => HomeController());
  }
}

class HomeController extends GetxController {
  var viewOptions = 0.obs;
  var sortOptions = 0.obs;
}

class HomePage extends GetView<HomeController> {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      floatingActionButton: FloatingActionButton(onPressed: () {
        Get.updateLocale(const Locale('ja', 'JP'));
      }),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: SearchBar(
                leading: const IconButton(
                  onPressed: null,
                  icon: Icon(Icons.search),
                ),
                hintText: "home_search_hint".tr,
              ),
            ),
            Text(
              "home_recently_played".tr,
              style: textTheme.titleLarge,
            ).paddingSymmetric(horizontal: 16),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: List.generate(3, (int index) => index + index)
                    .map(
                      (e) => videoThumbnail(context),
                    )
                    .toList(),
              ),
            ),
            Text(
              "home_recently_added".tr,
              style: textTheme.titleLarge,
            ).paddingSymmetric(horizontal: 16),
            SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                    children: List.generate(3, (int index) => index + index)
                        .map(
                          (e) => videoThumbnail(context),
                        )
                        .toList()))
          ],
        ),
      ),
    );
  }

  Widget videoThumbnail(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.all(Radius.circular(8)),
      onTap: () {
        Get.snackbar("Video", "Pressed Video");
      },
      child: Container(
        // color: Colors.red,
        width: 180,
        // margin: EdgeInsets.only(left: 8),
        padding: EdgeInsets.all(8),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Stack(
              children: [
                Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: Colors.black12),
                  width: 200,
                  height: 117,
                  child: Icon(Icons.broken_image),
                ),
                // VideoThumbnail(image: AssetImage("static/yelan.jpg")),
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
                      "1:02:34",
                      style: Theme.of(context)
                          .textTheme
                          .bodySmall
                          ?.copyWith(color: Colors.white),
                    ),
                  ),
                ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: InkWell(
                    onTap: () {
                      Get.toNamed("/player");
                      // Get.showSnackbar(snackbar.snackbar);
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
              "yelan looking at you while doing nothingyelan looking at you while doing nothingyelan looking at you while doing nothingyelan looking at you while doing nothing",
              style: Theme.of(context).textTheme.titleSmall,
              maxLines: 2,
              textAlign: TextAlign.left,
              overflow: TextOverflow.visible,
            ).paddingOnly(top: 4),
          ],
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
