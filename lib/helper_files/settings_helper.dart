import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:hive/hive.dart';
import 'package:quick_chat/hive/app_settings.dart';

class SettingsHelper {
  static final settingsBox = Hive.box<AppSettings>('settings');
  static Future<void> saveLocale(Locale locale) async {
    //get current settings
    final currentSettings = settingsBox.get('user_settings');
    // update the locale only
    await settingsBox.put(
      'user_settings',
      currentSettings!.copyWith(languageCode: locale.languageCode),
    );

  }

  static Future<Locale?> loadLocale() async {
    return Locale(settingsBox.get('user_settings')!.languageCode);
  }

  static Future<bool> loadSaveRecentNumbers() async {
    final currentSettings = settingsBox.get('user_settings');
    return currentSettings!.saveRecentNumber;
  }
  static Future<void> setSaveRecentNumbers(bool value) async {
    final currentSettings = settingsBox.get('user_settings');
    await settingsBox.put(
      'user_settings',
      currentSettings!.copyWith(saveRecentNumber: value),
    );
  }
  static Future<bool> loadDarkModeSettings() async {
    final currentSettings = settingsBox.get('user_settings');
    return currentSettings!.isDarkMode;
  }
  static Future<void> setDarkMode(bool value) async {
    final currentSettings = settingsBox.get('user_settings');
    await settingsBox.put(
      'user_settings',
      currentSettings!.copyWith(isDarkMode: value),
    );
  }
}
