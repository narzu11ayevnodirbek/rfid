# lib/features

Har papka — foydalanuvchi koʻradigan bitta boʻlim. Hammasi bir xil tuzilgan:

```
<feature>/
  data/          datasources (HTTP, qurilma), models (JSON), repositories (amalga oshirish)
  domain/        entities (sof Dart), repositories (interfeys)
  presentation/  bloc (event/state), pages (faqat layout), widgets
```

| Feature | Ekranlar |
|---|---|
| `auth/` | login; `SessionBloc` — kim tizimda ekani |
| `inventory/` | inventarizatsiyalar roʻyxati → tafsilot (topshiriqlar) → reja bilan skan |
| `marking/` | markirovkalar → topshiriqlar → obyektlar → metka bogʻlash |
| `movement/` | koʻchirish topshiriqlari → paketli skan; erkin koʻchirish |
| `item_lookup/` | metka boʻyicha obyektni topish |
| `settings/` | til, oʻquvchi diagnostikasi, chiqish |

Yangi feature qoʻshish retsepti: [docs/ARCHITECTURE.md](../../docs/ARCHITECTURE.md#yangi-feature-qoʻshish-retsept).
