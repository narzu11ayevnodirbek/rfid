# Backend API

Backend: PHP, standart manzil `https://mderp.uz/` (`--dart-define=API_BASE_URL` bilan o‘zgartiriladi). Barcha yo‘llar `lib/core/network/api_endpoints.dart` da.

> **Holat.** Quyidagi shakllar ilovaning ishlab turgan eski kodidan tiklangan. Ishlab chiquvchining kompyuteri ulangan tarmoq `mderp.uz` ni bloklagani (FortiGuard "Newly Observed Domain") uchun real javoblar bilan solishtirib bo‘lmadi. Ochiq tarmoqda [`tool/api_probe.py`](../tool/api_probe.py) ni ishga tushirib tekshiring (faqat GET so‘rovlar yuboradi) va farq bo‘lsa shu faylni hamda tegishli `*_model.dart` ni yangilang.

## Umumiy qoidalar

**Autentifikatsiya.** Login javobidagi token keyingi har bir so‘rovga `Authorization: Bearer <token>` sarlavhasi bilan qo‘shiladi (`AuthTokenInterceptor`).

**Konvert.** Har bir javob:

```json
{ "success": true,  "data": ... }
{ "success": false, "message": "..." }   // yoki "error"
```

`success` `true` bo‘lmasa, ilova buni xato deb biladi va `message` / `error` / `recommendation` matnini foydalanuvchiga ko‘rsatadi (`ApiEnvelopeParser`).

**HTTP 401** sessiyani tugatadi: ilova login ekraniga qaytadi.

**Turlar.** ID va sanoqlar goh son, goh matn bo‘lib keladi. Ilova ularni `JsonReader` orqali o‘qiydi, shuning uchun ikkalasi ham ishlaydi. Quyida `id` deb yozilgan joyda `"12"` yoki `12` bo‘lishi mumkin.

**So‘rov tanasi** — JSON (`Content-Type: application/json`).

## Auth

### `POST api/auth.php?action=login`

```json
{ "login": "operator", "password": "..." }
```

Javob:

```json
{ "success": true, "token": "...", "user": { "id": "3", "login": "operator", "username": "Ism Familiya" } }
```

`token` bo‘lmasa, javob xato hisoblanadi. Chiqish (logout) endpointi yo‘q — token faqat qurilmadan o‘chiriladi.

## Inventarizatsiya

### `GET api/inventory.php`

`data[]`: `id`, `name` (raqam), `type`, `user_name`, `created_at`, `status_code`, `status_label`, `found`, `not_found`, `total`. Ilova `status_code == "closed"` bo‘lganlarini ko‘rsatmaydi.

### `GET api/inventory_tasks.php?inventory_id={id}`

`data[]`: `id`, `inventory_id`, `location`, `status`, `common_status`, `found`, `total`, `last_name`, `first_name`, `middle_name`.

### `GET api/inventory_get_plan.php?id={inventoryId}`

Kutilgan obyektlar (reja). Maydonlar ildizda (ilova `data` ichida bo‘lsa ham o‘qiydi):

```json
{ "success": true, "inventory_id": 12, "location_name": "Ombor 1",
  "expected_items": [ { "epc": "E280...", "name": "Stol" } ] }
```

Ilova rejani qurilmada saqlaydi; server javob bermasa, saqlangan nusxa ishlatiladi.

### `POST api/inventory_finish.php`

```json
{ "inventory_id": 12, "scanned_items": ["E280...", "..."], "duration_seconds": 340, "device_id": "TSD" }
```

`inventory_id` son sifatida yuboriladi (eski ilova ham shunday yuborgan). Javobdan faqat `success` o‘qiladi.

## Obyektlar katalogi

### `GET api/items.php`

`data[]`: `id`, `name`, `code`, `location`, `responsible`, `rfid` (EPC), `photo_path`, `has_rfid`, `price`, `status`, `created_at`. "Metka bo‘yicha qidirish" butun ro‘yxatni bir marta yuklab, EPC bo‘yicha qurilmaning o‘zida qidiradi (EPC bo‘yicha qidirish endpointi yo‘q).

## Markirovka

### `GET api/markings.php`

`data[]`: `id`, `name`, `type`, `code`, `status`, `description`, `responsible_id`, `responsible_person`, `created_at`, `updated_at`, `closed_at`.

### `GET api/get_marking_tasks_for_mobile.php?marking_id={id}`

`data[]` — topshiriqlar, obyektlari ichida:

```json
{ "id": 10, "marking_id": 3, "name": "...", "status": "...", "executor_name": "...",
  "marked": "0", "total": "2", "items_count": 2, "marked_count": 0,
  "items": [ { "item_id": 100, "name": "Stol", "inventory_number": "INV-100",
               "status": "...", "photo": "uploads/100.jpg", "rfid": "" } ] }
```

Obyektda `item_id` yoki `id`, `inventory_number` yoki `barcode`, `photo` yoki `photo_path` kelishi mumkin — ilova ikkalasini ham qabul qiladi. `rfid` bo‘sh bo‘lmasa, obyekt "bog‘langan" hisoblanadi.

### `GET api/get_marking_items.php?marking_id={id}`

`data[]` — markirovkaning barcha obyektlari. Ilova bu endpointdan faqat obyekt rasmini (`photo` / `photo_path`) topish uchun foydalanadi.

### `POST api/process_marking_scan.php`

```json
{ "marking_id": "3", "task_id": "10", "item_id": "100", "rfid": "E280..." }
```

Xatoda `message` / `error` / `recommendation` ko‘rsatiladi.

## Ko‘chirish

### `GET api/get_movement_tasks_for_mobile.php`

`data[]`: `id`, `movement_id`, `name`, `movement_name`, `status`, `source_location`, `destination`, `executor_name`, `created_at`, `moved`, `total`, `moved_count`, `items_count`, `items[]`.

### `POST api/process_movement_batch.php`

```json
{ "movement_id": 40, "scanned_epcs": ["E280...", "..."] }
```

Javob:

```json
{ "success": true, "message": "...", "moved_count": 3,
  "errors": { "unknown_epcs": ["E2..."], "not_in_source": [ {"name": "..."} ] } }
```

### `GET api/locations.php`

`data[]`: `id`, `name`, `type`, `parent_id`, `path`, `description`. Ro‘yxatda `path` bo‘lsa, o‘sha ko‘rsatiladi.

### `POST api/transfer_free.php`

```json
{ "new_location_id": 9, "scanned_epcs": ["E280..."], "user_id": 12, "timestamp": "2025-03-04 05:06:07" }
```

`timestamp` — UTC. `user_id` — tizimga kirgan foydalanuvchi (eski ilova doim `0` yuborgan). Javob:

```json
{ "success": true, "message": "...", "moved_count": 3,
  "errors": { "unknown_epcs": [...], "already_here": [...], "blocked": [...] } }
```

`errors` ro‘yxatlari elementi matn ham, obyekt ham bo‘lishi mumkin (`name` / `epc` / `item_id` / `status`); ilova ikkalasini matnga aylantiradi.

## Ishlatilmaydigan endpointlar

Eski kodda bor edi, lekin hech qaysi ekrandan chaqirilmasdi, shuning uchun yangi ilovaga olinmagan: `api/process_tsd_scan.php`, `api/transfer_mission_update.php`, `api/process_movement_tsd.php`, `api/movements.php` (GET/POST), `api/get_movement_items.php`, `api/get_inventory_items_for_tsd.php`, `api/inventories.php/inventories`, `api/products.php/products`, `admin_panel_php/pages/get_open_inventory_items.php`.
