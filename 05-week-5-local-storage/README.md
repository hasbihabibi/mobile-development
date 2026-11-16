# Laporan Praktikum Modul 05: Local Storage Dasar

- **Nama**: Muhammad Hasbiallah Habibi
- **NIM**: 362558302135
- **Kelas / Prodi**: 2C / Sarjana Terapan TRPL
- **Mata Kuliah**: Pemrograman Perangkat Bergerak (Semester 3)

---

## 1. Ringkasan Implementasi
Pada praktikum Modul 05 ini, aplikasi Tugas Praktikum dibangun untuk mempelajari mekanisme penyimpanan lokal yang persisten menggunakan `SharedPreferences` (Fase A). Berbeda dengan *memory-based state* pada modul sebelumnya yang datanya menguap saat aplikasi ditutup, data aplikasi ini diubah menjadi *String JSON* dan dipertahankan di dalam disk perangkat. UI juga dirancang asinkron dengan 4 keadaan (Memuat, Gagal, Kosong, Berhasil) untuk mengantisipasi jeda waktu baca-tulis *I/O*. Konsep dasar CRUD (Create, Read, Update, Delete) berhasil direpresentasikan sepenuhnya di sisi klien tanpa bantuan *database engine*. 

## 2. Bukti Tangkapan Layar (4 Keadaan UI)
| Keadaan Memuat (Loading) | Keadaan Berhasil (Success) | Keadaan Kosong (Empty) | Keadaan Gagal (Error) |
|---|---|---|---|
| ![Loading](./screenshots/loading.png) | ![Success](./screenshots/success.png) | ![Empty](./screenshots/empty.png) | ![Error](./screenshots/error.png) |

---

## 3. Jawaban Pertanyaan Refleksi

**1. Migrasi Data (Fase A JSON vs Fase B SQLite)**
Pada Fase A, hal yang menjadi **lebih mudah** adalah saat kita perlu menambah *field* baru pada model (contoh: `prioritas`). Kita tidak memerlukan langkah migrasi atau perintah khusus; cukup menambahkan *field* tersebut pada `fromJson` dan memberikan nilai cadangan (default) agar data JSON lama tetap bisa dibaca. Sebaliknya, hal yang **lebih sulit** di Fase A adalah saat kita harus meng-update sebagian kecil data (misalnya mengubah 1 status), karena sistem harus mengurai (*decode*) JSON dari awal ke akhir, mengubah 1 objek di memori, dan menulis ulang seluruh JSON kembali. Pada Fase B, hal yang **lebih mudah** adalah mengubah/menghapus 1 baris tugas (karena SQLite mendukung query spesifik `UPDATE/DELETE WHERE id = ?`). Namun, hal yang menjadi **lebih sulit** adalah saat ada penambahan *field* baru, karena kita dipaksa menjalankan langkah migrasi eksplisit (`ALTER TABLE`) dan mengatur versi skema yang ketat di metode `onUpgrade` agar perangkat lama tidak mengalami benturan tipe data (*crash*).

**2. Melempar FormatException vs Mengembalikan Daftar Kosong []**
Fungsi `TaskStorage.muat()` dirancang untuk sengaja melempar `FormatException` saat JSON rusak, agar kerusakan data dapat ditangkap secara asinkron lalu diteruskan ke fungsi `_buildGagal()`. Jika keputusan sebaliknya diambil—yaitu secara diam-diam membuang *error* dengan sintaks `catch (e) { return <Task>[]; }`—maka sistem justru akan menipu pengguna (*silent failure*). Pengalaman pengguna akan menjadi sangat fatal: pengguna melihat pesan UI "Belum ada tugas" (Keadaan Kosong) dan menyimpulkan bahwa semua catatannya sudah hilang secara alamiah. Pengguna tidak akan tahu bahwa datanya sebenarnya masih tersimpan di *disk* namun hanya gagal ter-parsing, dan mereka kehilangan kesempatan untuk memulihkan (*recover*) data rusak tersebut.

**3. Urutan `_simpanDaftar` (UI dahulu vs Disk dahulu)**
Pada `_simpanDaftar`, alur logika sengaja mengatur perubahan disuntikkan ke UI terlebih dahulu (`setState`) sebelum menunggu *disk I/O* selesai (`await _storage.simpan`). Pendekatan ini (*Optimistic UI Updates*) dipilih agar layar bereaksi instan merespon interaksi pengguna, memberikan kesan cepat tanpa membiarkan aplikasi terasa macet sesaat (lag). Jika tiba-tiba penulisan disk ditolak, fungsi baru akan menggulung balik (rollback) *state* layar tersebut. Namun, **urutan sebaliknya (menunggu penulisan disk selesai baru meng-update layar)** akan jauh lebih tepat jika operasi tersebut memanipulasi *data yang sangat krusial di sisi server/database pusat*, seperti transaksi transfer bank, pembayaran keranjang belanja, atau klaim tiket masuk.

**4. Biaya operasi jika data mencapai Sepuluh Ribu (Fase A vs Fase B)**
Jika jumlah tugas membengkak, tiga operasi pada Fase A yang biayanya akan tumbuh drastis secara linear seiring pertumbuhan data (O(n)) adalah:
a) **Menghitung total tugas**, karena `SharedPreferences` tidak bisa menghitung panjang *List*; semua data harus dibaca utuh dari string JSON menjadi memori, baru dihitung panjang *List*-nya.
b) **Memfilter dan mengurutkan**, karena harus memuat JSON mentah dan mengeksekusi metode `.where()` dan `.sort()` di layer memori aplikasi Dart.
c) **Menyimpan perubahan (Toggle / Add)**, karena menambah satu tugas kecil tetap akan memaksa *engine* mengubah sisa 10.000 objek lainnya menjadi String besar (`jsonEncode`) lalu meng-override keseluruhan file.
Dalam SQLite, beban ini diatasi secara mandiri di belakang layar oleh *Database Engine*. Untuk menghitung jumlah data, SQLite cukup mengirim perintah `SELECT COUNT(*)`; untuk mengurutkan, cukup `ORDER BY`; dan untuk mengubah data cukup `UPDATE ... WHERE id = ?`. Operasi tersebut diselesaikan tanpa harus mentransfer 10.000 objek melintasi memori RAM.

**5. Risiko pelebaran metode spesifik di TaskRepository**
Metode khusus implementasi (misalnya `cariDenganKataKunci()` yang murni membutuhkan sintaks spesifik `LIKE %...%` pada SQL) tidak boleh ditambahkan ke dalam `TaskRepository`. Risiko terbesarnya adalah jika metode itu dideklarasikan, maka *SharedPreferences* akan dipaksa menulis operasi pencarian manual yang lamban dan mengotori arsitektur; atau terpaksa membiarkan metodenya kosong (*UnimplementedError*) sehingga melanggar kontrak abstraksi antarmuka (Polymorphism Liskov). Oleh karena itulah Modul merekomendasikan Fase B dipelajari *setelah* Fase A tamat: hal ini dilakukan agar mahasiswa merasakan penderitaan dan batas limitasi penyimpanan Kunci-Nilai JSON sederhana terlebih dahulu, barulah menyadari kebutuhan absolut dari *Database Relasional* saat aplikasinya mendadak membutuhkan Query Kompleks, Agregasi, relasi, maupun filter spesifik.