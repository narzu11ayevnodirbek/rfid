import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rfid/core/l10n/app_language.dart';
import 'package:rfid/features/settings/presentation/bloc/settings_bloc.dart';

class LanguageSelector extends StatelessWidget {
  const LanguageSelector({super.key});

  @override
  Widget build(BuildContext context) {
    final language = context.select((SettingsBloc bloc) => bloc.state.language);
    return SizedBox(
      width: double.infinity,
      child: SegmentedButton<AppLanguage>(
        showSelectedIcon: false,
        segments: [
          for (final option in AppLanguage.values)
            ButtonSegment(value: option, label: Text(option.nativeName)),
        ],
        selected: {language},
        onSelectionChanged: (selection) => context
            .read<SettingsBloc>()
            .add(SettingsLanguageChanged(selection.single)),
      ),
    );
  }
}
