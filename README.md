<p align="center">
  <img src="Images/Header.png" width="1000" height="500">
  <br>
</p>

<h1 align="center">🏥 <b>WELCOME TO DJIWA MEDICAL</b> 🚑💊</h1>
<h2 align="center"><i>"Smart Insights, Healthy Lives"</i></h2>

<div align="center">
  <a href="MASUKKAN_LINK_SHINYAPPS_DI_SINI">
    <img src="https://img.shields.io/badge/🌐_Live_Demo-Coba_Djiwa Medical_Sekarang!-2ea043?style=for-the-badge" alt="Live Demo">
  </a>
</div>

<br>

## 📑 Menu

<div align="center">
  <a href="#apa-itu-Djiwa Medical"><img src="https://img.shields.io/badge/1.-Apa_itu_Djiwa_Medical%3F-00599C?style=for-the-badge"></a>
  <a href="#deskripsi-proyek"><img src="https://img.shields.io/badge/2.-Deskripsi_Proyek-10b981?style=for-the-badge"></a>
  <a href="#tampilan-dashboard"><img src="https://img.shields.io/badge/3.-Tampilan_Dashboard-FF4B4B?style=for-the-badge"></a>
  <a href="#skema-basis-data"><img src="https://img.shields.io/badge/4.-Skema_Basis_Data_&_ERD-1E88E5?style=for-the-badge"></a>
  <a href="#deskripsi-data"><img src="https://img.shields.io/badge/5.-Deskripsi_Data-0288D1?style=for-the-badge"></a>
  <a href="#tools-digunakan"><img src="https://img.shields.io/badge/6.-Tools_Digunakan-9C27B0?style=for-the-badge"></a>
  <a href="#struktur-folder"><img src="https://img.shields.io/badge/7.-Struktur_Folder-2E7D32?style=for-the-badge"></a>
  <a href="#tim-pengembang"><img src="https://img.shields.io/badge/8.-Tim_Pengembang-F57C00?style=for-the-badge"></a>
</div>

<h2 id="apa-itu-Djiwa Medical">📌 Apa itu Djiwa Medical?</h2>

🏥 **Djiwa Medical - Platform Pusat Informasi & Data Klinik**

**Djiwa Medical!** adalah platform analitik yang menghadirkan pengalaman terbaik dalam mengeksplorasi data kesehatan. Dengan database klinis yang terpercaya, pengguna dapat menelusuri profil pasien, tren penyakit, hingga statistik kunjungan secara akurat. Temukan wawasan medis terbaik hanya di Djiwa Medical! 📊🩺✨

> **Coba langsung aplikasinya secara interaktif melalui link [Live Demo di sini](MASUKKAN_LINK_SHINYAPPS_DI_SINI).**

<h2 id="deskripsi-proyek">📋 Deskripsi Proyek</h2>

Tugas mata kuliah **Pemrosesan Data Besar** ini bertujuan untuk merancang dan mengoptimalkan sistem manajemen database (Platform Djiwa Medical) serta memvisualisasikannya ke dalam bentuk *dashboard* interaktif berbasis web menggunakan framework **RShiny**.

Proyek ini berangkat dari *dataset raw* berbentuk CSV (`Dataset_Klinik_Raw.csv` dengan 307.188 baris dan 30 kolom) yang bersumber dari **Dataset Mata Kuliah Pemrosesan Data Besar**. Karena penyimpanan tabel tunggal berisiko memunculkan redundansi, data tersebut dinormalisasi ke dalam sistem basis data relasional. Struktur ini dirancang menggunakan *referential integrity constraints* pada entitas utamanya (klinik, dokter, pasien, kunjungan, dan tindakan medis) untuk memastikan validitas data dan efisiensi *query*.

Hasilnya adalah aplikasi web komprehensif yang memudahkan eksplorasi data medis. Pengguna dapat dengan cepat memfilter informasi, menganalisis riwayat pasien, mengevaluasi tren layanan, serta menelusuri jadwal spesifik berdasarkan nama klinik maupun dokter.

<h2 id="tampilan-dashboard">📸 Tampilan Dashboard</h2>

**1. Tampilan Menu Utama atau Homepage**
* Menampilkan ringkasan informasi metrik penting (KPI) seperti total kunjungan, total pendapatan, jumlah cabang klinik, serta jumlah pasien dan dokter.
* Grafik kunjungan pasien bulanan yang dilengkapi dengan fitur prediksi untuk membantu perencanaan operasional ke depan.
* Visualisasi jenis diagnosa penyakit yang paling sering muncul agar beban kesehatan pasien mudah diidentifikasi.
* Menampilkan lokasi geografis seluruh cabang klinik untuk melihat jangkauan layanan.


`![Homepage Djiwa Medical](link-gambar-atau-lokasi-folder-gambar.png)`

**2. Tampilan Menu Klinik**
* Menyediakan fitur filter dinamis untuk mencari data berdasarkan kategori tertentu.
* Menampilkan perbandingan antar klinik berdasarkan komponen biaya (admin, konsultasi, obat, dan tindakan).
* Pengguna dapat melihat daftar cabang klinik dengan volume kunjungan pasien tertinggi.
* Menampilkan analisis persentase pasien yang datang kembali dibandingkan dengan pasien baru.
* Pengguna dapat melihat kecocokan antara fasilitas spesialisasi yang tersedia di tiap cabang dengan jumlah dokternya.
* Terdapat detail tabel data mentah lengkap mengenai seluruh aktivitas di level klinik.

**3. Tampilan Menu Dokter (Analisis Tenaga Medis)**
* Menyediakan fitur filter dinamis untuk mencari data berdasarkan kategori tertentu.
* Menyajikan informasi terkait total dokter, rata-rata beban pasien per dokter, dan spesialisasi yang paling banyak dicari.
* Pengguna dapat melihat distribusi gender dokter di berbagai bidang spesialisasi.
* Identifikasi dokter dengan jumlah kunjungan pasien terbanyak.
* Menampilkan top 3 dokter dengan tarif tertinggi serta perbandingan harga konsultasi antar spesialis melalui grafik boxplot.
* Terdapat detail tabel data mengenai profil dan performa masing-masing dokter.

**4. Tampilan Menu Pasien (Analisis Demografi & Profil Kesehatan)**
* Menyediakan informasi mengenai Distribusi pasien berdasarkan kelompok umur dan jenis kelamin.
* Pengguna dapat melihat profil kesehatan fisik secara umum melalui grafik analisis hubungan tinggi dan berat badan pasien.
* Visualisasi grafik garis yang menunjukkan perubahan jenis diagnosa penyakit dari waktu ke waktu.
* Terdapat informasi mengenai proporsi pasien BPJS vs Umum serta metode pembayaran (Cash, Debit, QRIS) yang paling sering digunakan.
* Tersedia tabel yang berisi data riwayat kunjungan pasien secara mendetail.

**5. Tampilan Menu Obat (Analisis Farmasi)**
* Menampilkan informasi mengenai total unit obat terjual, rata-rata jumlah obat dalam satu resep, dan kategori obat dengan harga tertinggi.
* Pengguna dapat melihat daftar 10 besar obat yang paling banyak dikonsumsi oleh pasien.
* Visualiasi tentang hubungan antara harga satuan obat dengan lama waktu pengobatan yang diberikan.
* Menyajikan grafik analisis keterkaitan antar obat yang sering diresepkan secara bersamaan dalam satu kunjungan.
*  Terdapat tabel yang memberikan informasi mengenai detail transaksi obat, dosis, hingga harga per unit.

**6. Tampilan Team (Informasi Penyusun)**

Halaman yang berisi profil dan peran dari masing-masing anggota tim penyusun yang berkontribusi dalam pengembangan aplikasi KlinikHub.


`![Eksplorasi Djiwa Medical](link-gambar-atau-lokasi-folder-gambar.png)`

<h2 id="skema-basis-data">🗄️ Skema Basis Data & ERD</h2>

<p>Sistem basis data dalam proyek <b>Djiwa Medical</b> dirancang menggunakan arsitektur relasional untuk memastikan integritas data medis dan efisiensi <i>query</i>. Semua entitas operasional terpusat dan berelasi kuat dengan entitas utama layanan kesehatan.</p>

<div align="center">
  <img src="images/ERD.png" alt="Entity Relationship Diagram Djiwa Medical" width="80%">
  <br>
  <i>Gambar 1: Entity Relationship Diagram (ERD) Djiwa Medical</i>
</div>
<br>

<h3>🔑 Struktur Kunci (Keys)</h3>
<p>Untuk membangun hubungan antar entitas dan menerapkan <i>referential integrity constraints</i>, kami menetapkan <i>Primary Key</i> (PK) dan <i>Foreign Key</i> (FK) sebagai berikut:</p>
<ul>
  <li><b>Primary Key (PK):</b> <code>id_klinik</code> (tabel klinik), <code>id_dokter</code> (tabel dokter), <code>id_pasien</code> (tabel pasien), dan <code>id_kunjungan</code> (tabel kunjungan).</li>
  <li><b>Foreign Key (FK):</b> Terdapat pada tabel transaksional seperti <b>kunjungan</b> (menghubungkan <code>id_pasien</code>, <code>id_dokter</code>, dan <code>id_klinik</code>) untuk merelasikan riwayat medis.</li>
</ul>

<h3>🌐 Relasi Antar Entitas</h3>
<table width="100%">
  <tr>
    <th width="25%">Hubungan</th>
    <th width="15%" style="text-align: center;">Kardinalitas</th>
    <th width="60%">Penjelasan</th>
  </tr>
  <tr>
    <td><b>Klinik → Dokter</b></td>
    <td align="center"><img src="https://img.shields.io/badge/1%20:%20N-00599C?style=flat-square" alt="1 to N"></td>
    <td>Satu klinik dapat memiliki <b>banyak dokter</b> yang berpraktik, tetapi satu profil dokter terkait dengan <b>satu klinik utama</b> dalam pencatatan ini.</td>
  </tr>
  <tr>
    <td><b>Pasien → Kunjungan</b></td>
    <td align="center"><img src="https://img.shields.io/badge/1%20:%20N-00599C?style=flat-square" alt="1 to N"></td>
    <td>Satu pasien dapat melakukan <b>banyak kunjungan</b> medis dari waktu ke waktu, tetapi satu rekam kunjungan hanya milik <b>satu pasien</b>.</td>
  </tr>
  <tr>
    <td><b>Dokter → Kunjungan</b></td>
    <td align="center"><img src="https://img.shields.io/badge/1%20:%20N-00599C?style=flat-square" alt="1 to N"></td>
    <td>Satu dokter dapat menangani <b>banyak kunjungan</b> pasien, tetapi satu sesi kunjungan spesifik hanya ditangani oleh <b>satu dokter penanggung jawab</b>.</td>
  </tr>
  <tr>
    <td><b>Kunjungan → Tindakan Medis</b></td>
    <td align="center"><img src="https://img.shields.io/badge/M%20:%20N-7B1FA2?style=flat-square" alt="M to N"></td>
    <td>Satu kunjungan bisa mencakup <b>banyak tindakan medis</b>, dan satu jenis tindakan bisa diberikan pada <b>banyak kunjungan</b>. Relasi <i>many-to-many</i> ini dikelola melalui tabel detail/penghubung.</td>
  </tr>
</table>

<h2 id="deskripsi-data">📜 Deskripsi Data & DDL</h2>

Bagian ini mendeskripsikan struktur tabel, tipe data (Data Dictionary), serta sintaks SQL (Data Definition Language/DDL) yang digunakan untuk membangun skema basis data Djiwa Medical.

### 🧮 Membuat Basis Data (Database)

Basis Data **Djiwa Medical** menyimpan informasi operasional medis yang mewakili atribut data yang saling berhubungan untuk keperluan analisis.

```sql
CREATE DATABASE IF NOT EXISTS klinikhub_db;

USE klinikhub_db;
```

### 🏥 1. Membuat Tabel Klinik

Tabel `clinic` menyediakan informasi mengenai entitas fasilitas kesehatan. Pengguna dapat mengetahui ID unik klinik, nama klinik, lokasi (kota dan provinsi), tanggal operasional, dokter kepala, hingga biaya administrasi.

| Attribute | Type | Description | Contoh Isian |
| :--- | :--- | :--- | :--- |
| **clinic_id (PK)** | VARCHAR(12) | ID unik klinik (Wajib diisi) | `CLN00001` |
| **clinic_name** | VARCHAR(200) | Nama klinik (Wajib diisi) | `Klinik Sehat Bersama Balikpapan 1` |
| **clinic_city** | VARCHAR(100) | Kota tempat klinik beroperasi (Wajib diisi) | `Balikpapan` |
| **clinic_province** | VARCHAR(100) | Provinsi tempat klinik beroperasi (Wajib diisi) | `Kalimantan Timur` |
| **clinic_open_date** | DATE | Tanggal klinik mulai beroperasi | `2019-07-11` |
| **head_doctor_name_of_clinic** | VARCHAR(200) | Nama dokter kepala di klinik tersebut | `dr. Lidya Mayasari, Sp.PD` |
| **administration_fee** | DECIMAL(14,2) | Biaya administrasi klinik | `50000.00` |

**Catatan:** Tabel ini dilengkapi dengan *Unique Key* pada kombinasi nama, kota, provinsi, tanggal buka, dan nama dokter untuk mencegah duplikasi data klinik.

<details>
<summary><b>🖥️ Klik untuk melihat SQL Script</b></summary>

```sql
CREATE TABLE IF NOT EXISTS `clinic` (
  `clinic_id` VARCHAR(12) NOT NULL,
  `clinic_name` VARCHAR(200) NOT NULL,
  `clinic_city` VARCHAR(100) NOT NULL,
  `clinic_province` VARCHAR(100) NOT NULL,
  `clinic_open_date` DATE NULL,
  `head_doctor_name_of_clinic` VARCHAR(200) NULL,
  `administration_fee` DECIMAL(14,2) NULL,
  PRIMARY KEY (`clinic_id`),
  UNIQUE KEY `uk_clinic_natural` (`clinic_name`, `clinic_city`, `clinic_province`, `clinic_open_date`, `head_doctor_name_of_clinic`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
```

</details>

### 👨‍⚕️ 2. Membuat Tabel Dokter

Tabel `doctor` menyimpan informasi detail mengenai dokter yang praktik di berbagai klinik. Tabel ini mencakup ID unik dokter, relasi ke klinik tempat praktik, nama, jenis kelamin, spesialisasi, hingga biaya konsultasi.

| Attribute | Type | Description | Contoh Isian |
| :--- | :--- | :--- | :--- |
| **doctor_id (PK)** | VARCHAR(12) | ID unik dokter (Wajib diisi) | `DOC000001` |
| **clinic_id (FK)** | VARCHAR(12) | ID klinik tempat dokter praktik (Wajib diisi) | `CLN00025` |
| **doctor_name** | VARCHAR(200) | Nama lengkap dokter (Wajib diisi) | `dr. Abyasa Jailani` |
| **doctor_gender** | CHAR(1) | Jenis kelamin dokter (misal: 'L' untuk Laki-laki) | `L` |
| **doctor_specialty** | VARCHAR(100) | Bidang spesialisasi dokter | `Umum` |
| **doctor_consultation_fee** | DECIMAL(14,2) | Biaya konsultasi dokter | `50000.00` |

**Catatan:** * Tabel ini memiliki **Foreign Key** pada kolom `clinic_id` yang terhubung langsung ke tabel `clinic`.
* Dilengkapi dengan **Unique Key** (`uk_doctor_natural`) pada kombinasi ID klinik, nama, jenis kelamin, dan spesialisasi untuk mencegah duplikasi pencatatan dokter yang sama di satu klinik.

<details>
<summary><b>🖥️ Klik untuk melihat SQL Script</b></summary>

```sql
CREATE TABLE IF NOT EXISTS `doctor` (
  `doctor_id` VARCHAR(12) NOT NULL,
  `clinic_id` VARCHAR(12) NOT NULL,
  `doctor_name` VARCHAR(200) NOT NULL,
  `doctor_gender` CHAR(1) NULL,
  `doctor_specialty` VARCHAR(100) NULL,
  `doctor_consultation_fee` DECIMAL(14,2) NULL,
  PRIMARY KEY (`doctor_id`),
  UNIQUE KEY `uk_doctor_natural` (`clinic_id`, `doctor_name`, `doctor_gender`, `doctor_specialty`),
  KEY `idx_doctor_clinic` (`clinic_id`),
  CONSTRAINT `fk_doctor_clinic`
    FOREIGN KEY (`clinic_id`) REFERENCES `clinic` (`clinic_id`)
    ON UPDATE CASCADE ON DELETE RESTRICT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
```

</details>

### 👤 3. Membuat Tabel Pasien

Tabel `patient` berfungsi untuk menyimpan data demografi dan informasi fisik dari pasien. Tabel ini memuat ID unik pasien, nama lengkap, jenis kelamin, tanggal lahir, tinggi dan berat badan, lokasi domisili, hingga jenis layanan pasien (seperti BPJS atau Umum).

| Attribute | Type | Description | Contoh Isian |
| :--- | :--- | :--- | :--- |
| **patient_id (PK)** | VARCHAR(14) | ID unik pasien (Wajib diisi) | `PAT0000001` |
| **patient_name** | VARCHAR(200) | Nama lengkap pasien (Wajib diisi) | `Abyasa Agustina` |
| **gender** | CHAR(1) | Jenis kelamin pasien (misal: 'L' atau 'P') | `L` |
| **date_of_birth** | DATE | Tanggal lahir pasien | `1988-05-05` |
| **height** | SMALLINT | Tinggi badan pasien (dalam cm) | `176` |
| **weight** | SMALLINT | Berat badan pasien (dalam kg) | `73` |
| **patient_city** | VARCHAR(100) | Kota domisili pasien | `Balikpapan` |
| **patient_province** | VARCHAR(100) | Provinsi domisili pasien | `Kalimantan Timur` |
| **patient_type** | VARCHAR(50) | Jenis layanan atau asuransi pasien | `BPJS` |

**Catatan:** Tabel ini dilengkapi dengan **Unique Key** (`uk_patient_natural`) pada kombinasi nama, jenis kelamin, tanggal lahir, postur tubuh (tinggi & berat), kota, provinsi, dan jenis pasien. Hal ini sangat berguna untuk mencegah pembuatan data rekam medis ganda untuk pasien yang sama persis.

<details>
<summary><b>🖥️ Klik untuk melihat SQL Script</b></summary>

```sql
CREATE TABLE IF NOT EXISTS `patient` (
  `patient_id` VARCHAR(14) NOT NULL,
  `patient_name` VARCHAR(200) NOT NULL,
  `gender` CHAR(1) NULL,
  `date_of_birth` DATE NULL,
  `height` SMALLINT NULL,
  `weight` SMALLINT NULL,
  `patient_city` VARCHAR(100) NULL,
  `patient_province` VARCHAR(100) NULL,
  `patient_type` VARCHAR(50) NULL,
  PRIMARY KEY (`patient_id`),
  UNIQUE KEY `uk_patient_natural` (`patient_name`, `gender`, `date_of_birth`, `height`, `weight`, `patient_city`, `patient_province`, `patient_type`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
```

</details>

### 🩺 4. Membuat Tabel Diagnosis

Tabel `diagnosis` menyimpan data referensi mengenai jenis penyakit atau diagnosis medis. Tabel ini mencatat ID unik untuk setiap diagnosis beserta nama penyakitnya.

| Attribute | Type | Description | Contoh Isian |
| :--- | :--- | :--- | :--- |
| **diagnosis_id (PK)** | VARCHAR(12) | ID unik diagnosis (Wajib diisi) | `DIA00004` |
| **diagnosis_name** | VARCHAR(200) | Nama diagnosis atau penyakit (Wajib diisi) | `Diare Akut` |

**Catatan:** Tabel ini dilengkapi dengan *Unique Key* pada kolom nama diagnosis (`uk_diagnosis_name`) untuk memastikan tidak ada pencatatan nama penyakit yang ganda di dalam sistem.

<details>
<summary><b>🖥️ Klik untuk melihat SQL Script</b></summary>

```sql
CREATE TABLE IF NOT EXISTS `diagnosis` (
  `diagnosis_id` VARCHAR(12) NOT NULL,
  `diagnosis_name` VARCHAR(200) NOT NULL,
  PRIMARY KEY (`diagnosis_id`),
  UNIQUE KEY `uk_diagnosis_name` (`diagnosis_name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
```

</details>

### 💊 5. Membuat Tabel Obat (Medicine)

Tabel `medicine` berfungsi untuk menyimpan data referensi obat-obatan yang tersedia di klinik. Tabel ini memuat informasi penting seperti ID unik obat, nama, kategori medis, harga satuan, dosis harian, hingga durasi konsumsi obat dalam hitungan hari.

| Attribute | Type | Description | Contoh Isian |
| :--- | :--- | :--- | :--- |
| **medicine_id (PK)** | VARCHAR(12) | ID unik obat (Wajib diisi) | `MED000003` |
| **medicine_name** | VARCHAR(255) | Nama obat beserta ukurannya (Wajib diisi) | `Amlodipine 5 mg tablet` |
| **medicine_category** | VARCHAR(100) | Kategori jenis obat | `Antihipertensi` |
| **medicine_unit_price** | DECIMAL(14,2) | Harga satuan obat | `900.00` |
| **medicine_dosage_per_day** | DECIMAL(10,2) | Dosis konsumsi obat per hari | `1.00` |
| **medicine_duration_days** | INT | Lama durasi konsumsi obat (dalam hari) | `7` |

**Catatan:** Tabel ini dilengkapi dengan **Unique Key** (`uk_medicine_natural`) pada kombinasi nama obat, kategori, harga satuan, dosis per hari, dan durasi untuk memastikan tidak ada pencatatan atribut obat yang ganda di dalam sistem.

<details>
<summary><b>🖥️ Klik untuk melihat SQL Script</b></summary>

```sql
CREATE TABLE IF NOT EXISTS `medicine` (
  `medicine_id` VARCHAR(12) NOT NULL,
  `medicine_name` VARCHAR(255) NOT NULL,
  `medicine_category` VARCHAR(100) NULL,
  `medicine_unit_price` DECIMAL(14,2) NULL,
  `medicine_dosage_per_day` DECIMAL(10,2) NULL,
  `medicine_duration_days` INT NULL,
  PRIMARY KEY (`medicine_id`),
  UNIQUE KEY `uk_medicine_natural` (`medicine_name`, `medicine_category`, `medicine_unit_price`, `medicine_dosage_per_day`, `medicine_duration_days`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
```

</details>

### 💉 6. Membuat Tabel Tindakan (Treatment)

Tabel `treatment` menyimpan referensi data mengenai berbagai jenis tindakan medis atau layanan perawatan yang tersedia di klinik. Tabel ini mencatat ID unik, nama tindakan, beserta standar biaya untuk masing-masing tindakan tersebut.

| Attribute | Type | Description | Contoh Isian |
| :--- | :--- | :--- | :--- |
| **treatment_id (PK)** | VARCHAR(12) | ID unik tindakan medis (Wajib diisi) | `TRT00001` |
| **treatment_name** | VARCHAR(200) | Nama tindakan atau layanan medis (Wajib diisi) | `Konsultasi Kehamilan` |
| **treatment_fee** | DECIMAL(14,2) | Standar biaya tindakan medis | `60000.00` |

**Catatan:** Tabel ini dilengkapi dengan **Unique Key** (`uk_treatment_name_fee`) pada kombinasi nama tindakan dan biayanya. Hal ini berguna untuk mencegah adanya duplikasi pencatatan layanan yang sama dengan harga yang sama persis di dalam sistem.

<details>
<summary><b>🖥️ Klik untuk melihat SQL Script</b></summary>

```sql
CREATE TABLE IF NOT EXISTS `treatment` (
  `treatment_id` VARCHAR(12) NOT NULL,
  `treatment_name` VARCHAR(200) NOT NULL,
  `treatment_fee` DECIMAL(14,2) NULL,
  PRIMARY KEY (`treatment_id`),
  UNIQUE KEY `uk_treatment_name_fee` (`treatment_name`, `treatment_fee`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
```

</details>

### 💳 7. Membuat Tabel Transaksi (Transactions)

Tabel `transactions` berfungsi untuk mencatat detail pembayaran dan tagihan dari setiap kunjungan pasien. Tabel ini merangkum rincian biaya mulai dari administrasi, konsultasi dokter, tindakan medis, hingga pembelian obat, serta menghubungkannya dengan data kunjungan dan diagnosis utama pasien.

| Attribute | Type | Description | Contoh Isian |
| :--- | :--- | :--- | :--- |
| **transaction_id (PK)** | BIGINT | ID unik sistem untuk transaksi (Wajib diisi) | `1` |
| **transaction_number** | VARCHAR(30) | Nomor referensi/invoice transaksi (Wajib diisi) | `TRX-00000001` |
| **visit_id (FK)** | VARCHAR(20) | ID kunjungan referensi (Wajib diisi) | `VST-0000D83254E1` |
| **primary_diagnosis_id (FK)** | VARCHAR(12) | ID diagnosis utama pada kunjungan tersebut | `DIA00019` |
| **payment_method** | VARCHAR(30) | Metode pembayaran yang digunakan | `debit` |
| **administration_fee** | DECIMAL(14,2) | Biaya administrasi klinik | `60000.00` |
| **doctor_consultation_fee** | DECIMAL(14,2) | Biaya jasa konsultasi dokter | `60000.00` |
| **treatment_total** | DECIMAL(14,2) | Total biaya tindakan/perawatan medis | `40000.00` |
| **medicine_total** | DECIMAL(14,2) | Total biaya pembelian obat | `9600.00` |
| **total_amount** | DECIMAL(14,2) | Total keseluruhan tagihan yang harus dibayar | `169600.00` |
| **created_at** | TIMESTAMP | Waktu pencatatan transaksi di sistem | `2026-03-01 02:06:38` |

**Catatan:** * Tabel ini memiliki **Foreign Key** ke tabel `visit` (`visit_id`) dan tabel `diagnosis` (`primary_diagnosis_id`).
* Terdapat **Unique Key** pada `transaction_number` untuk memastikan nomor struk/invoice tidak ada yang ganda, serta pada `visit_id` yang menandakan bahwa satu kunjungan hanya bisa memiliki satu transaksi pembayaran.

<details>
<summary><b>🖥️ Klik untuk melihat SQL Script</b></summary>

```sql
CREATE TABLE IF NOT EXISTS `transactions` (
  `transaction_id` BIGINT NOT NULL,
  `transaction_number` VARCHAR(30) NOT NULL,
  `visit_id` VARCHAR(20) NOT NULL,
  `primary_diagnosis_id` VARCHAR(12) NULL,
  `payment_method` VARCHAR(30) NULL,
  `administration_fee` DECIMAL(14,2) NULL,
  `doctor_consultation_fee` DECIMAL(14,2) NULL,
  `treatment_total` DECIMAL(14,2) NULL,
  `medicine_total` DECIMAL(14,2) NULL,
  `total_amount` DECIMAL(14,2) NULL,
  `created_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`transaction_id`),
  UNIQUE KEY `uk_transactions_number` (`transaction_number`),
  UNIQUE KEY `uk_transactions_visit` (`visit_id`),
  KEY `idx_transactions_diagnosis` (`primary_diagnosis_id`),
  CONSTRAINT `fk_transactions_visit`
    FOREIGN KEY (`visit_id`) REFERENCES `visit` (`visit_id`)
    ON UPDATE CASCADE ON DELETE RESTRICT,
  CONSTRAINT `fk_transactions_diagnosis`
    FOREIGN KEY (`primary_diagnosis_id`) REFERENCES `diagnosis` (`diagnosis_id`)
    ON UPDATE CASCADE ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
```

</details>

### 📅 8. Membuat Tabel Kunjungan (Visit)

Tabel `visit` adalah tabel operasional utama yang mencatat setiap kedatangan atau kunjungan pasien ke klinik. Tabel ini sangat krusial karena menghubungkan data pasien, dokter pemeriksa, lokasi klinik, waktu kejadian, hingga keluhan awal pasien.

| Attribute | Type | Description | Contoh Isian |
| :--- | :--- | :--- | :--- |
| **visit_id (PK)** | VARCHAR(20) | ID unik kunjungan (Wajib diisi) | `VST-0000D83254E1` |
| **visit_datetime** | DATETIME | Waktu dan tanggal pasien berkunjung | `2022-12-18 09:15:00` |
| **clinic_id (FK)** | VARCHAR(12) | ID klinik tempat pasien berkunjung (Wajib diisi) | `CLN00073` |
| **doctor_id (FK)** | VARCHAR(12) | ID dokter yang menangani pasien (Wajib diisi) | `DOC000104` |
| **patient_id (FK)** | VARCHAR(14) | ID pasien yang berkunjung (Wajib diisi) | `PAT0098899` |
| **complaint** | TEXT | Catatan keluhan awal atau gejala pasien | `Bersin-bersin dan hidung gatal berulang` |

**Catatan:** * Tabel ini bertindak sebagai jembatan relasi dengan memiliki **Foreign Key** ke tiga tabel sekaligus: `clinic`, `doctor`, dan `patient`.
* Tabel ini juga dilengkapi dengan beberapa indeks (seperti `idx_visit_datetime`) untuk mempercepat proses pencarian atau *filtering* data berdasarkan tanggal, klinik, dokter, maupun pasien.

<details>
<summary><b>🖥️ Klik untuk melihat SQL Script</b></summary>

```sql
CREATE TABLE IF NOT EXISTS `visit` (
  `visit_id` VARCHAR(20) NOT NULL,
  `visit_datetime` DATETIME NULL,
  `clinic_id` VARCHAR(12) NOT NULL,
  `doctor_id` VARCHAR(12) NOT NULL,
  `patient_id` VARCHAR(14) NOT NULL,
  `complaint` TEXT NULL,
  PRIMARY KEY (`visit_id`),
  KEY `idx_visit_datetime` (`visit_datetime`),
  KEY `idx_visit_clinic` (`clinic_id`),
  KEY `idx_visit_doctor` (`doctor_id`),
  KEY `idx_visit_patient` (`patient_id`),
  CONSTRAINT `fk_visit_clinic`
    FOREIGN KEY (`clinic_id`) REFERENCES `clinic` (`clinic_id`)
    ON UPDATE CASCADE ON DELETE RESTRICT,
  CONSTRAINT `fk_visit_doctor`
    FOREIGN KEY (`doctor_id`) REFERENCES `doctor` (`doctor_id`)
    ON UPDATE CASCADE ON DELETE RESTRICT,
  CONSTRAINT `fk_visit_patient`
    FOREIGN KEY (`patient_id`) REFERENCES `patient` (`patient_id`)
    ON UPDATE CASCADE ON DELETE RESTRICT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
```

</details>

### 📋 9. Membuat Tabel Diagnosis Kunjungan (Visit Diagnosis)

Tabel `visit_diagnosis` merupakan tabel pendetailan yang mencatat rincian diagnosis penyakit dari setiap kunjungan pasien. Karena dalam satu kali kunjungan pasien bisa didiagnosis memiliki lebih dari satu penyakit, tabel ini menggunakan nomor urut sekuens (`diagnosis_seq`) untuk mencatat urutan diagnosisnya (misalnya urutan ke-1 untuk diagnosis utama).

| Attribute | Type | Description | Contoh Isian |
| :--- | :--- | :--- | :--- |
| **visit_id (PK, FK)** | VARCHAR(20) | ID referensi kunjungan pasien (Wajib diisi) | `VST-00028BB41ACC` |
| **diagnosis_seq (PK)** | INT | Nomor urut diagnosis pada satu kunjungan | `1` |
| **diagnosis_id (FK)** | VARCHAR(12) | ID referensi diagnosis atau penyakit | `DIA00001` |

**Catatan:** * Tabel ini menggunakan **Composite Primary Key** (Kunci Primer Gabungan) pada kolom `visit_id` dan `diagnosis_seq`.
* Tabel ini memiliki **Foreign Key** ke tabel `visit` dan `diagnosis`. Menariknya, relasi ke tabel `visit` menggunakan aturan `ON DELETE CASCADE`, yang artinya jika data sebuah kunjungan dihapus oleh sistem, maka rincian diagnosis untuk kunjungan tersebut akan ikut terhapus secara otomatis agar tidak menjadi data yatim/sampah (*orphan data*).

<details>
<summary><b>🖥️ Klik untuk melihat SQL Script</b></summary>

```sql
CREATE TABLE IF NOT EXISTS `visit_diagnosis` (
  `visit_id` VARCHAR(20) NOT NULL,
  `diagnosis_seq` INT NOT NULL,
  `diagnosis_id` VARCHAR(12) NOT NULL,
  PRIMARY KEY (`visit_id`, `diagnosis_seq`),
  KEY `idx_visit_diagnosis_diag` (`diagnosis_id`),
  CONSTRAINT `fk_visit_diagnosis_visit`
    FOREIGN KEY (`visit_id`) REFERENCES `visit` (`visit_id`)
    ON UPDATE CASCADE ON DELETE CASCADE,
  CONSTRAINT `fk_visit_diagnosis_diagnosis`
    FOREIGN KEY (`diagnosis_id`) REFERENCES `diagnosis` (`diagnosis_id`)
    ON UPDATE CASCADE ON DELETE RESTRICT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
```

</details>

### 💊 10. Membuat Tabel Obat Kunjungan (Visit Medicine)

Tabel `visit_medicine` adalah tabel pendetailan yang menyimpan riwayat resep atau pemberian obat kepada pasien dalam setiap kunjungan. Mengingat seorang pasien sering kali menerima lebih dari satu jenis obat dalam satu kali pemeriksaan, tabel ini menggunakan nomor urut sekuens (`medicine_seq`) untuk mendata setiap obat yang diberikan.

| Attribute | Type | Description | Contoh Isian |
| :--- | :--- | :--- | :--- |
| **visit_id (PK, FK)** | VARCHAR(20) | ID referensi kunjungan pasien (Wajib diisi) | `VST-0001E1133AB3` |
| **medicine_seq (PK)** | INT | Nomor urut pemberian obat pada satu kunjungan | `1` |
| **medicine_id (FK)** | VARCHAR(12) | ID referensi obat yang diresepkan | `MED000001` |

**Catatan:** * Tabel ini menggunakan **Composite Primary Key** (Kunci Primer Gabungan) pada kolom `visit_id` dan `medicine_seq`.
* Tabel ini juga memiliki **Foreign Key** ke tabel `visit` dan `medicine`. Sama seperti tabel diagnosis kunjungan, relasi ke tabel `visit` menggunakan aturan `ON DELETE CASCADE` agar data rincian obat otomatis terhapus jika data kunjungan utamanya dihapus.

<details>
<summary><b>🖥️ Klik untuk melihat SQL Script</b></summary>

```sql
CREATE TABLE IF NOT EXISTS `visit_medicine` (
  `visit_id` VARCHAR(20) NOT NULL,
  `medicine_seq` INT NOT NULL,
  `medicine_id` VARCHAR(12) NOT NULL,
  PRIMARY KEY (`visit_id`, `medicine_seq`),
  KEY `idx_visit_medicine_medicine` (`medicine_id`),
  CONSTRAINT `fk_visit_medicine_visit`
    FOREIGN KEY (`visit_id`) REFERENCES `visit` (`visit_id`)
    ON UPDATE CASCADE ON DELETE CASCADE,
  CONSTRAINT `fk_visit_medicine_medicine`
    FOREIGN KEY (`medicine_id`) REFERENCES `medicine` (`medicine_id`)
    ON UPDATE CASCADE ON DELETE RESTRICT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
```

</details>

### 💉 11. Membuat Tabel Tindakan Kunjungan (Visit Treatment)

Tabel `visit_treatment` adalah tabel pendetailan yang berfungsi untuk mencatat riwayat tindakan medis atau perawatan yang diberikan kepada pasien selama waktu kunjungan. Karena pasien bisa menerima beberapa tindakan sekaligus dalam satu kali pemeriksaan, tabel ini menggunakan nomor urut sekuens (`treatment_seq`) untuk mendatanya dengan rapi.

| Attribute | Type | Description | Contoh Isian |
| :--- | :--- | :--- | :--- |
| **visit_id (PK, FK)** | VARCHAR(20) | ID referensi kunjungan pasien (Wajib diisi) | `VST-001B45B2C354` |
| **treatment_seq (PK)** | INT | Nomor urut tindakan medis pada satu kunjungan | `2` |
| **treatment_id (FK)** | VARCHAR(12) | ID referensi tindakan medis yang diberikan | `TRT00001` |

**Catatan:** * Tabel ini menggunakan **Composite Primary Key** (Kunci Primer Gabungan) pada kolom `visit_id` dan `treatment_seq`.
* Memiliki **Foreign Key** ke tabel `visit` dan `treatment`. Relasi ke tabel `visit` menerapkan `ON DELETE CASCADE`, sehingga jika rujukan data kunjungan utamanya dihapus, maka rincian tindakan pada kunjungan tersebut juga akan terhapus otomatis demi menjaga integritas data.

<details>
<summary><b>🖥️ Klik untuk melihat SQL Script</b></summary>

```sql
CREATE TABLE IF NOT EXISTS `visit_treatment` (
  `visit_id` VARCHAR(20) NOT NULL,
  `treatment_seq` INT NOT NULL,
  `treatment_id` VARCHAR(12) NOT NULL,
  PRIMARY KEY (`visit_id`, `treatment_seq`),
  KEY `idx_visit_treatment_treatment` (`treatment_id`),
  CONSTRAINT `fk_visit_treatment_visit`
    FOREIGN KEY (`visit_id`) REFERENCES `visit` (`visit_id`)
    ON UPDATE CASCADE ON DELETE CASCADE,
  CONSTRAINT `fk_visit_treatment_treatment`
    FOREIGN KEY (`treatment_id`) REFERENCES `treatment` (`treatment_id`)
    ON UPDATE CASCADE ON DELETE RESTRICT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
```

</details>
<p align="right"><a href="#-menu">⬆️ Kembali ke Menu</a></p>

<h2 id="tools-digunakan">🛠️ Tools yang Digunakan</h2>

<p>Proyek <b>Djiwa Medical</b> dibangun menggunakan ekosistem teknologi modern untuk memastikan performa pengolahan data besar yang optimal dan antarmuka yang interaktif:</p>

<table width="100%">
  <tr>
    <td align="center" width="25%" style="vertical-align: top;">
      <img src="https://img.shields.io/badge/RStudio-75AADB?style=for-the-badge&logo=rstudio&logoColor=white" alt="RStudio"><br><br>
      <b>IDE & Language</b>
      <hr>
      <p align="left"><sub>Digunakan sebagai lingkungan pengembangan utama untuk penulisan skrip R dan manajemen proyek.</sub></p>
    </td>
    <td align="center" width="25%" style="vertical-align: top;">
      <img src="https://img.shields.io/badge/R_Shiny-276DC3?style=for-the-badge&logo=rshiny&logoColor=white" alt="RShiny"><br><br>
      <b>Web Framework</b>
      <hr>
      <p align="left"><sub>Digunakan untuk membangun dashboard interaktif dengan fitur reaktivitas untuk visualisasi data klinis.</sub></p>
    </td>
        <td align="center" width="25%" style="vertical-align: top;">
      <img src="https://img.shields.io/badge/DBngin-7B1FA2?style=for-the-badge&logo=databricks&logoColor=white" alt="DBngin"><br><br>
      <b>DB Engine</b>
      <hr>
      <p align="left"><sub>Digunakan untuk menjalankan mesin database lokal guna mendukung penyimpanan data relasional yang efisien.</sub></p>
    </td>
        <td align="center" width="25%" style="vertical-align: top;">
      <img src="https://img.shields.io/badge/TablePlus-FFC107?style=for-the-badge&logo=postgresql&logoColor=black" alt="TablePlus"><br><br>
      <b>DB Management</b>
      <hr>
      <p align="left"><sub>Digunakan untuk mengelola skema tabel, relasi, dan memvalidasi query SQL secara visual.</sub></p>
    </td>
  </tr>
</table>

<br>

<p align="center">
  <b>Powered by R Libraries:</b><br>
  <img src="https://img.shields.io/badge/tidyverse-blue?style=flat-square&logo=tidyverse&logoColor=white"> 
  <img src="https://img.shields.io/badge/dplyr-red?style=flat-square&logo=r&logoColor=white"> 
  <img src="https://img.shields.io/badge/ggplot2-green?style=flat-square&logo=r&logoColor=white"> 
  <img src="https://img.shields.io/badge/DBI-orange?style=flat-square&logo=database&logoColor=white"> 
  <img src="https://img.shields.io/badge/bs4Dash-lightgrey?style=flat-square&logo=bootstrap&logoColor=white">
</p>

<h2 id="struktur-folder">📂 Struktur Folder</h2>

<p>Repositori ini disusun dengan arsitektur yang rapi untuk memisahkan antara logika aplikasi (backend/frontend), dataset, aset visual, dan dokumentasi agar mudah dipelihara dan dikembangkan lebih lanjut:</p>

```text
.
├── 📂 Application/                     # Direktori utama aplikasi RShiny
│   ├── 📄 server.R             # Logika backend, koneksi database, dan reaktivitas
│   └── 📄 ui.R                 # Antarmuka pengguna (Frontend dashboard)
├── 📂 Data/                    # Penyimpanan dataset proyek
│   ├── 📂 clean/               # Dataset yang telah dinormalisasi (siap pakai)
│   └── 📂 raw/                 # Dataset mentah awal (Dataset_Klinik_Raw.csv)
├── 📂 Documentation/                     # Dokumentasi teknis proyek
│   └── 🖼️ ERD.png              # Gambar Entity Relationship Diagram (ERD)
├── 📂 Images/                  # Aset visual untuk UI dashboard dan README
│   ├── 🖼️ joice.png            # Foto profil anggota tim
│   ├── 🖼️ wita.png
│   └── 🖼️ ika.png
└── 📝 README.md                # Dokumentasi utama repositori (file ini)
```

<h2 id="tim-pengembang">👥 Tim Pengembang</h2>

Proyek **Djiwa Medical** ini dikembangkan melalui kolaborasi tim yang hebat, dengan rincian anggota dan pembagian peran sebagai berikut:

<table width="100%">
  <tr>
    <td width="30%" align="center">
      <img src="images/joice.png" width="250" alt="Joice">
    </td>
    <td width="70%">
      <h3><a href="(https://github.com/JoiceJunansi)">Joice Junansi Tandirerung</a></h3>
      <b>M0501251007 | 🗄️ Database Manager</b>
      <hr>
      <i>Mengelola arsitektur database, melakukan normalisasi data mentah, dan memastikan integritas penyimpanan.</i>
    </td>
  </tr>

  <tr>
    <td width="30%" align="center">
      <img src="images/wita.png" width="250" alt="Wita">
    </td>
    <td width="70%">
      <h3><a href="https://github.com/baiqwitaa">Baiq Wita Rachmatia</a></h3>
      <b>M0501251061 | 🎨 Frontend Developer</b>
      <hr>
      <i>Merancang dan membangun antarmuka UI/UX dashboard RShiny yang interaktif dan responsif.</i>
    </td>
  </tr>

  <tr>
    <td width="30%" align="center">
      <img src="https://github.com/avinrahmadian.png" width="250" alt="Avin">
    </td>
    <td width="70%">
      <h3><a href="https://github.com/avinrahmadian">Avin Rahmadian</a></h3>
      <b>M0501251023 | 🖥️ Backend Developer</b>
      <hr>
      <i>Menghubungkan database ke aplikasi, mengelola pemrosesan query, dan memastikan logika server berjalan optimal.</i>
    </td>
  </tr>

  <tr>
    <td width="30%" align="center">
      <img src="images/ika.png" width="250" alt="Ika">
    </td>
    <td width="70%">
      <h3><a href="https://github.com/ikalailia06">Ika Lailia Nur Rohmatun Nazila</a></h3>
      <b>M0501251020 | 📊 Data Analyst</b>
      <hr>
      <i>Mengeksplorasi dataset, mengekstrak insight klinis, dan merancang metrik visualisasi.</i>
    </td>
  </tr>
</table>
<br>














