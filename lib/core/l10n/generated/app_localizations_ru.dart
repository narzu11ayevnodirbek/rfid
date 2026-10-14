// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Russian (`ru`).
class AppLocalizationsRu extends AppLocalizations {
  AppLocalizationsRu([String locale = 'ru']) : super(locale);

  @override
  String get appTitle => 'RFID Инвентаризация';

  @override
  String get commonRetry => 'Повторить';

  @override
  String get commonCancel => 'Отмена';

  @override
  String get commonOk => 'Понятно';

  @override
  String get commonClose => 'Закрыть';

  @override
  String get commonRemove => 'Удалить';

  @override
  String get commonEmptyList => 'Список пуст';

  @override
  String get commonRefreshFailed => 'Не удалось обновить данные';

  @override
  String get commonSearchByTag => 'Поиск по метке';

  @override
  String commonCreatedAt(String date) {
    return 'Создано: $date';
  }

  @override
  String commonProgress(int done, int total) {
    return '$done из $total';
  }

  @override
  String get failureNetwork =>
      'Нет связи с сервером. Проверьте интернет и повторите.';

  @override
  String get failureUnauthorized => 'Сессия истекла. Войдите снова.';

  @override
  String get failureServer => 'Сервер отклонил запрос.';

  @override
  String failureServerWithCode(int code) {
    return 'Ошибка сервера ($code).';
  }

  @override
  String get failureParsing => 'Сервер вернул непонятный ответ.';

  @override
  String get failureUnexpected => 'Что-то пошло не так. Повторите попытку.';

  @override
  String get failureRfidUnavailable =>
      'RFID-считыватель не найден на этом устройстве.';

  @override
  String get failureRfidInitFailed =>
      'Не удалось включить RFID-считыватель. Перезапустите приложение.';

  @override
  String get failureRfidCommandFailed =>
      'RFID-считыватель не выполнил команду. Повторите попытку.';

  @override
  String get tabInventory => 'Инвентаризация';

  @override
  String get tabMarking => 'Маркировка';

  @override
  String get tabMovement => 'Перемещение';

  @override
  String get tabSettings => 'Настройки';

  @override
  String get loginTitle => 'Вход';

  @override
  String get loginSubtitle => 'Войдите, чтобы продолжить работу';

  @override
  String get loginLoginLabel => 'Логин';

  @override
  String get loginPasswordLabel => 'Пароль';

  @override
  String get loginSubmit => 'Войти';

  @override
  String get loginFieldRequired => 'Заполните поле';

  @override
  String get loginInvalidCredentials => 'Неверный логин или пароль';

  @override
  String get loginShowPassword => 'Показать пароль';

  @override
  String get loginHidePassword => 'Скрыть пароль';

  @override
  String get scanStart => 'Запустить RFID';

  @override
  String get scanStop => 'Остановить';

  @override
  String get scanClear => 'Очистить';

  @override
  String get scanStatusReading => 'Идёт чтение';

  @override
  String get scanStatusArmed => 'Считыватель включён';

  @override
  String get scanStatusIdle => 'Считыватель выключен';

  @override
  String get scanHint =>
      'Нажмите «Запустить RFID» и поднесите устройство к меткам. Кнопка на корпусе тоже включает чтение.';

  @override
  String scanTagCount(int count) {
    return 'Считано меток: $count';
  }

  @override
  String get scanNoTags => 'Пока нет считанных меток';

  @override
  String get scanClearTitle => 'Очистить список?';

  @override
  String get scanClearMessage => 'Все считанные метки будут удалены из списка.';

  @override
  String get scanLeaveTitle => 'Выйти без отправки?';

  @override
  String get scanLeaveMessage =>
      'Считанные метки не отправлены и будут потеряны.';

  @override
  String get scanLeaveConfirm => 'Выйти';

  @override
  String get statTotal => 'Всего';

  @override
  String get statFound => 'Найдено';

  @override
  String get statMissing => 'Не найдено';

  @override
  String get statExtra => 'Лишние';

  @override
  String get statScanned => 'Считано';

  @override
  String get statBound => 'Привязано';

  @override
  String get statUnbound => 'Не привязано';

  @override
  String get inventoryListTitle => 'Инвентаризация';

  @override
  String get inventoryListEmpty => 'Нет активных инвентаризаций';

  @override
  String inventoryNumber(String name) {
    return 'Инвентаризация №$name';
  }

  @override
  String inventoryType(String type) {
    return 'Тип: $type';
  }

  @override
  String get inventoryTasksTitle => 'Задания';

  @override
  String get inventoryTasksEmpty => 'У этой инвентаризации нет заданий';

  @override
  String get inventoryStartScan => 'Начать сканирование';

  @override
  String get inventoryPlanFromCache =>
      'Нет связи с сервером — показан сохранённый план.';

  @override
  String get inventoryPlanEmpty =>
      'Сервер не вернул ожидаемых объектов. Все считанные метки попадут в «Лишние».';

  @override
  String inventoryDraftRestored(int count) {
    return 'Восстановлено из черновика: $count';
  }

  @override
  String get inventorySaveDraft => 'Сохранить черновик';

  @override
  String get inventoryDraftSaved => 'Черновик сохранён';

  @override
  String get inventoryFinish => 'Завершить';

  @override
  String get inventoryFinishTitle => 'Завершить инвентаризацию?';

  @override
  String inventoryFinishMessage(int found, int total, int extra) {
    return 'Найдено $found из $total, лишних меток: $extra. Результат будет отправлен на сервер.';
  }

  @override
  String get inventoryFinished => 'Результаты инвентаризации отправлены';

  @override
  String get inventoryFinishFailed =>
      'Не удалось отправить результаты. Черновик сохранён — отправьте позже.';

  @override
  String get inventoryNothingMissing => 'Все объекты найдены';

  @override
  String get inventoryNothingFound => 'Пока ничего не найдено';

  @override
  String get inventoryNoExtra => 'Лишних меток нет';

  @override
  String get itemLookupTitle => 'Поиск по метке';

  @override
  String get itemLookupEmpty => 'Считайте метку, чтобы увидеть объект';

  @override
  String itemLookupUnknownTags(int count) {
    return 'Метки без объекта в базе: $count';
  }

  @override
  String itemLocation(String location) {
    return 'Место: $location';
  }

  @override
  String itemResponsible(String name) {
    return 'Ответственный: $name';
  }

  @override
  String get markingListTitle => 'Маркировка';

  @override
  String get markingListEmpty => 'Нет маркировок';

  @override
  String get markingTasksTitle => 'Задания маркировки';

  @override
  String get markingTasksEmpty => 'Нет заданий';

  @override
  String get markingItemsEmpty => 'В задании нет объектов';

  @override
  String get markingItemTitle => 'Единица ТМЦ';

  @override
  String get markingItemName => 'Наименование';

  @override
  String get markingItemInventoryNumber => 'Инвентарный номер';

  @override
  String get markingItemStatus => 'Статус';

  @override
  String get markingItemPhoto => 'Фото';

  @override
  String get markingItemBound => 'Метка уже привязана';

  @override
  String get markingLastTag => 'Считанная метка';

  @override
  String get markingBindHint =>
      'Поднесите устройство к метке этого объекта. Будет привязана последняя считанная метка.';

  @override
  String get markingBindSubmit => 'Привязать метку';

  @override
  String get markingTagBound => 'Метка привязана';

  @override
  String get markingBindFailedTitle => 'Не удалось привязать метку';

  @override
  String get movementListTitle => 'Перемещение';

  @override
  String get movementListEmpty => 'Нет заданий на перемещение';

  @override
  String get movementFreeTransferTitle => 'Свободное перемещение';

  @override
  String get movementFreeTransferSubtitle =>
      'Переместить любые объекты в выбранную локацию';

  @override
  String get movementFrom => 'Откуда';

  @override
  String get movementTo => 'Куда';

  @override
  String get movementSubmit => 'Отправить';

  @override
  String get movementTargetLocation => 'Куда перемещаем?';

  @override
  String get movementSelectLocation => 'Выберите локацию';

  @override
  String get movementLocationRequired => 'Сначала выберите локацию';

  @override
  String get movementMove => 'Переместить';

  @override
  String get movementResultTitle => 'Результат перемещения';

  @override
  String get movementFailedTitle => 'Перемещение не выполнено';

  @override
  String movementMovedCount(int count) {
    return 'Перемещено объектов: $count';
  }

  @override
  String movementUnknownTags(int count) {
    return 'Метки не найдены в базе: $count';
  }

  @override
  String movementAlreadyHere(int count) {
    return 'Уже в этой локации: $count';
  }

  @override
  String movementBlocked(int count) {
    return 'Нельзя переместить (списаны, в ремонте): $count';
  }

  @override
  String movementNotInSource(int count) {
    return 'Не в исходной локации: $count';
  }

  @override
  String get settingsTitle => 'Настройки';

  @override
  String get settingsLanguage => 'Язык';

  @override
  String get settingsReaderDiagnostics => 'Диагностика считывателя';

  @override
  String get settingsReaderDiagnosticsSubtitle =>
      'Проверка RFID-модуля, мощности и кнопки';

  @override
  String get settingsSignOut => 'Выйти из аккаунта';

  @override
  String get settingsSignOutTitle => 'Выход из аккаунта';

  @override
  String get settingsSignOutMessage => 'Вы действительно хотите выйти?';

  @override
  String get settingsSignOutConfirm => 'Выйти';

  @override
  String get settingsUnknownUser => 'Пользователь';

  @override
  String get diagnosticsTitle => 'Диагностика считывателя';

  @override
  String get diagnosticsModule => 'RFID-модуль';

  @override
  String get diagnosticsModuleReady => 'Готов к работе';

  @override
  String get diagnosticsModuleNotReady => 'Не проверен';

  @override
  String get diagnosticsCheckModule => 'Проверить';

  @override
  String diagnosticsPower(int dbm) {
    return 'Мощность: $dbm dBm';
  }

  @override
  String get diagnosticsPowerRejected => 'Считыватель не принял мощность';

  @override
  String diagnosticsLastKey(int code) {
    return 'Последняя кнопка: код $code';
  }

  @override
  String get diagnosticsNoKey =>
      'Нажмите кнопку на корпусе, чтобы увидеть её код';
}
