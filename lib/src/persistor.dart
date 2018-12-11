import 'package:shared_preferences/shared_preferences.dart';

abstract class Persistor {
  Persistor();

  factory Persistor.sharedPreferences() => _SharedPreferencesPersistor();

  factory Persistor.mmkv() =>
      throw UnimplementedError('MMKV persistor not implemented yet');

  void save(String key, dynamic value);

  void load();
}

class _SharedPreferencesPersistor extends Persistor {
  _SharedPreferencesPersistor() {
    SharedPreferences.getInstance()
        .then((preferences) => this._preferences = preferences);
  }

  SharedPreferences _preferences;

  @override
  void save(String key, dynamic value) {

  }

  @override
  void load() {}
}
