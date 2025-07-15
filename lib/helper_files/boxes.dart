import 'package:hive/hive.dart';

import '../hive/app_settings.dart';
import '../hive/chat_history.dart';

var settingsBox = Hive.box<AppSettings>('settings');

AppSettings userSettings = settingsBox.get('user_settings')!;

var chatBox = Hive.box<ChatHistory>('chat_history');