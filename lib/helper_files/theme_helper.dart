import 'package:flutter/material.dart';

class ThemeHelper{
static ThemeData getThemeDate({Brightness brightness = Brightness.light}){
  return ThemeData(
    brightness: brightness,
    inputDecorationTheme: InputDecorationTheme(
      errorStyle: TextStyle(color: Colors.red.shade300),
      // When the field has an error and is **not focused**
      errorBorder:  OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Colors.red),
      ),
      // When the field has an error and **is focused**
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Colors.red),
      ),
      // Optional: control default enabled border
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Colors.grey),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Colors.grey),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Colors.green),
      ),
    ),
  );
}
}