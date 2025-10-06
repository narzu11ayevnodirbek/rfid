import 'package:flutter/material.dart';
import 'package:rf_id_test/core/extention/extension.dart';

class LoadingView extends StatelessWidget {
  const LoadingView({super.key, this.withOpacityBackground = false});

  final bool withOpacityBackground;

  @override
  Widget build(BuildContext context) => withOpacityBackground
      ? Container(
          width: 1.screenWidth(context),
          height: 1.screenHeight(context),
          color: context.colorScheme.surface.withOpacity(0.5),
          child: const Center(
            child: CircularProgressIndicator(strokeCap: StrokeCap.round),
          ),
        )
      : const Center(
          child: CircularProgressIndicator(strokeCap: StrokeCap.round),
        );
}

class SliverLoading extends StatelessWidget {
  const SliverLoading({super.key});

  @override
  Widget build(BuildContext context) => SliverToBoxAdapter(
        child: SizedBox(
          height: 56 + context.padding.bottom,
          child: Center(
            child: CircularProgressIndicator(
              color: context.colorScheme.primary,
              strokeCap: StrokeCap.round,
            ),
          ),
        ),
      );
}

class LoadingIndicator extends StatelessWidget {
  const LoadingIndicator({
    super.key,
    this.dimension = 24,
    this.color,
  });

  final double dimension;
  final Color? color;

  @override
  Widget build(BuildContext context) => SizedBox.square(
        dimension: dimension,
        child: CircularProgressIndicator(
          color: color ?? context.colorScheme.surface,
        ),
      );
}
