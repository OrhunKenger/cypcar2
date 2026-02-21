import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/constants/app_constants.dart';

class CustomTextField extends StatefulWidget {
  const CustomTextField({
    super.key,
    required this.label,
    this.controller,
    this.isPassword = false,
    this.keyboardType = TextInputType.text,
    this.validator,
    this.prefixIconData,
    this.inputFormatters,
    this.textInputAction = TextInputAction.next,
    this.onFieldSubmitted,
    this.maxLines = 1,
    this.hintText,
  });

  final String label;
  final TextEditingController? controller;
  final bool isPassword;
  final TextInputType keyboardType;
  final String? Function(String?)? validator;
  final IconData? prefixIconData;
  final List<TextInputFormatter>? inputFormatters;
  final TextInputAction textInputAction;
  final void Function(String)? onFieldSubmitted;
  final int maxLines;
  final String? hintText;

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  final FocusNode _focusNode = FocusNode();
  bool _isFocused = false;
  bool _obscureText = true;

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(() {
      setState(() => _isFocused = _focusNode.hasFocus);
    });
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      focusNode: _focusNode,
      obscureText: widget.isPassword && _obscureText,
      keyboardType: widget.keyboardType,
      validator: widget.validator,
      inputFormatters: widget.inputFormatters,
      textInputAction: widget.textInputAction,
      onFieldSubmitted: widget.onFieldSubmitted,
      maxLines: widget.maxLines,
      style: const TextStyle(
        color: AppColors.textPrimary,
        fontSize: 15,
      ),
      cursorColor: AppColors.red,
      decoration: InputDecoration(
        labelText: widget.label,
        hintText: widget.hintText,
        hintStyle: const TextStyle(color: AppColors.textMuted, fontSize: 13),
        labelStyle: TextStyle(
          color: _isFocused ? AppColors.redBright : AppColors.textMuted,
          fontSize: 14,
        ),
        floatingLabelStyle: const TextStyle(
          color: AppColors.redBright,
          fontSize: 12,
          letterSpacing: 0.5,
        ),
        filled: true,
        fillColor: AppColors.surface,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppConstants.paddingMD,
          vertical: AppConstants.paddingMD,
        ),
        prefixIcon: widget.prefixIconData != null
            ? Icon(
                widget.prefixIconData,
                size: 20,
                color: _isFocused ? AppColors.redBright : AppColors.textMuted,
              )
            : null,
        suffixIcon: widget.isPassword
            ? IconButton(
                onPressed: () => setState(() => _obscureText = !_obscureText),
                icon: Icon(
                  _obscureText
                      ? Icons.visibility_outlined
                      : Icons.visibility_off_outlined,
                  size: 20,
                  color: AppColors.textMuted,
                ),
              )
            : null,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppConstants.radiusMD),
          borderSide: const BorderSide(color: AppColors.border),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppConstants.radiusMD),
          borderSide: const BorderSide(color: AppColors.border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppConstants.radiusMD),
          borderSide: const BorderSide(color: AppColors.red, width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppConstants.radiusMD),
          borderSide: const BorderSide(color: AppColors.error),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppConstants.radiusMD),
          borderSide: const BorderSide(color: AppColors.error, width: 1.5),
        ),
        errorStyle: const TextStyle(color: AppColors.error, fontSize: 12),
      ),
    );
  }
}
