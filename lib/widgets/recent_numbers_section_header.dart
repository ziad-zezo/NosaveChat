import 'package:flutter/material.dart';
import 'package:quick_chat/widgets/section_header.dart';

class RecentNumbersSectionHeader extends StatelessWidget {
  const RecentNumbersSectionHeader({super.key, required this.onTap});

final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
   return SectionHeader(
     title: "Recent Numbers",
     trailing: Padding(
       padding: const EdgeInsets.symmetric(horizontal: 8.0),
       child: InkWell(
         onTap:onTap,
         child: Text(
           "View All",
           style: TextStyle(
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
