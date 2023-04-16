import 'package:mpvxd/models/settings_model.dart';
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
          always_mute INTEGER NOT NULL,
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

  // SettingsModel getSettings(Database db) {}
}
