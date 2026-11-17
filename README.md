# nim_latres_D - Toko Awikwok

Latihan Responsi Praktikum Mobile SI-D. Data produk diambil dari dari
`https://dummyjson.com/products`.

## Library
| Library | Fungsi |
|---|---|
| `http` | Request ke API eksternal |
| `shared_preferences` | Menyimpan session (username) agar tidak login ulang |
| `hive` + `hive_flutter` | Database lokal untuk Cart (per username) |

## Struktur Folder
```
lib/
├── main.dart                  # Entry point: init Hive, cek session, tentukan halaman awal
├── models/
│   └── product.dart           # Model Product + fromJson
├── services/
│   ├── api_service.dart       # GET produk dari API (http)
│   ├── session_service.dart   # Simpan/ambil/hapus username (SharedPreferences)
│   └── cart_service.dart      # CRUD cart di Hive (key: username_idProduk)
└── pages/
    ├── login_page.dart        # Login (username bebas, password = NIM)
    ├── main_page.dart         # Bottom navigation bar (Home, Profile)
    ├── home_page.dart         # Info username, tombol cart, list produk
    ├── detail_page.dart       # Detail produk, qty (0 < qty <= stok), Add to Cart
    ├── cart_page.dart         # List cart milik user yang login + hapus item + total
    └── profile_page.dart      # Info username, deskripsi, tombol logout
```

## Alur Aplikasi
1. App dibuka -> `main.dart` cek SharedPreferences. Ada username -> `MainPage`, tidak ada -> `LoginPage`.
2. Login berhasil -> username disimpan ke session -> `MainPage`.
3. Home mengambil produk via API -> tap item -> Detail.
4. Add to Cart -> disimpan ke Hive dengan data `username`, produk, dan `qty`.
5. Cart hanya menampilkan item yang `username`-nya sama dengan user yang login.
6. Logout -> session dihapus -> kembali ke Login (data cart tetap tersimpan per user).

## Cara Menjalankan
```
flutter pub get
flutter run
```
