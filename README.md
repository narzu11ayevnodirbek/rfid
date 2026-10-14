# RFID Inventarizatsiya

Chainway UHF terminallari (TSD) uchun Flutter ilovasi. Omborchi yoki mas’ul xodim qurilma bilan xonalarni aylanib, RFID metkalarni o‘qiydi; ilova natijani `mderp.uz` backendiga yuboradi.

Ilova faqat Android uchun. Rus va o‘zbek tillarida ishlaydi.

## Imkoniyatlar

| Bo‘lim | Nima qiladi |
|---|---|
| **Inventarizatsiya** | Faol inventarizatsiyalar ro‘yxati, topshiriqlar bo‘yicha progress. Skan paytida serverdagi reja bilan jonli solishtiradi: *topildi*, *topilmadi*, *ortiqcha*. Reja qurilmada keshlanadi (internet bo‘lmasa ham ishlaydi), o‘qilgan metkalar har o‘zgarishda qoralama sifatida saqlanadi. |
| **Markirovka** | Markirovka → topshiriq → obyekt. Obyekt sahifasida metka o‘qiladi va tasdiqlangandan keyin obyektga bog‘lanadi. |
| **Ko‘chirish** | Topshiriq bo‘yicha paketli ko‘chirish va topshiriqsiz "erkin ko‘chirish" (joyni tanlab). Server qaytargan muammolar (noma’lum metka, bloklangan obyekt, ...) bitta oynada ko‘rsatiladi. |
| **Metka bo‘yicha qidirish** | Metkani o‘qing — qaysi obyektga tegishli ekanini ko‘rasiz. |
| **Sozlamalar** | Til (ru/uz), o‘quvchi diagnostikasi (modul, quvvat, fizik tugma kodi), akkauntdan chiqish. |

## Texnologiyalar

| Vazifa | Paket |
|---|---|
| State management | [`flutter_bloc`](https://pub.dev/packages/flutter_bloc) (Bloc + Event + State) |
| Navigatsiya | [`go_router`](https://pub.dev/packages/go_router) |
| Dependency injection | [`get_it`](https://pub.dev/packages/get_it) |
| HTTP | [`dio`](https://pub.dev/packages/dio) |
| Qurilmadagi saqlash | [`hive`](https://pub.dev/packages/hive) |
| Lokalizatsiya | Flutter `gen-l10n` (ARB fayllar) |
| RFID | Chainway DeviceAPI (`android/app/libs/*.aar`), Kotlin orqali |
| Testlar | `flutter_test`, `bloc_test`, `mocktail` |

Flutter 3.41 / Dart 3.11 da tekshirilgan.

## Tez boshlash

```sh
flutter pub get
flutter run                              # Chainway terminalida
flutter run --dart-define=FAKE_RFID=true # emulyator yoki oddiy telefonda
```

`FAKE_RFID=true` bilan haqiqiy o‘quvchi o‘rniga soxtasi ishlaydi: "RFID ni yoqish" bosilganda bir necha namunaviy metka "o‘qiladi". Shu bilan barcha ekranlarni terminalsiz ko‘rish mumkin.

### Sozlash (`--dart-define`)

| Nomi | Standart | Ma’nosi |
|---|---|---|
| `API_BASE_URL` | `https://mderp.uz/` | Backend manzili, oxirida `/` bo‘lishi shart |
| `TRUST_API_HOST_CERTIFICATE` | `true` | API hostining tekshirib bo‘lmaydigan TLS sertifikatini qabul qilish. Serverda to‘g‘ri sertifikat o‘rnatilgach `false` qiling |
| `FAKE_RFID` | `false` | Soxta RFID o‘quvchi |

Hammasi bitta faylda: [`lib/core/config/app_config.dart`](lib/core/config/app_config.dart).

### Build

```sh
flutter build apk --release                 # bitta "fat" APK (~57 MB, barcha ABI)
flutter build apk --release --split-per-abi # har ABI uchun alohida, ancha kichik
```

Chainway terminallari `arm64-v8a` yoki `armeabi-v7a`; odatda `app-arm64-v8a-release.apk` yetarli.

> Release hozircha debug kalit bilan imzolanadi (`android/app/build.gradle`). Do‘konga yoki keng tarqatishdan oldin o‘z keystore'ingizni sozlang.

## Arxitektura qisqacha

Har bir feature uch qatlamdan iborat, bog‘liqlik faqat ichkariga qarab yo‘nalgan:

```mermaid
flowchart LR
  Page["Page<br/>(faqat layout)"] -- event --> Bloc
  Bloc -- state --> Page
  Bloc --> Repo["Repository<br/>(interfeys, domain)"]
  RepoImpl["RepositoryImpl<br/>(data)"] -. implements .-> Repo
  RepoImpl --> Remote["RemoteDataSource"] --> Api["ApiClient (Dio)"]
  RepoImpl --> Local["LocalDataSource"] --> Store["KeyValueStore (Hive)"]
  Bloc --> Scan["TagScanSession"] --> Reader["RfidReader"] --> Kotlin["Kotlin / Chainway SDK"]
```

- **Sahifalarda logika yo‘q.** Sahifa faqat chizadi va Bloc'ga event yuboradi.
- **Xatolar bitta joyda tutiladi.** Datasource exception otadi, repository uni `Result`/`Failure` ga aylantiradi (`guard()`), Bloc holatga yozadi, UI tarjima qilingan matn ko‘rsatadi.
- **Barcha skan ekranlari bir xil.** Har skan Bloc'i umumiy `TagScanSession` dan foydalanadi; ekran yopilganda o‘quvchi kafolatli to‘xtaydi.
- **UI bir joydan boshqariladi.** Ranglar, oraliqlar va Material vidjetlar uslubi `lib/core/theme/` da, umumiy vidjetlar `lib/core/widgets/` da.

Batafsil: [docs/ARCHITECTURE.md](docs/ARCHITECTURE.md).

## Papkalar

```
lib/
  main.dart            → app/bootstrap.dart ni chaqiradi
  app/                 ilovani yig‘ish: DI, router, pastki menyu
  core/                featurelar umumiy foydalanadigan narsalar
    config/            sozlamalar (--dart-define)
    network/           ApiClient, endpointlar, JSON o‘qish
    error/             Result, Failure, guard()
    session/           token va foydalanuvchi
    storage/           KeyValueStore (Hive)
    rfid/              RfidReader, TagScanSession, quvvat profillari
    bloc/              LoadBloc / ListBloc, LoadState, SubmitStatus
    routing/           barcha ekran manzillari (AppRoutes)
    theme/             rang, oraliq, AppTheme
    widgets/           umumiy vidjetlar
    l10n/              ru/uz matnlar (ARB) va generatsiya qilingan klasslar
  features/
    auth/  inventory/  marking/  movement/  item_lookup/  settings/
android/app/src/main/kotlin/.../rfid/   Chainway SDK bilan ishlovchi Kotlin kod
docs/                  arxitektura, API, RFID qo‘llanmalari
test/                  lib/ tuzilmasini takrorlaydi
```

## Testlar va tekshiruv

```sh
flutter analyze   # 0 ta ogohlantirish bo‘lishi kerak
flutter test
```

Testlar: JSON parsing, xatolarni tutish, sessiya, RFID sessiyasi, har bir Bloc (soxta repository va soxta o‘quvchi bilan), router qoidasi va asosiy sahifalar uchun widget smoke-testlar.

Real terminalda tekshirish ro‘yxati: [docs/RFID.md](docs/RFID.md#qurilmada-tekshirish).

## Hujjatlar

- [docs/ARCHITECTURE.md](docs/ARCHITECTURE.md) — qatlamlar, qoidalar, yangi feature qo‘shish qo‘llanmasi
- [docs/API.md](docs/API.md) — backend endpointlari: so‘rov va javob shakllari
- [docs/RFID.md](docs/RFID.md) — Dart ↔ Kotlin kanal shartnomasi, trigger, quvvat, diagnostika
- [lib/app/README.md](lib/app/README.md), [lib/core/README.md](lib/core/README.md), [lib/features/README.md](lib/features/README.md)
