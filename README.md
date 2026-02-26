<h1 align="center">🏥 <b>Welcome To KlinikHub</b> 🚑💊</h1>
<h2 align="center"><i>"Smart Insights, Healthy Lives"</i></h2>

<div align="center">
  <a href="MASUKKAN_LINK_SHINYAPPS_DI_SINI">
    <img src="https://img.shields.io/badge/🌐_Live_Demo-Coba_KlinikHub_Sekarang!-2ea043?style=for-the-badge" alt="Live Demo">
  </a>
</div>

<br>

## 📑 Menu

<div align="center">
  <a href="#apa-itu-klinikhub"><img src="https://img.shields.io/badge/1.-Apa_itu_KlinikHub%3F-00599C?style=for-the-badge"></a>
  <a href="#deskripsi-proyek"><img src="https://img.shields.io/badge/2.-Deskripsi_Proyek-10b981?style=for-the-badge"></a>
  <a href="#tampilan-dashboard"><img src="https://img.shields.io/badge/3.-Tampilan_Dashboard-FF4B4B?style=for-the-badge"></a>
  <a href="#skema-basis-data"><img src="https://img.shields.io/badge/4.-Skema_Basis_Data_&_ERD-1E88E5?style=for-the-badge"></a>
  <br><br>
  <a href="#deskripsi-data"><img src="https://img.shields.io/badge/5.-Deskripsi_Data-0288D1?style=for-the-badge"></a>
  <a href="#tools-digunakan"><img src="https://img.shields.io/badge/6.-Tools_Digunakan-9C27B0?style=for-the-badge"></a>
  <a href="#struktur-folder"><img src="https://img.shields.io/badge/7.-Struktur_Folder-2E7D32?style=for-the-badge"></a>
  <a href="#tim-pengembang"><img src="https://img.shields.io/badge/8.-Tim_Pengembang-F57C00?style=for-the-badge"></a>
</div>

<h2 id="apa-itu-klinikhub">📌 Apa itu KlinikHub?</h2>

🏥 **KlinikHub - Platform Pusat Informasi & Data Klinik**

**KlinikHub!** adalah platform analitik yang menghadirkan pengalaman terbaik dalam mengeksplorasi data kesehatan. Dengan database klinis yang terpercaya, pengguna dapat menelusuri profil pasien, tren penyakit, hingga statistik kunjungan secara akurat. Temukan wawasan medis terbaik hanya di KlinikHub! 📊🩺✨

> **Coba langsung aplikasinya secara interaktif melalui link [Live Demo di sini](MASUKKAN_LINK_SHINYAPPS_DI_SINI).**

<h2 id="deskripsi-proyek">📋 Deskripsi Proyek</h2>

Tugas mata kuliah **Pemrosesan Data Besar** ini bertujuan untuk merancang dan mengoptimalkan sistem manajemen database (Platform KlinikHub) serta memvisualisasikannya ke dalam bentuk *dashboard* interaktif berbasis web menggunakan framework **RShiny**.

Proyek ini berangkat dari *dataset raw* berbentuk CSV (`Dataset_Klinik_Raw.csv` dengan 307.188 baris dan 30 kolom) yang bersumber dari **Dataset Mata Kuliah Pemrosesan Data Besar**. Karena penyimpanan tabel tunggal berisiko memunculkan redundansi, data tersebut dinormalisasi ke dalam sistem basis data relasional. Struktur ini dirancang menggunakan *referential integrity constraints* pada entitas utamanya (klinik, dokter, pasien, kunjungan, dan tindakan medis) untuk memastikan validitas data dan efisiensi *query*.

Hasil akhirnya adalah aplikasi web yang memudahkan pengguna dalam menelusuri data dokter berdasarkan spesialisasi, melihat riwayat kunjungan pasien, serta mengevaluasi tren layanan. Platform ini juga dilengkapi fitur pencarian spesifik, seperti memfilter jadwal berdasarkan nama klinik, tanggal kunjungan, atau nama dokter secara cepat.

<h2 id="tampilan-dashboard">📸 Tampilan Dashboard (Nanti Diisi Kalo Dashboard udah jadi)</h2>

**1. Tampilan Menu Utama atau Homepage**
* Menampilkan ringkasan informasi metrik penting (KPI) seperti total klinik, jumlah dokter terdaftar, dan total kunjungan pasien.
* Statistik distribusi pasien berdasarkan poliklinik atau spesialisasi dalam bentuk grafik interaktif.
* Menampilkan daftar layanan atau dokter dengan tingkat kunjungan tertinggi.

*(Ganti teks ini dengan Screenshot Halaman Utama aplikasimu)*
`![Homepage KlinikHub](link-gambar-atau-lokasi-folder-gambar.png)`

**2. Tampilan Eksplorasi Data & Filter**
* Menyediakan fitur filter dinamis untuk mencari data berdasarkan kategori tertentu.
* Pengguna dapat mencari jadwal berdasarkan nama klinik, rentang tanggal kunjungan, atau nama dokter secara cepat.
* Menampilkan detail tabel riwayat kunjungan dan tindakan medis pasien.

*(Ganti teks ini dengan Screenshot Halaman Eksplorasi aplikasimu)*
`![Eksplorasi KlinikHub](link-gambar-atau-lokasi-folder-gambar.png)`

<h2 id="skema-basis-data">🗄️ Skema Basis Data & ERD</h2>

<p>Sistem basis data dalam proyek <b>KlinikHub</b> dirancang menggunakan arsitektur relasional untuk memastikan integritas data medis dan efisiensi <i>query</i>. Semua entitas operasional terpusat dan berelasi kuat dengan entitas utama layanan kesehatan.</p>

<div align="center">
  <img src="images/ERD.png" alt="Entity Relationship Diagram KlinikHub" width="80%">
  <br>
  <i>Gambar 1: Entity Relationship Diagram (ERD) KlinikHub</i>
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

Bagian ini mendeskripsikan struktur tabel, tipe data (Data Dictionary), serta sintaks SQL (Data Definition Language/DDL) yang digunakan untuk membangun skema basis data KlinikHub.

### 🧮 Membuat Basis Data (Database)

Basis Data **KlinikHub** menyimpan informasi operasional medis yang mewakili atribut data yang saling berhubungan untuk keperluan analisis.

```sql
CREATE DATABASE IF NOT EXISTS klinikhub_db;

USE klinikhub_db;
```

### 🏥 Membuat Tabel Klinik

Tabel Klinik menyediakan informasi mengenai entitas fasilitas kesehatan. Pengguna dapat mengetahui dari ID unik klinik, nama klinik, dan kota tempat klinik beroperasi.

| Attribute        | Type                   | Description       |
|------------------|------------------------|-------------------|
| id_klinik (PK)   | Character Varying(5)   | ID unik klinik    |
| nama_klinik      | Character Varying(255) | Nama klinik       |

with the SQL script :

``` sql
CREATE TABLE IF NOT EXISTS directors (
  id_klinik VARCHAR(5) PRIMARY KEY,
  nama_klinik VARCHAR(255)
);
```
Lanjut Seterusnya......


<h2 id="tools-digunakan">🛠️ Tools yang Digunakan</h2>

<p>Proyek <b>KlinikHub</b> dibangun menggunakan ekosistem teknologi modern untuk memastikan performa pengolahan data besar yang optimal dan antarmuka yang interaktif:</p>

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
├── 📂 app/                     # Direktori utama aplikasi RShiny
│   ├── 📄 server.R             # Logika backend, koneksi database, dan reaktivitas
│   └── 📄 ui.R                 # Antarmuka pengguna (Frontend dashboard)
├── 📂 data/                    # Penyimpanan dataset proyek
│   ├── 📂 clean/               # Dataset yang telah dinormalisasi (siap pakai)
│   └── 📂 raw/                 # Dataset mentah awal (Dataset_Klinik_Raw.csv)
├── 📂 doc/                     # Dokumentasi teknis proyek
│   └── 🖼️ ERD.png              # Gambar Entity Relationship Diagram (ERD)
├── 📂 images/                  # Aset visual untuk UI dashboard dan README
│   ├── 🖼️ joice.png            # Foto profil anggota tim
│   ├── 🖼️ wita.png
│   └── 🖼️ ika.png
└── 📝 README.md                # Dokumentasi utama repositori (file ini)
```

<h2 id="tim-pengembang">👥 Tim Pengembang</h2>

Proyek **KlinikHub** ini dikembangkan melalui kolaborasi tim yang hebat, dengan rincian anggota dan pembagian peran sebagai berikut:

<table align="center" width="100%">
  <tr>
    <td align="center" width="25%">
      <a href="https://github.com/username_joice">
        <img src="https://github.com/username_joice.png?size=200" width="160px;" alt="Joice"/><br>
        <br><b>Joice Junansi T.</b>
      </a><br>
      <sub>M0501251007</sub><br>
      <i>Database Manager</i>
    </td>
    <td align="center" width="25%">
      <a href="https://github.com/username_wita">
        <img src="https://github.com/username_wita.png?size=200" width="160px;" alt="Wita"/><br>
        <br><b>Baiq Wita Rachmatia</b>
      </a><br>
      <sub>M0501251061</sub><br>
      <i>Frontend Developer</i>
    </td>
    <td align="center" width="25%">
      <a href="https://github.com/avinrahmadian">
        <img src="https://github.com/avinrahmadian.png?size=200" width="160px;" alt="Avin"/><br>
        <br><b>Avin Rahmadian</b>
      </a><br>
      <sub>M0501251023</sub><br>
      <i>Backend Developer</i>
    </td>
    <td align="center" width="25%">
      <a href="https://github.com/username_ika">
        <img src="https://github.com/username_ika.png?size=200" width="160px;" alt="Ika"/><br>
        <br><b>Ika Lailia N. R. N.</b>
      </a><br>
      <sub>M0501251020</sub><br>
      <i>Data Analyst</i>
    </td>
  </tr>
</table>
<br>

## 👥 Tim Pengembang

Proyek **KlinikHub** ini dikembangkan melalui kolaborasi tim yang hebat, dengan rincian anggota dan pembagian peran sebagai berikut:

<table align="center" width="100%">
  <tr>
    <td align="center" width="50%">
      <a href="https://github.com/username_joice">
        <img src="https://github.com/username_joice.png?size=250" width="200px;" alt="Joice"/><br>
        <br><b>Joice Junansi T.</b>
      </a><br>
      <sub>M0501251007</sub><br>
      <i>Database Manager</i>
    </td>
    <td align="center" width="50%">
      <a href="https://github.com/username_wita">
        <img src="https://github.com/username_wita.png?size=250" width="200px;" alt="Wita"/><br>
        <br><b>Baiq Wita Rachmatia</b>
      </a><br>
      <sub>M0501251061</sub><br>
      <i>Frontend Developer</i>
    </td>
  </tr>
  <tr>
    <td align="center" width="50%">
      <br>
      <a href="https://github.com/avinrahmadian">
        <img src="https://github.com/avinrahmadian.png?size=250" width="200px;" alt="Avin"/><br>
        <br><b>Avin Rahmadian</b>
      </a><br>
      <sub>M0501251023</sub><br>
      <i>Backend Developer</i>
    </td>
    <td align="center" width="50%">
      <br>
      <a href="https://github.com/username_ika">
        <img src="https://github.com/username_ika.png?size=250" width="200px;" alt="Ika"/><br>
        <br><b>Ika Lailia N. R. N.</b>
      </a><br>
      <sub>M0501251020</sub><br>
      <i>Data Analyst</i>
    </td>
  </tr>
</table>
<br>

## 👥 Tim Pengembang KlinikHub

<table width="100%">
  <tr>
    <td width="30%" align="center">
      <img src="images/joice.png" width="250" alt="Joice">
    </td>
    <td width="70%">
      <h3><a href="https://github.com/username_joice">Joice Junansi Tandirerung</a></h3>
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
      <h3><a href="https://github.com/username_wita">Baiq Wita Rachmatia</a></h3>
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
      <h3><a href="https://github.com/username_ika">Ika Lailia Nur Rohmatun Nazila</a></h3>
      <b>M0501251020 | 📊 Data Analyst</b>
      <hr>
      <i>Mengeksplorasi dataset, mengekstrak insight klinis, dan merancang metrik visualisasi.</i>
    </td>
  </tr>
</table>
<br>

## 👥 Tim Pengembang KlinikHub

<br>

<div>
  <img align="left" width="200" src="images/joice.png" alt="Joice">
  <h3><a href="https://github.com/username_joice">Joice Junansi Tandirerung</a></h3>
  <b>M0501251007 | 🗄️ Database Manager</b><br><br>
  <i>Mendesain struktur database dan ERD, serta menulis dan menguji query SQL yang akan digunakan oleh backend.</i>
</div>
<br clear="left"/>
<hr>

<div>
  <img align="left" width="200" src="images/wita.png" alt="Wita">
  <h3><a href="https://github.com/username_wita">Baiq Wita Rachmatia</a></h3>
  <b>M0501251061 | 🎨 Frontend Developer</b><br><br>
  <i>Mendesain struktur UI dashboard beserta komponen input/output, dan mengintegrasikan hasil dari server ke tampilan visual pengguna.</i>
</div>
<br clear="left"/>
<hr>

<div>
  <img align="left" width="200" src="https://github.com/avinrahmadian.png" alt="Avin">
  <h3><a href="https://github.com/avinrahmadian">Avin Rahmadian</a></h3>
  <b>M0501251023 | 🖥️ Backend Developer</b><br><br>
  <i>Menghubungkan R dengan database, mengelola logika reaktivitas server RShiny, dan memproses data untuk disediakan ke frontend.</i>
</div>
<br clear="left"/>
<hr>

<div>
  <img align="left" width="200" src="images/ika.png" alt="Ika">
  <h3><a href="https://github.com/username_ika">Ika Lailia Nur Rohmatun Nazila</a></h3>
  <b>M0501251020 | 📊 Data Analyst</b><br><br>
  <i>Menentukan KPI, menguji validitas data pada dashboard, serta menyusun interpretasi insight utama dan dokumentasi proyek.</i>
</div>
<br clear="left"/>













