// GENERATED CODE - DO NOT MODIFY BY HAND
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'intl/messages_all.dart';

// **************************************************************************
// Generator: Flutter Intl IDE plugin
// Made by Localizely
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, lines_longer_than_80_chars
// ignore_for_file: join_return_with_assignment, prefer_final_in_for_each
// ignore_for_file: avoid_redundant_argument_values, avoid_escaping_inner_quotes

class S {
  S();

  static S? _current;

  static S get current {
    assert(
      _current != null,
      'No instance of S was loaded. Try to initialize the S delegate before accessing S.current.',
    );
    return _current!;
  }

  static const AppLocalizationDelegate delegate = AppLocalizationDelegate();

  static Future<S> load(Locale locale) {
    final name = (locale.countryCode?.isEmpty ?? false)
        ? locale.languageCode
        : locale.toString();
    final localeName = Intl.canonicalizedLocale(name);
    return initializeMessages(localeName).then((_) {
      Intl.defaultLocale = localeName;
      final instance = S();
      S._current = instance;

      return instance;
    });
  }

  static S of(BuildContext context) {
    final instance = S.maybeOf(context);
    assert(
      instance != null,
      'No instance of S present in the widget tree. Did you add S.delegate in localizationsDelegates?',
    );
    return instance!;
  }

  static S? maybeOf(BuildContext context) {
    return Localizations.of<S>(context, S);
  }

  /// `Enter Phone Number`
  String get enter_phone_number {
    return Intl.message(
      'Enter Phone Number',
      name: 'enter_phone_number',
      desc: '',
      args: [],
    );
  }

  /// `Phone number found in clipboard`
  String get clipboard_content {
    return Intl.message(
      'Phone number found in clipboard',
      name: 'clipboard_content',
      desc: '',
      args: [],
    );
  }

  /// `An error occurred while reading the clipboard`
  String get failed_to_read_clipboard {
    return Intl.message(
      'An error occurred while reading the clipboard',
      name: 'failed_to_read_clipboard',
      desc: '',
      args: [],
    );
  }

  /// `Invalid phone number`
  String get invalid_phone_number {
    return Intl.message(
      'Invalid phone number',
      name: 'invalid_phone_number',
      desc: '',
      args: [],
    );
  }

  /// `No Phone Found`
  String get no_phone_found {
    return Intl.message(
      'No Phone Found',
      name: 'no_phone_found',
      desc: '',
      args: [],
    );
  }

  /// `No valid phone number was detected in the image.`
  String get no_phone_found_desc {
    return Intl.message(
      'No valid phone number was detected in the image.',
      name: 'no_phone_found_desc',
      desc: '',
      args: [],
    );
  }

  /// `OK`
  String get ok {
    return Intl.message('OK', name: 'ok', desc: '', args: []);
  }

  /// `Detected Phone`
  String get detected_phone {
    return Intl.message(
      'Detected Phone',
      name: 'detected_phone',
      desc: '',
      args: [],
    );
  }

  /// `Edit`
  String get edit {
    return Intl.message('Edit', name: 'edit', desc: '', args: []);
  }

  /// `Chat`
  String get chat {
    return Intl.message('Chat', name: 'chat', desc: '', args: []);
  }

  /// `Chat History`
  String get chat_history {
    return Intl.message(
      'Chat History',
      name: 'chat_history',
      desc: '',
      args: [],
    );
  }

  /// `Delete`
  String get delete {
    return Intl.message('Delete', name: 'delete', desc: '', args: []);
  }

  /// `Chat Deleted`
  String get chat_deleted {
    return Intl.message(
      'Chat Deleted',
      name: 'chat_deleted',
      desc: '',
      args: [],
    );
  }

  /// `No Chat History`
  String get no_chat_history {
    return Intl.message(
      'No Chat History',
      name: 'no_chat_history',
      desc: '',
      args: [],
    );
  }

  /// `Confirm Deletion`
  String get confirm_deletion {
    return Intl.message(
      'Confirm Deletion',
      name: 'confirm_deletion',
      desc: '',
      args: [],
    );
  }

  /// `Are you sure you want to delete all chat history? This action cannot be undone.`
  String get confirm_delete_warning {
    return Intl.message(
      'Are you sure you want to delete all chat history? This action cannot be undone.',
      name: 'confirm_delete_warning',
      desc: '',
      args: [],
    );
  }

  /// `Cancel`
  String get cancel {
    return Intl.message('Cancel', name: 'cancel', desc: '', args: []);
  }

  /// `Yes, Delete`
  String get yes_delete {
    return Intl.message('Yes, Delete', name: 'yes_delete', desc: '', args: []);
  }

  /// `Language`
  String get language {
    return Intl.message('Language', name: 'language', desc: '', args: []);
  }

  /// `Select Language`
  String get select_language {
    return Intl.message(
      'Select Language',
      name: 'select_language',
      desc: '',
      args: [],
    );
  }

  /// `English`
  String get english {
    return Intl.message('English', name: 'english', desc: '', args: []);
  }

  /// `Arabic`
  String get arabic {
    return Intl.message('Arabic', name: 'arabic', desc: '', args: []);
  }

  /// `Country Code`
  String get country_code {
    return Intl.message(
      'Country Code',
      name: 'country_code',
      desc: '',
      args: [],
    );
  }

  /// `Select country code`
  String get select_country_code {
    return Intl.message(
      'Select country code',
      name: 'select_country_code',
      desc: '',
      args: [],
    );
  }

  /// `Preferences`
  String get preferences {
    return Intl.message('Preferences', name: 'preferences', desc: '', args: []);
  }

  /// `Dark Mode`
  String get dark_mode {
    return Intl.message('Dark Mode', name: 'dark_mode', desc: '', args: []);
  }

  /// `Save Recent Numbers`
  String get save_recent_numbers {
    return Intl.message(
      'Save Recent Numbers',
      name: 'save_recent_numbers',
      desc: '',
      args: [],
    );
  }

  /// `Chat started`
  String get chat_started {
    return Intl.message(
      'Chat started',
      name: 'chat_started',
      desc: '',
      args: [],
    );
  }

  /// `Failed to launch WhatsApp`
  String get whatsapp_launch_failed {
    return Intl.message(
      'Failed to launch WhatsApp',
      name: 'whatsapp_launch_failed',
      desc: '',
      args: [],
    );
  }

  /// `Long press to edit`
  String get long_press_to_edit {
    return Intl.message(
      'Long press to edit',
      name: 'long_press_to_edit',
      desc: '',
      args: [],
    );
  }

  /// `Start Chat`
  String get start_chat {
    return Intl.message('Start Chat', name: 'start_chat', desc: '', args: []);
  }

  /// `Clipboard`
  String get clipboard {
    return Intl.message('Clipboard', name: 'clipboard', desc: '', args: []);
  }

  /// `Enter your message (optional)`
  String get message_hint_optional {
    return Intl.message(
      'Enter your message (optional)',
      name: 'message_hint_optional',
      desc: '',
      args: [],
    );
  }

  /// `Phone Number`
  String get hint_phone_number {
    return Intl.message(
      'Phone Number',
      name: 'hint_phone_number',
      desc: '',
      args: [],
    );
  }

  /// `No Message`
  String get no_message {
    return Intl.message('No Message', name: 'no_message', desc: '', args: []);
  }

  /// `Message:`
  String get message_prefix {
    return Intl.message('Message:', name: 'message_prefix', desc: '', args: []);
  }

  /// `Invalid Phone Number`
  String get error_invalid_phone {
    return Intl.message(
      'Invalid Phone Number',
      name: 'error_invalid_phone',
      desc: '',
      args: [],
    );
  }

  /// `Recent Numbers`
  String get recent_numbers {
    return Intl.message(
      'Recent Numbers',
      name: 'recent_numbers',
      desc: '',
      args: [],
    );
  }

  /// `View All`
  String get view_all {
    return Intl.message('View All', name: 'view_all', desc: '', args: []);
  }

  /// `Home`
  String get home {
    return Intl.message('Home', name: 'home', desc: '', args: []);
  }

  /// `History`
  String get history {
    return Intl.message('History', name: 'history', desc: '', args: []);
  }

  /// `Settings`
  String get settings {
    return Intl.message('Settings', name: 'settings', desc: '', args: []);
  }

  /// `Saved Message`
  String get saved_message {
    return Intl.message(
      'Saved Message',
      name: 'saved_message',
      desc: '',
      args: [],
    );
  }

  /// `Enter your message`
  String get enter_message {
    return Intl.message(
      'Enter your message',
      name: 'enter_message',
      desc: '',
      args: [],
    );
  }

  /// `This is a message you can insert manually when chatting by tapping the message icon.`
  String get saved_message_hint {
    return Intl.message(
      'This is a message you can insert manually when chatting by tapping the message icon.',
      name: 'saved_message_hint',
      desc: '',
      args: [],
    );
  }

  /// `No saved message found. Set it in Settings.`
  String get saved_message_empty {
    return Intl.message(
      'No saved message found. Set it in Settings.',
      name: 'saved_message_empty',
      desc: '',
      args: [],
    );
  }

  /// `Saved message added`
  String get message_added {
    return Intl.message(
      'Saved message added',
      name: 'message_added',
      desc: '',
      args: [],
    );
  }
}

class AppLocalizationDelegate extends LocalizationsDelegate<S> {
  const AppLocalizationDelegate();

  List<Locale> get supportedLocales {
    return const <Locale>[
      Locale.fromSubtags(languageCode: 'en'),
      Locale.fromSubtags(languageCode: 'ar'),
    ];
  }

  @override
  bool isSupported(Locale locale) => _isSupported(locale);
  @override
  Future<S> load(Locale locale) => S.load(locale);
  @override
  bool shouldReload(AppLocalizationDelegate old) => false;

  bool _isSupported(Locale locale) {
    for (var supportedLocale in supportedLocales) {
      if (supportedLocale.languageCode == locale.languageCode) {
        return true;
      }
    }
    return false;
  }
}
