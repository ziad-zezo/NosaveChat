import 'package:flutter/material.dart';

class SectionHeader extends StatelessWidget {
  const SectionHeader({super.key, required this.title, this.trailing});

final String title;
final Widget? trailing;
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      alignment: Alignment.centerLeft,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [Expanded(child: Text(title, style: const TextStyle(fontSize: 20),overflow: TextOverflow.clip,)),?trailing],
      ),
    );
  }
}
