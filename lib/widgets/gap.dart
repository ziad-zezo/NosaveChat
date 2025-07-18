import 'package:flutter/material.dart';

class VerticalGap extends StatelessWidget {

  const VerticalGap({super.key, required this.gap});
  final double gap;
  @override
  Widget build(BuildContext context) {
    return SizedBox(height: gap);
  }
}

class HorizontalGap extends StatelessWidget {

  const HorizontalGap({super.key, required this.gap});
  final double gap;
  @override
  Widget build(BuildContext context) {
    return SizedBox(width: gap);
  }
}
