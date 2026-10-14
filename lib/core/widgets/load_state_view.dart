import 'package:flutter/material.dart';
import 'package:rfid/core/bloc/load_state.dart';
import 'package:rfid/core/widgets/error_state_view.dart';
import 'package:rfid/core/widgets/loading_view.dart';

class LoadStateView<T> extends StatelessWidget {
  const LoadStateView({
    super.key,
    required this.state,
    required this.onRetry,
    required this.builder,
  });

  final LoadState<T> state;
  final VoidCallback onRetry;
  final Widget Function(BuildContext context, T value) builder;

  @override
  Widget build(BuildContext context) => switch (state) {
        LoadInProgress<T>() => const LoadingView(),
        LoadFailure<T>(:final failure) =>
          ErrorStateView(failure: failure, onRetry: onRetry),
        LoadSuccess<T>(:final value) => builder(context, value),
      };
}
