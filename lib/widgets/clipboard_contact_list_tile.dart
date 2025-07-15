import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';


class ClipboardContactListTile extends StatelessWidget {
  const ClipboardContactListTile({super.key, required this.phoneNumber, this.onTap, this.onLongPress});
  final String phoneNumber;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;
  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      onLongPress:onLongPress,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
        side:const BorderSide(color: Colors.green),
      ),
      leading:const Icon(FontAwesomeIcons.whatsapp, color: Colors.green, size: 30),
      title: Text(
        phoneNumber,
        style:const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ),
      subtitle: Text("Long Press To Edit",style: Theme.of(context).textTheme.bodySmall!.copyWith(color: Colors.grey),),
      trailing: const Text(
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
