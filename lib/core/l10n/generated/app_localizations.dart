import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_ru.dart';
import 'app_localizations_uz.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'generated/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
      : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('ru'),
    Locale('uz')
  ];

  /// No description provided for @appTitle.
  ///
  /// In ru, this message translates to:
  /// **'RFID Инвентаризация'**
  String get appTitle;

  /// No description provided for @commonRetry.
  ///
  /// In ru, this message translates to:
  /// **'Повторить'**
  String get commonRetry;

  /// No description provided for @commonCancel.
  ///
  /// In ru, this message translates to:
  /// **'Отмена'**
  String get commonCancel;

  /// No description provided for @commonOk.
  ///
  /// In ru, this message translates to:
  /// **'Понятно'**
  String get commonOk;

  /// No description provided for @commonClose.
  ///
  /// In ru, this message translates to:
  /// **'Закрыть'**
  String get commonClose;

  /// No description provided for @commonRemove.
  ///
  /// In ru, this message translates to:
  /// **'Удалить'**
  String get commonRemove;

  /// No description provided for @commonEmptyList.
  ///
  /// In ru, this message translates to:
  /// **'Список пуст'**
  String get commonEmptyList;

  /// No description provided for @commonRefreshFailed.
  ///
  /// In ru, this message translates to:
  /// **'Не удалось обновить данные'**
  String get commonRefreshFailed;

  /// No description provided for @commonSearchByTag.
  ///
  /// In ru, this message translates to:
  /// **'Поиск по метке'**
  String get commonSearchByTag;

  /// No description provided for @commonCreatedAt.
  ///
  /// In ru, this message translates to:
  /// **'Создано: {date}'**
  String commonCreatedAt(String date);

  /// No description provided for @commonProgress.
  ///
  /// In ru, this message translates to:
  /// **'{done} из {total}'**
  String commonProgress(int done, int total);

  /// No description provided for @failureNetwork.
  ///
  /// In ru, this message translates to:
  /// **'Нет связи с сервером. Проверьте интернет и повторите.'**
  String get failureNetwork;

  /// No description provided for @failureUnauthorized.
  ///
  /// In ru, this message translates to:
  /// **'Сессия истекла. Войдите снова.'**
  String get failureUnauthorized;

  /// No description provided for @failureServer.
  ///
  /// In ru, this message translates to:
  /// **'Сервер отклонил запрос.'**
  String get failureServer;

  /// No description provided for @failureServerWithCode.
  ///
  /// In ru, this message translates to:
  /// **'Ошибка сервера ({code}).'**
  String failureServerWithCode(int code);

  /// No description provided for @failureParsing.
  ///
  /// In ru, this message translates to:
  /// **'Сервер вернул непонятный ответ.'**
  String get failureParsing;

  /// No description provided for @failureUnexpected.
  ///
  /// In ru, this message translates to:
  /// **'Что-то пошло не так. Повторите попытку.'**
  String get failureUnexpected;

  /// No description provided for @failureRfidUnavailable.
  ///
  /// In ru, this message translates to:
  /// **'RFID-считыватель не найден на этом устройстве.'**
  String get failureRfidUnavailable;

  /// No description provided for @failureRfidInitFailed.
  ///
  /// In ru, this message translates to:
  /// **'Не удалось включить RFID-считыватель. Перезапустите приложение.'**
  String get failureRfidInitFailed;

  /// No description provided for @failureRfidCommandFailed.
  ///
  /// In ru, this message translates to:
  /// **'RFID-считыватель не выполнил команду. Повторите попытку.'**
  String get failureRfidCommandFailed;

  /// No description provided for @tabInventory.
  ///
  /// In ru, this message translates to:
  /// **'Инвентаризация'**
  String get tabInventory;

  /// No description provided for @tabMarking.
  ///
  /// In ru, this message translates to:
  /// **'Маркировка'**
  String get tabMarking;

  /// No description provided for @tabMovement.
  ///
  /// In ru, this message translates to:
  /// **'Перемещение'**
  String get tabMovement;

  /// No description provided for @tabSettings.
  ///
  /// In ru, this message translates to:
  /// **'Настройки'**
  String get tabSettings;

  /// No description provided for @loginTitle.
  ///
  /// In ru, this message translates to:
  /// **'Вход'**
  String get loginTitle;

  /// No description provided for @loginSubtitle.
  ///
  /// In ru, this message translates to:
  /// **'Войдите, чтобы продолжить работу'**
  String get loginSubtitle;

  /// No description provided for @loginLoginLabel.
  ///
  /// In ru, this message translates to:
  /// **'Логин'**
  String get loginLoginLabel;

  /// No description provided for @loginPasswordLabel.
  ///
  /// In ru, this message translates to:
  /// **'Пароль'**
  String get loginPasswordLabel;

  /// No description provided for @loginSubmit.
  ///
  /// In ru, this message translates to:
  /// **'Войти'**
  String get loginSubmit;

  /// No description provided for @loginFieldRequired.
  ///
  /// In ru, this message translates to:
  /// **'Заполните поле'**
  String get loginFieldRequired;

  /// No description provided for @loginInvalidCredentials.
  ///
  /// In ru, this message translates to:
  /// **'Неверный логин или пароль'**
  String get loginInvalidCredentials;

  /// No description provided for @loginShowPassword.
  ///
  /// In ru, this message translates to:
  /// **'Показать пароль'**
  String get loginShowPassword;

  /// No description provided for @loginHidePassword.
  ///
  /// In ru, this message translates to:
  /// **'Скрыть пароль'**
  String get loginHidePassword;

  /// No description provided for @scanStart.
  ///
  /// In ru, this message translates to:
  /// **'Запустить RFID'**
  String get scanStart;

  /// No description provided for @scanStop.
  ///
  /// In ru, this message translates to:
  /// **'Остановить'**
  String get scanStop;

  /// No description provided for @scanClear.
  ///
  /// In ru, this message translates to:
  /// **'Очистить'**
  String get scanClear;

  /// No description provided for @scanStatusReading.
  ///
  /// In ru, this message translates to:
  /// **'Идёт чтение'**
  String get scanStatusReading;

  /// No description provided for @scanStatusArmed.
  ///
  /// In ru, this message translates to:
  /// **'Считыватель включён'**
  String get scanStatusArmed;

  /// No description provided for @scanStatusIdle.
  ///
  /// In ru, this message translates to:
  /// **'Считыватель выключен'**
  String get scanStatusIdle;

  /// No description provided for @scanHint.
  ///
  /// In ru, this message translates to:
  /// **'Нажмите «Запустить RFID» и поднесите устройство к меткам. Кнопка на корпусе тоже включает чтение.'**
  String get scanHint;

  /// No description provided for @scanTagCount.
  ///
  /// In ru, this message translates to:
  /// **'Считано меток: {count}'**
  String scanTagCount(int count);

  /// No description provided for @scanNoTags.
  ///
  /// In ru, this message translates to:
  /// **'Пока нет считанных меток'**
  String get scanNoTags;

  /// No description provided for @scanClearTitle.
  ///
  /// In ru, this message translates to:
  /// **'Очистить список?'**
  String get scanClearTitle;

  /// No description provided for @scanClearMessage.
  ///
  /// In ru, this message translates to:
  /// **'Все считанные метки будут удалены из списка.'**
  String get scanClearMessage;

  /// No description provided for @scanLeaveTitle.
  ///
  /// In ru, this message translates to:
  /// **'Выйти без отправки?'**
  String get scanLeaveTitle;

  /// No description provided for @scanLeaveMessage.
  ///
  /// In ru, this message translates to:
  /// **'Считанные метки не отправлены и будут потеряны.'**
  String get scanLeaveMessage;

  /// No description provided for @scanLeaveConfirm.
  ///
  /// In ru, this message translates to:
  /// **'Выйти'**
  String get scanLeaveConfirm;

  /// No description provided for @statTotal.
  ///
  /// In ru, this message translates to:
  /// **'Всего'**
  String get statTotal;

  /// No description provided for @statFound.
  ///
  /// In ru, this message translates to:
  /// **'Найдено'**
  String get statFound;

  /// No description provided for @statMissing.
  ///
  /// In ru, this message translates to:
  /// **'Не найдено'**
  String get statMissing;

  /// No description provided for @statExtra.
  ///
  /// In ru, this message translates to:
  /// **'Лишние'**
  String get statExtra;

  /// No description provided for @statScanned.
  ///
  /// In ru, this message translates to:
  /// **'Считано'**
  String get statScanned;

  /// No description provided for @statBound.
  ///
  /// In ru, this message translates to:
  /// **'Привязано'**
  String get statBound;

  /// No description provided for @statUnbound.
  ///
  /// In ru, this message translates to:
  /// **'Не привязано'**
  String get statUnbound;

  /// No description provided for @inventoryListTitle.
  ///
  /// In ru, this message translates to:
  /// **'Инвентаризация'**
  String get inventoryListTitle;

  /// No description provided for @inventoryListEmpty.
  ///
  /// In ru, this message translates to:
  /// **'Нет активных инвентаризаций'**
  String get inventoryListEmpty;

  /// No description provided for @inventoryNumber.
  ///
  /// In ru, this message translates to:
  /// **'Инвентаризация №{name}'**
  String inventoryNumber(String name);

  /// No description provided for @inventoryType.
  ///
  /// In ru, this message translates to:
  /// **'Тип: {type}'**
  String inventoryType(String type);

  /// No description provided for @inventoryTasksTitle.
  ///
  /// In ru, this message translates to:
  /// **'Задания'**
  String get inventoryTasksTitle;

  /// No description provided for @inventoryTasksEmpty.
  ///
  /// In ru, this message translates to:
  /// **'У этой инвентаризации нет заданий'**
  String get inventoryTasksEmpty;

  /// No description provided for @inventoryStartScan.
  ///
  /// In ru, this message translates to:
  /// **'Начать сканирование'**
  String get inventoryStartScan;

  /// No description provided for @inventoryPlanFromCache.
  ///
  /// In ru, this message translates to:
  /// **'Нет связи с сервером — показан сохранённый план.'**
  String get inventoryPlanFromCache;

  /// No description provided for @inventoryPlanEmpty.
  ///
  /// In ru, this message translates to:
  /// **'Сервер не вернул ожидаемых объектов. Все считанные метки попадут в «Лишние».'**
  String get inventoryPlanEmpty;

  /// No description provided for @inventoryDraftRestored.
  ///
  /// In ru, this message translates to:
  /// **'Восстановлено из черновика: {count}'**
  String inventoryDraftRestored(int count);

  /// No description provided for @inventorySaveDraft.
  ///
  /// In ru, this message translates to:
  /// **'Сохранить черновик'**
  String get inventorySaveDraft;

  /// No description provided for @inventoryDraftSaved.
  ///
  /// In ru, this message translates to:
  /// **'Черновик сохранён'**
  String get inventoryDraftSaved;

  /// No description provided for @inventoryFinish.
  ///
  /// In ru, this message translates to:
  /// **'Завершить'**
  String get inventoryFinish;

  /// No description provided for @inventoryFinishTitle.
  ///
  /// In ru, this message translates to:
  /// **'Завершить инвентаризацию?'**
  String get inventoryFinishTitle;

  /// No description provided for @inventoryFinishMessage.
  ///
  /// In ru, this message translates to:
  /// **'Найдено {found} из {total}, лишних меток: {extra}. Результат будет отправлен на сервер.'**
  String inventoryFinishMessage(int found, int total, int extra);

  /// No description provided for @inventoryFinished.
  ///
  /// In ru, this message translates to:
  /// **'Результаты инвентаризации отправлены'**
  String get inventoryFinished;

  /// No description provided for @inventoryFinishFailed.
  ///
  /// In ru, this message translates to:
  /// **'Не удалось отправить результаты. Черновик сохранён — отправьте позже.'**
  String get inventoryFinishFailed;

  /// No description provided for @inventoryNothingMissing.
  ///
  /// In ru, this message translates to:
  /// **'Все объекты найдены'**
  String get inventoryNothingMissing;

  /// No description provided for @inventoryNothingFound.
  ///
  /// In ru, this message translates to:
  /// **'Пока ничего не найдено'**
  String get inventoryNothingFound;

  /// No description provided for @inventoryNoExtra.
  ///
  /// In ru, this message translates to:
  /// **'Лишних меток нет'**
  String get inventoryNoExtra;

  /// No description provided for @itemLookupTitle.
  ///
  /// In ru, this message translates to:
  /// **'Поиск по метке'**
  String get itemLookupTitle;

  /// No description provided for @itemLookupEmpty.
  ///
  /// In ru, this message translates to:
  /// **'Считайте метку, чтобы увидеть объект'**
  String get itemLookupEmpty;

  /// No description provided for @itemLookupUnknownTags.
  ///
  /// In ru, this message translates to:
  /// **'Метки без объекта в базе: {count}'**
  String itemLookupUnknownTags(int count);

  /// No description provided for @itemLocation.
  ///
  /// In ru, this message translates to:
  /// **'Место: {location}'**
  String itemLocation(String location);

  /// No description provided for @itemResponsible.
  ///
  /// In ru, this message translates to:
  /// **'Ответственный: {name}'**
  String itemResponsible(String name);

  /// No description provided for @markingListTitle.
  ///
  /// In ru, this message translates to:
  /// **'Маркировка'**
  String get markingListTitle;

  /// No description provided for @markingListEmpty.
  ///
  /// In ru, this message translates to:
  /// **'Нет маркировок'**
  String get markingListEmpty;

  /// No description provided for @markingTasksTitle.
  ///
  /// In ru, this message translates to:
  /// **'Задания маркировки'**
  String get markingTasksTitle;

  /// No description provided for @markingTasksEmpty.
  ///
  /// In ru, this message translates to:
  /// **'Нет заданий'**
  String get markingTasksEmpty;

  /// No description provided for @markingItemsEmpty.
  ///
  /// In ru, this message translates to:
  /// **'В задании нет объектов'**
  String get markingItemsEmpty;

  /// No description provided for @markingItemTitle.
  ///
  /// In ru, this message translates to:
  /// **'Единица ТМЦ'**
  String get markingItemTitle;

  /// No description provided for @markingItemName.
  ///
  /// In ru, this message translates to:
  /// **'Наименование'**
  String get markingItemName;

  /// No description provided for @markingItemInventoryNumber.
  ///
  /// In ru, this message translates to:
  /// **'Инвентарный номер'**
  String get markingItemInventoryNumber;

  /// No description provided for @markingItemStatus.
  ///
  /// In ru, this message translates to:
  /// **'Статус'**
  String get markingItemStatus;

  /// No description provided for @markingItemPhoto.
  ///
  /// In ru, this message translates to:
  /// **'Фото'**
  String get markingItemPhoto;

  /// No description provided for @markingItemBound.
  ///
  /// In ru, this message translates to:
  /// **'Метка уже привязана'**
  String get markingItemBound;

  /// No description provided for @markingLastTag.
  ///
  /// In ru, this message translates to:
  /// **'Считанная метка'**
  String get markingLastTag;

  /// No description provided for @markingBindHint.
  ///
  /// In ru, this message translates to:
  /// **'Поднесите устройство к метке этого объекта. Будет привязана последняя считанная метка.'**
  String get markingBindHint;

  /// No description provided for @markingBindSubmit.
  ///
  /// In ru, this message translates to:
  /// **'Привязать метку'**
  String get markingBindSubmit;

  /// No description provided for @markingTagBound.
  ///
  /// In ru, this message translates to:
  /// **'Метка привязана'**
  String get markingTagBound;

  /// No description provided for @markingBindFailedTitle.
  ///
  /// In ru, this message translates to:
  /// **'Не удалось привязать метку'**
  String get markingBindFailedTitle;

  /// No description provided for @movementListTitle.
  ///
  /// In ru, this message translates to:
  /// **'Перемещение'**
  String get movementListTitle;

  /// No description provided for @movementListEmpty.
  ///
  /// In ru, this message translates to:
  /// **'Нет заданий на перемещение'**
  String get movementListEmpty;

  /// No description provided for @movementFreeTransferTitle.
  ///
  /// In ru, this message translates to:
  /// **'Свободное перемещение'**
  String get movementFreeTransferTitle;

  /// No description provided for @movementFreeTransferSubtitle.
  ///
  /// In ru, this message translates to:
  /// **'Переместить любые объекты в выбранную локацию'**
  String get movementFreeTransferSubtitle;

  /// No description provided for @movementFrom.
  ///
  /// In ru, this message translates to:
  /// **'Откуда'**
  String get movementFrom;

  /// No description provided for @movementTo.
  ///
  /// In ru, this message translates to:
  /// **'Куда'**
  String get movementTo;

  /// No description provided for @movementSubmit.
  ///
  /// In ru, this message translates to:
  /// **'Отправить'**
  String get movementSubmit;

  /// No description provided for @movementTargetLocation.
  ///
  /// In ru, this message translates to:
  /// **'Куда перемещаем?'**
  String get movementTargetLocation;

  /// No description provided for @movementSelectLocation.
  ///
  /// In ru, this message translates to:
  /// **'Выберите локацию'**
  String get movementSelectLocation;

  /// No description provided for @movementLocationRequired.
  ///
  /// In ru, this message translates to:
  /// **'Сначала выберите локацию'**
  String get movementLocationRequired;

  /// No description provided for @movementMove.
  ///
  /// In ru, this message translates to:
  /// **'Переместить'**
  String get movementMove;

  /// No description provided for @movementResultTitle.
  ///
  /// In ru, this message translates to:
  /// **'Результат перемещения'**
  String get movementResultTitle;

  /// No description provided for @movementFailedTitle.
  ///
  /// In ru, this message translates to:
  /// **'Перемещение не выполнено'**
  String get movementFailedTitle;

  /// No description provided for @movementMovedCount.
  ///
  /// In ru, this message translates to:
  /// **'Перемещено объектов: {count}'**
  String movementMovedCount(int count);

  /// No description provided for @movementUnknownTags.
  ///
  /// In ru, this message translates to:
  /// **'Метки не найдены в базе: {count}'**
  String movementUnknownTags(int count);

  /// No description provided for @movementAlreadyHere.
  ///
  /// In ru, this message translates to:
  /// **'Уже в этой локации: {count}'**
  String movementAlreadyHere(int count);

  /// No description provided for @movementBlocked.
  ///
  /// In ru, this message translates to:
  /// **'Нельзя переместить (списаны, в ремонте): {count}'**
  String movementBlocked(int count);

  /// No description provided for @movementNotInSource.
  ///
  /// In ru, this message translates to:
  /// **'Не в исходной локации: {count}'**
  String movementNotInSource(int count);

  /// No description provided for @settingsTitle.
  ///
  /// In ru, this message translates to:
  /// **'Настройки'**
  String get settingsTitle;

  /// No description provided for @settingsLanguage.
  ///
  /// In ru, this message translates to:
  /// **'Язык'**
  String get settingsLanguage;

  /// No description provided for @settingsReaderDiagnostics.
  ///
  /// In ru, this message translates to:
  /// **'Диагностика считывателя'**
  String get settingsReaderDiagnostics;

  /// No description provided for @settingsReaderDiagnosticsSubtitle.
  ///
  /// In ru, this message translates to:
  /// **'Проверка RFID-модуля, мощности и кнопки'**
  String get settingsReaderDiagnosticsSubtitle;

  /// No description provided for @settingsSignOut.
  ///
  /// In ru, this message translates to:
  /// **'Выйти из аккаунта'**
  String get settingsSignOut;

  /// No description provided for @settingsSignOutTitle.
  ///
  /// In ru, this message translates to:
  /// **'Выход из аккаунта'**
  String get settingsSignOutTitle;

  /// No description provided for @settingsSignOutMessage.
  ///
  /// In ru, this message translates to:
  /// **'Вы действительно хотите выйти?'**
  String get settingsSignOutMessage;

  /// No description provided for @settingsSignOutConfirm.
  ///
  /// In ru, this message translates to:
  /// **'Выйти'**
  String get settingsSignOutConfirm;

  /// No description provided for @settingsUnknownUser.
  ///
  /// In ru, this message translates to:
  /// **'Пользователь'**
  String get settingsUnknownUser;

  /// No description provided for @diagnosticsTitle.
  ///
  /// In ru, this message translates to:
  /// **'Диагностика считывателя'**
  String get diagnosticsTitle;

  /// No description provided for @diagnosticsModule.
  ///
  /// In ru, this message translates to:
  /// **'RFID-модуль'**
  String get diagnosticsModule;

  /// No description provided for @diagnosticsModuleReady.
  ///
  /// In ru, this message translates to:
  /// **'Готов к работе'**
  String get diagnosticsModuleReady;

  /// No description provided for @diagnosticsModuleNotReady.
  ///
  /// In ru, this message translates to:
  /// **'Не проверен'**
  String get diagnosticsModuleNotReady;

  /// No description provided for @diagnosticsModuleFailed.
  ///
  /// In ru, this message translates to:
  /// **'Недоступен'**
  String get diagnosticsModuleFailed;

  /// No description provided for @diagnosticsCheckModule.
  ///
  /// In ru, this message translates to:
  /// **'Проверить'**
  String get diagnosticsCheckModule;

  /// No description provided for @diagnosticsPower.
  ///
  /// In ru, this message translates to:
  /// **'Мощность: {dbm} dBm'**
  String diagnosticsPower(int dbm);

  /// No description provided for @diagnosticsPowerRejected.
  ///
  /// In ru, this message translates to:
  /// **'Считыватель не принял мощность'**
  String get diagnosticsPowerRejected;

  /// No description provided for @diagnosticsLastKey.
  ///
  /// In ru, this message translates to:
  /// **'Последняя кнопка: код {code}'**
  String diagnosticsLastKey(int code);

  /// No description provided for @diagnosticsNoKey.
  ///
  /// In ru, this message translates to:
  /// **'Нажмите кнопку на корпусе, чтобы увидеть её код'**
  String get diagnosticsNoKey;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['ru', 'uz'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ru':
      return AppLocalizationsRu();
    case 'uz':
      return AppLocalizationsUz();
  }

  throw FlutterError(
      'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
      'an issue with the localizations generation tool. Please file an issue '
      'on GitHub with a reproducible sample app and the gen-l10n configuration '
      'that was used.');
}
