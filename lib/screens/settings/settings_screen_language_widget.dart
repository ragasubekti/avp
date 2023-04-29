import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:avp/screens/settings/settings_screen.dart';

class SettingScreenLanguageWidget extends GetView<SettingsController> {
  const SettingScreenLanguageWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
              child: Text(
                "settings_title_language".tr,
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ),
            ListTile(
              leading: const Text("🇺🇸"),
              onTap: () => controller.changeSelectedLanguage(0, context),
              title: const Text("English"),
              trailing: controller.screenOrientation.value == 0 ? null : null,
            ),
            ListTile(
              leading: const Text("🇯🇵"),
              onTap: () => controller.changeSelectedLanguage(1, context),
              title: const Text("日本語"),
              // trailing: isSelected(selectedOrientation == 0),
            ),
            ListTile(
              leading: const Text("🇰🇷"),
              onTap: () => controller.changeSelectedLanguage(2, context),
              title: const Text("한국어"),
              // trailing: isSelected(selectedOrientation == 0),
            ),
            ListTile(
              leading: const Text("🇨🇳"),
              onTap: () => controller.changeSelectedLanguage(3, context),
              title: const Text("简体中文"),
              // trailing: isSelected(selectedOrientation == 0),
            ),
          ],
        ),
      );
    });
  }
}

// 日本語,简体中文🇨🇳,한국어