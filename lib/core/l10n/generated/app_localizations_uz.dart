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
  String get commonRemove => 'O‘chirish';

  @override
  String get commonRefreshFailed => 'Ma’lumotlarni yangilab bo‘lmadi';

  @override
  String get commonSearchByTag => 'Metka bo‘yicha qidirish';

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
      'Server bilan aloqa yo‘q. Internetni tekshirib, qayta urinib ko‘ring.';

  @override
  String get failureUnauthorized => 'Sessiya tugadi. Qaytadan kiring.';

  @override
  String get failureServer => 'Server so‘rovni rad etdi.';

  @override
  String failureServerWithCode(int code) {
    return 'Server xatosi ($code).';
  }

  @override
  String get failureParsing => 'Server tushunarsiz javob qaytardi.';

  @override
  String get failureUnexpected =>
      'Nimadir noto‘g‘ri ketdi. Qayta urinib ko‘ring.';

  @override
  String get failureRfidUnavailable => 'Bu qurilmada RFID o‘quvchi topilmadi.';

  @override
  String get failureRfidInitFailed =>
      'RFID o‘quvchini yoqib bo‘lmadi. Ilovani qayta ishga tushiring.';

  @override
  String get failureRfidCommandFailed =>
      'RFID o‘quvchi buyruqni bajarmadi. Qayta urinib ko‘ring.';

  @override
  String get tabInventory => 'Inventarizatsiya';

  @override
  String get tabMarking => 'Markirovka';

  @override
  String get tabMovement => 'Ko‘chirish';

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
  String get loginFieldRequired => 'Maydonni to‘ldiring';

  @override
  String get loginInvalidCredentials => 'Login yoki parol noto‘g‘ri';

  @override
  String get loginShowPassword => 'Parolni ko‘rsatish';

  @override
  String get loginHidePassword => 'Parolni yashirish';

  @override
  String get scanStart => 'RFID ni yoqish';

  @override
  String get scanStop => 'To‘xtatish';

  @override
  String get scanClear => 'Tozalash';

  @override
  String get scanStatusReading => 'O‘qilmoqda';

  @override
  String get scanStatusArmed => 'O‘quvchi yoqilgan';

  @override
  String get scanStatusIdle => 'O‘quvchi o‘chiq';

  @override
  String get scanHint =>
      '«RFID ni yoqish» tugmasini bosing va qurilmani metkalarga yaqinlashtiring. Korpusdagi tugma ham o‘qishni yoqadi.';

  @override
  String scanTagCount(int count) {
    return 'O‘qilgan metkalar: $count';
  }

  @override
  String get scanNoTags => 'Hozircha o‘qilgan metkalar yo‘q';

  @override
  String get scanClearTitle => 'Ro‘yxat tozalansinmi?';

  @override
  String get scanClearMessage =>
      'Barcha o‘qilgan metkalar ro‘yxatdan o‘chiriladi.';

  @override
  String get scanLeaveTitle => 'Yubormasdan chiqilsinmi?';

  @override
  String get scanLeaveMessage => 'O‘qilgan metkalar yuborilmagan va yo‘qoladi.';

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
  String get statBound => 'Bog‘langan';

  @override
  String get statUnbound => 'Bog‘lanmagan';

  @override
  String get inventoryListTitle => 'Inventarizatsiya';

  @override
  String get inventoryListEmpty => 'Faol inventarizatsiyalar yo‘q';

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
  String get inventoryTasksEmpty => 'Bu inventarizatsiyada topshiriqlar yo‘q';

  @override
  String get inventoryStartScan => 'Skanerlashni boshlash';

  @override
  String get inventoryPlanFromCache =>
      'Server bilan aloqa yo‘q — saqlangan reja ko‘rsatilmoqda.';

  @override
  String get inventoryPlanEmpty =>
      'Server kutilgan obyektlarni qaytarmadi. Barcha o‘qilgan metkalar «Ortiqcha»ga tushadi.';

  @override
  String inventoryDraftRestored(int count) {
    return 'Qoralamadan tiklandi: $count';
  }

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
      'Natijalarni yuborib bo‘lmadi. Qoralama saqlandi — keyinroq yuboring.';

  @override
  String get inventoryNothingMissing => 'Barcha obyektlar topildi';

  @override
  String get inventoryNothingFound => 'Hozircha hech narsa topilmadi';

  @override
  String get inventoryNoExtra => 'Ortiqcha metkalar yo‘q';

  @override
  String get itemLookupTitle => 'Metka bo‘yicha qidirish';

  @override
  String get itemLookupEmpty => 'Obyektni ko‘rish uchun metkani o‘qing';

  @override
  String itemLookupUnknownTags(int count) {
    return 'Bazada obyekti yo‘q metkalar: $count';
  }

  @override
  String itemLocation(String location) {
    return 'Joyi: $location';
  }

  @override
  String itemResponsible(String name) {
    return 'Mas’ul: $name';
  }

  @override
  String get markingListTitle => 'Markirovka';

  @override
  String get markingListEmpty => 'Markirovkalar yo‘q';

  @override
  String get markingTasksTitle => 'Markirovka topshiriqlari';

  @override
  String get markingTasksEmpty => 'Topshiriqlar yo‘q';

  @override
  String get markingItemsEmpty => 'Topshiriqda obyektlar yo‘q';

  @override
  String get markingItemTitle => 'TMQ birligi';

  @override
  String get markingItemName => 'Nomi';

  @override
  String get markingItemInventoryNumber => 'Inventar raqami';

  @override
  String get markingItemStatus => 'Holati';

  @override
  String get markingItemBound => 'Metka allaqachon bog‘langan';

  @override
  String get markingLastTag => 'O‘qilgan metka';

  @override
  String get markingBindHint =>
      'Qurilmani shu obyekt metkasiga yaqinlashtiring. Oxirgi o‘qilgan metka bog‘lanadi.';

  @override
  String get markingBindSubmit => 'Metkani bog‘lash';

  @override
  String get markingTagBound => 'Metka bog‘landi';

  @override
  String get markingBindFailedTitle => 'Metkani bog‘lab bo‘lmadi';

  @override
  String get movementListTitle => 'Ko‘chirish';

  @override
  String get movementListEmpty => 'Ko‘chirish topshiriqlari yo‘q';

  @override
  String get movementFreeTransferTitle => 'Erkin ko‘chirish';

  @override
  String get movementFreeTransferSubtitle =>
      'Istalgan obyektlarni tanlangan joyga ko‘chirish';

  @override
  String get movementFrom => 'Qayerdan';

  @override
  String get movementTo => 'Qayerga';

  @override
  String get movementSubmit => 'Yuborish';

  @override
  String get movementTargetLocation => 'Qayerga ko‘chiramiz?';

  @override
  String get movementSelectLocation => 'Joyni tanlang';

  @override
  String get movementLocationRequired => 'Avval joyni tanlang';

  @override
  String get movementMove => 'Ko‘chirish';

  @override
  String get movementResultTitle => 'Ko‘chirish natijasi';

  @override
  String get movementFailedTitle => 'Ko‘chirish bajarilmadi';

  @override
  String movementMovedCount(int count) {
    return 'Ko‘chirilgan obyektlar: $count';
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
    return 'Ko‘chirib bo‘lmaydi (hisobdan chiqarilgan, ta’mirda): $count';
  }

  @override
  String movementNotInSource(int count) {
    return 'Boshlang‘ich joyda emas: $count';
  }

  @override
  String get settingsTitle => 'Sozlamalar';

  @override
  String get settingsLanguage => 'Til';

  @override
  String get settingsReaderDiagnostics => 'O‘quvchi diagnostikasi';

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
  String get diagnosticsTitle => 'O‘quvchi diagnostikasi';

  @override
  String get diagnosticsModule => 'RFID modul';

  @override
  String get diagnosticsModuleReady => 'Ishlashga tayyor';

  @override
  String get diagnosticsModuleNotReady => 'Tekshirilmagan';

  @override
  String get diagnosticsModuleFailed => 'Mavjud emas';

  @override
  String get diagnosticsCheckModule => 'Tekshirish';

  @override
  String diagnosticsPower(int dbm) {
    return 'Quvvat: $dbm dBm';
  }

  @override
  String get diagnosticsPowerRejected => 'O‘quvchi quvvatni qabul qilmadi';

  @override
  String diagnosticsLastKey(int code) {
    return 'Oxirgi tugma: kod $code';
  }

  @override
  String get diagnosticsNoKey =>
      'Kodini ko‘rish uchun korpusdagi tugmani bosing';
}
