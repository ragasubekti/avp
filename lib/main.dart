import 'package:avp/db/videos_provider.dart';
import 'package:avp/screens/settings/settings_service.dart';
import 'package:avp/screens/video_player/video_player_screen.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

import 'package:avp/i18n/translations.dart';
import 'package:avp/screens/init/init_screen.dart';
// import 'package:media_kit/media_kit.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // MediaKit.ensureInitialized();

  await initializeConfig();
  runApp(Avp());
}

Future<void> initializeConfig() async {
  await Get.putAsync(() => SettingService().init());
  await Get.putAsync(() => VideosProvider().init());
}

class Avp extends StatelessWidget {
  Avp({super.key});
  final settings = Get.find<SettingService>();

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      locale: Get.deviceLocale,
      fallbackLocale: const Locale('en', 'US'),
      translations: AvpTranslation(),
      darkTheme: ThemeData.dark(
        useMaterial3: true,
      ),
      theme: ThemeData(useMaterial3: true),
      themeMode: settings.isDarkMode ? ThemeMode.dark : ThemeMode.light,
      defaultTransition: Transition.native,
      initialRoute: "/init",
      getPages: [
        GetPage(
          name: '/init',
          page: () => const InitPage(),
          binding: InitBinding(),
        ),
        GetPage(
          name: "/player",
          page: () => VideoPlayerPage(),
          binding: VideoPlayerBinding(),
        ),
      ],
    );
  }
}
