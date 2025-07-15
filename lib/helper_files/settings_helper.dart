import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:hive/hive.dart';
import 'package:quick_chat/hive/app_settings.dart';

class LocaleHelper {
  static const _key = 'preferred_language';
  static final settingsBox = Hive.box<AppSettings>('settings');
  static Future<void> saveLocale(Locale locale) async {
    //get current settings
    final currentSettings = settingsBox.get('user_settings');
    // update the locale only
    await settingsBox.put(
      'user_settings',
      currentSettings!.copyWith(languageCode: locale.languageCode),
    );
    //todo remove print

    print("Your previous locale is ${currentSettings.languageCode} ");
    print(
      "You set new locale is ${settingsBox.get('user_settings')!.languageCode} ",
    );
  }

  static Future<Locale?> loadLocale() async {
    //todo remove print
    print("Your locale is ${settingsBox.get('user_settings')!.languageCode} ");

    return Locale(settingsBox.get('user_settings')!.languageCode);
  }
}
