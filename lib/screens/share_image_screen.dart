import 'package:flutter/material.dart';

class ShareImageScreen extends StatelessWidget {
final String text;

  const ShareImageScreen({super.key, required this.text});
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      body: Center(child:Text(text,style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold, color: Colors.red))),
    );
  }
}
