import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  const CustomButton({super.key, required this.onPressed});

final GestureTapCallback onPressed;

  @override
  Widget build(BuildContext context) {
  return    InkWell(
   onTap: onPressed,
    child: Container(
      width: double.infinity,
      alignment: Alignment.center,
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
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
