import 'package:hive/hive.dart';

import 'package:quick_chat/hive/app_settings.dart';
import 'package:quick_chat/hive/chat_history.dart';

Box<AppSettings> settingsBox = Hive.box<AppSettings>('settings');

AppSettings userSettings = settingsBox.get('user_settings')!;

Box<ChatHistory> chatBox = Hive.box<ChatHistory>('chat_history');