# Arxitektura

Bu hujjat loyihaga yangi qoʻshilgan dasturchi uchun: kod qayerda turadi, qaysi qoidaga amal qiladi va yangi ekran yoki feature qanday qoʻshiladi.

## Qatlamlar va bogʻliqlik qoidasi

```
lib/app/        → features/ va core/ ni biladi (yigʻuvchi qatlam)
lib/features/x/ → core/ ni biladi; boshqa featurelarni bilmaydi*
lib/core/       → hech bir featureni bilmaydi
```

\* Istisno: `settings` va `auth` sessiya Bloc'ini birgalikda ishlatadi (`SessionBloc` ilova darajasida).

Har bir feature ichida:

```
features/<nom>/
  data/
    datasources/   HTTP yoki qurilmadagi saqlash bilan gaplashadi; xatoda exception otadi
    models/        entity'dan meros oladi + fromJson (va kerak boʻlsa toJson)
    repositories/  domain interfeysini amalga oshiradi; exception → Result
  domain/
    entities/      sof Dart klasslari (Equatable), Flutter importisiz
    repositories/  interfeys: Bloc faqat shuni biladi
  presentation/
    bloc/          <ekran>_bloc.dart, _event.dart, _state.dart
    pages/         <ekran>_page.dart — faqat layout
    widgets/       sahifani boʻlaklari
```

Qoida bitta: **Bloc → Repository interfeysi.** Bloc Dio, Hive yoki `sl` ni bilmaydi. Sof hisob-kitob (masalan, inventarizatsiya natijasini hisoblash) `domain/entities/` dagi oddiy klassda yashaydi — `inventory_reconciliation.dart` ga qarang. Faqat chaqiruvni uzatib qoʻyadigan "use case" klasslari yozilmaydi.

## Maʼlumot oqimi: bitta soʻrov misolida

```
InventoryListPage
  └─ ListBlocView<InventoryListBloc, Inventory>     (core/widgets)
       └─ InventoryListBloc.load()                   (ListBloc → LoadBloc)
            └─ InventoryRepository.getActiveInventories()
                 └─ guard(() => InventoryRemoteDataSource.getInventories())
                      └─ ApiClient.get('api/inventory.php')
                           └─ ApiEnvelopeParser: success == true ? body : throw ApiException
```

Javob `Result<List<Inventory>>` boʻlib qaytadi, Bloc uni `LoadState` ga aylantiradi (`LoadInProgress` / `LoadSuccess` / `LoadFailure`), `LoadStateView` esa spinner, xato yoki roʻyxatni chizadi.

## Xatolar

| Qayerda | Nima |
|---|---|
| Datasource | Exception otadi: `DioException`, `ApiException` (server `success: false` qaytardi), `FormatException` (tushunarsiz javob) |
| Repository | Har chaqiruvni `guard()` ichida bajaradi → `Success(value)` yoki `Failed(failure)` |
| Bloc | `Failure` ni holatga yozadi; hech qachon matn emas |
| UI | `failure.localizedMessage(l10n)` — ru/uz matn (`core/l10n/failure_localizer.dart`) |

`Failure` turlari (`core/error/failure.dart`): `NetworkFailure`, `UnauthorizedFailure`, `ServerFailure(message)`, `ParsingFailure`, `RfidFailure(reason)`, `UnexpectedFailure`. Server yuborgan xabar (`message`/`error`) foydalanuvchiga oʻzgarishsiz koʻrsatiladi.

Barcha JSON maydonlar `JsonReader` orqali oʻqiladi: PHP backend bir xil maydonni goh `"12"`, goh `12`, goh `null` qilib yuboradi, `JsonReader` esa bularning hammasini xavfsiz oʻqiydi.

## State management (Bloc)

- Har ekranning oʻz Bloc'i bor, u marshrutda `BlocProvider` bilan yaratiladi va ekran yopilganda yopiladi (`lib/app/router/app_router.dart`).
- Holatlar oʻzgarmas, `Equatable`, `copyWith` bilan yangilanadi.
- Serverdan yuklanadigan ekranlar umumiy bazadan meros oladi:
  - `ListBloc<T>` — roʻyxat; sahifada `ListBlocView` bilan chiziladi.
  - `LoadBloc<T>` — bitta qiymat; sahifada `LoadBlocView` bilan chiziladi.
  - Ikkalasi ham yuklash, qayta urinish, pastga tortib yangilash va "maʼlumot oʻzgardi → qayta yukla" (`invalidations`) ni oʻzi qiladi.
- Bir martalik amallar (yuborish) uchun `SubmitStatus` (`idle → submitting → succeeded/failed`). Sahifa uning oʻzgarishini `BlocListener` da tinglaydi: muvaffaqiyatda yopiladi, xatoda oyna koʻrsatadi. **Bloc hech qachon navigatsiya qilmaydi va dialog ochmaydi.**
- Tasdiqlash kerak boʻlgan tugmalar `confirmThen(...)` dan foydalanadi (`core/widgets/confirm_dialog.dart`), shuning uchun sahifada `if` yozilmaydi.
- Bir ekran ikkinchisidagi oʻzgarishni bilishi kerak boʻlsa (masalan, metka bogʻlangach topshiriqlar roʻyxati yangilanishi), repository `changes` oqimiga signal beradi va roʻyxat Bloc'i oʻzi qayta yuklanadi. Sahifalarda "qaytganda yangila" logikasi yoʻq.

## RFID

- `core/rfid/rfid_reader.dart` — oʻquvchi shartnomasi. `PlatformRfidReader` haqiqiy qurilma uchun, `FakeRfidReader` testlar va `FAKE_RFID=true` uchun.
- EventChannel'ga **faqat bitta** obuna bor (`PlatformRfidReader` ichida). Ekranlar oʻquvchiga toʻgʻridan-toʻgʻri tegmaydi.
- Har skan Bloc'i `TagScanSession` ga ega: boshlash/toʻxtatish, quvvatni qoʻllash, dublikatlarni olib tashlash, haptik. Bloc `close()` da `session.dispose()` ni chaqiradi — ekran yopilsa oʻquvchi albatta toʻxtaydi.
- EPC har doim `Epc.normalize` (trim + katta harf) shaklida.
- Quvvat va "Boshlash" xulqi bitta faylda: `core/rfid/rfid_scan_settings.dart`.
- Kotlin tomoni va kanal shartnomasi: [RFID.md](RFID.md).

## Navigatsiya

- Barcha manzillar `core/routing/app_routes.dart` da (`AppRoutes.inventoryScan(id)` kabi). Sahifa `context.push(AppRoutes...)` qiladi.
- Marshrutlar faqat ID olib yuradi — `extra` yoki `dynamic` yoʻq. Ekran kerakli maʼlumotni oʻz repository'sidan oladi.
- Sessiya: `SessionStorage` (core) → `SessionBloc` → `GoRouter.redirect`. Token yoʻq boʻlsa yoki server 401 qaytarsa, foydalanuvchi login ekraniga oʻtadi; tarmoq qatlami UI haqida hech narsa bilmaydi.
- Pastki menyu (`app/shell/home_shell_page.dart`) — `StatefulShellRoute`: har tab oʻz holatini saqlaydi.

## Dependency injection

`get_it` faqat `lib/app/` ichida ishlatiladi (`app/di/service_locator.dart`). Boshqa hamma joyda bogʻliqliklar konstruktor orqali keladi — shuning uchun hamma narsani testda soxtasi bilan almashtirish oson.

## UI

- `core/theme/app_theme.dart` — Material vidjetlar (tugma, karta, input, appbar, navigatsiya) uslubi shu yerda. Sahifalarda rang, shrift oʻlchami yoki radius yozilmaydi.
- `core/theme/app_colors.dart` — brend rangi va `StatusColors` (success / warning / danger / info / neutral). Vidjetda: `context.statusColors.foreground(StatusTone.success)`.
- `core/theme/app_spacing.dart` — `AppSpacing`, `AppRadius`, `AppSizes`.
- `core/widgets/` — umumiy vidjetlar: `ListCard`, `StatTile`, `StatusBadge`, `ScanControlBar`, `ScannedTagTile`, `InfoBanner`, `LoadStateView`, `ListBlocView`, dialoglar, snackbar.

## Lokalizatsiya

1. Matnni `lib/core/l10n/arb/app_ru.arb` ga (shablon) va `app_uz.arb` ga qoʻshing.
2. `flutter gen-l10n` (yoki oddiy `flutter run`) klasslarni qayta yaratadi.
3. Kodda: `context.l10n.kalitNomi`.

Generatsiya qilingan fayllar (`lib/core/l10n/generated/`) repoda turadi, shunda loyiha klon qilingandan keyin darhol analiz qilinadi.

## Fayl nomlash

- Nom faylning vazifasini aytadi: `inventory_scan_page.dart`, `inventory_remote_data_source.dart`, `marking_tag_bind_bloc.dart`.
- Bitta fayl — bitta asosiy klass. Bloc uchta faylda: `_bloc.dart` (+ `part` sifatida `_event.dart`, `_state.dart`).
- `utils`, `helpers`, `base`, `new_feature` kabi umumiy nomlar ishlatilmaydi.
- Testlar `lib/` tuzilmasini takrorlaydi: `test/features/inventory/...`.

## Yangi feature qoʻshish (retsept)

Misol: "Hisobotlar" boʻlimi, `GET api/reports.php`.

1. **Endpoint**: `core/network/api_endpoints.dart` ga `static const reports = 'api/reports.php';`. Javob shaklini [API.md](API.md) ga yozing.
2. **Entity**: `features/reports/domain/entities/report.dart` — sof Dart, `Equatable`.
3. **Repository interfeysi**: `features/reports/domain/repositories/report_repository.dart` — `Future<Result<List<Report>>> getReports();`.
4. **Model**: `features/reports/data/models/report_model.dart` — `class ReportModel extends Report` + `factory ReportModel.fromJson(JsonMap json)` (`JsonReader` bilan).
5. **Datasource**: `features/reports/data/datasources/report_remote_data_source.dart` — `_api.get(ApiEndpoints.reports)` → modellar roʻyxati.
6. **Repository**: `features/reports/data/repositories/report_repository_impl.dart` — `guard(_remote.getReports)`.
7. **Bloc**: roʻyxat boʻlsa — `class ReportListBloc extends ListBloc<Report>`, faqat `load()` ni yozasiz.
8. **Sahifa**: `features/reports/presentation/pages/report_list_page.dart` — `ListBlocView<ReportListBloc, Report>` + karta vidjeti.
9. **Matnlar**: ARB fayllariga.
10. **DI**: `app/di/service_locator.dart` ga `_registerReports()`.
11. **Marshrut**: `core/routing/app_routes.dart` ga manzil, `app/router/app_router.dart` ga `GoRoute` (Bloc shu yerda `BlocProvider` bilan yaratiladi).
12. **Testlar**: model (`fromJson`), repository (soxta datasource bilan), Bloc (`bloc_test`).

Skan qiladigan ekran boʻlsa, Bloc'ga `TagScanSession` qoʻshing (masalan, `movement_scan_bloc.dart` ga qarang) va sahifada `ScanControlBar` ishlating.

## Testlar

| Nima | Qayerda | Qanday |
|---|---|---|
| JSON va xatolar | `test/core/` | oddiy unit testlar |
| Bloc'lar | `test/features/*/` | `bloc_test`, `mocktail` bilan soxta repository, `FakeRfidReader` |
| Sahifalar | `test/app/pages_smoke_test.dart` | `MockBloc` bilan holatlarni chizish va eventlarni tekshirish |

Har PR'dan oldin: `flutter analyze` (0 ta muammo) va `flutter test`.
