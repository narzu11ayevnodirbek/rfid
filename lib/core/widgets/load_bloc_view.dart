import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rfid/core/bloc/load_bloc.dart';
import 'package:rfid/core/bloc/load_state.dart';
import 'package:rfid/core/l10n/l10n.dart';
import 'package:rfid/core/widgets/app_snackbar.dart';
import 'package:rfid/core/widgets/load_state_view.dart';

class LoadBlocView<B extends LoadBloc<T>, T> extends StatelessWidget {
  const LoadBlocView({super.key, required this.builder});

  final Widget Function(BuildContext context, T value) builder;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<B, LoadState<T>>(
      listenWhen: (previous, current) =>
          current is LoadSuccess<T> &&
          current.refreshFailure != null &&
          previous != current,
      listener: (context, state) =>
          context.showErrorMessage(context.l10n.commonRefreshFailed),
      builder: (context, state) => LoadStateView<T>(
        state: state,
        onRetry: () => context.read<B>().add(const LoadRequested()),
        builder: (context, value) => RefreshIndicator(
          onRefresh: context.read<B>().refresh,
          child: builder(context, value),
        ),
      ),
    );
  }
}
