import 'package:shared_preferences/shared_preferences.dart';

class SettingsRepository {
  static const String _randomizedPreferencesKey = 'randomized';

  final _prefsFuture = SharedPreferences.getInstance();

  Future<bool> isPlayOrderRandomized() async {
    final prefs = await _prefsFuture;
    return prefs.getBool(_randomizedPreferencesKey) ?? true;
  }
}
