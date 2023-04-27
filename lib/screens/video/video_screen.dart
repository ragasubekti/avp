import 'package:flutter/material.dart';
import 'package:get/get.dart';

class VideoBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => VideoController());
  }
}

class VideoController extends GetxController {
  final title = "Video".obs;
}

class VideoScreen extends GetView<VideoController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar.large(
            automaticallyImplyLeading: false,
            title: Text("video_title".tr),
          ),
        ],
      ),
    );
  }
}
