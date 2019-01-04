import 'package:shared_preferences/shared_preferences.dart';

abstract class Persistor {}

class SharedPreferencesPersistor extends Persistor {
  SharedPreferencesPersistor() {
    SharedPreferences.getInstance()
        .then((preferences) => _preferences = preferences);
  }

  static SharedPreferences _preferences;

  Future<bool> setBool(String key, bool value) => _preferences.setBool(key, value);

  Future<bool> setInt(String key, int value) => _preferences.setInt(key, value);

  Future<bool> setDouble(String key, double value) => _preferences.setDouble(key, value);

  Future<bool> setString(String key, String value) => _preferences.setString(key, value);

  Future<bool> setStringList(String key, List<String> value) => _preferences.setStringList(key, value);

  Future<bool> remove(String key) => _preferences.remove(key);

  Set<String> getKeys() => _preferences.getKeys();

  bool getBool(String key) => _preferences.getBool(key);

  int getInt(String key) => _preferences.getInt(key);

  double getDouble(String key) => _preferences.getDouble(key);

  String getString(String key) => _preferences.getString(key);
  
  List<String> getStringList(String key) => _preferences.getStringList(key);
}