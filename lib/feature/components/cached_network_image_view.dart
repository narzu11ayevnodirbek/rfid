import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:rf_id_test/core/extention/extension.dart';
import 'package:rf_id_test/core/theme/themes.dart';

class CachedNetworkImageView extends StatelessWidget {
  const CachedNetworkImageView({
    super.key,
    required this.imageUrl,
    this.width,
    this.height,
    this.borderRadius = kBorderRadius12,
    this.fit,
    this.backgroundColor,
    this.errorWidget,
  });

  final String imageUrl;
  final double? width;
  final double? height;
  final BorderRadius borderRadius;
  final BoxFit? fit;
  final Color? backgroundColor;
  final Widget? errorWidget;

  @override
  Widget build(BuildContext context) => ClipRRect(
        borderRadius: borderRadius,
        child: Container(
          width: width,
          height: height,
          color: backgroundColor,
          child: CachedNetworkImage(
            imageUrl: imageUrl,
            width: width,
            height: height,
            fit: fit,
            fadeInCurve: Curves.easeInToLinear,
            fadeOutCurve: Curves.linearToEaseOut,
            placeholder: (_, errorText) => ColoredBox(
              color: context.colorScheme.outline.withOpacity(0.2),
            ),
            errorWidget: (_, __, ___) => ColoredBox(
              color: context.theme.canvasColor,
              child: const Center(
                child: Image(
                  width: 80,
                  height: 80,
                  image: AssetImage('assets/images/logo/foreground.png'),
                ),
              ),
            ),
          ),
        ),
      );
}
