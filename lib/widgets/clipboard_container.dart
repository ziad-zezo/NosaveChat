import 'package:flutter/material.dart';
import 'package:quick_chat/generated/l10n.dart';
import 'package:quick_chat/widgets/clipboard_contact_list_tile.dart';
import 'package:quick_chat/widgets/gap.dart';
import 'package:quick_chat/widgets/section_header.dart';

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
        SectionHeader(title: S.of(context).clipboard,trailing: trailing,),
        const VerticalGap(gap: 20),
        ClipboardContactListTile(phoneNumber: phoneNumber,onTap: onTap,onLongPress: onLongPress,),
        const VerticalGap(gap: 30),
      ],
    );
  }
}
