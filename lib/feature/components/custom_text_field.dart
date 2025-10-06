import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:rf_id_test/core/extention/extension.dart';

class CustomTextField extends StatelessWidget {
  const CustomTextField({
    super.key,
    required this.controller,
    required this.focusNode,
    this.errorText,
    required this.title,
    this.hintText = '',
    this.textInputAction,
    this.onEditingComplete,
    this.maxLines = 1,
    this.textInputType,
    this.readOnly = false,
    this.expands = false,
    this.obscureText = false,
    this.inputFormatters = const [],
    this.maxLength,
    this.suffixIcon,
    this.prefixIcon,
    this.onTap,
  });

  final String title;
  final String hintText;
  final TextEditingController controller;
  final FocusNode focusNode;
  final String? errorText;
  final TextInputAction? textInputAction;
  final VoidCallback? onEditingComplete;
  final int? maxLines;
  final TextInputType? textInputType;
  final bool readOnly;
  final bool expands;
  final bool obscureText;
  final List<TextInputFormatter>? inputFormatters;
  final int? maxLength;
  final Widget? suffixIcon;
  final Widget? prefixIcon;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: context.textStyle.regularCallout.copyWith(
              fontSize: 12,
            ),
          ),
          4.kBoxHeight,
          TextFormField(
            autovalidateMode: AutovalidateMode.onUserInteraction,
            controller: controller,
            cursorColor: context.colorScheme.primary,
            textInputAction: textInputAction,
            cursorOpacityAnimates: true,
            style: context.textStyle.regularCallout,
            onEditingComplete: onEditingComplete,
            maxLines: maxLines,
            focusNode: focusNode,
            keyboardType: textInputType,
            readOnly: readOnly,
            expands: expands,
            obscureText: obscureText,
            inputFormatters: inputFormatters,
            maxLength: maxLength,
            onTap: onTap,
            decoration: InputDecoration(
              filled: true,
              isDense: false,
              counterText: '',
              fillColor: context.theme.canvasColor,
              hintText: hintText.isEmpty ? title : hintText,
              errorText: errorText,
              errorStyle: context.textStyle.regularCallout.copyWith(
                fontSize: 12,
                color: context.colorScheme.error,
              ),
              suffixIcon: suffixIcon,
              prefixIcon: prefixIcon,
              errorBorder: OutlineInputBorder(
                borderRadius: 12.kBorderRadiusAll,
                borderSide: BorderSide.none,
                gapPadding: 0,
              ),
              focusedErrorBorder: OutlineInputBorder(
                borderRadius: 12.kBorderRadiusAll,
                borderSide: BorderSide(color: context.colorScheme.error),
                gapPadding: 0,
              ),
              hintStyle: context.textStyle.regularCallout.copyWith(
                color: context.colorScheme.outline.withValues(alpha: 0.5),
                overflow: TextOverflow.ellipsis,
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: 12.kBorderRadiusAll,
                borderSide: BorderSide.none,
                gapPadding: 0,
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: 12.kBorderRadiusAll,
                borderSide: BorderSide(color: context.colorScheme.primary),
                gapPadding: 0,
              ),
            ),
          ),
        ],
      );
}
