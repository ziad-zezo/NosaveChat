import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:quick_chat/widgets/recent_numbers_list_tile.dart';
import 'package:quick_chat/widgets/section_header.dart';
import 'package:quick_chat/widgets/settings_list_tile.dart';
import 'package:restart_app/restart_app.dart';
//import 'package:shared_preferences/shared_preferences.dart';

import '../defalut_values.dart';
import '../widgets/gap.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {

  bool _darkModeSwitch = false;


  @override
  void initState() {
    super.initState();

_loadSettings();
  }

  void _loadSettings() async {
   // SharedPreferences prefs=await SharedPreferences.getInstance();
  }
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: defaultPadding),
      child: SingleChildScrollView(
        child: Column(
          children: [
            SectionHeader(title: "Language"),
            VerticalGap(gap: 10),
         SettingsListTile(title: "English", onTap: (){
           showDialog(context: context, builder: (context){
             return AlertDialog();
           });

         }),
            VerticalGap(gap: 20),
            SectionHeader(title: "Country Code"),
            VerticalGap(gap: 10),
            ListTile(
              onTap: () {},
              title: Text("Egypt (+20)"),
              trailing: Icon(Icons.arrow_forward_ios),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
                side: BorderSide(color: Colors.green),
        
              ),
            ),
            VerticalGap(gap: 20),
            SectionHeader(title: "Preferences"),
            VerticalGap(gap: 10),
        
            SwitchListTile(
              value: _darkModeSwitch,
              onChanged: (v) {
                _darkModeSwitch=v;
                setState(() {
        
                });
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
            SwitchListTile(
              value: _darkModeSwitch,
              onChanged: (v) {
                _darkModeSwitch=v;
                setState(() {
        
                });
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
    //RestartWidget.restartApp(context);
  }
}
