import 'package:avp/core/screen_helper.dart';
import 'package:avp/screens/settings/settings_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class VideoPlayerBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => VideoPlayerController());
  }
}

class VideoPlayerController extends GetxController {
  final setting = Get.find<SettingService>();

  @override
  void onInit() {
    super.onInit();
    // setScreenOrientation(setting.screenOrientation);
    setScreenOrientation(2);
    setApplicationFullscreen(immersive: true);
  }

  @override
  void onClose() {
    super.onClose();
    setScreenOrientation(0);
  }
}

class VideoPlayerPage extends GetView<VideoPlayerController> {
  @override
  Widget build(BuildContext context) {
    final setting = controller.setting;
    final theme = Theme.of(context);

    return Scaffold(
      body: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onHorizontalDragUpdate: (details) {
          final Size windowSize = MediaQuery.of(context).size;

          if (details.globalPosition.dx <= (windowSize.width / 2)) {
            print("LEFT");
          } else {
            print("RIGHT");
          }

          print("${details.primaryDelta}");
        },
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "SPY x FAMILY S01E01",
                    style: theme.textTheme.headlineMedium,
                  ).marginOnly(bottom: 4),
                  const Row(
                    children: [
                      AvpChip("HEVC"),
                      AvpChip("TRUE-HD"),
                      AvpChip("4K"),
                    ],
                  ),
                ],
              ),
              Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      FilledButton(
                        onPressed: () {},
                        child: Icon(Icons.audiotrack),
                      ),
                      FilledButton(
                        onPressed: () {},
                        child: Icon(Icons.subtitles),
                      ),
                    ],
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}

class AvpChip extends StatelessWidget {
  final String label;

  const AvpChip(
    this.label, {
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(2),
      margin: const EdgeInsets.only(right: 4),
      decoration: BoxDecoration(
        color: theme.colorScheme.primaryContainer.withOpacity(0.5),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        label,
        style: theme.textTheme.labelSmall,
      ),
    );
  }
}
