# lib/app

Ilovani yigʻuvchi qatlam. Featurelar va core shu yerda bir-biriga ulanadi.

| Fayl | Vazifasi |
|---|---|
| `bootstrap.dart` | birinchi kadrdan oldingi hamma narsa: TLS istisnosi, ekran yoʻnalishi, DI, `runApp` |
| `rfid_app.dart` | `MaterialApp.router`: tema, til, router; ilova darajasidagi Bloc'lar (`SessionBloc`, `SettingsBloc`) |
| `di/service_locator.dart` | `get_it` roʻyxatdan oʻtkazishlari. `sl` faqat shu papkada ishlatiladi |
| `router/app_router.dart` | barcha marshrutlar; har ekran Bloc'i shu yerda `BlocProvider` bilan yaratiladi; login redirect |
| `router/stream_listenable.dart` | Bloc oqimini `GoRouter.refreshListenable` ga ulaydi |
| `shell/home_shell_page.dart` | pastki menyu (4 ta tab) |

Kodni oʻqishni `bootstrap.dart` dan, keyin `router/app_router.dart` dan boshlang.
