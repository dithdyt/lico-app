***

# FUNCTIONAL SPECIFICATION DOCUMENT (FSD)
**Project Name:** LICO (Life-Cost)
**Scope:** Core Logic, Data Validation, & Calculation Engine

## 1. Global Formatting & Data Representation Rules
*   **Currency Input:** Semua input uang menggunakan *numeric keyboard*. Sistem harus mem-parsing input string yang memiliki pemisah ribuan (titik/koma) menjadi tipe data `Double` yang valid untuk kalkulasi.
*   **Time Output Conversion (Aturan Konversi Waktu):**
    Hasil pembagian (Harga / *Hourly Rate*) akan menghasilkan angka desimal (contoh: `42.5` jam). Programmer harus membuat *Helper Class* untuk mengkonversi nilai ini ke dalam format manusia (*Human Readable*):
    *   Jika < 1 Jam: Tampilkan dalam Menit.
    *   Jika >= 1 Jam & < 24 Jam: Tampilkan "X Jam Y Menit".
    *   Jika >= 24 Jam: Tampilkan "X Hari Y Jam". *(Asumsi 1 Hari = 24 Jam waktu absolut, atau bisa disesuaikan dengan jam kerja).*

## 2. Valuation Calculation Engine (Logika Penetapan Harga Nyawa)
Engine ini berjalan di halaman Onboarding / Settings.
*   **Mode Pemilihan:**
    1.  **Mode Pekerja (Gaji):**
        *   `monthlyIncome` = Gaji bulanan.
        *   `monthlyWorkHours` = Jam kerja per minggu * 4.
    2.  **Mode Pelajar (Uang Saku):**
        *   `monthlyIncome` = Uang saku/jajan bulanan.
        *   `monthlyWorkHours` = Jam belajar per minggu * 4.
*   **Formula:**
    *   `hourlyRate` = `monthlyIncome` / `monthlyWorkHours`.
*   **Validation & Edge Cases:**
    *   **Division by Zero:** `monthlyWorkHours` **TIDAK BOLEH** `0` atau kosong. Jika 0, set default ke `1` atau cegah user untuk *Save* agar tidak terjadi error *Infinity / NaN* pada sistem.
    *   **Negative Values:** Tolak input angka minus.

## 3. The Crossroads Engine (Logika Kalkulator Utama)
Engine ini berjalan saat user memasukkan barang yang ingin dibeli.
*   **Standard Mode (Cash/Lunas):**
    *   `itemPrice` (Double): Harga barang.
    *   **Formula:** `timeCost` = `itemPrice` / `hourlyRate`.
*   **Paylater / Installment Mode (Cicilan):**
    *   Jika *toggle* Paylater aktif, munculkan dua input tambahan: `durationInMonths` (Int) dan `interestRatePercentage` (Double - Bunga total, bukan per bulan untuk simplifikasi).
    *   **Formula Final Price:** `totalPrice` = `itemPrice` + (`itemPrice` * (`interestRatePercentage` / 100)).
    *   **Formula Time Cost:** `timeCost` = `totalPrice` / `hourlyRate`.
    *   **UI Trigger (Visceral Warning):** Jika Paylater digunakan, aplikasi wajib menampilkan teks peringatan berwarna merah terang: 
        > *"PERINGATAN: Anda menggadaikan [X] jam hidup Anda SETIAP BULAN selama [Y] bulan ke depan."*
        > *(X = timeCost / durationInMonths, Y = durationInMonths)*

## 4. State Management & Database Triggers
*   **Immutable Logging:** Saat tombol "Beli (BURNED)" atau "Batal (SAVED)" ditekan, data yang dikirim ke database Isar harus berupa angka absolut hasil kalkulasi saat itu. **JANGAN** merelasikan record transaksi dengan tabel/preference `HourlyRate` yang bisa berubah di masa depan.
*   **Action Feedback:** Setelah tombol ditekan, berikan jeda (*delay/loading state*) 1 detik sebelum diarahkan ke Dashboard. Ini untuk memberikan efek *closure* (penyelesaian psikologis) bagi pengguna.

## 5. Aggregation Logic for Dashboard (Statistik)
Data yang ditampilkan di *Chart/Dashboard* tidak boleh mengambil seluruh isi database dari awal rilis, melainkan harus difilter.
*   **Timeframe Filtering:** Lakukan query ke Isar untuk mengambil data `DecisionLog` di mana `createdAt` berada di bulan berjalan (*Current Month*).
*   **Data Grouping:**
    *   `Total Burned Time`: Sum (akumulasi) seluruh field `timeCostInHours` dengan status `BURNED`.
    *   `Total Saved Time`: Sum (akumulasi) seluruh field `timeCostInHours` dengan status `SAVED`.
*   **Chart Output:** Sediakan data `List<DataPoint>` yang sudah teragregasi untuk dikonsumsi oleh UI (`fl_chart`).

***