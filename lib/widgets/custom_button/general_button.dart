import 'package:flutter/material.dart';

import '../../core/utils/dimensions.dart';

class GeneralButton extends StatefulWidget {
  final Color btnColor;
  final double? width;
  final double? height;
  final double? borderRadius;
  final BoxBorder? boxBorder;
  final Color? hoverColor;
  final Color? pressedColor;
  final Widget child;
  final void Function()? onTap;

  const GeneralButton({
    super.key,
    required this.btnColor,
    this.width,
    this.height,
    this.borderRadius,
    this.boxBorder,
    this.hoverColor,
    this.pressedColor,
    required this.child,
    this.onTap,
  });

  @override
  State<GeneralButton> createState() => _GeneralButtonState();
}

class _GeneralButtonState extends State<GeneralButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 100),
      lowerBound: 0.95,
      upperBound: 1.0,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => _controller.reverse(),
      onTapUp: (_) {
        _controller.forward();
        if (widget.onTap != null) widget.onTap!();
      },
      onTapCancel: () => _controller.forward(),
      child: ScaleTransition(
        scale: _controller,
        child: Container(
          width: widget.width ?? Dimensions.screenWidth * 0.5,
          height: widget.height ?? 50,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: widget.btnColor,
            borderRadius: BorderRadius.circular(widget.borderRadius ?? 24),
            border: widget.boxBorder,
            boxShadow: const [
              BoxShadow(
                color: Colors.black12,
                offset: Offset(4, 4),
                blurRadius: 10,
              ),
              BoxShadow(
                color: Colors.white,
                offset: Offset(-4, -4),
                blurRadius: 10,
              ),
            ],
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(widget.borderRadius ?? 24),
              splashColor: widget.pressedColor?.withOpacity(0.5) ?? Colors.black12,
              hoverColor: widget.hoverColor ?? Colors.black.withOpacity(0.05),
              onTap: widget.onTap,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                child: widget.child,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
