import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';
import 'package:quick_chat/cubit/chat_history_cubit.dart';
import 'package:quick_chat/helper_files/theme_helper.dart';
import 'package:quick_chat/screens/home_screen.dart';
import 'package:quick_chat/helper_files/boxes.dart';
import 'package:quick_chat/generated/l10n.dart';
import 'package:quick_chat/hive/app_settings.dart';
import 'package:quick_chat/hive/chat_history.dart';

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
      ),
    );
  }

  runApp(QuickChat(isDarkMode: userSettings.isDarkMode));
}

class QuickChat extends StatefulWidget {
  const QuickChat({super.key, required this.isDarkMode});

  final bool isDarkMode;
  @override
  State<QuickChat> createState() => _QuickChatState();
}

class _QuickChatState extends State<QuickChat> {
  ThemeMode _themeMode = ThemeMode.light;
  final Locale locale = Locale(userSettings.languageCode);
  @override
  void initState() {
    super.initState();
    _loadTheme();
  }

  void _loadTheme() async {
    if (widget.isDarkMode) {
      toggleTheme();
    }
  }

  void toggleTheme() async {
    setState(() {
      _themeMode = _themeMode == ThemeMode.light
          ? ThemeMode.dark
          : ThemeMode.light;
    });
    await settingsBox.put(
      'user_settings',
      userSettings.copyWith(isDarkMode: _themeMode == ThemeMode.dark),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ChatHistoryCubit(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        darkTheme: ThemeHelper.getThemeDate(brightness: Brightness.dark),
        //ThemeData.dark(),
        theme: ThemeHelper.getThemeDate(),
        themeMode: _themeMode,
        localizationsDelegates: const [
          S.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: S.delegate.supportedLocales,
        locale: locale,
        home: HomeScreen(toggleTheme: toggleTheme),
        //AppEntryPoint(toggleTheme: toggleTheme),
      ),
    );
  }
}
