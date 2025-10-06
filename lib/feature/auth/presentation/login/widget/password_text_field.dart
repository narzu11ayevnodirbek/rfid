
import 'package:flutter/material.dart';
import 'package:rf_id_test/core/extention/extension.dart';

class AuthTextField extends StatelessWidget {
  const AuthTextField({
    super.key,
    required this.controller,
    required this.focusNode,
    required this.hasError,
  });

  final TextEditingController controller;
  final FocusNode focusNode;
  final ValueNotifier<bool> hasError;

  @override
  Widget build(BuildContext context) => AnimatedBuilder(
    animation: Listenable.merge([focusNode, hasError]),
    builder: (_, __) => Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Password',
          style: context.textStyle.regularCallout.copyWith(
            fontSize: 12,
          ),
        ),
        4.kBoxHeight,
        TextFormField(
          autovalidateMode: AutovalidateMode.onUserInteraction,
          controller: controller,
          cursorColor: context.colorScheme.primary,
          textInputAction: TextInputAction.search,
          cursorOpacityAnimates: true,
          style: context.textStyle.regularCallout,
          decoration: InputDecoration(
            filled: true,
            isDense: false,
            counterText: '',
            fillColor: context.theme.canvasColor,
            hintText: 'Login',
            errorText: hasError.value ? 'Login is required' : null,
            errorStyle: context.textStyle.regularCallout.copyWith(
              color: context.colorScheme.error,
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: 12.kBorderRadiusAll,
              borderSide: BorderSide.none,
              gapPadding: 0,
            ),
            hintStyle: context.textStyle.regularCallout.copyWith(
              color: context.colorScheme.outline.withOpacity(0.5),
              overflow: TextOverflow.ellipsis,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: 12.kBorderRadiusAll,
              borderSide: BorderSide.none,
              gapPadding: 0,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: 12.kBorderRadiusAll,
              borderSide: BorderSide.none,
              gapPadding: 0,
            ),
          ),
        ),
      ],
    ),
  );
}
