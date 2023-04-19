import 'package:flutter/material.dart';
import 'package:another_vp/db/settings_database.dart';
import 'package:another_vp/db/video_database.dart';
import 'package:another_vp/models/settings_model.dart';
import 'package:another_vp/widgets/checkbox_menu_widget.dart';
import 'package:sqflite/sqflite.dart';
import 'package:styled_widget/styled_widget.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final SettingsDatabase settingsDb = SettingsDatabase();
  late Database db;
  SettingsModel? settings;
  bool loaded = false;

  @override
  void initState() {
    super.initState();

    Future.microtask(() async {
      db = await settingsDb.initializeDatabase();
      var sett = await settingsDb.getSettings(db);
      settings = sett;
      setState(() {
        loaded = true;
      });
    });
  }

  void refreshSettings() async {
    var sett = await settingsDb.getSettings(db);
    setState(() {
      settings = sett;
    });
  }

  void setDeviceOrientation(SettingDeviceOrientation orientation) async {
    settingsDb.updateSettings(
        db, settings!.copyWith(forceDeviceOrientation: orientation));
    refreshSettings();
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        // appBar:,
        body: Visibility(
      visible: loaded,
      child: SafeArea(
          child: CustomScrollView(
        slivers: [
          SliverAppBar.large(
            title: Text(
              "Settings",
              style: Theme.of(context).textTheme.headlineLarge,
            ),
          ),
          SliverList(
              delegate: SliverChildListDelegate([
            MenuItem(
              title: "Default Orientation",
              // subtitle: "Always Use External Player to Play Media Files",
              subtitle: settings?.forceDeviceOrientation.toString() ?? "",
              icon: Icons.screen_rotation_outlined,
              onPressed: () {
                showModalBottomSheet(
                    context: context,
                    builder: (BuildContext ctx) {
                      return SafeArea(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Default Orientation",
                              style: Theme.of(context).textTheme.headlineSmall,
                            ).padding(all: 16),
                            ListTile(
                              title: const Text("Auto"),
                              onTap: () => setDeviceOrientation(
                                  SettingDeviceOrientation.auto),
                            ),
                            ListTile(
                              title: const Text("Always Portrait"),
                              onTap: () => setDeviceOrientation(
                                  SettingDeviceOrientation.portrait),
                            ),
                            ListTile(
                              title: const Text("Always Landscape"),
                              onTap: () => setDeviceOrientation(
                                  SettingDeviceOrientation.landscape),
                            ),
                          ],
                        ),
                      );
                    });
              },
              type: MenuItemType.dropdown,
            ),
            MenuItem(
              title: "Open in External Player",
              subtitle: "Always Use External Player to Play Media Files",
              icon: Icons.exit_to_app_outlined,
              onPressed: () {
                settingsDb.updateSettings(
                    db,
                    settings!.copyWith(
                        alwaysOpenExternal: !settings!.alwaysOpenExternal));
                refreshSettings();
              },
              enabled: settings?.alwaysOpenExternal ?? false,
              type: MenuItemType.checkbox,
            ),
            MenuItem(
              title: "Mute by Default",
              subtitle:
                  "Disable audio track by default, you can enable it back by changing audio track",
              icon: Icons.volume_off_outlined,
              onPressed: () {
                settingsDb.updateSettings(
                    db, settings!.copyWith(alwaysMute: !settings!.alwaysMute));
                refreshSettings();
              },
              enabled: settings?.alwaysMute ?? false,
              type: MenuItemType.checkbox,
            ),
            // MenuItem(
            //   title: "Dark Mode",
            //   subtitle: "Enable Dark Mode",
            //   icon: Icons.brightness_3_outlined,
            //   onPressed: () {},
            //   enabled: settings?.isDarkMode ?? false,
            //   disabled: true,
            //   type: MenuItemType.none,
            // ),
            MenuItem(
              title: "Clear Database",
              subtitle: "Clear Database, this doesn't delete thumbnail cache",
              icon: Icons.clear_all_outlined,
              onPressed: () async {
                final vd = VideoDatabase();
                final db = await vd.initializeDatabase();

                await db.delete("video_database");

                // ignore: use_build_context_synchronously
                showDialog(
                    context: context,
                    builder: (context) => const AlertDialog(
                          title: Text("Database Cleared"),
                        ));
              },
              enabled: true,
            ),
          ]))
          // SettingsList()
        ],
      )),
    ));
  }
}
