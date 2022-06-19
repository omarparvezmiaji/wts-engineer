import 'package:shared_preferences/shared_preferences.dart';
import 'package:wts_support_engineer/util/shared_pref_key.dart';


class MySharedPreference {
  static void setInt(String key, int value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setInt(key, value);
  }

  static Future<int?> getInt(String key) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getInt(key);
  }

  static void setString(String key, String value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(key, value);
  }

  static Future<String?> getString(String key, {String? defauleValue}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(key) ?? defauleValue;
  }

  static void setBoolean(String key, bool value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool(key, value);
  }

  static Future<bool?> getBoolean(String key) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool(key);
  }

  static Future<String?> getLanguage() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(SharedPrefKey.LANGUAGE) ?? 'bn';
  }

  static void clear()async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool(SharedPrefKey.ISLOGIN, false);
    prefs.setBool(SharedPrefKey.ISUSER, false);
    prefs.setString(SharedPrefKey.USER_INFO, '');
    prefs.setString(SharedPrefKey.EMAIL, '');
    prefs.setString(SharedPrefKey.PHONE_NUMBER, '');
    prefs.setInt(SharedPrefKey.USER_ID, 0);



  }
}
