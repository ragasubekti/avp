String intToTimeLeft(int value, {bool showHours = false}) {
  int h, m, s;

  h = value ~/ 3600;

  m = ((value - h * 3600)) ~/ 60;

  s = value - (h * 3600) - (m * 60);

  final hourLeft = h.toString().padLeft(2, '0');
  final minuteLeft = m.toString().padLeft(2, '0');
  final secondLeft = s.toString().padLeft(2, '0');

  String result = showHours
      ? "$hourLeft:$minuteLeft:$secondLeft"
      : "$minuteLeft:$secondLeft";

  return result;
}
