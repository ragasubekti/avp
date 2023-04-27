import 'package:flutter/services.dart';

void setScreenOrientation(int type) {
  switch (type) {
    case 1:
      SystemChrome.setPreferredOrientations([
        DeviceOrientation.portraitUp,
        DeviceOrientation.portraitDown,
      ]);
      break;
    case 2:
      SystemChrome.setPreferredOrientations([
        DeviceOrientation.landscapeLeft,
        DeviceOrientation.landscapeRight,
      ]);
      break;
    default:
      SystemChrome.setPreferredOrientations([]);
  }
}

void setApplicationFullscreen({bool immersive = false}) {
  SystemChrome.setEnabledSystemUIMode(
    immersive ? SystemUiMode.immersive : SystemUiMode.edgeToEdge,
  );
}
