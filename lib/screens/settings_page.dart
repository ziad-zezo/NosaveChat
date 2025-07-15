import 'package:flutter/material.dart';
import 'package:intl_phone_field/countries.dart' as intl;
import 'package:quick_chat/helper_files/boxes.dart';
import 'package:quick_chat/helper_files/settings_helper.dart';
import 'package:quick_chat/widgets/section_header.dart';
import 'package:quick_chat/widgets/settings_list_tile.dart';
import 'package:restart_app/restart_app.dart';
import '../helper_files/default_values.dart';
import '../widgets/gap.dart';
import 'package:country_picker/country_picker.dart' as cp;

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
    _language = _languageCode.toLowerCase() == 'en' ? "English" : "العربية";

    //*load country settings
    _country = _getCountryString();
    //*load save recent numbers settings
    _saveRecentNumbersSwitch = await SettingsHelper.loadSaveRecentNumbers();
    //*load dark mode settings
    _isLoading = false;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return _isLoading
        ? Center(child: CircularProgressIndicator())
        : Padding(
            padding: const EdgeInsets.symmetric(horizontal: defaultPadding),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  SectionHeader(title: "Language"),
                  VerticalGap(gap: 10),
                  SettingsListTile(
                    title: _language,
                    onTap: _showLanguagePickerDialog,
                  ),
                  VerticalGap(gap: 20),
                  SectionHeader(title: "Country Code"),
                  VerticalGap(gap: 10),
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
                    trailing: Icon(Icons.arrow_forward_ios),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                      side: BorderSide(color: Colors.green),
                    ),
                  ),
                  VerticalGap(gap: 20),
                  SectionHeader(title: "Preferences"),
                  VerticalGap(gap: 10),

                  //Dark mode Enable Switch
                  SwitchListTile(
                    value: Theme.of(context).brightness == Brightness.dark,
                    onChanged: (enabled) async {
                      widget.toggleTheme();
                      setState(() {});
                    },
                    title: Text(" Dark Mode"),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                      side: BorderSide(color: Colors.green),
                    ),
                    enableFeedback: true,
                    activeColor: Colors.green,
                  ),
                  VerticalGap(gap: 10),
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

                    title: Text("Save Recent Numbers"),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                      side: BorderSide(color: Colors.green),
                    ),
                    enableFeedback: true,
                    activeColor: Colors.green,
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
      animationStyle: AnimationStyle(
        duration: Duration(milliseconds: 300),
        curve: Curves.decelerate,
      ),
      builder: (BuildContext context) {
        return SimpleDialog(
          contentPadding: EdgeInsets.all(defaultPadding),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          title: const Text('Select Language'),
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
              padding: EdgeInsets.all(defaultPadding),
              child: const Text('English'),
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
              padding: EdgeInsets.all(defaultPadding),
              child: const Text('العربية'),
            ),
          ],
        );
      },
    );
  }

  String _getCountryString() {
    final c = intl.countries.firstWhere(
      (country) => country.code == userSettings.countryCode.toUpperCase(),
    );
    return "${c.name} (+${c.dialCode})";
  }

  Future<void> _changeLanguage(String languageCode) async {
    await SettingsHelper.saveLocale(Locale(languageCode));
    _loadSettings();
    _restartApp();
    // setState(() {});
  }
}
