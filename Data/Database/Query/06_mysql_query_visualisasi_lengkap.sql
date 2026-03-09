USE `db_klinik_normalisasi`;

-- ==========================================================
-- HOME / GLOBAL
-- ==========================================================

-- H1. KOTAK RINGKASAN UTAMA
SELECT
  (SELECT COUNT(*)
   FROM `visit` v
   JOIN `clinic` c ON c.clinic_id = v.clinic_id
   WHERE {{CLINIC_FILTER}}) AS total_visit,
  (SELECT ROUND(SUM(COALESCE(t.total_amount, 0)), 2)
   FROM `transactions` t
   JOIN `visit` v ON v.visit_id = t.visit_id
   JOIN `clinic` c ON c.clinic_id = v.clinic_id
   WHERE {{CLINIC_FILTER}}) AS total_revenue,
  (SELECT COUNT(DISTINCT c.clinic_id)
   FROM `clinic` c
   WHERE {{CLINIC_FILTER}}) AS total_klinik,
  (SELECT COUNT(DISTINCT v.patient_id)
   FROM `visit` v
   JOIN `clinic` c ON c.clinic_id = v.clinic_id
   WHERE {{CLINIC_FILTER}}) AS jumlah_pasien,
  (SELECT COUNT(DISTINCT d.doctor_id)
   FROM `doctor` d
   JOIN `clinic` c ON c.clinic_id = d.clinic_id
   WHERE {{CLINIC_FILTER}}) AS jumlah_dokter;

-- H2. TREN KUNJUNGAN DAN PREDIKSI BULANAN
WITH RECURSIVE monthly_visit AS (
  SELECT
    DATE_FORMAT(v.visit_datetime, '%Y-%m-01') AS month_start,
    COUNT(*) AS total_kunjungan
  FROM `visit` v
  JOIN `clinic` c ON c.clinic_id = v.clinic_id
  WHERE {{CLINIC_FILTER}}
  GROUP BY DATE_FORMAT(v.visit_datetime, '%Y-%m-01')
),
last_three AS (
  SELECT month_start, total_kunjungan
  FROM monthly_visit
  ORDER BY month_start DESC
  LIMIT 3
),
seed_forecast AS (
  SELECT
    DATE_ADD(MAX(STR_TO_DATE(month_start, '%Y-%m-%d')), INTERVAL 1 MONTH) AS forecast_month,
    ROUND(AVG(total_kunjungan), 0) AS forecast_kunjungan,
    1 AS step_no
  FROM last_three
),
forecast_next AS (
  SELECT forecast_month, forecast_kunjungan, step_no
  FROM seed_forecast
  UNION ALL
  SELECT
    DATE_ADD(forecast_month, INTERVAL 1 MONTH),
    forecast_kunjungan,
    step_no + 1
  FROM forecast_next
  WHERE step_no < 3
)
SELECT *
FROM (
  SELECT
    DATE_FORMAT(STR_TO_DATE(month_start, '%Y-%m-%d'), '%Y-%m') AS periode,
    total_kunjungan AS nilai,
    'actual' AS series
  FROM monthly_visit

  UNION ALL

  SELECT
    DATE_FORMAT(forecast_month, '%Y-%m') AS periode,
    forecast_kunjungan AS nilai,
    'forecast_3ma' AS series
  FROM forecast_next
) x
ORDER BY periode, series;

-- H3. WORDCLOUD PENYAKIT
SELECT
  d.diagnosis_name,
  COUNT(*) AS total_kasus
FROM `visit_diagnosis` vd
JOIN `diagnosis` d ON d.diagnosis_id = vd.diagnosis_id
JOIN `visit` v ON v.visit_id = vd.visit_id
JOIN `clinic` c ON c.clinic_id = v.clinic_id
WHERE {{CLINIC_FILTER}}
GROUP BY d.diagnosis_name
ORDER BY total_kasus DESC;

-- H4. PETA SEBARAN KLINIK
WITH clinic_visit AS (
  SELECT
    v.clinic_id,
    COUNT(DISTINCT v.visit_id) AS total_kunjungan
  FROM `visit` v
  GROUP BY v.clinic_id
),
clinic_doctor AS (
  SELECT
    d.clinic_id,
    COUNT(DISTINCT d.doctor_id) AS total_dokter
  FROM `doctor` d
  GROUP BY d.clinic_id
),
clinic_revenue AS (
  SELECT
    v.clinic_id,
    ROUND(SUM(COALESCE(t.total_amount, 0)), 2) AS total_revenue
  FROM `visit` v
  LEFT JOIN `transactions` t ON t.visit_id = v.visit_id
  GROUP BY v.clinic_id
)
SELECT
  c.clinic_id,
  c.clinic_name,
  c.clinic_city,
  c.clinic_province,
  COALESCE(cv.total_kunjungan, 0) AS total_kunjungan,
  COALESCE(cd.total_dokter, 0) AS total_dokter,
  COALESCE(cr.total_revenue, 0) AS total_revenue
FROM `clinic` c
LEFT JOIN clinic_visit cv ON cv.clinic_id = c.clinic_id
LEFT JOIN clinic_doctor cd ON cd.clinic_id = c.clinic_id
LEFT JOIN clinic_revenue cr ON cr.clinic_id = c.clinic_id
WHERE {{CLINIC_FILTER}}
ORDER BY total_revenue DESC, total_kunjungan DESC;

-- ==========================================================
-- KLINIK
-- ==========================================================

-- K1. RADAR CHART PERBANDINGAN KLINIK BERDASARKAN RATA-RATA REVENUE PER KOMPONEN
WITH clinic_metric AS (
  SELECT
    c.clinic_id,
    c.clinic_name,
    ROUND(AVG(COALESCE(t.administration_fee, 0)), 2) AS avg_administration_fee,
    ROUND(AVG(COALESCE(t.doctor_consultation_fee, 0)), 2) AS avg_consultation_fee,
    ROUND(AVG(COALESCE(t.medicine_total, 0)), 2) AS avg_medicine_revenue,
    ROUND(AVG(COALESCE(t.treatment_total, 0)), 2) AS avg_treatment_revenue
  FROM `clinic` c
  LEFT JOIN `visit` v ON v.clinic_id = c.clinic_id
  LEFT JOIN `transactions` t ON t.visit_id = v.visit_id
  WHERE {{CLINIC_FILTER}}
  GROUP BY c.clinic_id, c.clinic_name
)
SELECT clinic_name, 'avg_administration_fee' AS metric_name, avg_administration_fee AS metric_value FROM clinic_metric
UNION ALL
SELECT clinic_name, 'avg_consultation_fee' AS metric_name, avg_consultation_fee AS metric_value FROM clinic_metric
UNION ALL
SELECT clinic_name, 'avg_medicine_revenue' AS metric_name, avg_medicine_revenue AS metric_value FROM clinic_metric
UNION ALL
SELECT clinic_name, 'avg_treatment_revenue' AS metric_name, avg_treatment_revenue AS metric_value FROM clinic_metric
ORDER BY clinic_name, metric_name;

-- K2. TOP 5 KLINIK BERDASARKAN KUNJUNGAN
SELECT
  c.clinic_name,
  COUNT(v.visit_id) AS total_kunjungan
FROM `clinic` c
LEFT JOIN `visit` v ON v.clinic_id = c.clinic_id
WHERE {{CLINIC_FILTER}}
GROUP BY c.clinic_name
ORDER BY total_kunjungan DESC
LIMIT 5;

-- K3. LOYALITAS PASIEN PER KLINIK (DONUT)
WITH patient_repeat AS (
  SELECT
    c.clinic_name,
    v.patient_id,
    COUNT(*) AS total_visit_patient
  FROM `visit` v
  JOIN `clinic` c ON c.clinic_id = v.clinic_id
  WHERE {{CLINIC_FILTER}}
  GROUP BY c.clinic_name, v.patient_id
)
SELECT
  clinic_name,
  CASE WHEN total_visit_patient > 1 THEN 'repeat_patient' ELSE 'one_time_patient' END AS loyalty_status,
  COUNT(*) AS total_pasien
FROM patient_repeat
GROUP BY clinic_name, loyalty_status
ORDER BY clinic_name, loyalty_status;

-- K4. DISTRIBUSI SPESIALISASI PER KLINIK (TREEMAP)
SELECT
  c.clinic_name,
  d.doctor_specialty,
  COUNT(DISTINCT d.doctor_id) AS total_dokter,
  COUNT(v.visit_id) AS total_kunjungan
FROM `clinic` c
LEFT JOIN `doctor` d ON d.clinic_id = c.clinic_id
LEFT JOIN `visit` v ON v.doctor_id = d.doctor_id
WHERE {{CLINIC_FILTER}}
GROUP BY c.clinic_name, d.doctor_specialty
ORDER BY c.clinic_name, total_dokter DESC, total_kunjungan DESC;

-- K5. TABEL KESELURUHAN INFORMASI KLINIK
WITH clinic_doctor AS (
  SELECT
    d.clinic_id,
    COUNT(DISTINCT d.doctor_id) AS total_dokter
  FROM `doctor` d
  GROUP BY d.clinic_id
),
clinic_visit AS (
  SELECT
    v.clinic_id,
    COUNT(DISTINCT v.patient_id) AS total_pasien_unik,
    COUNT(DISTINCT v.visit_id) AS total_kunjungan
  FROM `visit` v
  GROUP BY v.clinic_id
),
clinic_revenue AS (
  SELECT
    v.clinic_id,
    ROUND(SUM(COALESCE(t.total_amount, 0)), 2) AS total_revenue,
    ROUND(AVG(COALESCE(t.total_amount, 0)), 2) AS avg_revenue_per_visit
  FROM `visit` v
  LEFT JOIN `transactions` t ON t.visit_id = v.visit_id
  GROUP BY v.clinic_id
)
SELECT
  c.clinic_id,
  c.clinic_name,
  c.clinic_city,
  c.clinic_province,
  c.clinic_open_date,
  c.head_doctor_name_of_clinic,
  COALESCE(cd.total_dokter, 0) AS total_dokter,
  COALESCE(cv.total_pasien_unik, 0) AS total_pasien_unik,
  COALESCE(cv.total_kunjungan, 0) AS total_kunjungan,
  COALESCE(cr.total_revenue, 0) AS total_revenue,
  COALESCE(cr.avg_revenue_per_visit, 0) AS avg_revenue_per_visit
FROM `clinic` c
LEFT JOIN clinic_doctor cd ON cd.clinic_id = c.clinic_id
LEFT JOIN clinic_visit cv ON cv.clinic_id = c.clinic_id
LEFT JOIN clinic_revenue cr ON cr.clinic_id = c.clinic_id
WHERE {{CLINIC_FILTER}}
ORDER BY total_revenue DESC, total_kunjungan DESC;

-- ==========================================================
-- DOKTER
-- ==========================================================

-- D1. RINGKASAN KOTAK DOKTER
WITH specialty_demand AS (
  SELECT
    d.doctor_specialty,
    COUNT(v.visit_id) AS total_kunjungan,
    ROW_NUMBER() OVER (ORDER BY COUNT(v.visit_id) DESC, d.doctor_specialty) AS rn
  FROM `doctor` d
  LEFT JOIN `visit` v ON v.doctor_id = d.doctor_id
  JOIN `clinic` c ON c.clinic_id = d.clinic_id
  WHERE {{CLINIC_FILTER}}
  GROUP BY d.doctor_specialty
)
SELECT
  COUNT(DISTINCT d.doctor_id) AS total_dokter,
  ROUND(COUNT(DISTINCT v.patient_id) / NULLIF(COUNT(DISTINCT d.doctor_id), 0), 2) AS rata_rata_pasien_per_dokter,
  (SELECT sd.doctor_specialty
   FROM specialty_demand sd
   WHERE sd.rn = 1
   LIMIT 1) AS spesialisasi_paling_dicari
FROM `doctor` d
LEFT JOIN `visit` v ON v.doctor_id = d.doctor_id
JOIN `clinic` c ON c.clinic_id = d.clinic_id
WHERE {{CLINIC_FILTER}};

-- D2. KOMPOSISI GENDER DOKTER PER SPESIALISASI
SELECT
  d.doctor_specialty,
  d.doctor_gender,
  COUNT(DISTINCT d.doctor_id) AS total_dokter
FROM `doctor` d
JOIN `clinic` c ON c.clinic_id = d.clinic_id
WHERE {{CLINIC_FILTER}}
GROUP BY d.doctor_specialty, d.doctor_gender
ORDER BY d.doctor_specialty, d.doctor_gender;

-- D3. TOP 1 DOKTER BERDASARKAN KUNJUNGAN TERBANYAK
SELECT
  d.doctor_name,
  d.doctor_specialty,
  c.clinic_name,
  COUNT(v.visit_id) AS total_kunjungan
FROM `doctor` d
LEFT JOIN `visit` v ON v.doctor_id = d.doctor_id
JOIN `clinic` c ON c.clinic_id = d.clinic_id
WHERE {{CLINIC_FILTER}}
GROUP BY d.doctor_name, d.doctor_specialty, c.clinic_name
ORDER BY total_kunjungan DESC, d.doctor_name
LIMIT 1;

-- D4. TOP 3 DOKTER TERMAHAL BERDASARKAN TARIF KONSULTASI
SELECT
  d.doctor_specialty,
  d.doctor_name,
  c.clinic_name,
  d.doctor_consultation_fee
FROM `doctor` d
JOIN `clinic` c ON c.clinic_id = d.clinic_id
WHERE {{CLINIC_FILTER}}
ORDER BY d.doctor_consultation_fee DESC, d.doctor_name
LIMIT 3;

-- D5. DATA BOXPLOT TARIF KONSULTASI ANTAR SPESIALIS
SELECT
  d.doctor_specialty,
  d.doctor_name,
  c.clinic_name,
  d.doctor_consultation_fee
FROM `doctor` d
JOIN `clinic` c ON c.clinic_id = d.clinic_id
WHERE {{CLINIC_FILTER}}
  AND d.doctor_consultation_fee IS NOT NULL
ORDER BY d.doctor_specialty, d.doctor_consultation_fee;

-- D6. TABEL KESELURUHAN INFORMASI DOKTER
SELECT
  d.doctor_id,
  d.doctor_name,
  d.doctor_gender,
  d.doctor_specialty,
  d.doctor_consultation_fee,
  c.clinic_name,
  COUNT(v.visit_id) AS total_kunjungan,
  COUNT(DISTINCT v.patient_id) AS total_pasien_unik,
  ROUND(SUM(COALESCE(t.total_amount, 0)), 2) AS total_revenue_dokter
FROM `doctor` d
JOIN `clinic` c ON c.clinic_id = d.clinic_id
LEFT JOIN `visit` v ON v.doctor_id = d.doctor_id
LEFT JOIN `transactions` t ON t.visit_id = v.visit_id
WHERE {{CLINIC_FILTER}}
GROUP BY
  d.doctor_id,
  d.doctor_name,
  d.doctor_gender,
  d.doctor_specialty,
  d.doctor_consultation_fee,
  c.clinic_name
ORDER BY total_kunjungan DESC, total_pasien_unik DESC;

-- ==========================================================
-- PASIEN
-- ==========================================================

-- P1. PIRAMIDA PENDUDUK
WITH age_base AS (
  SELECT
    p.patient_id,
    p.gender,
    TIMESTAMPDIFF(YEAR, p.date_of_birth, v.visit_datetime) AS age_years
  FROM `patient` p
  JOIN `visit` v ON v.patient_id = p.patient_id
  JOIN `clinic` c ON c.clinic_id = v.clinic_id
  WHERE {{CLINIC_FILTER}}
    AND p.date_of_birth IS NOT NULL
    AND v.visit_datetime IS NOT NULL
),
age_grouped AS (
  SELECT
    CASE
      WHEN age_years < 5 THEN '00-04'
      WHEN age_years BETWEEN 5 AND 12 THEN '05-12'
      WHEN age_years BETWEEN 13 AND 17 THEN '13-17'
      WHEN age_years BETWEEN 18 AND 35 THEN '18-35'
      WHEN age_years BETWEEN 36 AND 59 THEN '36-59'
      ELSE '60+'
    END AS age_group,
    gender
  FROM age_base
)
SELECT
  age_group,
  gender,
  COUNT(*) AS total_kunjungan,
  CASE WHEN gender = 'L' THEN -COUNT(*) ELSE COUNT(*) END AS pyramid_value
FROM age_grouped
GROUP BY age_group, gender
ORDER BY FIELD(age_group, '00-04', '05-12', '13-17', '18-35', '36-59', '60+'), gender;

-- P2. ANALISIS STATUS GIZI (BMI SCATTER)
SELECT DISTINCT
  p.patient_id,
  p.patient_name,
  p.gender,
  p.height,
  p.weight,
  ROUND(p.weight / POW(p.height / 100, 2), 2) AS bmi
FROM `patient` p
JOIN `visit` v ON v.patient_id = p.patient_id
JOIN `clinic` c ON c.clinic_id = v.clinic_id
WHERE {{CLINIC_FILTER}}
  AND p.height IS NOT NULL
  AND p.weight IS NOT NULL
  AND p.height > 0
  AND p.weight > 0;

-- P3. TREN KELUHAN / DIAGNOSIS VS WAKTU
SELECT
  DATE(v.visit_datetime) AS visit_date,
  d.diagnosis_name,
  COUNT(DISTINCT v.visit_id) AS total_kunjungan
FROM `visit` v
JOIN `clinic` c ON c.clinic_id = v.clinic_id
LEFT JOIN `transactions` t ON t.visit_id = v.visit_id
LEFT JOIN `diagnosis` d ON d.diagnosis_id = t.primary_diagnosis_id
WHERE {{CLINIC_FILTER}}
GROUP BY DATE(v.visit_datetime), d.diagnosis_name
ORDER BY visit_date, total_kunjungan DESC;

-- P4. JENIS TIPE PASIEN
SELECT
  p.patient_type,
  COUNT(*) AS total_kunjungan,
  COUNT(DISTINCT p.patient_id) AS total_pasien
FROM `patient` p
JOIN `visit` v ON v.patient_id = p.patient_id
JOIN `clinic` c ON c.clinic_id = v.clinic_id
WHERE {{CLINIC_FILTER}}
GROUP BY p.patient_type
ORDER BY total_kunjungan DESC;

-- P5. METODE PEMBAYARAN (LOLLIPOP HORIZONTAL)
SELECT
  COALESCE(t.payment_method, 'unknown') AS payment_method,
  COUNT(v.visit_id) AS total_kunjungan
FROM `visit` v
JOIN `clinic` c ON c.clinic_id = v.clinic_id
LEFT JOIN `transactions` t ON t.visit_id = v.visit_id
WHERE {{CLINIC_FILTER}}
GROUP BY COALESCE(t.payment_method, 'unknown')
ORDER BY total_kunjungan DESC;

-- P6. TABEL KESELURUHAN INFORMASI PASIEN
SELECT
  p.patient_id,
  p.patient_name,
  p.gender,
  p.date_of_birth,
  p.height,
  p.weight,
  p.patient_city,
  p.patient_province,
  p.patient_type,
  COUNT(v.visit_id) AS total_kunjungan,
  COUNT(DISTINCT v.clinic_id) AS total_klinik_dikunjungi,
  MIN(v.visit_datetime) AS kunjungan_pertama,
  MAX(v.visit_datetime) AS kunjungan_terakhir,
  ROUND(AVG(CASE WHEN p.height > 0 AND p.weight > 0 THEN p.weight / POW(p.height / 100, 2) END), 2) AS bmi_rata_rata
FROM `patient` p
LEFT JOIN `visit` v ON v.patient_id = p.patient_id
LEFT JOIN `clinic` c ON c.clinic_id = v.clinic_id
WHERE {{CLINIC_FILTER}}
GROUP BY
  p.patient_id,
  p.patient_name,
  p.gender,
  p.date_of_birth,
  p.height,
  p.weight,
  p.patient_city,
  p.patient_province,
  p.patient_type
ORDER BY total_kunjungan DESC, p.patient_name;

-- ==========================================================
-- OBAT
-- ==========================================================

-- O1. KOTAK RINGKASAN OBAT
WITH medicine_summary AS (
  SELECT
    SUM(COALESCE(m.medicine_dosage_per_day, 0) * COALESCE(m.medicine_duration_days, 0)) AS total_item_obat_terjual,
    COUNT(vm.visit_id) / NULLIF(COUNT(DISTINCT vm.visit_id), 0) AS rata_rata_jenis_obat_per_resep
  FROM `visit_medicine` vm
  JOIN `medicine` m ON m.medicine_id = vm.medicine_id
  JOIN `visit` v ON v.visit_id = vm.visit_id
  JOIN `clinic` c ON c.clinic_id = v.clinic_id
  WHERE {{CLINIC_FILTER}}
),
most_expensive_category AS (
  SELECT
    m.medicine_category,
    ROUND(AVG(COALESCE(m.medicine_unit_price, 0)), 2) AS avg_unit_price,
    ROW_NUMBER() OVER (ORDER BY AVG(COALESCE(m.medicine_unit_price, 0)) DESC, m.medicine_category) AS rn
  FROM `visit_medicine` vm
  JOIN `medicine` m ON m.medicine_id = vm.medicine_id
  JOIN `visit` v ON v.visit_id = vm.visit_id
  JOIN `clinic` c ON c.clinic_id = v.clinic_id
  WHERE {{CLINIC_FILTER}}
  GROUP BY m.medicine_category
)
SELECT
  ROUND(ms.total_item_obat_terjual, 2) AS total_item_obat_terjual,
  ROUND(ms.rata_rata_jenis_obat_per_resep, 2) AS rata_rata_jenis_obat_per_resep,
  mec.medicine_category AS kategori_obat_paling_mahal,
  mec.avg_unit_price AS rata_rata_harga_kategori_termahal
FROM medicine_summary ms
LEFT JOIN most_expensive_category mec ON mec.rn = 1;

-- O2. TOP 10 OBAT PALING LARIS
SELECT
  m.medicine_name,
  m.medicine_category,
  COUNT(vm.visit_id) AS total_resep
FROM `visit_medicine` vm
JOIN `medicine` m ON m.medicine_id = vm.medicine_id
JOIN `visit` v ON v.visit_id = vm.visit_id
JOIN `clinic` c ON c.clinic_id = v.clinic_id
WHERE {{CLINIC_FILTER}}
GROUP BY m.medicine_name, m.medicine_category
ORDER BY total_resep DESC, m.medicine_name
LIMIT 10;

-- O3. KORELASI HARGA SATUAN VS DURASI PENGOBATAN
SELECT
  m.medicine_id,
  m.medicine_name,
  m.medicine_category,
  m.medicine_unit_price,
  m.medicine_duration_days,
  m.medicine_dosage_per_day,
  COUNT(vm.visit_id) AS total_resep
FROM `visit_medicine` vm
JOIN `medicine` m ON m.medicine_id = vm.medicine_id
JOIN `visit` v ON v.visit_id = vm.visit_id
JOIN `clinic` c ON c.clinic_id = v.clinic_id
WHERE {{CLINIC_FILTER}}
GROUP BY
  m.medicine_id,
  m.medicine_name,
  m.medicine_category,
  m.medicine_unit_price,
  m.medicine_duration_days,
  m.medicine_dosage_per_day
ORDER BY total_resep DESC;

-- O4. DISTRIBUSI DOSIS OBAT PER HARI
SELECT
  m.medicine_dosage_per_day,
  COUNT(*) AS total_item
FROM `visit_medicine` vm
JOIN `medicine` m ON m.medicine_id = vm.medicine_id
JOIN `visit` v ON v.visit_id = vm.visit_id
JOIN `clinic` c ON c.clinic_id = v.clinic_id
WHERE {{CLINIC_FILTER}}
  AND m.medicine_dosage_per_day IS NOT NULL
GROUP BY m.medicine_dosage_per_day
ORDER BY m.medicine_dosage_per_day;

-- O5. ANALISIS OBAT PENDAMPING (CO-OCCURRENCE NETWORK)
SELECT
  m1.medicine_name AS source_medicine,
  m2.medicine_name AS target_medicine,
  COUNT(DISTINCT vm1.visit_id) AS co_occurrence_count
FROM `visit_medicine` vm1
JOIN `visit_medicine` vm2
  ON vm1.visit_id = vm2.visit_id
 AND vm1.medicine_id < vm2.medicine_id
JOIN `medicine` m1 ON m1.medicine_id = vm1.medicine_id
JOIN `medicine` m2 ON m2.medicine_id = vm2.medicine_id
JOIN `visit` v ON v.visit_id = vm1.visit_id
JOIN `clinic` c ON c.clinic_id = v.clinic_id
WHERE {{CLINIC_FILTER}}
GROUP BY m1.medicine_name, m2.medicine_name
HAVING COUNT(DISTINCT vm1.visit_id) >= 2
ORDER BY co_occurrence_count DESC, source_medicine, target_medicine;

-- O6. TABEL KESELURUHAN INFORMASI OBAT
SELECT
  m.medicine_id,
  m.medicine_name,
  m.medicine_category,
  m.medicine_unit_price,
  m.medicine_dosage_per_day,
  m.medicine_duration_days,
  COUNT(vm.visit_id) AS total_resep,
  ROUND(SUM(COALESCE(m.medicine_dosage_per_day, 0) * COALESCE(m.medicine_duration_days, 0)), 2) AS total_unit_estimasi,
  ROUND(SUM(COALESCE(m.medicine_unit_price, 0) * COALESCE(m.medicine_dosage_per_day, 0) * COALESCE(m.medicine_duration_days, 0)), 2) AS total_revenue_estimasi
FROM `visit_medicine` vm
JOIN `medicine` m ON m.medicine_id = vm.medicine_id
JOIN `visit` v ON v.visit_id = vm.visit_id
JOIN `clinic` c ON c.clinic_id = v.clinic_id
WHERE {{CLINIC_FILTER}}
GROUP BY
  m.medicine_id,
  m.medicine_name,
  m.medicine_category,
  m.medicine_unit_price,
  m.medicine_dosage_per_day,
  m.medicine_duration_days
ORDER BY total_resep DESC, total_revenue_estimasi DESC;
