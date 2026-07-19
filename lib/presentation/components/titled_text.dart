import 'package:flutter/material.dart';
import 'package:rfid/core/extension/extension.dart';

class TitledText extends StatelessWidget {
  const TitledText({
    super.key,
    required this.title,
    required this.subTitle,
  });

  final String title;
  final String subTitle;

  @override
  Widget build(BuildContext context) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: context.textStyle.regularHeadline.copyWith(fontSize: 12)),
          Text(
            subTitle,
            style: context.textStyle.regularCallout.copyWith(fontSize: 16),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      );
}
