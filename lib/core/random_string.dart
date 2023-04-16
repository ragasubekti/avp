import 'dart:math';

///
/// Solution taken from StackOverflow:
/// https://stackoverflow.com/questions/61919395/how-to-generate-random-string-in-dart
///

String generateRandomString(int len) {
  var r = Random.secure();
  const _chars =
      'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
  return List.generate(len, (index) => _chars[r.nextInt(_chars.length)]).join();
}
