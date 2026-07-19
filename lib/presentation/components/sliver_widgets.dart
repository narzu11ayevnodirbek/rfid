import 'package:flutter/material.dart';
import 'package:rfid/core/extension/extension.dart';
import 'package:rfid/core/theme/themes.dart';

class SliverListEmpty extends StatelessWidget {
  const SliverListEmpty({super.key, this.message = 'empty_message'});

  final String message;

  @override
  Widget build(BuildContext context) => SafeArea(
        child: CustomScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          slivers: [
            SliverFillRemaining(
              child: Padding(
                padding: kPaddingAll12,
                child: Center(
                  child: Text(
                    message,
                    style: context.textStyle.regularCallout,
                  ),
                ),
              ),
            ),
          ],
        ),
      );
}
