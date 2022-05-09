import 'package:shared_preferences/shared_preferences.dart';

// 저장한다.
saveAsString(key, value) async {
  final prefs = await SharedPreferences.getInstance();
  prefs.setString(key, value);
}

// 읽는다.
Future<String?> readAsString(key) async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.getString(key);
}
