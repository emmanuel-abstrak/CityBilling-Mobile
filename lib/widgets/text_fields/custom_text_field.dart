import 'package:flutter/material.dart';
import '../../core/constants/color_constants.dart';

class CustomTextField extends StatefulWidget {
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
  final FocusNode? focusNode; // Nullable focusNode property

  const CustomTextField({
    super.key,
    this.maxLength,
    this.readOnly,
    this.controller,
    this.fillColor,
    this.filled,
    this.defaultBoarderColor,
    this.focusedBoarderColor,
    required this.labelText,
    this.labelStyle,
    this.inputTextStyle,
    this.keyBoardType,
    required this.prefixIcon,
    this.obscureText,
    this.suffixIconButton,
    this.enabled,
    this.onChanged,
    this.onSubmitted,
    this.borderRadius,
    this.focusNode, // Add focusNode to constructor
  });

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  late FocusNode _internalFocusNode;

  @override
  void initState() {
    super.initState();
    // Use the provided focusNode or create an internal one
    _internalFocusNode = widget.focusNode ?? FocusNode();
  }

  @override
  void dispose() {
    // Dispose the internal focusNode only if it was created internally
    if (widget.focusNode == null) {
      _internalFocusNode.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Unfocus the text field when tapping outside to close the keyboard
        FocusScope.of(context).requestFocus(FocusNode());
      },
      child: TextField(
        maxLength: widget.maxLength,
        keyboardType: widget.keyBoardType ?? TextInputType.text,
        obscureText: widget.obscureText ?? false,
        controller: widget.controller,
        onChanged: widget.onChanged,
        readOnly: widget.readOnly ?? false,
        onSubmitted: widget.onSubmitted,
        enabled: widget.enabled ?? true,
        focusNode: _internalFocusNode, // Use the internal or external focusNode
        decoration: InputDecoration(
          fillColor: widget.fillColor,
          filled: widget.filled ?? false,
          counterText: '',
          contentPadding: const EdgeInsets.all(16),
          prefixIcon: widget.prefixIcon,
          suffixIcon: widget.suffixIconButton,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(widget.borderRadius ?? 20,),
            borderSide: BorderSide(color: widget.defaultBoarderColor ?? Colors.grey),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(widget.borderRadius ?? 20.0),
            borderSide: BorderSide(color: widget.defaultBoarderColor ?? Colors.grey),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(widget.borderRadius ?? 20.0),
            borderSide: BorderSide(color: widget.focusedBoarderColor ?? Pallete.primary),
          ),
          labelText: widget.labelText ?? '',
          labelStyle: widget.labelStyle ?? Theme.of(context).textTheme.labelMedium?.copyWith(color: Colors.grey)
        ),
        style: widget.inputTextStyle ?? Theme.of(context).textTheme.labelMedium?.copyWith(color: Pallete.primary)
      ),
    );
  }
}
