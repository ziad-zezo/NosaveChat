import 'package:flutter/material.dart';
import 'package:quick_chat/widgets/section_header.dart';

import 'clipboard_contact_list_tile.dart';
import 'gap.dart';

class ClipboardContainer extends StatelessWidget {
  const ClipboardContainer({super.key, required this.phoneNumber, this.onTap, this.onLongPress, required this.trailing});
final String phoneNumber;
final VoidCallback? onTap;
final VoidCallback? onLongPress;
final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SectionHeader(title: "Clipboard",trailing: trailing,),
        VerticalGap(gap: 20),
        ClipboardContactListTile(phoneNumber: phoneNumber,onTap: onTap,onLongPress: onLongPress,),
        VerticalGap(gap: 30),
      ],
    );
  }
}
