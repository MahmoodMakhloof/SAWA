import 'package:shared_preferences/shared_preferences.dart';

class CacheHelper {
  static SharedPreferences? sharedPreference;

  static Future init() async {
    sharedPreference = await SharedPreferences.getInstance();
  }

  static Future<bool> saveData({
    required String key,
    required dynamic value,
  }) async {
    if (value is String)
      return await sharedPreference!.setString(key, value);
    else if (value is bool)
      return await sharedPreference!.setBool(key, value);
    else if (value is int)
      return await sharedPreference!.setInt(key, value);
    else
      return await sharedPreference!.setDouble(key, value);
  }

  static dynamic importData({required String key}) {
    return sharedPreference!.get(key);
  }

  static dynamic removeData({required String key}) {
    return sharedPreference!.remove(key);
  }
}
