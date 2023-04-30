import 'package:avp/screens/audio/audio_screen.dart';
import 'package:avp/screens/home/home_screen.dart';
import 'package:avp/screens/settings/settings_screen.dart';
import 'package:avp/screens/video/video_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class InitLargeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => InitLargeController());
  }
}

class InitLargeController extends GetxController {
  static InitLargeController get to => Get.find();

  var currentIndex = 0.obs;

  final pages = <String>[
    '/home',
    '/video',
    '/audio',
    '/settings',
  ];

  void changePage(int index) {
    if (index == currentIndex.value) return;
    currentIndex.value = index;
    Get.offAllNamed(
      pages[index],
      id: 1,
    );
  }

  Route? onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/settings':
        return GetPageRoute(
          settings: settings,
          page: () => const SettingsScreen(),
          binding: SettingsBinding(),
        );
      case '/audio':
        return GetPageRoute(
          settings: settings,
          page: () => AudioScreen(),
          binding: AudioBinding(),
        );
      case '/video':
        return GetPageRoute(
          settings: settings,
          page: () => VideoScreen(),
          binding: VideoBinding(),
        );
      default:
        return GetPageRoute(
          settings: settings,
          page: () => const HomePage(),
          binding: HomeBinding(),
        );
    }
  }
}

class InitLargePage extends GetView<InitLargeController> {
  const InitLargePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text("TV/Tablet Screen"),
      ),
    );
  }
}
