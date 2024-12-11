import 'package:flutter/material.dart';
import 'package:utility_token_app/core/constants/color_constants.dart';

class CustomButton extends StatefulWidget {
  final String text;
  final VoidCallback onPressed;
  final String variant;
  final bool isLoading;
  final bool outline;

  const CustomButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.variant = 'primary',
    this.isLoading = false,
    this.outline = false,
  });

  @override
  State<CustomButton> createState() => _CustomButtonState();
}

class _CustomButtonState extends State<CustomButton> {
  Map<String, Map<String, Color>> variants = {
    'primary': {
      'background': Pallete.primary,
      'text': Colors.white,
    },
    'secondary': {
      'background': Pallete.secondary,
      'text': Colors.white,
    },
    'link': {
      'background': Colors.white,
      'text': Pallete.secondary,
    },
    'danger': {
      'background':Colors.redAccent,
      'text': Colors.white,
    },
  };

  double borderWidth = 4;

  @override
  Widget build(BuildContext context) {
    final variantColors = variants[widget.variant] ?? variants['primary']!;

    return InkWell(
      splashColor: Colors.transparent,
      onTap: widget.isLoading ? null : widget.onPressed,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 18, vertical: 10),
        decoration: BoxDecoration(
          color: variantColors['background'],
          borderRadius: BorderRadius.circular(14),
          border: widget.outline
              ? Border(
            bottom: BorderSide(
              color: variantColors['border']!,
              width: widget.isLoading ? 0 : borderWidth,
            ),
            top: BorderSide(
              color: variantColors['border']!,
              width: 2,
            ),
            left: BorderSide(
              color: variantColors['border']!,
              width: 2,
            ),
            right: BorderSide(
              color: variantColors['border']!,
              width: 2,
            ),
          )
              : null,
        ),
        child: widget.isLoading
            ? const Center(
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
          ),
        )
            : Text(
          widget.text.toUpperCase(),
          textAlign: TextAlign.center,
          style: TextStyle(
            color: variantColors['text'],
            fontSize: 12,
            letterSpacing: 1,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
