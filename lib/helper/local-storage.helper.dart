import 'package:shared_preferences/shared_preferences.dart';

late SharedPreferences prefs;

getPrefs() {
  return SharedPreferences.getInstance();
}

class LocalStorageHelper {
  static setValue(key, value) async {
    SharedPreferences prefs = await getPrefs();
    prefs.setString(key, value);
  }

  static getValue(key) async {
    SharedPreferences prefs = await getPrefs();
    return prefs.getString(key);
  }

  static remove(key) async {
    SharedPreferences prefs = await getPrefs();
    prefs.remove(key);
  }
}
