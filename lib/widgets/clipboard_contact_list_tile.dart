import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'gap.dart';

class Clipboard_section extends StatelessWidget {
  const Clipboard_section({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Container(
          width: double.infinity,
          alignment: Alignment.centerLeft,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [Text("Clipboard", style: TextStyle(fontSize: 20))],
          ),
        ),

      ],
    );
  }
}

class ClipboardContactListTile extends StatelessWidget {
  const ClipboardContactListTile({super.key});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () {},
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
        side: BorderSide(color: Colors.grey[400]!),
      ),

      trailing: Container(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: BoxDecoration(
          color: Colors.green,

          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(FontAwesomeIcons.whatsapp, color: Colors.white, size: 30),
      ),

      title: Text("+201554083601", style: TextStyle(fontSize: 16)),
      subtitle: Text(
        "Start Chat",
        style: TextStyle(
          fontSize: 14,
          color: Colors.green,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
