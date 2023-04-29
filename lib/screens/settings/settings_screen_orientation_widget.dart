import 'package:avp/screens/settings/settings_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SettingScreenOrientationWidget extends GetView<SettingsController> {
  const SettingScreenOrientationWidget({super.key});

  Widget? isSelected(bool value) {
    if (!value) return null;

    return const Icon(Icons.check);
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      var selectedOrientation = controller.screenOrientation.value;

      return SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
              child: Text(
                "settings_title_screen_orientation_widget".tr,
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ),
            ListTile(
              leading: const Icon(Icons.screen_rotation),
              onTap: () => controller.changeScreenOrientation(0, context),
              title: Text("settings_title_screen_orientation_auto".tr),
              trailing: isSelected(selectedOrientation == 0),
            ),
            ListTile(
              leading: const Icon(Icons.stay_current_portrait),
              onTap: () => controller.changeScreenOrientation(1, context),
              title: Text("settings_title_screen_orientation_portrait".tr),
              trailing: isSelected(selectedOrientation == 1),
            ),
            ListTile(
              leading: const Icon(Icons.stay_current_landscape),
              onTap: () => controller.changeScreenOrientation(2, context),
              title: Text("settings_title_screen_orientation_landscape".tr),
              trailing: isSelected(selectedOrientation == 2),
            ),
          ],
        ),
      );
    });
  }
}
