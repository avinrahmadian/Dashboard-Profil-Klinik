# ==============================================================================
# SCRIPT ANALISIS: BIG DATA & SUPERVISED LEARNING
# Materi: Pengantar Big Data & Supervised Learning (Regresi Linier & Logistik)
# ==============================================================================

# ------------------------------------------------------------------------------
# BAGIAN 1: ILUSTRASI KARAKTERISTIK BIG DATA (5V)
# Berdasarkan: "1 Pengantar Big Data.pdf"
# Kasus: Simulasi data sensor IoT untuk memahami Volume, Velocity, Variety, Veracity, Value
# ------------------------------------------------------------------------------

cat("--- BAGIAN 1: KARAKTERISTIK BIG DATA (5V) ---\n")

# Simulasi Volume & Velocity: Data masuk cepat dalam jumlah besar
set.seed(123)
n <- 1000 
data_sensor <- data.frame(
  timestamp = seq(from = Sys.time(), by = "sec", length.out = n), # Velocity [cite: 28]
  sensor_id = sample(paste0("Sensor-", 1:5), n, replace = TRUE),   # Variety [cite: 33]
  suhu = rnorm(n, mean = 30, sd = 5)
)

# Simulasi Veracity: Menambahkan noise/missing values (kualitas data) [cite: 38]
data_sensor$suhu[sample(1:n, 50)] <- NA 

# Output 1: Ringkasan Data
print(summary(data_sensor$suhu))

# INTERPRETASI BIG DATA:
# 1. Volume: Dataset ini memiliki 1000 observasi, menggambarkan skala data yang besar[cite: 24].
# 2. Velocity: Data dicatat setiap detik, menunjukkan kecepatan aliran data yang tinggi[cite: 28].
# 3. Variety: Penggunaan 'sensor_id' menunjukkan data berasal dari berbagai sumber sensor[cite: 33].
# 4. Veracity: Adanya 'NA' (missing values) menunjukkan masalah kualitas data (noise)[cite: 38].
# 5. Value: Melalui fungsi summary(), kita mengekstraksi nilai (insight) berupa rata-rata suhu[cite: 43].


# ------------------------------------------------------------------------------
# BAGIAN 2: SUPERVISED LEARNING - REGRESI LINIER
# Berdasarkan: "02-Pengantar-Supervised-Learning.pdf"
# Kasus: Prediksi Harga Rumah berdasarkan Luas Bangunan
# ------------------------------------------------------------------------------

cat("\n--- BAGIAN 2: REGRESI LINIER ---\n")

# 1. Menyiapkan Data
luas <- c(50, 60, 70, 80, 90, 100)
harga <- c(300, 350, 400, 450, 520, 580)
df_rumah <- data.frame(luas, harga)

# 2. Membangun Model (Metode Least Squares) [cite: 500]
model_linier <- lm(harga ~ luas, data = df_rumah)

# Output 2: Koefisien Model
coef_linier <- summary(model_linier)$coefficients
print(coef_linier)

# INTERPRETASI REGRESI LINIER:
# - Estimate (Intercept): Jika luas bangunan 0, maka prediksi harga dasar adalah sekitar ", 
#   round(coef_linier[1,1], 2), " juta.
# - Estimate (Luas): Setiap kenaikan 1 m2 luas bangunan, maka harga rumah diprediksi 
#   meningkat sebesar ", round(coef_linier[2,1], 2), " juta[cite: 552].


# ------------------------------------------------------------------------------
# BAGIAN 3: SUPERVISED LEARNING - REGRESI LOGISTIK
# Berdasarkan: "02-Pengantar-Supervised-Learning.pdf"
# Kasus: Klasifikasi Kelulusan (Lulus/Gagal) berdasarkan Jam Belajar
# ------------------------------------------------------------------------------

cat("\n--- BAGIAN 3: REGRESI LOGISTIK (KLASIFIKASI) ---\n")

# 1. Menyiapkan Data (Biner: 0=Gagal, 1=Lulus)
jam_belajar <- c(1, 2, 3, 4, 5, 6, 7, 8, 9, 10)
status_lulus <- c(0, 0, 0, 0, 1, 0, 1, 1, 1, 1)
df_lulus <- data.frame(jam_belajar, status_lulus)

# 2. Membangun Model (Maximum Likelihood) [cite: 551]
model_logistik <- glm(status_lulus ~ jam_belajar, data = df_lulus, family = "binomial")

# Output 3: Koefisien Model (Skala Log-Odds)
print(summary(model_logistik)$coefficients)

# 3. Prediksi Probabilitas untuk belajar 6 jam
prob <- predict(model_logistik, newdata = data.frame(jam_belajar = 6), type = "response")

# INTERPRETASI REGRESI LOGISTIK:
# - Koefisien jam_belajar positif menunjukkan bahwa semakin lama jam belajar, 
#   semakin tinggi peluang mahasiswa untuk lulus[cite: 552].
# - Prediksi Probabilitas: Mahasiswa yang belajar selama 6 jam memiliki peluang lulus sebesar ", 
#   round(prob * 100, 2), "%. 
# - Jika menggunakan threshold 0.5, mahasiswa ini diklasifikasikan sebagai 'Lulus'.


#--------------------------------------------Materi 3-----------------------------------------------------------------------
# ------------------------------------------------------------------------------
# 4A. Evaluasi Regresi (Menggunakan Model Rumah di Bagian 2)
# Metrik: RMSE (Root Mean Squared Error) dan MAE (Mean Absolute Error)
# ------------------------------------------------------------------------------

# Menghitung prediksi dari model linier sebelumnya
pred_harga <- predict(model_linier)
aktual_harga <- df_rumah$harga

# Menghitung Error
error <- aktual_harga - pred_harga
rmse <- sqrt(mean(error^2))
mae <- mean(abs(error))

cat("Metrik Evaluasi Regresi:\n")
cat("RMSE:", round(rmse, 2), "\n")
cat("MAE :", round(mae, 2), "\n")

# INTERPRETASI EVALUASI REGRESI:
# 1. MAE: Secara rata-rata, prediksi harga rumah meleset sebesar ", round(mae, 2), " juta 
#    dari harga aslinya.
# 2. RMSE: Karena RMSE memberikan penalti lebih besar pada error yang besar, nilai ", 
#    round(rmse, 2), " menunjukkan variasi kesalahan prediksi kita. Semakin kecil nilai 
#    RMSE/MAE, semakin akurat model tersebut.


# ------------------------------------------------------------------------------
# 4B. Evaluasi Klasifikasi (Menggunakan Model Kelulusan di Bagian 3)
# Metrik: Confusion Matrix, Akurasi, dan Precision
# ------------------------------------------------------------------------------

# Simulasi Prediksi Kelas (Threshold 0.5)
pred_prob <- predict(model_logistik, type = "response")
pred_kelas <- ifelse(pred_prob > 0.5, 1, 0)
aktual_kelas <- df_lulus$status_lulus

# Membuat Confusion Matrix sederhana
conf_matrix <- table(Aktual = aktual_kelas, Prediksi = pred_kelas)
print(conf_matrix)

# Menghitung Akurasi
akurasi <- sum(diag(conf_matrix)) / sum(conf_matrix)

cat("\nMetrik Evaluasi Klasifikasi:\n")
cat("Akurasi:", akurasi * 100, "%\n")

# INTERPRETASI EVALUASI KLASIFIKASI:
# 1. Confusion Matrix: Menunjukkan berapa banyak yang diprediksi benar (diagonal) 
#    dan berapa yang salah (off-diagonal).
# 2. Akurasi: Model berhasil memprediksi status kelulusan dengan benar sebesar ", 
#    akurasi * 100, "% dari total data.
# 3. Catatan Penting (Materi 3): Akurasi bukan segalanya. Jika data tidak seimbang 
#    (imbalanced), kita perlu melihat metrik lain seperti Precision, Recall, atau F1-Score.


# ------------------------------------------------------------------------------
# BAGIAN 5: PEMILIHAN MODEL (MODEL SELECTION)
# Kasus: Membandingkan dua model berdasarkan nilai AIC (Akaike Information Criterion)
# ------------------------------------------------------------------------------

cat("\n--- BAGIAN 5: PEMILIHAN MODEL ---\n")

# Misal kita punya model alternatif (hanya menggunakan intercept)
model_simple <- glm(status_lulus ~ 1, data = df_lulus, family = "binomial")

aic_model_1 <- AIC(model_logistik)
aic_model_simple <- AIC(model_simple)

cat("AIC Model Logistik (dengan Jam Belajar):", round(aic_model_1, 2), "\n")
cat("AIC Model Simpel (tanpa variabel):", round(aic_model_simple, 2), "\n")

# INTERPRETASI PEMILIHAN MODEL:
# Dalam pemilihan model, kita mencari nilai AIC yang LEBIH KECIL. 
# Model dengan AIC ", round(min(aic_model_1, aic_model_simple), 2), " lebih baik karena 
# berhasil menjelaskan data dengan baik namun tetap efisien (parsimonious).

#--------------------------------------------- Materi 4----------------------------------------------------------------
# Load library yang diperlukan
if(!require(rpart)) install.packages("rpart")
if(!require(rpart.plot)) install.packages("rpart.plot")
library(rpart)
library(rpart.plot)

# ------------------------------------------------------------------------------
# KASUS 1: REGRESSION TREE (PREDIKSI HARGA MOBIL)
# Fokus: Y Kontinu, Kriteria Split RSS (Residual Sum of Squares)
# ------------------------------------------------------------------------------

cat("--- Kasus 1: Regression Tree (Y Kontinu) ---\n")

# 1. Menyiapkan Data (Menggunakan dataset bawaan mtcars)
# Kita ingin memprediksi efisiensi bahan bakar (mpg) berdasarkan fitur mobil
data(mtcars)

# 2. Membangun Model Regression Tree
# rpart secara otomatis menggunakan kriteria split RSS untuk Y kontinu
model_reg_tree <- rpart(mpg ~ cyl + disp + hp + wt, data = mtcars, method = "anova")

# 3. Visualisasi Pohon
prp(model_reg_tree, type = 2, extra = 1, main = "Pohon Regresi: Prediksi MPG")

# INTERPRETASI REGRESSION TREE:
# - Root Node: Split pertama seringkali adalah variabel paling informatif[cite: 28, 41].
# - Di sini, jika 'wt' (berat) >= 2.3, mobil cenderung memiliki mpg lebih rendah.
# - Setiap Leaf (daun) berisi nilai rata-rata (mean response) dari kelompok tersebut[cite: 19, 21, 26].
# - Model ini bersifat 'piecewise constant', artinya semua mobil dalam satu region 
#   akan mendapatkan prediksi nilai yang sama persis[cite: 18, 24].


# ------------------------------------------------------------------------------
# KASUS 2: CLASSIFICATION TREE (KLASIFIKASI KUALITAS DATA)
# Fokus: Y Kategorikal, Kriteria Split Impurity (Gini / Entropy)
# ------------------------------------------------------------------------------

cat("\n--- Kasus 2: Classification Tree (Y Kategorikal) ---\n")

# 1. Menyiapkan Data (Dataset Iris: Klasifikasi Spesies Bunga)
data(iris)

# 2. Membangun Model Classification Tree
# Menggunakan indeks Gini untuk meminimalkan impurity [cite: 29, 32, 44]
model_class_tree <- rpart(Species ~ ., data = iris, method = "class", 
                          control = rpart.control(cp = 0.01))

# 3. Visualisasi Pohon
rpart.plot(model_class_tree, main = "Pohon Klasifikasi: Spesies Iris")

# INTERPRETASI CLASSIFICATION TREE:
# - Berbeda dengan regresi, leaf di sini menghasilkan label kategori atau 
#   estimasi probabilitas kelas[cite: 19, 36, 54].
# - Split dilakukan untuk meningkatkan 'purity' (kemurnian) node[cite: 31, 39, 41].
# - Contoh: "Jika Petal.Length < 2.5, maka 100% diprediksi Setosa". Node ini sudah murni.


# ------------------------------------------------------------------------------
# BAGIAN 3: OVERFITTING DAN PRUNING (PENYUSUTAN POHON)
# Fokus: Mengontrol Kompleksitas (Bias-Variance Trade-off)
# ------------------------------------------------------------------------------

cat("\n--- Bagian 3: Pruning (Cost-Complexity Pruning) ---\n")

# 1. Melihat Tabel Complexity Parameter (CP)
# Kita mencari CP yang memberikan 'xerror' (cross-validation error) terkecil [cite: 52, 71]
printcp(model_reg_tree)

# 2. Melakukan Pruning
# Memotong dahan yang tidak memberikan penurunan error signifikan untuk mengurangi ragam [cite: 54, 55, 60]
model_pruned <- prune(model_reg_tree, 
                      cp = model_reg_tree$cptable[which.min(model_reg_tree$cptable[,"xerror"]),"CP"])

# INTERPRETASI PRUNING:
# - Pohon yang terlalu dalam memiliki 'Bias Rendah' tapi 'Ragam Tinggi' (Overfitting)[cite: 44, 58].
# - Pruning adalah strategi 'Post-pruning' untuk mendapatkan pohon yang lebih sederhana 
#   tapi lebih stabil saat menghadapi data baru[cite: 64, 65, 72].
# - Prinsipnya: Mencari titik temu optimal antara kompleksitas model dan akurasi prediksi[cite: 53, 59].


# ------------------------------------------------------------------------------
# BAGIAN 4: TRANSISI KE ENSEMBLE (SIMULASI KONSEP)
# Fokus: Menggabungkan banyak model (Bagging/Random Forest/Boosting)
# ------------------------------------------------------------------------------

# CATATAN TEORITIS (Materi 4, Halaman 79-81):
# Jika satu pohon tunggal tidak stabil karena sensitif terhadap perubahan kecil pada data[cite: 45, 46, 59], 
# maka solusinya adalah ENSEMBLE: menggunakan banyak pohon dan merata-ratakannya[cite: 61, 62].
# 1. Bagging: Membangun banyak pohon dari sampel bootstrap[cite: 63].
# 2. Random Forest: Memperbaiki bagging dengan memilih fitur secara acak saat split[cite: 63].
# 3. Boosting: Membangun pohon secara berurutan untuk memperbaiki error pohon sebelumnya[cite: 63].

#------------------------------------------- Materi 5 -------------------------------------------------------------------------------
# ==============================================================================
# SCRIPT ANALISIS: TEKNIK ENSEMBEL (BAGGING, RANDOM FOREST, BOOSTING)
# Berdasarkan materi: materi05-slide.pdf
# ==============================================================================

# Load library yang diperlukan
if(!require(randomForest)) install.packages("randomForest")
if(!require(gbm)) install.packages("gbm")
library(randomForest)
library(gbm)

# Persiapan Data: Menggunakan dataset 'Boston' (Prediksi Harga Rumah)
if(!require(MASS)) install.packages("MASS")
data(Boston, package = "MASS")
set.seed(123)
train_idx <- sample(1:nrow(Boston), nrow(Boston)*0.7)
train_data <- Boston[train_idx, ]
test_data <- Boston[-train_idx, ]

# ------------------------------------------------------------------------------
# 1. BAGGING (Bootstrap Aggregating)
# Fokus: Mengurangi varians dengan rata-rata dari sampel bootstrap
# ------------------------------------------------------------------------------
cat("--- 1. Bagging ---\n")

# Bagging adalah Random Forest dengan mtry = jumlah semua prediktor
model_bagging <- randomForest(medv ~ ., data = train_data, mtry = 13, importance = TRUE)
pred_bagging <- predict(model_bagging, test_data)
rmse_bagging <- sqrt(mean((test_data$medv - pred_bagging)^2))

cat("RMSE Bagging:", round(rmse_bagging, 3), "\n")

# INTERPRETASI BAGGING:
# - Bagging membangun banyak pohon secara paralel dari sampel acak dengan pengembalian.
# - Karena kita menggunakan semua variabel (mtry=13), pohon-pohon yang dihasilkan 
#   mungkin mirip satu sama lain (berkorelasi).


# ------------------------------------------------------------------------------
# 2. RANDOM FOREST
# Fokus: Mengurangi korelasi antar pohon (Dekorelasi)
# ------------------------------------------------------------------------------
cat("\n--- 2. Random Forest ---\n")

# Random Forest memilih subset fitur secara acak di setiap split
model_rf <- randomForest(medv ~ ., data = train_data, mtry = 4, importance = TRUE)
pred_rf <- predict(model_rf, test_data)
rmse_rf <- sqrt(mean((test_data$medv - pred_rf)^2))

cat("RMSE Random Forest:", round(rmse_rf, 3), "\n")

# Visualisasi Pentingnya Variabel
varImpPlot(model_rf, main = "Variable Importance: Random Forest")

# INTERPRETASI RANDOM FOREST:
# - Dengan memilih fitur secara acak (mtry=4), kita memaksa pohon untuk bervariasi.
# - Ini menghasilkan penurunan varians yang lebih besar dibanding Bagging.
# - Output 'Variable Importance' menunjukkan fitur mana yang paling berkontribusi 
#   dalam menurunkan error (misal: 'rm' atau 'lstat').


# ------------------------------------------------------------------------------
# 3. BOOSTING (Gradient Boosting Machine)
# Fokus: Mengurangi Bias dengan belajar secara berurutan (Sequential)
# ------------------------------------------------------------------------------
cat("\n--- 3. Boosting ---\n")

# Boosting membangun pohon pendek (stumps) yang memperbaiki error pohon sebelumnya
model_boost <- gbm(medv ~ ., data = train_data, distribution = "gaussian",
                   n.trees = 5000, interaction.depth = 4, shrinkage = 0.01)

pred_boost <- predict(model_boost, test_data, n.trees = 5000)
rmse_boost <- sqrt(mean((test_data$medv - pred_boost)^2))

cat("RMSE Boosting:", round(rmse_boost, 3), "\n")

# INTERPRETASI BOOSTING:
# - Berbeda dengan RF, Boosting bekerja secara lambat (slow learning) untuk 
#   meminimalkan bias. 
# - Parameter 'shrinkage' (learning rate) mengontrol seberapa cepat model belajar.


# ------------------------------------------------------------------------------
# RINGKASAN EVALUASI MODEL (Materi 5, Halaman 55)
# ------------------------------------------------------------------------------
cat("\n--- Ringkasan Perbandingan (RMSE) ---\n")
cat("Bagging      :", rmse_bagging, "\n")
cat("Random Forest:", rmse_rf, "\n")
cat("Boosting     :", rmse_boost, "\n")

# KESIMPULAN BERDASARKAN MATERI:
# 1. Bagging: Menurunkan Ragam (Variance).
# 2. Random Forest: Menurunkan Korelasi antar pohon agar ragam lebih turun lagi.
# 3. Boosting: Menurunkan Bias melalui optimisasi residual secara berurutan.
# 4. BART (Bayesian Additive Regression Trees): Langkah selanjutnya yang menggunakan 
#    pendekatan probabilitas untuk stabilitas yang lebih tinggi.

#----------------------------------------- Materi 6 ----------------------------------------------------------------------------------
# ==============================================================================
# SCRIPT ANALISIS: NAIVE BAYES & k-NEAREST NEIGHBORS (KNN)
# Berdasarkan materi: 6 Naive Bayes dan k-Nearest Neighbors.pdf
# ==============================================================================

# Load library yang diperlukan
if(!require(e1071)) install.packages("e1071")   # Untuk Naive Bayes
if(!require(class)) install.packages("class")   # Untuk KNN
if(!require(caret)) install.packages("caret")   # Untuk Pre-processing & Evaluasi
library(e1071)
library(class)
library(caret)

# Persiapan Data: Menggunakan dataset 'Iris'
# Kasus: Klasifikasi jenis bunga berdasarkan dimensi sepal dan petal
set.seed(123)
trainIndex <- createDataPartition(iris$Species, p = 0.7, list = FALSE)
train_data <- iris[trainIndex, ]
test_data  <- iris[-trainIndex, ]

# ------------------------------------------------------------------------------
# 1. NAIVE BAYES (Pendekatan Probabilistik)
# Fokus: Teorema Bayes & Asumsi Independensi Kondisional
# ------------------------------------------------------------------------------
cat("--- 1. Model Naive Bayes ---\n")

# Membangun model
# Naive Bayes menghitung P(Kelas | Data) berdasarkan P(Data | Kelas) * P(Kelas)
model_nb <- naiveBayes(Species ~ ., data = train_data)

# Prediksi
pred_nb <- predict(model_nb, test_data)

# Output: Confusion Matrix
cat("Confusion Matrix Naive Bayes:\n")
print(table(Prediksi = pred_nb, Aktual = test_data$Species))

# INTERPRETASI NAIVE BAYES:
# - Asumsi Utama: "Naive" karena menganggap semua fitur (sepal/petal) saling bebas 
#   secara statistik (independensi kondisional). Meskipun asumsi ini sering dilanggar 
#   di dunia nyata, model ini tetap sangat tangguh dan cepat.
# - Sangat Efektif untuk: Data berdimensi tinggi seperti klasifikasi teks (Spam filtering).


# ------------------------------------------------------------------------------
# 2. k-NEAREST NEIGHBORS / KNN (Pendekatan Berbasis Jarak)
# Fokus: Jarak Euclidean, Pemilihan nilai K, dan Normalisasi
# ------------------------------------------------------------------------------
cat("\n--- 2. Model k-Nearest Neighbors (KNN) ---\n")

# PENTING (Materi 6 Hal 41-43): KNN sangat sensitif terhadap skala data.
# Kita harus melakukan standarisasi/normalisasi terlebih dahulu.
preprocess_params <- preProcess(train_data[,1:4], method = c("center", "scale"))
train_scaled <- predict(preprocess_params, train_data[,1:4])
test_scaled  <- predict(preprocess_params, test_data[,1:4])

# Menjalankan KNN dengan K=3
# KNN tidak memiliki fase 'training' eksplisit (Lazy Learner)
pred_knn <- knn(train = train_scaled, 
                test = test_scaled, 
                cl = train_data$Species, 
                k = 3)

# Output: Confusion Matrix
cat("Confusion Matrix KNN (K=3):\n")
print(table(Prediksi = pred_knn, Aktual = test_data$Species))

# INTERPRETASI KNN:
# - Prinsip: "Tunjukkan siapa tetanggamu, maka aku tahu siapa kamu". Objek diklasifikasi 
#   berdasarkan mayoritas label dari K tetangga terdekatnya.
# - Jarak: Umumnya menggunakan Jarak Euclidean.
# - Pemilihan K: K yang terlalu kecil (misal K=1) menyebabkan overfitting (sensitif noise), 
#   K yang terlalu besar menyebabkan underfitting (decision boundary terlalu halus).


# ------------------------------------------------------------------------------
# 3. PERBANDINGAN & POIN KRUSIAL (Key Takeaways Materi 6)
# ------------------------------------------------------------------------------
cat("\n--- 3. Poin Penting Perbandingan ---\n")

# INTERPRETASI AKHIR (Halaman 48-49 Slide):
# 1. Skalabilitas: Naive Bayes jauh lebih cepat untuk dataset sangat besar dibanding KNN.
# 2. Curse of Dimensionality: KNN kinerjanya menurun drastis pada data berdimensi tinggi 
#    karena konsep "jarak" menjadi tidak bermakna (semua titik jadi terasa jauh).
# 3. Baseline Model: Kedua metode ini harus dicoba pertama kali sebelum menggunakan 
#    model yang lebih kompleks seperti Neural Networks atau Random Forest.


#-------------------------------------- Materi 7 ------------------------------------------------------------------------
# ==============================================================================
# SCRIPT ANALISIS: SUPPORT VECTOR MACHINE (SVM)
# Berdasarkan materi: 7 Support Vector Machine.pdf
# ==============================================================================

# Load library yang diperlukan
if(!require(e1071)) install.packages("e1071")
library(e1071)

# ------------------------------------------------------------------------------
# 1. LINEAR SVM (Hard & Soft Margin)
# Fokus: Mencari Hyperplane dengan Margin Maksimal
# ------------------------------------------------------------------------------
cat("--- 1. Linear SVM ---\n")

# Simulasi data sederhana yang bisa dipisahkan secara linier
set.seed(123)
x <- matrix(rnorm(40), 20, 2)
y <- c(rep(-1, 10), rep(1, 10))
x[y == 1, ] <- x[y == 1, ] + 3
dat <- data.frame(x = x, y = as.factor(y))

# Membangun model Linear SVM
# Parameter cost (C): Mengontrol trade-off antara margin dan error training
model_linear <- svm(y ~ ., data = dat, kernel = "linear", cost = 10, scale = FALSE)

# Visualisasi
plot(model_linear, dat)

# INTERPRETASI LINEAR SVM:
# - Support Vectors: Titik-titik yang berada di dekat atau di dalam margin (ditandai 'x' di plot). 
#   Hanya titik-titik inilah yang menentukan posisi hyperplane.
# - Parameter C (Cost): 
#   * C Besar: Margin sempit, sangat berusaha mengklasifikasikan semua data training dengan benar (risiko Overfitting).
#   * C Kecil: Margin lebih lebar, lebih toleran terhadap kesalahan klasifikasi (Generalisasi lebih baik).


# ------------------------------------------------------------------------------
# 2. NON-LINEAR SVM (Kernel Trick)
# Fokus: Transformasi ke dimensi lebih tinggi menggunakan Kernel RBF
# ------------------------------------------------------------------------------
cat("\n--- 2. Non-Linear SVM (Kernel RBF) ---\n")

# Simulasi data berbentuk lingkaran (tidak bisa dipisahkan garis lurus)
set.seed(1)
x_non <- matrix(rnorm(400), 200, 2)
x_non[1:100, ] <- x_non[1:100, ] + 2
x_non[101:150, ] <- x_non[101:150, ] - 2
y_non <- c(rep(1, 150), rep(2, 50))
dat_non <- data.frame(x = x_non, y = as.factor(y_non))

# Membangun model dengan Kernel Radial Basis Function (RBF)
# Parameter gamma: Mengontrol seberapa jauh pengaruh satu titik data
model_nonlinear <- svm(y ~ ., data = dat_non, kernel = "radial", gamma = 1, cost = 1)

# Visualisasi Decision Boundary
plot(model_nonlinear, dat_non)

# INTERPRETASI NON-LINEAR SVM:
# - Kernel Trick: Memetakan data ke dimensi lebih tinggi di mana pemisahan linier menjadi mungkin.
# - Parameter Gamma (??):
#   * Gamma Besar: Pengaruh titik data sangat lokal, boundary sangat meliuk-liuk mengikuti data (risiko Overfitting).
#   * Gamma Kecil: Pengaruh titik data lebih luas, menghasilkan boundary yang lebih halus (smooth).


# ------------------------------------------------------------------------------
# 3. SUPPORT VECTOR REGRESSION (SVR)
# Fokus: Menggunakan prinsip SVM untuk prediksi nilai kontinu
# ------------------------------------------------------------------------------
cat("\n--- 3. Support Vector Regression (SVR) ---\n")

# Kasus: Prediksi mpg pada data mtcars
model_svr <- svm(mpg ~ wt + hp, data = mtcars)
pred_svr <- predict(model_svr, mtcars)

# Evaluasi Sederhana
rmse_svr <- sqrt(mean((mtcars$mpg - pred_svr)^2))
cat("RMSE SVR pada data mtcars:", round(rmse_svr, 3), "\n")

# INTERPRETASI SVR:
# - Jika SVM mencari hyperplane untuk memisahkan kelas, SVR mencari hyperplane 
#   yang memuat sebanyak mungkin titik data di dalam sebuah tabung (epsilon-tube).