import 'package:flutter/material.dart';

class CustomSnackBar {
  static void showErrorSnackBar(
    BuildContext context, {
    required String message,
    IconData? icon,
  }) {
    ScaffoldMessenger.of(context).showSnackBar(
      snackBar(
        context: context,
        message: message,
        color: Colors.red,
        icon: icon??Icons.report_problem_outlined,
      ),
    );
  }

  static void showWarningSnackBar() {}
  static void showInfoSnackBar(
    BuildContext context, {
    required String message,
    IconData? icon,
  }) {
    ScaffoldMessenger.of(context).showSnackBar(
      snackBar(
        context: context,
        message: message,
        color: Colors.grey,
        icon: icon??Icons.info,
      ),
    );
  }

  static void showSuccessSnackBar(
    BuildContext context, {
    required String message,
    IconData? icon,
  }) {
    ScaffoldMessenger.of(context).showSnackBar(
      snackBar(
        context: context,
        message: message,
        color: Colors.green,
        icon: icon??Icons.check_circle,
      ),
    );
  }

  static SnackBar snackBar({
    required BuildContext context,
    required String message,
    required IconData icon,
    required Color color,
  }) {
    return SnackBar(
      duration: const Duration(milliseconds: 2500),
      elevation: 0,
      dismissDirection: DismissDirection.horizontal,
      behavior: SnackBarBehavior.floating,
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 20),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
        side: BorderSide(color: color, width: 2),
      ),
      backgroundColor: Colors.black87,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 20),
      content: Row(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Icon(icon, color: color, size: 26),
          ),
          Text(
            message,
            style: const TextStyle(
              color: Colors.white,
              letterSpacing: 1.25,
              fontWeight: FontWeight.bold,
              fontSize: 15,
            ),
          ),
        ],
      ),
    );
  }
}
