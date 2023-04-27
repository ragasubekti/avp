import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AudioBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => AudioController());
  }
}

class AudioController extends GetxController {
  final title = "Audio".obs;
}

class AudioScreen extends GetView<AudioController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar.large(
            automaticallyImplyLeading: false,
            title: Text("audio_title".tr),
          ),
        ],
      ),
    );
  }
}
