import 'package:flutter/material.dart';

import '../../core/constants/color_constants.dart';


class CustomTextField extends StatelessWidget {
  final Color? fillColor;
  final bool? filled;
  final Color? focusedBoarderColor;
  final Color? defaultBoarderColor;
  final TextEditingController? controller;
  final String? labelText;
  final void Function(String?)? onChanged;
  final void Function(String?)? onSubmitted;
  final bool? obscureText;
  final TextStyle? labelStyle;
  final TextStyle? inputTextStyle;
  final TextInputType? keyBoardType;
  final Icon? prefixIcon;
  final int? maxLength;
  final Widget? suffixIconButton;
  final bool? enabled;
  final bool? readOnly;
  final double? borderRadius;

  const CustomTextField({super.key, this.maxLength, this.readOnly, this.controller, this.fillColor, this.filled, this.defaultBoarderColor, this.focusedBoarderColor, required this.labelText, this.labelStyle, this.inputTextStyle, this.keyBoardType, required this.prefixIcon, this.obscureText, this.suffixIconButton, this.enabled, this.onChanged, this.onSubmitted, this.borderRadius});

  @override
  Widget build(BuildContext context) {
    return TextField(
      maxLength: maxLength,
      keyboardType: keyBoardType ?? TextInputType.text,
      obscureText: obscureText ?? false,
      controller: controller,
      onChanged: onChanged,
      readOnly: readOnly ?? false,
      onSubmitted: onSubmitted,
      enabled: enabled ?? true,
      decoration: InputDecoration(
        fillColor: fillColor,
        filled: filled ?? false,
        counterText: '',
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        prefixIcon: prefixIcon,
        suffixIcon: suffixIconButton,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(borderRadius ?? 10.0),
          borderSide: BorderSide(color: defaultBoarderColor ?? Colors.grey),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(borderRadius ?? 10.0),
          borderSide: BorderSide(color: defaultBoarderColor ?? Colors.grey),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(borderRadius ?? 10.0),
          borderSide: BorderSide(color: focusedBoarderColor ?? Pallete.primary),
        ),

        labelText: labelText ?? '',
        labelStyle: labelStyle ?? const TextStyle(
          color: Colors.grey,
          fontSize: 12
        ),
      ),
      style: inputTextStyle ??  const TextStyle(
          color: Pallete.primary,
          fontSize: 12
      ),

    );
  }
}