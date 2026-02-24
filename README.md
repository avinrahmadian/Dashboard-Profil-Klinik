
<h1 align="center">🏥 <b>Welcome To KlinikHub</b> 🚑💊</h1>
<h2 align="center"><i>"Smart Insights, Healthy Lives"</i></h2>

🏥 KlinikHub - Platform Pusat Informasi & Data Klinik

### 🚀Apa itu KlinikHub?

**KlinikHub!** adalah platform analitik yang menghadirkan pengalaman terbaik dalam mengeksplorasi data kesehatan. Dengan database klinis yang terpercaya, pengguna dapat menelusuri profil pasien, tren penyakit, hingga statistik kunjungan secara akurat. Temukan wawasan medis terbaik hanya di KlinikHub! 📊🩺✨

<h2 id="tentang-nobar">📋 Tentang KlinikHub</h2>

Tugas mata kuliah Pemrosesan Data Besar ini mengambil topik Database Platform KlinikHub. Analisis proyek ini bertujuan untuk merancang dan mengoptimalkan sistem manajemen database Klinik, termasuk entitas seperti klinik, dokter, pasien, kunjungan, dan tindakan medis. Struktur database dirancang dengan model relasional yang memanfaatkan entitas dan referensial integrity constraints untuk memastikan validitas data. Dataset yang digunakan dalam proyek ini bersumber dari Dataset Mata Kuliah Manajemen Data Statistika. Hasil yang diharapkan adalah sebuah aplikasi web yang memungkinkan pengguna untuk menelusuri data dokter berdasarkan spesialisasi, melihat riwayat kunjungan pasien, serta mengevaluasi tren layanan klinik. Pengguna dapat mencari data berdasarkan kategori tertentu, misalnya pencarian jadwal berdasarkan nama klinik, tanggal kunjungan, atau nama dokter.

## 📖 Deskripsi Proyek
Tugas mata kuliah **Pemrosesan Data Besar** ini bertujuan untuk merancang dan mengoptimalkan sistem manajemen database (Platform KlinikHub) serta memvisualisasikannya ke dalam bentuk *dashboard* interaktif berbasis web menggunakan framework **RShiny**. 

Proyek ini berangkat dari satu *dataset raw* berbentuk CSV (`Dataset_Klinik_Raw.csv` dengan 307.188 baris dan 30 kolom). Penyimpanan dalam satu tabel tunggal berisiko menyebabkan redundansi dan inkonsistensi data. Oleh karena itu, data ini dinormalisasi ke dalam **sistem basis data relasional** agar integritasnya terjaga dan proses *query* untuk *dashboard* menjadi lebih efisien.


📖 Deskripsi Proyek
---
Tugas mata kuliah **Pemrosesan Data Besar** ini bertujuan untuk merancang dan mengoptimalkan sistem manajemen database (Platform KlinikHub) serta memvisualisasikannya ke dalam bentuk *dashboard* interaktif berbasis web menggunakan framework **RShiny**.

Proyek ini berangkat dari *dataset raw* berbentuk CSV (`Dataset_Klinik_Raw.csv` dengan 307.188 baris dan 30 kolom) yang bersumber dari **Dataset Mata Kuliah Manajemen Data Statistika**. Karena penyimpanan tabel tunggal berisiko memunculkan redundansi, data tersebut dinormalisasi ke dalam sistem basis data relasional. Struktur ini dirancang menggunakan *referential integrity constraints* pada entitas utamanya (klinik, dokter, pasien, kunjungan, dan tindakan medis) untuk memastikan validitas data dan efisiensi *query*.

Hasil akhirnya adalah aplikasi web yang memudahkan pengguna dalam menelusuri data dokter berdasarkan spesialisasi, melihat riwayat kunjungan pasien, serta mengevaluasi tren layanan. Platform ini juga dilengkapi fitur pencarian spesifik, seperti memfilter jadwal berdasarkan nama klinik, tanggal kunjungan, atau nama dokter secara cepat.





