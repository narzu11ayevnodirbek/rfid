// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Uzbek (`uz`).
class AppLocalizationsUz extends AppLocalizations {
  AppLocalizationsUz([String locale = 'uz']) : super(locale);

  @override
  String get appTitle => 'RFID Inventarizatsiya';

  @override
  String get commonRetry => 'Qayta urinish';

  @override
  String get commonCancel => 'Bekor qilish';

  @override
  String get commonOk => 'Tushunarli';

  @override
  String get commonClose => 'Yopish';

  @override
  String get commonRemove => 'Oʻchirish';

  @override
  String get commonEmptyList => 'Roʻyxat boʻsh';

  @override
  String get commonRefreshFailed => 'Maʼlumotlarni yangilab boʻlmadi';

  @override
  String get commonSearchByTag => 'Metka boʻyicha qidirish';

  @override
  String commonCreatedAt(String date) {
    return 'Yaratilgan: $date';
  }

  @override
  String commonProgress(int done, int total) {
    return '$total tadan $done';
  }

  @override
  String get failureNetwork =>
      'Server bilan aloqa yoʻq. Internetni tekshirib, qayta urinib koʻring.';

  @override
  String get failureUnauthorized => 'Sessiya tugadi. Qaytadan kiring.';

  @override
  String get failureServer => 'Server soʻrovni rad etdi.';

  @override
  String failureServerWithCode(int code) {
    return 'Server xatosi ($code).';
  }

  @override
  String get failureParsing => 'Server tushunarsiz javob qaytardi.';

  @override
  String get failureUnexpected =>
      'Nimadir notoʻgʻri ketdi. Qayta urinib koʻring.';

  @override
  String get failureRfidUnavailable => 'Bu qurilmada RFID oʻquvchi topilmadi.';

  @override
  String get failureRfidInitFailed =>
      'RFID oʻquvchini yoqib boʻlmadi. Ilovani qayta ishga tushiring.';

  @override
  String get failureRfidCommandFailed =>
      'RFID oʻquvchi buyruqni bajarmadi. Qayta urinib koʻring.';

  @override
  String get tabInventory => 'Inventarizatsiya';

  @override
  String get tabMarking => 'Markirovka';

  @override
  String get tabMovement => 'Koʻchirish';

  @override
  String get tabSettings => 'Sozlamalar';

  @override
  String get loginTitle => 'Kirish';

  @override
  String get loginSubtitle => 'Ishni davom ettirish uchun tizimga kiring';

  @override
  String get loginLoginLabel => 'Login';

  @override
  String get loginPasswordLabel => 'Parol';

  @override
  String get loginSubmit => 'Kirish';

  @override
  String get loginFieldRequired => 'Maydonni toʻldiring';

  @override
  String get loginInvalidCredentials => 'Login yoki parol notoʻgʻri';

  @override
  String get loginShowPassword => 'Parolni koʻrsatish';

  @override
  String get loginHidePassword => 'Parolni yashirish';

  @override
  String get scanStart => 'RFID ni yoqish';

  @override
  String get scanStop => 'Toʻxtatish';

  @override
  String get scanClear => 'Tozalash';

  @override
  String get scanStatusReading => 'Oʻqilmoqda';

  @override
  String get scanStatusArmed => 'Oʻquvchi yoqilgan';

  @override
  String get scanStatusIdle => 'Oʻquvchi oʻchiq';

  @override
  String get scanHint =>
      '«RFID ni yoqish» tugmasini bosing va qurilmani metkalarga yaqinlashtiring. Korpusdagi tugma ham oʻqishni yoqadi.';

  @override
  String scanTagCount(int count) {
    return 'Oʻqilgan metkalar: $count';
  }

  @override
  String get scanNoTags => 'Hozircha oʻqilgan metkalar yoʻq';

  @override
  String get scanClearTitle => 'Roʻyxat tozalansinmi?';

  @override
  String get scanClearMessage =>
      'Barcha oʻqilgan metkalar roʻyxatdan oʻchiriladi.';

  @override
  String get scanLeaveTitle => 'Yubormasdan chiqilsinmi?';

  @override
  String get scanLeaveMessage => 'Oʻqilgan metkalar yuborilmagan va yoʻqoladi.';

  @override
  String get scanLeaveConfirm => 'Chiqish';

  @override
  String get statTotal => 'Jami';

  @override
  String get statFound => 'Topildi';

  @override
  String get statMissing => 'Topilmadi';

  @override
  String get statExtra => 'Ortiqcha';

  @override
  String get statScanned => 'Oʻqildi';

  @override
  String get statBound => 'Bogʻlangan';

  @override
  String get statUnbound => 'Bogʻlanmagan';

  @override
  String get inventoryListTitle => 'Inventarizatsiya';

  @override
  String get inventoryListEmpty => 'Faol inventarizatsiyalar yoʻq';

  @override
  String inventoryNumber(String name) {
    return 'Inventarizatsiya №$name';
  }

  @override
  String inventoryType(String type) {
    return 'Turi: $type';
  }

  @override
  String get inventoryTasksTitle => 'Topshiriqlar';

  @override
  String get inventoryTasksEmpty => 'Bu inventarizatsiyada topshiriqlar yoʻq';

  @override
  String get inventoryStartScan => 'Skanerlashni boshlash';

  @override
  String get inventoryPlanFromCache =>
      'Server bilan aloqa yoʻq — saqlangan reja koʻrsatilmoqda.';

  @override
  String get inventoryPlanEmpty =>
      'Server kutilgan obyektlarni qaytarmadi. Barcha oʻqilgan metkalar «Ortiqcha»ga tushadi.';

  @override
  String inventoryDraftRestored(int count) {
    return 'Qoralamadan tiklandi: $count';
  }

  @override
  String get inventorySaveDraft => 'Qoralamani saqlash';

  @override
  String get inventoryDraftSaved => 'Qoralama saqlandi';

  @override
  String get inventoryFinish => 'Yakunlash';

  @override
  String get inventoryFinishTitle => 'Inventarizatsiya yakunlansinmi?';

  @override
  String inventoryFinishMessage(int found, int total, int extra) {
    return '$total tadan $found tasi topildi, ortiqcha metkalar: $extra. Natija serverga yuboriladi.';
  }

  @override
  String get inventoryFinished => 'Inventarizatsiya natijalari yuborildi';

  @override
  String get inventoryFinishFailed =>
      'Natijalarni yuborib boʻlmadi. Qoralama saqlandi — keyinroq yuboring.';

  @override
  String get inventoryNothingMissing => 'Barcha obyektlar topildi';

  @override
  String get inventoryNothingFound => 'Hozircha hech narsa topilmadi';

  @override
  String get inventoryNoExtra => 'Ortiqcha metkalar yoʻq';

  @override
  String get itemLookupTitle => 'Metka boʻyicha qidirish';

  @override
  String get itemLookupEmpty => 'Obyektni koʻrish uchun metkani oʻqing';

  @override
  String itemLookupUnknownTags(int count) {
    return 'Bazada obyekti yoʻq metkalar: $count';
  }

  @override
  String itemLocation(String location) {
    return 'Joyi: $location';
  }

  @override
  String itemResponsible(String name) {
    return 'Masʼul: $name';
  }

  @override
  String get markingListTitle => 'Markirovka';

  @override
  String get markingListEmpty => 'Markirovkalar yoʻq';

  @override
  String get markingTasksTitle => 'Markirovka topshiriqlari';

  @override
  String get markingTasksEmpty => 'Topshiriqlar yoʻq';

  @override
  String get markingItemsEmpty => 'Topshiriqda obyektlar yoʻq';

  @override
  String get markingItemTitle => 'TMQ birligi';

  @override
  String get markingItemName => 'Nomi';

  @override
  String get markingItemInventoryNumber => 'Inventar raqami';

  @override
  String get markingItemStatus => 'Holati';

  @override
  String get markingItemPhoto => 'Rasm';

  @override
  String get markingItemBound => 'Metka allaqachon bogʻlangan';

  @override
  String get markingLastTag => 'Oʻqilgan metka';

  @override
  String get markingBindHint =>
      'Qurilmani shu obyekt metkasiga yaqinlashtiring. Oxirgi oʻqilgan metka bogʻlanadi.';

  @override
  String get markingBindSubmit => 'Metkani bogʻlash';

  @override
  String get markingTagBound => 'Metka bogʻlandi';

  @override
  String get markingBindFailedTitle => 'Metkani bogʻlab boʻlmadi';

  @override
  String get movementListTitle => 'Koʻchirish';

  @override
  String get movementListEmpty => 'Koʻchirish topshiriqlari yoʻq';

  @override
  String get movementFreeTransferTitle => 'Erkin koʻchirish';

  @override
  String get movementFreeTransferSubtitle =>
      'Istalgan obyektlarni tanlangan joyga koʻchirish';

  @override
  String get movementFrom => 'Qayerdan';

  @override
  String get movementTo => 'Qayerga';

  @override
  String get movementSubmit => 'Yuborish';

  @override
  String get movementTargetLocation => 'Qayerga koʻchiramiz?';

  @override
  String get movementSelectLocation => 'Joyni tanlang';

  @override
  String get movementLocationRequired => 'Avval joyni tanlang';

  @override
  String get movementMove => 'Koʻchirish';

  @override
  String get movementResultTitle => 'Koʻchirish natijasi';

  @override
  String get movementFailedTitle => 'Koʻchirish bajarilmadi';

  @override
  String movementMovedCount(int count) {
    return 'Koʻchirilgan obyektlar: $count';
  }

  @override
  String movementUnknownTags(int count) {
    return 'Bazada topilmagan metkalar: $count';
  }

  @override
  String movementAlreadyHere(int count) {
    return 'Allaqachon shu joyda: $count';
  }

  @override
  String movementBlocked(int count) {
    return 'Koʻchirib boʻlmaydi (hisobdan chiqarilgan, taʼmirda): $count';
  }

  @override
  String movementNotInSource(int count) {
    return 'Boshlangʻich joyda emas: $count';
  }

  @override
  String get settingsTitle => 'Sozlamalar';

  @override
  String get settingsLanguage => 'Til';

  @override
  String get settingsReaderDiagnostics => 'Oʻquvchi diagnostikasi';

  @override
  String get settingsReaderDiagnosticsSubtitle =>
      'RFID modul, quvvat va tugmani tekshirish';

  @override
  String get settingsSignOut => 'Akkauntdan chiqish';

  @override
  String get settingsSignOutTitle => 'Akkauntdan chiqish';

  @override
  String get settingsSignOutMessage => 'Haqiqatan ham chiqmoqchimisiz?';

  @override
  String get settingsSignOutConfirm => 'Chiqish';

  @override
  String get settingsUnknownUser => 'Foydalanuvchi';

  @override
  String get diagnosticsTitle => 'Oʻquvchi diagnostikasi';

  @override
  String get diagnosticsModule => 'RFID modul';

  @override
  String get diagnosticsModuleReady => 'Ishlashga tayyor';

  @override
  String get diagnosticsModuleNotReady => 'Tekshirilmagan';

  @override
  String get diagnosticsCheckModule => 'Tekshirish';

  @override
  String diagnosticsPower(int dbm) {
    return 'Quvvat: $dbm dBm';
  }

  @override
  String get diagnosticsPowerRejected => 'Oʻquvchi quvvatni qabul qilmadi';

  @override
  String diagnosticsLastKey(int code) {
    return 'Oxirgi tugma: kod $code';
  }

  @override
  String get diagnosticsNoKey =>
      'Kodini koʻrish uchun korpusdagi tugmani bosing';
}
