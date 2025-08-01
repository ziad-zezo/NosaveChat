import 'package:flutter/material.dart';
import 'package:quick_chat/generated/l10n.dart';
import 'package:quick_chat/widgets/section_header.dart';

class RecentNumbersSectionHeader extends StatelessWidget {
  const RecentNumbersSectionHeader({super.key, required this.onTap});

final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
   return SectionHeader(
     title: S.of(context).recent_numbers,
     trailing: Padding(
       padding: const EdgeInsets.symmetric(horizontal: 8.0),
       child: InkWell(
         onTap:onTap,
         child:  Text(
           S.of(context).view_all,
           style: const TextStyle(
             fontSize: 14,
             color: Colors.green,
             fontWeight: FontWeight.bold,
           ),
         ),
       ),
     ),
   );
  }
}
