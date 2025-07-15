import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CustomTooltip extends StatefulWidget {
  final Widget child;
  final Widget message;
  final Duration showDuration;
  final TextStyle? textStyle;
  final Color backgroundColor;
  final EdgeInsets padding;
  final double borderRadius;
  final TooltipTriggerMode triggerMode; // hover, tap, longPress

  const CustomTooltip({
    super.key,
    required this.child,
    required this.message,
    this.showDuration = const Duration(seconds: 2),
    this.textStyle,
    this.backgroundColor = Colors.black87,
    this.padding = const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
    this.borderRadius = 8,
    this.triggerMode = TooltipTriggerMode.longPress,
  });

  @override
  State<CustomTooltip> createState() => _CustomTooltipState();
}

class _CustomTooltipState extends State<CustomTooltip> {
  final LayerLink _layerLink = LayerLink();
  OverlayEntry? _overlayEntry;

  void _showOverlay() {
    if (_overlayEntry != null) return;
    HapticFeedback.mediumImpact();
    final renderBox = context.findRenderObject() as RenderBox;
    final size = renderBox.size;

    _overlayEntry = OverlayEntry(
      builder: (context) => Positioned.fill(
        child: Stack(
          children: [
            CompositedTransformFollower(
              link: _layerLink,
              showWhenUnlinked: false,
              offset: Offset(size.width*0.4, -size.height*0.25), // ⬅️ Vertical offset above the child
              child: Material(
                color: Colors.transparent,
                child: Container(
                  padding: widget.padding,
                  decoration: BoxDecoration(
                    color: widget.backgroundColor,
                    borderRadius: BorderRadius.circular(widget.borderRadius),
                  ),
                  child: widget.message
                ),
              ),
            ),
          ],
        ),
      ),
    );


    Overlay.of(context).insert(_overlayEntry!);

    Future.delayed(widget.showDuration, _hideOverlay);
  }

  void _hideOverlay() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  void _handleTrigger() {
    _showOverlay();
  }

  @override
  Widget build(BuildContext context) {
    Widget trigger = GestureDetector(
      onTap: widget.triggerMode == TooltipTriggerMode.tap ? _handleTrigger : null,
      onLongPress: widget.triggerMode == TooltipTriggerMode.longPress ? _handleTrigger : null,
      child: CompositedTransformTarget(
        link: _layerLink,
        child: widget.child,
      ),
    );

    return trigger;
  }
}
