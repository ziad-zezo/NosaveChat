import 'package:hive/hive.dart';

import 'hive/app_settings.dart';

var settingsBox = Hive.box<AppSettings>('settings');

AppSettings userSettings = settingsBox.get('user_settings')!;
