import 'package:flutter/material.dart';

class VerticalGap extends StatelessWidget {
  final double gap;

  const VerticalGap({super.key, required this.gap});
  @override
  Widget build(BuildContext context) {
    return SizedBox(height: gap);
  }
}

class HorizontalGap extends StatelessWidget {
  final double gap;

  const HorizontalGap({super.key, required this.gap});
  @override
  Widget build(BuildContext context) {
    return SizedBox(width: gap);
  }
}
