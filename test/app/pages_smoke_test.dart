import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:rfid/core/bloc/load_bloc.dart';
import 'package:rfid/core/bloc/load_state.dart';
import 'package:rfid/core/error/failure.dart';
import 'package:rfid/core/l10n/app_language.dart';
import 'package:rfid/core/rfid/tag_scan_state.dart';
import 'package:rfid/features/auth/presentation/bloc/login_bloc.dart';
import 'package:rfid/features/auth/presentation/bloc/session_bloc.dart';
import 'package:rfid/features/auth/presentation/pages/login_page.dart';
import 'package:rfid/features/inventory/domain/entities/inventory.dart';
import 'package:rfid/features/inventory/domain/entities/inventory_plan.dart';
import 'package:rfid/features/inventory/domain/entities/inventory_reconciliation.dart';
import 'package:rfid/features/inventory/presentation/bloc/inventory_list_bloc.dart';
import 'package:rfid/features/inventory/presentation/bloc/inventory_scan_bloc.dart';
import 'package:rfid/features/inventory/presentation/pages/inventory_list_page.dart';
import 'package:rfid/features/inventory/presentation/pages/inventory_scan_page.dart';
import 'package:rfid/features/marking/domain/entities/marking_item.dart';
import 'package:rfid/features/marking/presentation/bloc/marking_tag_bind_bloc.dart';
import 'package:rfid/features/marking/presentation/pages/marking_tag_bind_page.dart';
import 'package:rfid/features/movement/domain/entities/storage_location.dart';
import 'package:rfid/features/movement/presentation/bloc/free_transfer_bloc.dart';
import 'package:rfid/features/movement/presentation/pages/free_transfer_page.dart';
import 'package:rfid/features/settings/presentation/bloc/settings_bloc.dart';
import 'package:rfid/features/settings/presentation/pages/settings_page.dart';

import '../support/pump_app.dart';

class _MockLoginBloc extends MockBloc<LoginEvent, LoginState>
    implements LoginBloc {}

class _MockSessionBloc extends MockBloc<SessionEvent, SessionState>
    implements SessionBloc {}

class _MockSettingsBloc extends MockBloc<SettingsEvent, SettingsState>
    implements SettingsBloc {}

class _MockInventoryListBloc
    extends MockBloc<LoadEvent, LoadState<List<Inventory>>>
    implements InventoryListBloc {}

class _MockInventoryScanBloc
    extends MockBloc<InventoryScanEvent, InventoryScanState>
    implements InventoryScanBloc {}

class _MockMarkingTagBindBloc
    extends MockBloc<MarkingTagBindEvent, MarkingTagBindState>
    implements MarkingTagBindBloc {}

class _MockFreeTransferBloc
    extends MockBloc<FreeTransferEvent, FreeTransferState>
    implements FreeTransferBloc {}

const _inventory = Inventory(
  id: '7',
  name: '0042',
  type: 'Плановая',
  responsibleName: 'Иванов',
  createdAt: '2025-10-06',
  statusCode: 'open',
  statusLabel: 'Открыта',
  foundCount: 3,
  missingCount: 7,
  totalCount: 10,
);

void main() {
  setUpAll(() {
    registerFallbackValue(const LoginSubmitted());
    registerFallbackValue(const LoadRequested());
    registerFallbackValue(const InventoryScanToggled());
    registerFallbackValue(const SessionSignOutRequested());
  });

  group('LoginPage', () {
    testWidgets('shows the form and submits it', (tester) async {
      final login = _MockLoginBloc();
      final session = _MockSessionBloc();
      when(() => login.state).thenReturn(const LoginState());
      when(() => session.state)
          .thenReturn(const SessionState(isAuthenticated: false));

      await tester.pumpApp(
        MultiBlocProvider(
          providers: [
            BlocProvider<LoginBloc>.value(value: login),
            BlocProvider<SessionBloc>.value(value: session),
          ],
          child: const LoginPage(),
        ),
      );
      await tester.tap(find.widgetWithText(FilledButton, 'Войти'));

      expect(find.text('Логин'), findsOneWidget);
      expect(find.text('Пароль'), findsOneWidget);
      verify(() => login.add(const LoginSubmitted())).called(1);
    });
  });

  group('InventoryListPage', () {
    late _MockInventoryListBloc bloc;

    Future<void> pump(WidgetTester tester, LoadState<List<Inventory>> state) {
      when(() => bloc.state).thenReturn(state);
      return tester.pumpApp(
        BlocProvider<InventoryListBloc>.value(
          value: bloc,
          child: const InventoryListPage(),
        ),
      );
    }

    setUp(() => bloc = _MockInventoryListBloc());

    testWidgets('shows a spinner while loading', (tester) async {
      await pump(tester, const LoadInProgress<List<Inventory>>());

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('offers a retry after a failure', (tester) async {
      await pump(tester, const LoadFailure<List<Inventory>>(NetworkFailure()));
      await tester.tap(find.text('Повторить'));

      expect(find.textContaining('Нет связи'), findsOneWidget);
      verify(() => bloc.add(const LoadRequested())).called(1);
    });

    testWidgets('shows an empty message', (tester) async {
      await pump(tester, const LoadSuccess(<Inventory>[]));

      expect(find.text('Нет активных инвентаризаций'), findsOneWidget);
    });

    testWidgets('shows the inventories with their progress', (tester) async {
      await pump(tester, const LoadSuccess([_inventory]));

      expect(find.text('Инвентаризация №0042'), findsOneWidget);
      expect(find.text('3 из 10'), findsOneWidget);
    });
  });

  group('InventoryScanPage', () {
    testWidgets('shows counters and the missing items', (tester) async {
      final bloc = _MockInventoryScanBloc();
      when(() => bloc.state).thenReturn(
        const InventoryScanState(
          inventoryId: '7',
          inventoryName: '0042',
          plan: InventoryPlan.empty('7'),
          reconciliation: InventoryReconciliation(
            found: [ExpectedItem(epc: 'E1', name: 'Стол')],
            missing: [ExpectedItem(epc: 'E2', name: 'Шкаф')],
            extraEpcs: ['E9'],
          ),
        ),
      );

      await tester.pumpApp(
        BlocProvider<InventoryScanBloc>.value(
          value: bloc,
          child: const InventoryScanPage(),
        ),
      );
      await tester.tap(find.text('Запустить RFID'));

      expect(find.text('Шкаф'), findsOneWidget);
      expect(find.text('Стол'), findsNothing);
      verify(() => bloc.add(const InventoryScanToggled())).called(1);
    });
  });

  group('MarkingTagBindPage', () {
    const item = MarkingItem(
      id: '100',
      name: 'Стол',
      inventoryNumber: 'INV-100',
      status: '',
      photoPath: '',
      boundEpc: '',
    );

    Future<void> pump(WidgetTester tester, MarkingTagBindState state) {
      final bloc = _MockMarkingTagBindBloc();
      when(() => bloc.state).thenReturn(state);
      return tester.pumpApp(
        BlocProvider<MarkingTagBindBloc>.value(
          value: bloc,
          child: const MarkingTagBindPage(),
        ),
      );
    }

    FilledButton bindButton(WidgetTester tester) => tester.widget(
          find.ancestor(
            of: find.text('Привязать метку'),
            matching: find.byWidgetPredicate((w) => w is FilledButton),
          ),
        );

    testWidgets('cannot bind before a tag is read', (tester) async {
      await pump(tester, const MarkingTagBindState(item: LoadSuccess(item)));

      expect(find.text('INV-100'), findsOneWidget);
      expect(bindButton(tester).onPressed, isNull);
    });

    testWidgets('shows the tag to bind and enables binding', (tester) async {
      await pump(
        tester,
        const MarkingTagBindState(
          item: LoadSuccess(item),
          scan: TagScanState(tags: ['E1'], lastTag: 'E1'),
        ),
      );

      await tester.scrollUntilVisible(find.text('E1'), 200);

      expect(find.text('E1'), findsOneWidget);
      expect(bindButton(tester).onPressed, isNotNull);
    });
  });

  group('FreeTransferPage', () {
    testWidgets('asks for a location when sending without one', (tester) async {
      final bloc = _MockFreeTransferBloc();
      when(() => bloc.state).thenReturn(
        const FreeTransferState(
          locations: LoadSuccess([
            StorageLocation(id: '9', name: 'Кабинет 5', path: ''),
          ]),
          showLocationRequired: true,
        ),
      );

      await tester.pumpApp(
        BlocProvider<FreeTransferBloc>.value(
          value: bloc,
          child: const FreeTransferPage(),
        ),
      );

      expect(find.text('Сначала выберите локацию'), findsOneWidget);
    });
  });

  group('SettingsPage', () {
    testWidgets('signs out after confirmation', (tester) async {
      final session = _MockSessionBloc();
      final settings = _MockSettingsBloc();
      when(() => session.state)
          .thenReturn(const SessionState(isAuthenticated: true));
      when(() => settings.state)
          .thenReturn(const SettingsState(language: AppLanguage.russian));

      await tester.pumpApp(
        MultiBlocProvider(
          providers: [
            BlocProvider<SessionBloc>.value(value: session),
            BlocProvider<SettingsBloc>.value(value: settings),
          ],
          child: const SettingsPage(),
        ),
      );
      await tester.tap(find.text('Выйти из аккаунта'));
      await tester.pumpAndSettle();
      await tester.tap(find.widgetWithText(FilledButton, 'Выйти'));
      await tester.pumpAndSettle();

      verify(() => session.add(const SessionSignOutRequested())).called(1);
    });
  });
}
