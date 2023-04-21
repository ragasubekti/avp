import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:avp/constants/settings.dart';

class SettingService extends GetxService {
  bool isDarkMode = false;
  bool isBlackMode = false;
  bool isAlwaysExternal = false;
  bool isAlwaysMute = false;
  int screenOrientation = 0;

  Future<SettingService> init() async {
    await GetStorage.init();
    isDarkMode =
        (GetStorage().read(SettingsConstant.DARK_MODE)) ?? Get.isDarkMode;
    isBlackMode = (GetStorage().read(SettingsConstant.BLACK_MODE)) ?? false;
    isAlwaysExternal =
        (GetStorage().read(SettingsConstant.ALWAYS_EXTERNAL)) ?? false;
    isAlwaysMute = (GetStorage().read(SettingsConstant.ALWAYS_MUTE)) ?? false;
    screenOrientation =
        (GetStorage().read(SettingsConstant.SCREEN_ORIENTATION)) ?? 0;

    return this;
  }
}
