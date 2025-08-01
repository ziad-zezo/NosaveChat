import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:quick_chat/generated/l10n.dart';
import 'package:quick_chat/helper_files/default_values.dart';

class MessageTextField extends StatelessWidget {
  const MessageTextField({
    super.key,
    required this.messageController,
    required this.messageFocusNode,
    required this.suffixIcon, this.onChanged,

  });
  final TextEditingController messageController;
  final FocusNode messageFocusNode;
  final Widget suffixIcon;

  final void Function(String)? onChanged;
  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: messageController,
      focusNode: messageFocusNode,
      keyboardType: TextInputType.multiline,
      textInputAction: TextInputAction.newline,
      maxLines: 2,
      maxLength: 120,
      maxLengthEnforcement: MaxLengthEnforcement.enforced,
      style:  const TextStyle(fontSize: 18),
      decoration: InputDecoration(
        hint: Text(
          S.of(context).message_hint_optional,
          style: TextStyle(color: Colors.grey[500], fontSize: 17),
        ),
        hintStyle: TextStyle(color: Colors.grey[500]),
        suffixIcon: suffixIcon,
        contentPadding: const EdgeInsets.all(defaultPadding / 1.5),

        filled: true,
        fillColor: const Color(0x0b008000),
      ),
      onChanged: onChanged,
    );
  }
}
