import 'package:flutter/material.dart';
import 'package:mpvxd/widgets/checkbox_menu_widget.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        // appBar:,
        body: SafeArea(
            child: CustomScrollView(
      slivers: [
        SliverAppBar.large(
          title: const Text("Settings"),
        ),
        SliverList(
            delegate: SliverChildListDelegate([
          ChecboxMenuWidget(
            title: "Default Orientation",
            subtitle: "Always Use External Player to Play Media Files",
            icon: Icons.screen_rotation_outlined,
            onPressed: () {},
          ),
          ChecboxMenuWidget(
            title: "Open in External Player",
            subtitle: "Always Use External Player to Play Media Files",
            icon: Icons.exit_to_app_outlined,
            onPressed: () {},
          ),
          ChecboxMenuWidget(
            title: "Mute by Default",
            subtitle:
                "Set Volume to 0 within the app and disable volume control (doesn't apply to external player)",
            icon: Icons.volume_off_outlined,
            onPressed: () {},
          ),
          ChecboxMenuWidget(
            title: "Dark Mode",
            subtitle: "Enable Dark Mode",
            icon: Icons.brightness_3_outlined,
            onPressed: () {},
            enabled: true,
          ),
          ChecboxMenuWidget(
            title: "Clear Database",
            subtitle: "Clear Database and Force Rescan of Library",
            icon: Icons.clear_all_outlined,
            onPressed: () {},
            enabled: true,
          ),
        ]))
        // SettingsList()
      ],
    )));
  }
}
