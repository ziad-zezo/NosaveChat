import 'package:flutter/material.dart';
import 'package:quick_chat/helper_files/default_values.dart';

class MessageTextField extends StatelessWidget {
  const MessageTextField({
    super.key,
    required this.messageController,
    required this.messageFocusNode,
    required this.suffixIcon,
  });
  final TextEditingController messageController;
  final FocusNode messageFocusNode;
  final Widget suffixIcon;
  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: messageController,
      focusNode: messageFocusNode,
      keyboardType: TextInputType.multiline,
      textInputAction: TextInputAction.newline,
      maxLines: 2,
      style: TextStyle(fontSize: 18),
      decoration: InputDecoration(
        hint: Text(
          "Enter your message (optional)",
          style: TextStyle(color: Colors.grey[500], fontSize: 17),
        ),
        hintStyle: TextStyle(color: Colors.grey[500]),
        suffixIcon: suffixIcon,
        contentPadding: const EdgeInsets.all(defaultPadding / 1.5),
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
          borderSide: BorderSide(color: Colors.green),
        ),
        filled: true,
        fillColor: Color(0x0b008000),
      ),
      autofillHints: ["ziad", "mohamed"],
    );
  }
}
