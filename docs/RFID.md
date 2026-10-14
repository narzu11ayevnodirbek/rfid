# RFID oʻquvchi

## Qurilma va SDK

- Chainway UHF terminallari (`com.rscja.deviceapi.RFIDWithUHFUART`).
- SDK: `android/app/libs/DeviceAPI_ver20250209_release.aar`, `android/app/build.gradle` da ulangan.
- Release build'da R8 SDK klasslarini kesib tashlamasligi uchun: `android/app/proguard-rules.pro`.

## Kod qayerda

| Qism | Fayl | Vazifasi |
|---|---|---|
| Kotlin | `android/.../MainActivity.kt` | kanalni yaratadi, fizik tugmalarni va lifecycle'ni uzatadi |
| Kotlin | `android/.../rfid/UhfReader.kt` | SDK oʻrami: init, quvvat, oʻqish, "armed" holati |
| Kotlin | `android/.../rfid/RfidChannel.kt` | MethodChannel / EventChannel shartnomasi |
| Kotlin | `android/.../rfid/TriggerKeys.kt` | trigger hisoblanadigan tugma kodlari |
| Dart | `lib/core/rfid/rfid_reader.dart` | oʻquvchi shartnomasi va hodisalar |
| Dart | `lib/core/rfid/platform_rfid_reader.dart` | shartnomaning kanal orqali amalga oshirilishi |
| Dart | `lib/core/rfid/fake_rfid_reader.dart` | testlar va `FAKE_RFID=true` uchun soxta oʻquvchi |
| Dart | `lib/core/rfid/tag_scan_session.dart` | bitta ekranning skan sessiyasi |
| Dart | `lib/core/rfid/rfid_scan_settings.dart` | quvvat profillari va "Boshlash" xulqi |

## Ikki holat: "armed" va "reading"

- **Armed** — foydalanuvchi ilovada "RFID ni yoqish" ni bosgan. Shu holatda fizik trigger ishlaydi.
- **Reading** — radio ayni damda metka oʻqiyapti.

`RfidScanSettings.readImmediatelyOnStart = true` (standart): "RFID ni yoqish" bosilganda oʻqish darhol boshlanadi. Trigger qoʻyib yuborilganda oʻqish toʻxtaydi, qayta bosilganda yana boshlanadi. `false` qilinsa, tugma faqat triggerni "armed" qiladi va metkalar trigger bosib turilganda oʻqiladi.

## Kanal shartnomasi

### Metodlar — `uz.tatu.rfid/reader`

| Metod | Argumentlar | Javob |
|---|---|---|
| `initialize` | — | `true`; xato kodlari `UNAVAILABLE` (Chainway emas yoki SDK yoʻq), `INIT_FAILED` (modul yoqilmadi). Modul fon oqimida yoqiladi |
| `setPower` | `dbm: int` (5–30) | modul qabul qildimi (`bool`) |
| `startScanning` | `readImmediately: bool` | trigger "armed" boʻldimi (`bool`) |
| `stopScanning` | — | `true`; oʻqishni toʻxtatadi, triggerni oʻchiradi |
| `setKeyEventReporting` | `enabled: bool` | `true`; diagnostika uchun tugma hodisalarini yoqadi |
| `release` | — | `true`; modulni oʻchiradi |
| boshqa | — | `notImplemented` |

### Hodisalar — `uz.tatu.rfid/reader_events`

Har biri bitta map:

| `type` | Maydonlar | Qachon |
|---|---|---|
| `tag` | `epc: String` | metka oʻqildi; har EPC bitta oʻqish davrida bir marta keladi |
| `reading` | `value: bool` | radio yoqildi/oʻchdi (tugma, trigger, ilova fonga oʻtdi) |
| `key` | `code: int`, `down: bool` | tugma bosildi/qoʻyib yuborildi (faqat `setKeyEventReporting` yoqilganda) |

Dart tomonida EventChannel'ga faqat bitta obuna bor (`PlatformRfidReader`), u hodisalarni hamma ekranlarga tarqatadi. EPC'lar Dart'ga kirishda `Epc.normalize` bilan (trim + katta harf) bir xil shaklga keltiriladi.

### Lifecycle

- Ilova fonga oʻtsa (`onPause`) radio toʻxtaydi, trigger "armed" boʻlib qoladi.
- Activity yopilsa (`onDestroy`) modul oʻchiriladi (`free()`).
- Skan ekrani yopilganda uning Bloc'i `TagScanSession.dispose()` ni chaqiradi — oʻquvchi toʻxtaydi.

## Quvvat

`lib/core/rfid/rfid_scan_settings.dart`:

| Profil | dBm | Nega |
|---|---|---|
| `inventory` | 30 | butun xonani sanash |
| `movement` | 18 | faqat koʻchirilayotgan obyektlar, atrofdagi javon emas |
| `marking` | 15 | qurilmaga yaqin turgan bitta metka |
| `itemLookup` | 15 | oldingizdagi obyekt |
| `diagnostics` | 26 | diagnostika ekranida slayder bilan oʻzgartiriladi |

## Yangi model terminalini qoʻshish

1. Ilovada **Sozlamalar → Oʻquvchi diagnostikasi** ni oching.
2. Korpusdagi trigger tugmasini bosing — ekranda uning kodi chiqadi.
3. Kodni `android/.../rfid/TriggerKeys.kt` ga qoʻshing.

## Qurilmada tekshirish

Kod emulyator va unit testlarda tekshirilgan, lekin haqiqiy terminalda sinalmagan. Yangi versiyani tarqatishdan oldin terminalda shu roʻyxatni oʻting:

1. **Diagnostika → Tekshirish**: "Ishlashga tayyor" chiqadi.
2. **Quvvat slayderi**: qiymatni oʻzgartiring — "quvvatni qabul qilmadi" ogohlantirishi chiqmasligi kerak.
3. **RFID ni yoqish**: metkalar roʻyxatga tushadi, indikator "Oʻqilmoqda".
4. **Trigger**: tugmani qoʻyib yuboring — oʻqish toʻxtaydi; bosing — davom etadi. Diagnostikada tugma kodi koʻrinadi.
5. **Toʻxtatish**: oʻqish toʻxtaydi, trigger endi hech narsa qilmaydi.
6. **Ekrandan chiqish** skan paytida: oʻquvchi toʻxtashi kerak (boshqa ekranda metka oʻqilmaydi).
7. **Ekranni oʻchirish / boshqa ilovaga oʻtish** skan paytida: "Oʻqilmoqda" indikatori oʻchadi.
8. **Ilovani yopib qayta ochish**: diagnostika yana "tayyor" deydi.
9. **Inventarizatsiya**: bitta haqiqiy inventarizatsiyani yakunlang; serverda natija toʻgʻri chiqqanini tekshiring.
10. **Markirovka**: bitta obyektga metka bogʻlang; serverda shu obyektga aynan shu EPC yozilganini tekshiring.
11. **Koʻchirish**: topshiriq boʻyicha va erkin koʻchirishni bir martadan bajaring, natija oynasini va serverdagi joylashuvni tekshiring.
12. **Release APK** (`flutter build apk --release`) bilan 1–3-bandlarni takrorlang — R8 SDK'ni buzmaganini koʻrsatadi.

## Eski versiyadan farqlar

- Kanal nomlari oʻzgardi: `rfid_channel` → `uz.tatu.rfid/reader`, `rfid_event_channel` → `uz.tatu.rfid/reader_events`. Hodisalar endi faqat EPC matni emas, `type` li map.
- Hech qachon chaqirilmagan `singleShot` rejimi va `writeEpc` stub'i olib tashlandi.
- Tugmani bosib turganda takroriy (`repeatCount > 0`) hodisalar eʼtiborga olinmaydi.
- `init` asosiy oqimni bloklamaydi; xato boʻlsa aniq kod qaytadi va ilova yiqilmaydi.
