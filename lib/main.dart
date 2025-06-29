import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';
import 'package:quick_chat/screens/app_entry_point.dart';
import 'package:quick_chat/screens/home_screen.dart';
import 'package:quick_chat/screens/share_image_screen.dart';
import 'package:receive_sharing_intent/receive_sharing_intent.dart';

import 'generated/l10n.dart';
import 'hive/chat_history.dart';
//import 'locale_helper.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  final appDocDir = await getApplicationDocumentsDirectory();
  Hive.init(appDocDir.path);

  Hive.registerAdapter(ChatHistoryAdapter());

  await Hive.openBox<ChatHistory>('chat_history');


  // final Locale? locale = await LocaleHelper.loadLocale();
  final Locale? locale = Locale('en');
  runApp(QuickChat(locale:locale));
}

class QuickChat extends StatefulWidget {
  const QuickChat({super.key, this.locale});
final Locale? locale;
  @override
  State<QuickChat> createState() => _QuickChatState();
}

class _QuickChatState extends State<QuickChat> {
  ThemeMode _themeMode = ThemeMode.light;





  void toggleTheme() {
    setState(() {
      _themeMode = _themeMode == ThemeMode.light
          ? ThemeMode.dark
          : ThemeMode.light;
    });
  }

  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.light().copyWith(
        floatingActionButtonTheme: FloatingActionButtonThemeData(
          backgroundColor: Colors.black45,
          foregroundColor: Colors.grey,
        ),
      ),
      darkTheme: ThemeData.dark(),
      themeMode: _themeMode,

      localizationsDelegates: [
        S.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: S.delegate.supportedLocales,

      locale: widget.locale,
      home:AppEntryPoint(toggleTheme: toggleTheme,),
    );
  }
}
