import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import 'state.dart';

abstract class Persistor {
  void autoSave(CerebralState state);
}

class DummyPersistor extends Persistor {
  @override
  void autoSave(CerebralState state) {}
}

class SharedPreferencesPersistor extends Persistor {
  static Future<SharedPreferencesPersistor> getInstance() async {
    _preferences = await SharedPreferences.getInstance();
    return SharedPreferencesPersistor._();
  }

  SharedPreferencesPersistor._();

  @override
  void autoSave(CerebralState state) => _preferences.setString(state.runtimeType.toString(), json.encode(state));

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
