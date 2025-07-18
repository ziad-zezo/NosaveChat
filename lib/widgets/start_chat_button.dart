import 'package:flutter/material.dart';

class StartChatButton extends StatelessWidget {
  const StartChatButton({super.key, required this.onPressed});

final GestureTapCallback onPressed;

  @override
  Widget build(BuildContext context) {
  return InkWell(
    customBorder: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
    onTap: onPressed,
    child: Container(
      width: double.infinity,
      alignment: Alignment.center,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: BoxDecoration(
       color: Colors.green,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Text(
        "Start Chat",
        style: TextStyle(fontSize: 16, color: Colors.black),
      ),
    ),
  );
  }
}
