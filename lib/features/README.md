# lib/features

Har papka — foydalanuvchi ko‘radigan bitta bo‘lim. Hammasi bir xil tuzilgan:

```
<feature>/
  data/          datasources (HTTP, qurilma), models (JSON), repositories (amalga oshirish)
  domain/        entities (sof Dart), repositories (interfeys)
  presentation/  bloc (event/state), pages (faqat layout), widgets
```

| Feature | Ekranlar |
|---|---|
| `auth/` | login; `SessionBloc` — kim tizimda ekani |
| `inventory/` | inventarizatsiyalar ro‘yxati → tafsilot (topshiriqlar) → reja bilan skan |
| `marking/` | markirovkalar → topshiriqlar → obyektlar → metka bog‘lash |
| `movement/` | ko‘chirish topshiriqlari → paketli skan; erkin ko‘chirish |
| `item_lookup/` | metka bo‘yicha obyektni topish |
| `settings/` | til, o‘quvchi diagnostikasi, chiqish |

Yangi feature qo‘shish retsepti: [docs/ARCHITECTURE.md](../../docs/ARCHITECTURE.md#yangi-feature-qo‘shish-retsept).
