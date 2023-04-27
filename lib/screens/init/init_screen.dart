import 'package:avp/screens/audio/audio_screen.dart';
import 'package:avp/screens/home/home_screen.dart';
import 'package:avp/screens/settings/settings_screen.dart';
import 'package:avp/screens/video/video_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class InitBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => InitController());
  }
}

class InitController extends GetxController {
  static InitController get to => Get.find();

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

class InitPage extends GetView<InitController> {
  const InitPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Navigator(
        key: Get.nestedKey(1),
        initialRoute: '/home',
        onGenerateRoute: controller.onGenerateRoute,
      ),
      bottomNavigationBar: Obx(
        () => NavigationBar(
          destinations: [
            NavigationDestination(
              icon: const Icon(Icons.home),
              label: "appbar_home".tr,
            ),
            NavigationDestination(
              icon: const Icon(Icons.video_library),
              label: "appbar_video".tr,
            ),
            NavigationDestination(
              icon: const Icon(Icons.library_music),
              label: 'appbar_audio'.tr,
            ),
            NavigationDestination(
              icon: const Icon(Icons.settings),
              label: 'appbar_setting'.tr,
            ),
          ],
          selectedIndex: controller.currentIndex.value,
          onDestinationSelected: controller.changePage,
        ),
      ),
    );
  }
}
