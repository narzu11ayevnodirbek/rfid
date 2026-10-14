import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rfid/core/error/failure.dart';
import 'package:rfid/core/l10n/app_language.dart';
import 'package:rfid/core/rfid/fake_rfid_reader.dart';
import 'package:rfid/core/rfid/rfid_scan_settings.dart';
import 'package:rfid/core/rfid/tag_scan_session.dart';
import 'package:rfid/core/storage/in_memory_key_value_store.dart';
import 'package:rfid/features/settings/data/repositories/settings_repository_impl.dart';
import 'package:rfid/features/settings/presentation/bloc/reader_diagnostics_bloc.dart';
import 'package:rfid/features/settings/presentation/bloc/settings_bloc.dart';

void main() {
  group('SettingsBloc', () {
    test('defaults to Russian and remembers the chosen language', () async {
      final store = InMemoryKeyValueStore();
      final bloc = SettingsBloc(SettingsRepositoryImpl(store));
      expect(bloc.state.language, AppLanguage.russian);

      bloc.add(const SettingsLanguageChanged(AppLanguage.uzbek));
      await pumpEventQueue();

      expect(bloc.state.language, AppLanguage.uzbek);
      expect(
        SettingsBloc(SettingsRepositoryImpl(store)).state.language,
        AppLanguage.uzbek,
      );
      await bloc.close();
    });
  });

  group('ReaderDiagnosticsBloc', () {
    late FakeRfidReader reader;

    ReaderDiagnosticsBloc build() => ReaderDiagnosticsBloc(
          reader,
          scanSession: TagScanSession(
            reader: reader,
            powerProfile: RfidPowerProfile.diagnostics,
            onNewTag: () {},
          ),
        );

    setUp(() => reader = FakeRfidReader());

    test('checks the module and turns on key reporting when opened', () async {
      final bloc = build()..add(const ReaderDiagnosticsStarted());
      await pumpEventQueue();

      expect(bloc.state.moduleStatus, ModuleStatus.ready);
      expect(reader.reportsKeyEvents, isTrue);
      await bloc.close();
    });

    blocTest<ReaderDiagnosticsBloc, ReaderDiagnosticsState>(
      'reports a missing module',
      build: () {
        reader = FakeRfidReader(
          initializeFailure: RfidFailureReason.unavailable,
        );
        return build();
      },
      act: (bloc) => bloc.add(const ReaderDiagnosticsStarted()),
      verify: (bloc) {
        expect(bloc.state.moduleStatus, ModuleStatus.failed);
        expect(
          bloc.state.moduleFailure,
          const RfidFailure(RfidFailureReason.unavailable),
        );
      },
    );

    blocTest<ReaderDiagnosticsBloc, ReaderDiagnosticsState>(
      'applies the selected power, also after starting a scan',
      build: build,
      act: (bloc) async {
        bloc
          ..add(const ReaderDiagnosticsPowerSelected(12))
          ..add(const ReaderDiagnosticsPowerApplied());
        await pumpEventQueue();
        bloc.add(const ReaderDiagnosticsScanToggled());
      },
      verify: (bloc) {
        expect(reader.powerDbm, 12);
        expect(bloc.state.isPowerAccepted, isTrue);
        expect(bloc.state.scan.isScanning, isTrue);
      },
    );

    blocTest<ReaderDiagnosticsBloc, ReaderDiagnosticsState>(
      'shows the last hardware key',
      build: build,
      act: (bloc) async {
        bloc.add(const ReaderDiagnosticsStarted());
        await pumpEventQueue();
        reader.simulateKey(293, isDown: true);
      },
      verify: (bloc) {
        expect(bloc.state.lastKeyCode, 293);
        expect(bloc.state.isKeyDown, isTrue);
      },
    );

    test('closing stops the reader and key reporting', () async {
      final bloc = build()..add(const ReaderDiagnosticsStarted());
      await pumpEventQueue();
      bloc.add(const ReaderDiagnosticsScanToggled());
      await pumpEventQueue();

      await bloc.close();

      expect(reader.isScanning, isFalse);
      expect(reader.reportsKeyEvents, isFalse);
    });
  });
}
