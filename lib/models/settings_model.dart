enum SettingDeviceOrientation { auto, portrait, landscape }

class SettingsModel {
  final bool alwaysOpenExternal;
  final bool isDarkMode;
  final bool isBlackDark;
  final SettingDeviceOrientation forceDeviceOrientation;
  final bool alwaysMute;

  const SettingsModel(
      {required this.alwaysOpenExternal,
      required this.isDarkMode,
      required this.isBlackDark,
      required this.forceDeviceOrientation,
      required this.alwaysMute});

  int mapOrientationToDb(SettingDeviceOrientation orientation) {
    switch (orientation) {
      case SettingDeviceOrientation.portrait:
        return 1;
      case SettingDeviceOrientation.landscape:
        return 2;
      default:
        return 0;
    }
  }

  static SettingDeviceOrientation mapOrientationFromDb(int orientation) {
    switch (orientation) {
      case 1:
        return SettingDeviceOrientation.portrait;
      case 2:
        return SettingDeviceOrientation.landscape;
      default:
        return SettingDeviceOrientation.auto;
    }
  }

  Map<String, dynamic> toMap() {
    return {
      'id': 1,
      'always_open_external': alwaysOpenExternal,
      'is_dark_mode': isDarkMode,
      'is_black_dark': isBlackDark,
      'force_device_orientation': mapOrientationToDb(forceDeviceOrientation),
      'always_mute': alwaysMute,
    };
  }

  SettingsModel copyWith(
      {bool? alwaysOpenExternal,
      bool? isDarkMode,
      bool? isBlackDark,
      SettingDeviceOrientation? forceDeviceOrientation,
      bool? alwaysMute}) {
    return SettingsModel(
        alwaysOpenExternal: alwaysOpenExternal ?? this.alwaysOpenExternal,
        isDarkMode: isDarkMode ?? this.isDarkMode,
        isBlackDark: isBlackDark ?? this.isBlackDark,
        forceDeviceOrientation:
            forceDeviceOrientation ?? this.forceDeviceOrientation,
        alwaysMute: alwaysMute ?? this.alwaysMute);
  }
}
