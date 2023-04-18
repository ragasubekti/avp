import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:another_vp/models/settings_model.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class SettingsDatabase {
  Future<Database>? database;
  Future<Database> initializeDatabase() async {
    final databasePath =
        join(getExternalStorageDirectory().toString(), "setting_store.db");
    return openDatabase(databasePath, onCreate: (db, version) {
      return db.execute("""
        CREATE TABLE settings_database (
          id INTEGER PRIMARY KEY,
          always_open_external INTEGER NOT NULL,
          is_dark_mode INTEGER NOT NULL,
          is_black_dark INTEGER NOT NULL,
          force_device_orientation INTEGER NOT NULL,
          always_mute INTEGER NOT NULL
        )
      """);
    }, version: 1, onOpen: (db) {});
  }

  Future<int> updateSettings(Database db, SettingsModel settings) async {
    final findSettings = await db.query("settings_database");

    if (findSettings.isEmpty) {
      return await db.insert("settings_database", settings.toMap());
    } else {
      return await db.update("settings_database", settings.toMap(),
          where: "id = 1");
    }
  }

  Future<SettingsModel> getSettings(Database db) async {
    final findSettings = await db.query("settings_database");

    if (findSettings.isEmpty) {
      final findUserBrightness =
          SchedulerBinding.instance.window.platformBrightness;
      final isDarkMode = findUserBrightness == Brightness.dark;

      SettingsModel settings = SettingsModel(
          alwaysOpenExternal: false,
          isDarkMode: isDarkMode,
          isBlackDark: false,
          forceDeviceOrientation: SettingDeviceOrientation.auto,
          alwaysMute: false);

      await db.insert("settings_database", settings.toMap());

      return settings;
    } else {
      final findSettings = await db.query("settings_database");
      var first = findSettings.first;

      SettingsModel settings = SettingsModel(
          alwaysOpenExternal: first['always_open_external'] == 1,
          isDarkMode: first['is_dark_mode'] == 1,
          isBlackDark: first['is_black_dark'] == 1,
          forceDeviceOrientation: SettingsModel.mapOrientationFromDb(
              first['force_device_orientation'] as int),
          alwaysMute: first['always_mute'] == 1);

      return settings;
      // final returnSettingsData =

      // return await db.update("settings_database", settings.toMap(),
      //     where: "id = 1");
    }
  }
}
