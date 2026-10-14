# lib/core

Featurelar umumiy foydalanadigan kod. Bu yerdagi hech narsa biror featureni import qilmaydi.

| Papka | Ichida |
|---|---|
| `config/` | `AppConfig`: backend manzili va `--dart-define` bayroqlari |
| `network/` | `ApiClient` (yagona Dio), `ApiEndpoints`, `ApiEnvelopeParser` (`success` konverti), `JsonReader` (string/int aralash JSON), token interceptor, TLS istisnosi |
| `error/` | `Failure` turlari, `Result` (`Success`/`Failed`), `guard()` — exception'larni failure'ga aylantiradigan yagona joy |
| `session/` | `SessionStorage` (token + foydalanuvchi, oʻzgarishlar oqimi), `User` |
| `storage/` | `KeyValueStore` interfeysi, Hive va xotiradagi amalga oshirilishi |
| `rfid/` | `RfidReader` (platforma va soxta), `TagScanSession`, `Epc`, quvvat profillari |
| `bloc/` | `LoadBloc` / `ListBloc`, `LoadState`, `SubmitStatus` |
| `routing/` | `AppRoutes` — barcha ekran manzillari |
| `theme/` | `AppTheme`, ranglar (`StatusColors`), oraliqlar |
| `widgets/` | umumiy vidjetlar: kartalar, holat koʻrinishlari, skan paneli, dialoglar |
| `l10n/` | ARB matnlar (ru — shablon, uz), generatsiya qilingan klasslar, `FailureLocalizer`, `AppLanguage` |

Batafsil: [docs/ARCHITECTURE.md](../../docs/ARCHITECTURE.md).
