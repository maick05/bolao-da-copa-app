import 'package:shared_preferences/shared_preferences.dart';

late SharedPreferences prefs;

getPrefs() {
  return SharedPreferences.getInstance();
}

class LocalStorageHelper {
  static setValue<SetType>(key, value) async {
    SharedPreferences prefs = await getPrefs();
    switch (SetType) {
      case int:
        prefs.setInt(key, value);
        break;
      default:
        prefs.setString(key, value);
        break;
    }
  }

  static getValue<GetType>(key) async {
    SharedPreferences prefs = await getPrefs();
    switch (GetType) {
      case int:
        return prefs.getInt(key);
      default:
        return prefs.getString(key);
    }
  }

  static getValueIfNotExists(key, callback) async {
    var value = await LocalStorageHelper.getValue(key);
    if (value != null) {
      value = await callback();
    }
    await LocalStorageHelper.setValue(key, value);
    return LocalStorageHelper.getValue(key);
  }

  static remove(key) async {
    SharedPreferences prefs = await getPrefs();
    prefs.remove(key);
  }
}
