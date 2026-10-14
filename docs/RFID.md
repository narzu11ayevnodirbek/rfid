# RFID o‘quvchi

## Qurilma va SDK

- Chainway UHF terminallari (`com.rscja.deviceapi.RFIDWithUHFUART`).
- SDK: `android/app/libs/DeviceAPI_ver20250209_release.aar`, `android/app/build.gradle` da ulangan.
- Release build'da R8 SDK klasslarini kesib tashlamasligi uchun: `android/app/proguard-rules.pro`.

## Kod qayerda

| Qism | Fayl | Vazifasi |
|---|---|---|
| Kotlin | `android/.../MainActivity.kt` | kanalni yaratadi, fizik tugmalarni va lifecycle'ni uzatadi |
| Kotlin | `android/.../rfid/UhfReader.kt` | SDK o‘rami: init, quvvat, o‘qish, "armed" holati |
| Kotlin | `android/.../rfid/RfidChannel.kt` | MethodChannel / EventChannel shartnomasi |
| Kotlin | `android/.../rfid/TriggerKeys.kt` | trigger hisoblanadigan tugma kodlari |
| Dart | `lib/core/rfid/rfid_reader.dart` | o‘quvchi shartnomasi va hodisalar |
| Dart | `lib/core/rfid/platform_rfid_reader.dart` | shartnomaning kanal orqali amalga oshirilishi |
| Dart | `lib/core/rfid/fake_rfid_reader.dart` | testlar va `FAKE_RFID=true` uchun soxta o‘quvchi |
| Dart | `lib/core/rfid/tag_scan_session.dart` | bitta ekranning skan sessiyasi |
| Dart | `lib/core/rfid/rfid_scan_settings.dart` | quvvat profillari va "Boshlash" xulqi |

## Ikki holat: "armed" va "reading"

- **Armed** — foydalanuvchi ilovada "RFID ni yoqish" ni bosgan. Shu holatda fizik trigger ishlaydi.
- **Reading** — radio ayni damda metka o‘qiyapti.

`RfidScanSettings.readImmediatelyOnStart = true` (standart): "RFID ni yoqish" bosilganda o‘qish darhol boshlanadi. Trigger qo‘yib yuborilganda o‘qish to‘xtaydi, qayta bosilganda yana boshlanadi. `false` qilinsa, tugma faqat triggerni "armed" qiladi va metkalar trigger bosib turilganda o‘qiladi.

## Kanal shartnomasi

### Metodlar — `uz.tatu.rfid/reader`

| Metod | Argumentlar | Javob |
|---|---|---|
| `initialize` | — | `true`; xato kodlari `UNAVAILABLE` (Chainway emas yoki SDK yo‘q), `INIT_FAILED` (modul yoqilmadi). Modul fon oqimida yoqiladi |
| `setPower` | `dbm: int` (5–30) | modul qabul qildimi (`bool`) |
| `startScanning` | `readImmediately: bool` | trigger "armed" bo‘ldimi (`bool`) |
| `stopScanning` | — | `true`; o‘qishni to‘xtatadi, triggerni o‘chiradi |
| `setKeyEventReporting` | `enabled: bool` | `true`; diagnostika uchun tugma hodisalarini yoqadi |
| `release` | — | `true`; modulni o‘chiradi |
| boshqa | — | `notImplemented` |

### Hodisalar — `uz.tatu.rfid/reader_events`

Har biri bitta map:

| `type` | Maydonlar | Qachon |
|---|---|---|
| `tag` | `epc: String` | metka o‘qildi; har EPC bitta o‘qish davrida bir marta keladi |
| `reading` | `value: bool` | radio yoqildi/o‘chdi (tugma, trigger, ilova fonga o‘tdi) |
| `key` | `code: int`, `down: bool` | tugma bosildi/qo‘yib yuborildi (faqat `setKeyEventReporting` yoqilganda) |

Dart tomonida EventChannel'ga faqat bitta obuna bor (`PlatformRfidReader`), u hodisalarni hamma ekranlarga tarqatadi. EPC'lar Dart'ga kirishda `Epc.normalize` bilan (trim + katta harf) bir xil shaklga keltiriladi.

### Lifecycle

- Ilova fonga o‘tsa (`onPause`) radio to‘xtaydi, trigger "armed" bo‘lib qoladi.
- Activity yopilsa (`onDestroy`) modul o‘chiriladi (`free()`).
- Skan ekrani yopilganda uning Bloc'i `TagScanSession.dispose()` ni chaqiradi — o‘quvchi to‘xtaydi.

## Quvvat

`lib/core/rfid/rfid_scan_settings.dart`:

| Profil | dBm | Nega |
|---|---|---|
| `inventory` | 30 | butun xonani sanash |
| `movement` | 18 | faqat ko‘chirilayotgan obyektlar, atrofdagi javon emas |
| `marking` | 15 | qurilmaga yaqin turgan bitta metka |
| `itemLookup` | 15 | oldingizdagi obyekt |
| `diagnostics` | 26 | diagnostika ekranida slayder bilan o‘zgartiriladi |

## Yangi model terminalini qo‘shish

1. Ilovada **Sozlamalar → O‘quvchi diagnostikasi** ni oching.
2. Korpusdagi trigger tugmasini bosing — ekranda uning kodi chiqadi.
3. Kodni `android/.../rfid/TriggerKeys.kt` ga qo‘shing.

## Qurilmada tekshirish

Kod emulyator va unit testlarda tekshirilgan, lekin haqiqiy terminalda sinalmagan. Yangi versiyani tarqatishdan oldin terminalda shu ro‘yxatni o‘ting:

1. **Diagnostika → Tekshirish**: "Ishlashga tayyor" chiqadi.
2. **Quvvat slayderi**: qiymatni o‘zgartiring — "quvvatni qabul qilmadi" ogohlantirishi chiqmasligi kerak.
3. **RFID ni yoqish**: metkalar ro‘yxatga tushadi, indikator "O‘qilmoqda".
4. **Trigger**: tugmani qo‘yib yuboring — o‘qish to‘xtaydi; bosing — davom etadi. Diagnostikada tugma kodi ko‘rinadi.
5. **To‘xtatish**: o‘qish to‘xtaydi, trigger endi hech narsa qilmaydi.
6. **Ekrandan chiqish** skan paytida: o‘quvchi to‘xtashi kerak (boshqa ekranda metka o‘qilmaydi).
7. **Ekranni o‘chirish / boshqa ilovaga o‘tish** skan paytida: "O‘qilmoqda" indikatori o‘chadi.
8. **Ilovani yopib qayta ochish**: diagnostika yana "tayyor" deydi.
9. **Inventarizatsiya**: bitta haqiqiy inventarizatsiyani yakunlang; serverda natija to‘g‘ri chiqqanini tekshiring.
10. **Markirovka**: bitta obyektga metka bog‘lang; serverda shu obyektga aynan shu EPC yozilganini tekshiring.
11. **Ko‘chirish**: topshiriq bo‘yicha va erkin ko‘chirishni bir martadan bajaring, natija oynasini va serverdagi joylashuvni tekshiring.
12. **Release APK** (`flutter build apk --release`) bilan 1–3-bandlarni takrorlang — R8 SDK'ni buzmaganini ko‘rsatadi.

## Eski versiyadan farqlar

- Kanal nomlari o‘zgardi: `rfid_channel` → `uz.tatu.rfid/reader`, `rfid_event_channel` → `uz.tatu.rfid/reader_events`. Hodisalar endi faqat EPC matni emas, `type` li map.
- Hech qachon chaqirilmagan `singleShot` rejimi va `writeEpc` stub'i olib tashlandi.
- Tugmani bosib turganda takroriy (`repeatCount > 0`) hodisalar e’tiborga olinmaydi.
- `init` asosiy oqimni bloklamaydi; xato bo‘lsa aniq kod qaytadi va ilova yiqilmaydi.
