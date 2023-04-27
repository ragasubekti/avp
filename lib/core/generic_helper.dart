import 'dart:math';

String generateRandomString(int len) {
  var r = Random.secure();
  const chars =
      'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';

  return List.generate(len, (index) => chars[r.nextInt(chars.length)]).join();
}

String intToTimeLeft(int value, {bool showHours = false}) {
  final duration = Duration(seconds: value);
  final hours = duration.inHours.toString().padLeft(2, '0');
  final minutes = duration.inMinutes.remainder(60).toString().padLeft(2, '0');
  final seconds = duration.inSeconds.remainder(60).toString().padLeft(2, '0');

  return showHours ? '$hours:$minutes:$seconds' : '$minutes:$seconds';
}
