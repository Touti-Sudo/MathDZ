import 'package:shared_preferences/shared_preferences.dart';
Future<bool> isFirstTime() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  bool seen = prefs.getBool('seen') ?? false;

  if (!seen) {
    await prefs.setBool('seen', true);
  }

  return !seen;
}
