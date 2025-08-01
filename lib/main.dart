import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';
import 'package:quick_chat/cubit/chat_history_cubit.dart';
import 'package:quick_chat/generated/l10n.dart';
import 'package:quick_chat/helper_files/boxes.dart';
import 'package:quick_chat/helper_files/theme_helper.dart';
import 'package:quick_chat/hive/app_settings.dart';
import 'package:quick_chat/hive/chat_history.dart';
import 'package:quick_chat/screens/home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final appDocDir = await getApplicationDocumentsDirectory();
  Hive.init(appDocDir.path);
  Hive.registerAdapter(ChatHistoryAdapter());
  await Hive.openBox<ChatHistory>('chat_history');
  Hive.registerAdapter(AppSettingsAdapter());
  await Hive.openBox<AppSettings>('settings');
  final settingsBox = await Hive.openBox<AppSettings>('settings');
  // Check if 'user_settings' is saved already
  if (!settingsBox.containsKey('user_settings')) {
    await settingsBox.put(
      'user_settings',
      AppSettings(
        languageCode: PlatformDispatcher.instance.locale.languageCode,
        isDarkMode: false,
        countryCode: 'EG',
        saveRecentNumber: true,
        savedMessage: '',
      ),
    );
  }

  runApp(const NoSaveChat());
}

class NoSaveChat extends StatefulWidget {
  const NoSaveChat({super.key});

  @override
  State<NoSaveChat> createState() => _NoSaveChatState();
}

class _NoSaveChatState extends State<NoSaveChat> {
  late ThemeMode _themeMode = settingsBox.get('user_settings')!.isDarkMode
  ? ThemeMode.dark
      : ThemeMode.light;
  final Locale locale = Locale(userSettings.languageCode);
  @override
  void initState() {
    super.initState();
    // _themeMode = userSettings.isDarkMode
    //     ? ThemeMode.dark
    //     : ThemeMode.light;
  }



  Future<void> toggleTheme() async {
    setState(() {
      _themeMode = _themeMode == ThemeMode.light
          ? ThemeMode.dark
          : ThemeMode.light;
    });
    userSettings = userSettings.copyWith(
      isDarkMode: _themeMode == ThemeMode.dark,
    );
    await settingsBox.put('user_settings', userSettings);
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ChatHistoryCubit(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        darkTheme: ThemeHelper.getThemeData(brightness: Brightness.dark),
        theme: ThemeHelper.getThemeData(),
        themeMode: _themeMode,
        //userSettings.isDarkMode ? ThemeMode.dark : ThemeMode.light,
        localizationsDelegates: const [
          S.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: S.delegate.supportedLocales,
        locale: locale,
        home: HomeScreen(toggleTheme: toggleTheme),
      ),
    );
  }
}
