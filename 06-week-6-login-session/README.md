# Laporan Praktikum Modul 06: Login & Session Dasar

- **Nama**: Muhammad Hasbiallah Habibi
- **NIM**: 362558302135
- **Kelas / Prodi**: 2C / Sarjana Terapan TRPL
- **Mata Kuliah**: Pemrograman Perangkat Bergerak (Semester 3)

---

## 1. Ringkasan Implementasi
Pada praktikum Modul 06 (Fase A) ini, aplikasi dibangun untuk mensimulasikan alur autentikasi secara lengkap mencakup validasi form lokal, proteksi *double-submit*, mesin keadaan (state machine) dengan 5 *state* (memeriksa, keluar, memproses, masuk, gagal), dan manajemen sesi *in-memory*. Berbeda dengan modul sebelumnya, penyimpanan *token* pada fase ini dipertahankan secara murni di dalam variabel `SesiMemori` yang mengikat umur datanya pada memori proses. Tujuannya adalah membuktikan secara empiris bahwa data sesi yang tidak diproteksi oleh *secure storage* (penyimpanan aman milik sistem operasi) akan langsung musnah (menguap) seketika *lifecycle* aplikasi dihentikan sepenuhnya melalui *app switcher*.

## 2. Bukti Tangkapan Layar Alur Autentikasi
| Keadaan Keluar (Form) | Keadaan Masuk (Beranda Sesi) | Keadaan Gagal (Error) |
|---|---|---|
| ![Keluar](./screenshots/keluar.png) | ![Masuk](./screenshots/masuk.png) | ![Gagal](./screenshots/gagal.png) |

---

## 3. Jawaban Pertanyaan Refleksi

**1. Pertanyaan baru setelah sesi mulai bertahan (Fase A ke Fase B)**
Setelah kita sadar sesi perlu bertahan melintasi proses aplikasi (*persisted*), muncul satu pertanyaan teknis paling esensial: *"Di mana letak penyimpanan yang tepat agar token tidak bisa diekstrak oleh aplikasi lain atau malware?"* Di Fase A, pertanyaan ini tidak pernah ditanyakan karena variabel *RAM* relatif terisolasi oleh sistem operasi selama *runtime*. Namun, saat memutuskan menuliskannya secara permanen ke disk, kita dipaksa mengevaluasi celah keamanan *SharedPreferences* yang rentan dibaca mentah (plain text) dibandingkan *Secure Storage* (Keystore/Keychain) yang dienkripsi oleh OS.

**2. Kesalahpahaman tombol kembali (Back button) vs Menutup Aplikasi**
Banyak yang mengira menekan tombol kembali (*back/swipe edge*) berarti "menutup/mematikan" aplikasi. Padahal, tindakan itu seringkali hanya menghancurkan layar (UI) dan memindahkan aplikasi ke latar belakang (background), sementara proses memori utamanya masih hidup. Jika developer menggunakan kesalahpahaman ini untuk menguji ketahanan `SesiMemori`, mereka akan keliru menyimpulkan bahwa data sesi mereka "berhasil bertahan permanen". Validasi baru terbukti jika aplikasi benar-benar di-*kill* dari *app switcher* lalu dibuka ulang.

**3. Pertimbangan privasi pada pesan "Email atau kata sandi salah"**
Secara sengaja *tidak menyebutkan field mana yang keliru* (menyembunyikan fakta apakah email terdaftar atau sandinya yang salah) sangat menguntungkan pengguna dari sisi keamanan (meski sedikit mengurangi kenyamanan UX). Hal ini dinamakan proteksi terhadap *Account Enumeration*. Jika API membedakan pesannya menjadi "Email tidak terdaftar", penyerang/bot bisa melakukan *brute force* ribuan email acak secara cepat untuk memanen direktori pengguna sah kita, yang mana sangat membahayakan kerahasiaan *database* sistem akademik.

**4. Salah implementasi vs Pilihan tidak tepat pada SharedPreferences**
`SharedPreferences` bisa menyimpan token JSON dengan sempurna tanpa *error code*. Secara *syntax*, ini bukan "salah implementasi" karena fungsinya memang untuk *Key-Value storage*. Namun secara *architecture and security design*, ini adalah "pilihan yang sangat tidak tepat". Paket ini dikhususkan untuk preferensi tampilan biasa (seperti bahasa, dark mode) dan menyimpan data dalam format *plain-text* XML/JSON di file sistem. Untuk data autentikasi seperti *JWT/Token*, itu ibarat menaruh brankas uang (token) di dalam kotak sepatu berbahan kardus; fungsinya bekerja menahan barang, namun sangat rapuh terhadap serangan peretasan dasar. 

**5. Pentingnya validasi server di perangkat root**
Meskipun token disimpan di dalam `Secure Storage` (seperti *Keystore* Android), perangkat yang telah di-*root* atau dieksploitasi dapat melewati sandi keamanan OS, membongkar *sandbox* memori, dan mengendus token secara paksa. Walaupun demikian, token **tetap harus disimpan di perangkat** demi kenyamanan pengguna (agar tidak perlu mengetik sandi ribuan kali setiap membuka halaman). Sebagai penyeimbangnya, *Otorisasi sejati harus ditegakkan di Server*. Token hanya bertindak sebagai "tanda pengenal sementara". Serverlah yang mengendalikan masa *expired* (kedaluwarsa) token, memperbarui enkripsi sesi rahasia, dan membatalkan token secara remote jika aktivitas mencurigakan pada perangkat yang diretas (root) terdeteksi.