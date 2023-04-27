import 'package:avp/constants/settings.dart';
import 'package:avp/screens/settings/settings_screen_orientation_widget.dart';
import 'package:avp/screens/settings/settings_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class SettingsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => SettingsController());
  }
}

class SettingsController extends GetxController {
  final box = GetStorage();

  RxBool isDarkMode = false.obs;
  RxBool isBlackMode = false.obs;
  RxBool isAlwaysExternal = false.obs;
  RxBool isAlwaysMute = false.obs;
  RxInt screenOrientation = 0.obs;

  @override
  void onInit() {
    super.onInit();
    final darkMode =
        box.read<bool?>(SettingsConstant.DARK_MODE) ?? Get.isDarkMode;
    final blackMode = box.read<bool?>(SettingsConstant.BLACK_MODE) ?? false;
    final alwaysExternal =
        box.read<bool?>(SettingsConstant.ALWAYS_EXTERNAL) ?? false;
    final alwaysMute = box.read<bool?>(SettingsConstant.ALWAYS_MUTE) ?? false;
    final sOrientation =
        box.read<int?>(SettingsConstant.SCREEN_ORIENTATION) ?? 0;

    isDarkMode(darkMode);
    isBlackMode(blackMode);
    isAlwaysExternal(alwaysExternal);
    isAlwaysMute(alwaysMute);
    screenOrientation(sOrientation);
  }

  onBoolOptionChange(String type) {
    switch (type) {
      case SettingsConstant.DARK_MODE:
        isDarkMode(!isDarkMode.value);
        box.write(type, isDarkMode.value);

        Get.changeThemeMode(
          isDarkMode.value ? ThemeMode.dark : ThemeMode.light,
        );
        break;
      case SettingsConstant.BLACK_MODE:
        isBlackMode(!isBlackMode.value);
        box.write(type, isBlackMode.value);
        break;
      case SettingsConstant.ALWAYS_MUTE:
        isAlwaysMute(!isAlwaysMute.value);
        box.write(type, isAlwaysMute.value);
        break;
      case SettingsConstant.ALWAYS_EXTERNAL:
        isAlwaysExternal(!isAlwaysExternal.value);
        box.write(type, isAlwaysExternal.value);
        break;
    }

    Get.find<SettingService>().updateValues();
  }

  onScreenOrientationPressed(BuildContext context) {
    showModalBottomSheet(
      context: Get.context ?? context,
      builder: (BuildContext ctx) {
        return const SettingScreenOrientationWidget();
      },
    );
  }

  changeScreenOrientation(int value, BuildContext context) {
    screenOrientation(value);
    box.write(SettingsConstant.SCREEN_ORIENTATION, value);

    Get.find<SettingService>().updateValues();
    Navigator.pop(context);
  }
}

class SettingsScreen extends GetView<SettingsController> {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar.large(
            automaticallyImplyLeading: false,
            title: Text(
              "settings_title".tr,
              style: Theme.of(context).textTheme.headlineLarge,
            ),
          ),
          Obx(
            () => SliverList(
              delegate: SliverChildListDelegate([
                ListTile(
                  onTap: () => controller.onScreenOrientationPressed(context),
                  leading: const Icon(Icons.screen_rotation),
                  title: Text('settings_title_screen_orientation'.tr),
                  subtitle: Text('settings_subtitle_screen_orientation'.tr),
                ),
                CheckboxListTile(
                  value: controller.isAlwaysExternal.value,
                  onChanged: (_) => controller
                      .onBoolOptionChange(SettingsConstant.ALWAYS_EXTERNAL),
                  secondary: const Icon(Icons.open_in_new),
                  title: Text("settings_title_open_external".tr),
                  subtitle: Text("settings_subtitle_open_external".tr),
                ),
                CheckboxListTile(
                  value: controller.isAlwaysMute.value,
                  onChanged: (_) => controller
                      .onBoolOptionChange(SettingsConstant.ALWAYS_MUTE),
                  secondary: const Icon(Icons.volume_off),
                  title: Text("settings_title_mute".tr),
                  subtitle: Text("settings_subtitle_mute".tr),
                ),
                CheckboxListTile(
                  value: controller.isDarkMode.value,
                  onChanged: (_) =>
                      controller.onBoolOptionChange(SettingsConstant.DARK_MODE),
                  secondary: const Icon(Icons.dark_mode),
                  title: Text("settings_title_dark".tr),
                  subtitle: Text("settings_subtitle_dark".tr),
                ),
                CheckboxListTile(
                  value: controller.isBlackMode.value,
                  onChanged: controller.isDarkMode.value
                      ? (_) => controller
                          .onBoolOptionChange(SettingsConstant.BLACK_MODE)
                      : null,
                  secondary: const Icon(Icons.dark_mode_outlined),
                  title: Text("settings_title_black".tr),
                  subtitle: Text("settings_subtitle_black".tr),
                ),
              ]),
            ),
          ),
        ],
      ),
    );
  }
}
