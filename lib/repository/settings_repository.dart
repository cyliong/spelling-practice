import 'package:shared_preferences/shared_preferences.dart';

class SettingsRepository {
  static final _instance = SettingsRepository._();
  factory SettingsRepository() => _instance;
  SettingsRepository._();

  static const String _randomizedPreferencesKey = 'randomized';
  static const String _confirmDeletePreferencesKey = 'confirm_delete';

  final _prefsFuture = SharedPreferences.getInstance();

  Future<bool> isPlayOrderRandomized() async {
    final prefs = await _prefsFuture;
    return prefs.getBool(_randomizedPreferencesKey) ?? true;
  }

  Future<void> savePlayOrder(bool randomized) async {
    final prefs = await _prefsFuture;
    prefs.setBool(_randomizedPreferencesKey, randomized);
  }

  Future<bool> isConfirmDelete() async {
    final prefs = await _prefsFuture;
    return prefs.getBool(_confirmDeletePreferencesKey) ?? true;
  }

  Future<void> saveConfirmDelete(bool confirmDelete) async {
    final prefs = await _prefsFuture;
    prefs.setBool(_confirmDeletePreferencesKey, confirmDelete);
  }
}
