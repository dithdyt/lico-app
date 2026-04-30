***

# PRODUCT REQUIREMENTS DOCUMENT (PRD)
**Project Name:** LICO (Life-Cost)
**Platform:** Mobile App (Flutter)
**Architecture Style:** Feature-First, Offline-First (No API)

## 1. Product Vision & Core Philosophy
LICO adalah *Decision Audit Tool* untuk mencegah pembelian impulsif. Aplikasi ini **diharamkan** menampilkan sisa saldo bank. Sistem utamanya adalah mengkonversi "Harga Barang" menjadi "Waktu Kehidupan (Jam/Hari)" berdasarkan nilai pendapatan pengguna. 

**Tujuan Utama:** Menciptakan *friction* (gesekan psikologis) sebelum pengguna melakukan transaksi.

## 2. Technology Stack Boundaries
*   **Framework:** Flutter (Material 3 enabled).
*   **State Management:** Riverpod (Gunakan arsitektur reaktif, UI harus otomatis update jika data berubah).
*   **Database:** Isar NoSQL (Penyimpanan lokal yang cepat dan *type-safe*).
*   **Data Visualization:** `fl_chart` (Untuk statistik dasbor).

## 3. High-Level Data Models (Isar Entities)
Programmer harus menerjemahkan kebutuhan ini ke dalam schema Isar:

1.  **UserValuation (Singleton/Preferences):**
    *   Menyimpan profil pendapatan user (Gaji Bulanan, Freelance, atau Uang Jajan).
    *   Menyimpan jam produktif per minggu/bulan.
    *   **Output Wajib:** Terdapat sebuah *getter/fungsi* yang menghitung **Blended Hourly Rate** (Nilai Waktu Per Jam).
2.  **DecisionLog (Transaction Entity):**
    *   `itemName` (Nama barang).
    *   `itemPrice` (Harga barang asli).
    *   `timeCostInHours` (Konversi harga ke waktu, bersifat statis/immutable saat disimpan).
    *   `isPaylater` (Boolean, apakah menggunakan cicilan).
    *   `status` (Enum: `BURNED` untuk barang yang jadi dibeli, `SAVED` untuk barang yang batal dibeli).
    *   `createdAt` (Timestamp).

## 4. Core User Flows & Screens

### A. The Valuation Setup (Onboarding / Settings)
*   **Tujuan:** Mendapatkan *Hourly Rate* pengguna.
*   **Flow:** 
    *   User menginput jumlah penghasilan rata-rata dalam sebulan.
    *   User menginput estimasi waktu kerja/belajar dalam sebulan (dalam jam).
    *   Aplikasi menghitung dan menyimpan "Harga 1 Jam Kehidupan" pengguna.
*   **Rule:** Layar ini harus bisa diakses ulang dari menu Pengaturan jika pendapatan user berubah.

### B. Reality Check Calculator (Input Screen)
*   **Tujuan:** Tempat user memasukkan barang yang ingin dibeli.
*   **Flow:** 
    *   User input Nama Barang dan Harga (Angka).
    *   Terdapat Toggle Switch: *"Gunakan Paylater/Cicilan?"* (Jika aktif, tambahkan input Durasi Bulan & Bunga).
    *   Tombol Submit: "Lihat Harga Asli".

### C. The Crossroads (Intervention Screen)
*   **Tujuan:** Menampar kesadaran pengguna (Layar Transisi).
*   **Flow:**
    *   Layar menampilkan konversi waktu secara masif. Contoh: *"Sepatu ini menukar 48 Jam Hidup Anda."*
    *   Jika Paylater aktif, tambahkan *warning* ekstra tentang "perampokan masa depan".
    *   **Action:** Terdapat dua tombol besar:
        1. Tombol Merah/Gelap: **"Beli (Bakar Waktu)"** -> Menyimpan ke DB dengan status `BURNED`.
        2. Tombol Hijau/Terang: **"Batal (Selamatkan Waktu)"** -> Menyimpan ke DB dengan status `SAVED`.
    *   Setelah diklik, user diarahkan ke The Ledger.

### D. The Vault & Ledger (Main Dashboard)
*   **Tujuan:** Rekapitulasi keputusan pengguna.
*   **Flow:**
    *   **Header:** Menampilkan Bar Chart (fl_chart) perbandingan total waktu yang di-*Saved* vs di-*Burned* dalam bulan berjalan.
    *   **Tab/Filter:** User bisa melihat dua daftar berbeda:
        *   *Burn Ledger:* Daftar barang yang dibeli (Fokus visual pada waktu yang hilang).
        *   *Time Vault:* Daftar barang yang batal dibeli (Fokus visual pada waktu yang diselamatkan).
    *   **Rule:** Di dalam *list* ini, harga Rupiah dihilangkan atau disamarkan, diganti dengan teks tebal berformat Waktu (Jam/Hari).

## 5. UI/UX & Design Language Constraints
*   **Theme:** Minimalist Dark Mode atau Neo-Brutalism. Hindari warna-warni ceria.
*   **Typography:** Tipografi adalah elemen desain utama. Gunakan font *Sans-Serif* (seperti Inter, Roboto, atau Bebas Neue) dengan ukuran ekstrem pada teks peringatan.
*   **Tone of Voice:** Formal, dingin, dan lugas. Aplikasi bertindak sebagai Penasihat Finansial yang objektif.

***