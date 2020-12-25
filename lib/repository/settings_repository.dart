import 'package:shared_preferences/shared_preferences.dart';

class SettingsRepository {
  static final _instance = SettingsRepository._internal();
  factory SettingsRepository() => _instance;
  SettingsRepository._internal();

  static const String _randomizedPreferencesKey = 'randomized';

  final _prefsFuture = SharedPreferences.getInstance();

  Future<bool> isPlayOrderRandomized() async {
    final prefs = await _prefsFuture;
    return prefs.getBool(_randomizedPreferencesKey) ?? true;
  }

  void savePlayOrder(bool randomized) async {
    final prefs = await _prefsFuture;
    prefs.setBool(_randomizedPreferencesKey, randomized);
  }
}
