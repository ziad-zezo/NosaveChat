import 'package:country_picker/country_picker.dart' as cp;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl_phone_field/countries.dart' as intl;
import 'package:quick_chat/generated/l10n.dart';
import 'package:quick_chat/helper_files/boxes.dart';
import 'package:quick_chat/helper_files/default_values.dart';
import 'package:quick_chat/helper_files/settings_helper.dart';
import 'package:quick_chat/widgets/custom_tooltip.dart';
import 'package:quick_chat/widgets/gap.dart';
import 'package:quick_chat/widgets/section_header.dart';
import 'package:quick_chat/widgets/settings_list_tile.dart';
import 'package:restart_app/restart_app.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key, required this.toggleTheme});
  final VoidCallback toggleTheme;
  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  late bool _saveRecentNumbersSwitch;
  late String _language;
  late String _languageCode;
  late String _country;
  bool _isLoading = true;
  final messageFocusNode = FocusNode();
  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  void _loadSettings() async {
    _isLoading = true;

    //*load language settings
    _languageCode = await SettingsHelper.loadLocale().then(
      (value) => value!.languageCode,
    );
    _language = _languageCode.toLowerCase() == 'en' ? 'English' : 'العربية';

    //*load country settings
    _country = _getCountryString();
    //*load save recent numbers settings
    _saveRecentNumbersSwitch = await SettingsHelper.loadSaveRecentNumbers();
    _isLoading = false;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return _isLoading
        ? const Center(child: CircularProgressIndicator())
        : Padding(
            padding: const EdgeInsets.symmetric(horizontal: defaultPadding),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  SectionHeader(title: S.of(context).language),
                  const VerticalGap(gap: 10),
                  SettingsListTile(
                    title: _language,
                    onTap: _showLanguagePickerDialog,
                  ),
                  const VerticalGap(gap: 20),
                  SectionHeader(title: S.of(context).country_code),
                  const VerticalGap(gap: 10),
                  ListTile(
                    onTap: () {
                      cp.showCountryPicker(
                        context: context,
                        showPhoneCode: true,
                        onSelect: (country) async {
                          userSettings = userSettings.copyWith(
                            countryCode: country.countryCode,
                          );
                          await settingsBox.put('user_settings', userSettings);
                          _loadSettings();
                          _restartApp();
                        },
                      );
                    },
                    title: Text(_country),
                    trailing: const Icon(Icons.arrow_forward_ios),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                      side: const BorderSide(color: Colors.green),
                    ),
                  ),
                  const VerticalGap(gap: 20),
                  SectionHeader(title: S.of(context).preferences),
                  const VerticalGap(gap: 10),
                  //default message

                  //Dark mode Enable Switch
                  SwitchListTile(
                    value: Theme.of(context).brightness == Brightness.dark,
                    onChanged: (enabled) async {
                      widget.toggleTheme();
                      setState(() {});
                    },
                    title: Text(S.of(context).dark_mode),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                      side: const BorderSide(color: Colors.green),
                    ),
                    enableFeedback: true,
                    activeColor: Colors.green,
                  ),
                  const VerticalGap(gap: 10),
                  //History Enable Switch
                  SwitchListTile(
                    value: _saveRecentNumbersSwitch,
                    onChanged: (enabled) async {
                      userSettings = userSettings.copyWith(
                        saveRecentNumber: enabled,
                      );
                      await settingsBox.put('user_settings', userSettings);
                      _loadSettings();
                    },

                    title: Text(S.of(context).save_recent_numbers),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                      side: const BorderSide(color: Colors.green),
                    ),
                    enableFeedback: true,
                    activeColor: Colors.green,
                  ),
                  const VerticalGap(gap: 20),
                  SectionHeader(
                    title: S.of(context).saved_message,
                    trailing: Tooltip(
                      message: S.of(context).saved_message_hint,
                      preferBelow: false,
                      margin: const EdgeInsets.all(8),
                      enableFeedback: true,
                      showDuration: const Duration(seconds: 3),
                      triggerMode: TooltipTriggerMode.tap,
                      child: Icon(Icons.info),
                    ),
                  ),
                  const VerticalGap(gap: 10),
                  //saved message
                  TextFormField(
                    focusNode: messageFocusNode,
                    initialValue: userSettings.savedMessage ?? '',
                    keyboardType: TextInputType.multiline,
                    textInputAction: TextInputAction.newline,
                    maxLines: 2,
                    maxLength: 120,
                    maxLengthEnforcement: MaxLengthEnforcement.enforced,
                    style: const TextStyle(fontSize: 18),
                    decoration: InputDecoration(
                      labelText: S.of(context).enter_message,
                      hint: Text(
                        S.of(context).enter_message,
                        style: TextStyle(color: Colors.grey[500], fontSize: 17),
                      ),
                      hintStyle: TextStyle(color: Colors.grey[500]),
                      contentPadding: const EdgeInsets.all(
                        defaultPadding / 1.5,
                      ),
                      filled: true,
                      fillColor: const Color(0x0b008000),
                      suffixIcon: const Icon(Icons.message_outlined),
                    ),
                    onChanged: (value) async {
                      userSettings = userSettings.copyWith(
                        savedMessage: value.trim(),
                      );
                      await settingsBox.put('user_settings', userSettings);
                    },
                    onTapOutside: (p) {
                      messageFocusNode.unfocus();
                    },
                  ),
                ],
              ),
            ),
          );
  }

  void _restartApp() async {
    await Restart.restartApp();
  }

  void _showLanguagePickerDialog() {
    showDialog(
      context: context,
      barrierColor: Colors.black87,
      animationStyle: const AnimationStyle(
        duration: Duration(milliseconds: 300),
        curve: Curves.decelerate,
      ),
      builder: (BuildContext context) {
        return SimpleDialog(
          contentPadding: const EdgeInsets.all(defaultPadding),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          title: Text(S.of(context).select_language),
          children: <Widget>[
            SimpleDialogOption(
              onPressed: () async {
                if (_languageCode != 'en') {
                  // Update app locale to English
                  _changeLanguage('en');
                }
                if (!context.mounted) return;
                Navigator.pop(context);
              },
              padding: const EdgeInsets.all(defaultPadding),
              child: Text(S.of(context).english),
            ),
            SimpleDialogOption(
              onPressed: () async {
                if (_languageCode != 'ar') {
                  // Update app locale to Arabic
                  _changeLanguage('ar');
                }
                if (!context.mounted) return;
                Navigator.pop(context);
              },
              padding: const EdgeInsets.all(defaultPadding),
              child: Text(S.of(context).arabic),
            ),
          ],
        );
      },
    );
  }

  String _getCountryString() {
    try {
      final c = intl.countries.firstWhere(
        (country) => country.code == userSettings.countryCode.toUpperCase(),
      );
      return '${c.name} (+${c.dialCode})';
    } catch (e) {
      return S.of(context).select_country_code;
    }
  }

  Future<void> _changeLanguage(String languageCode) async {
    await SettingsHelper.saveLocale(Locale(languageCode));
    _loadSettings();
    _restartApp();
    // setState(() {});
  }
}
