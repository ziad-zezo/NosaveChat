import 'package:flutter/material.dart';

class SettingsListTile extends StatelessWidget {
  const SettingsListTile({super.key, required this.title, required this.onTap});

 final String title;
 final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return   ListTile(
      onTap: onTap,
      title: Text(title),
      trailing: Icon(Icons.arrow_forward_ios),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
        side: BorderSide(color: Colors.green),

      ),
    );
  }
}
