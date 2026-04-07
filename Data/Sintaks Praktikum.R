# ==========================================================
# REGRESI LINIER: PREDIKSI HARGA RUMAH
# ==========================================================
# Kasus: Prediksi harga rumah berdasarkan luas bangunan dan jumlah kamar

# Data
luas <- c(50, 60, 70, 80)
kamar <- c(2, 2, 3, 3)
harga <- c(300, 350, 400, 450)
data <- data.frame(luas, kamar, harga)

# Estimasi Parameter
model_lin <- lm(harga ~ luas + kamar, data = data)
summary(model_lin)

# INTERPRETASI:
# 1. Coefficients (Estimate): Menunjukkan kontribusi tiap variabel. Jika Koefisien Luas = 5, 
#    artinya setiap tambah 1m2 luas, harga naik 5 satuan (asumsi jumlah kamar tetap).
# 2. Pr(>|t|): P-value. Jika < 0.05, variabel tersebut signifikan mempengaruhi harga.
# 3. Adjusted R-squared: Persentase variasi harga yang bisa dijelaskan oleh luas & kamar.


# ==========================================================
# REGRESI LINIER UNTUK DATA BINER
# ==========================================================
set.seed(123)
X <- seq(-3, 3, length.out = 50)
Y <- ifelse(X + rnorm(50, 0, 0.8) > 0, 1, 0)
data_bin <- data.frame(X, Y)

model_lin_bin <- lm(Y ~ X, data = data_bin)
summary(model_lin_bin)

# INTERPRETASI:
# Model ini disebut Linear Probability Model (LPM). 
# Kelemahannya: Prediksi peluang bisa bernilai negatif atau > 1, yang secara logika 
# matematika salah (karena peluang harus 0-1). Itulah alasan kita butuh Regresi Logistik.


# ==========================================================
# REGRESI LOGISTIK: ESTIMASI KEMUNGKINAN MAKSIMUM
# ==========================================================
model_log <- glm(Y ~ X, data = data_bin, family = binomial(link = "logit"))
summary(model_log)
exp(coef(model_log)) 

# INTERPRETASI:
# 1. Koefisien Logit: Menunjukkan perubahan dalam "log-odds". Sulit dibaca langsung.
# 2. exp(coef) / Odds Ratio: Jika nilainya 2.5, artinya setiap kenaikan 1 unit X, 
#    peluang Y terjadi (Y=1) meningkat 2.5 kali lipat.


# ==========================================================
# STUDI KASUS REGRESI LINIER: KESEHATAN
# ==========================================================
set.seed(2026)
n <- 120
umur <- round(runif(n, 25, 70))
IMT <- round(rnorm(n, 25, 4), 1)
aktivitas <- round(runif(n, 0, 10), 1)
tekanan_darah <- 90 + 0.6*umur + 1.2*IMT - 1.5*aktivitas + rnorm(n, 0, 8)
data_kesehatan <- data.frame(umur, IMT, aktivitas, tekanan_darah)

model_kes <- lm(tekanan_darah ~ umur + IMT + aktivitas, data = data_kesehatan)
summary(model_kes)

# INTERPRETASI:
# - Koefisien Aktivitas Negatif (-1.5): Semakin tinggi aktivitas fisik, 
#   tekanan darah cenderung turun. Ini menunjukkan hubungan protektif.
# - Residual Standard Error: Rata-rata penyimpangan data asli dari garis prediksi model.


# ==========================================================
# REGRESI LOGISTIK: STUDI KASUS KELULUSAN MAHASISWA
# ==========================================================
set.seed(2026)
n <- 150
IPK <- round(runif(n, 2.2, 4.0), 2)
kehadiran <- round(runif(n, 60, 100), 1)
bekerja <- rbinom(n, 1, 0.35)

linpred <- -15 + 4*IPK + 0.08*kehadiran - 1.2*bekerja
prob_lulus <- 1 / (1 + exp(-linpred))
lulus <- rbinom(n, 1, prob_lulus)
data_kelulusan <- data.frame(IPK, kehadiran, bekerja, lulus)

model_lulus <- glm(lulus ~ IPK + kehadiran + bekerja, 
                   data = data_kelulusan, family = binomial(link = "logit"))
summary(model_lulus)
exp(coef(model_lulus))

# INTERPRETASI:
# Jika exp(coef) Bekerja < 1 (misal 0.3): Mahasiswa yang bekerja memiliki peluang lulus 
# lebih kecil (hanya 0.3 kali lipat) dibanding yang tidak bekerja.


# ==========================================================
# EVALUASI DAN PEMILIHAN MODEL (REGRESI)
# ==========================================================
set.seed(1)
idx <- sample(1:nrow(data_kes), size = 0.7*nrow(data_kes))
train <- data_kes[idx, ]
test <- data_kes[-idx, ]

model1 <- lm(tekanan_darah ~ umur + IMT + aktivitas, data = train)
model2 <- lm(tekanan_darah ~ umur + IMT + aktivitas + I(umur^2), data = train)

pred1 <- predict(model1, newdata = test)
pred2 <- predict(model2, newdata = test)

rmse1 <- sqrt(mean((test$tekanan_darah - pred1)^2))
rmse2 <- sqrt(mean((test$tekanan_darah - pred2)^2))
cat("RMSE Model 1:", rmse1, "\nRMSE Model 2:", rmse2)

# INTERPRETASI:
# RMSE (Root Mean Squared Error) mengukur rata-rata error. 
# Pilih model dengan RMSE terkecil karena itu berarti prediksi paling mendekati kenyataan.


# ==========================================================
# EVALUASI KLASIFIKASI: CONFUSION MATRIX & ROC
# ==========================================================
# Confusion Matrix
threshold <- 0.5
pred_class <- ifelse(prob_pred > threshold, 1, 0)
table(Predicted = pred_class, Actual = data_kel$lulus)

# INTERPRETASI CONFUSION MATRIX:
# - Baris 0, Kolom 0: TN (Benar diprediksi Gagal)
# - Baris 1, Kolom 1: TP (Benar diprediksi Lulus)
# - Akurasi: (TP+TN) / Total Data.

# ROC DAN AUC
library(pROC)
roc_obj <- roc(data_kel$lulus, prob_pred)
plot(roc_obj)
auc(roc_obj)

# INTERPRETASI AUC:
# 0.5 = Model tidak berguna (sama seperti tebak koin).
# 0.7 - 0.8 = Bagus.
# 0.9 - 1.0 = Sangat Bagus dalam membedakan lulus vs tidak lulus.


# ==========================================================
# K-FOLD CROSS VALIDATION
# ==========================================================
library(caret)
train_control <- trainControl(method = "cv", number = 5)
cv_model <- train(tekanan_darah ~ umur + IMT + aktivitas, 
                  data = data_kes, method = "lm", trControl = train_control)
print(cv_model)

# INTERPRETASI:
# Teknik ini membagi data jadi 5 bagian dan bergantian jadi data uji.
# Tujuannya: Memastikan model kita "stabil" dan tidak hanya bagus karena kebetulan 
# di satu set data saja (menghindari Overfitting).

# ==========================================================
# PENGANTAR SUPERVISED LEARNING DENGAN R
# ==========================================================

# ==========================================================
# (1) BAGIAN I – EVALUASI MODEL REGRESI
# ==========================================================

# (1.1) Data Simulasi Realistis (Kesehatan)
# Kasus: Prediksi tekanan darah berdasarkan umur, IMT, dan aktivitas fisik.
set.seed(2026)
n <- 200

umur      <- round(runif(n, 25, 70))
IMT       <- round(rnorm(n, 25, 4), 1)
aktivitas <- round(runif(n, 0, 10), 1)

# Tekanan darah naik karena umur & IMT, turun karena aktivitas
tekanan_darah <- 90 + 0.6*umur + 1.2*IMT - 1.5*aktivitas + rnorm(n, 0, 8)
data_kes      <- data.frame(umur, IMT, aktivitas, tekanan_darah)

# (1.2) Train-Test Split
# Membagi data: 70% untuk belajar (train), 30% untuk menguji (test).
set.seed(1)
idx   <- sample(1:n, size = 0.7*n)
train <- data_kes[idx, ]
test  <- data_kes[-idx, ]

# (1.3) Estimasi Model
# Model 1: Model Linier Standar
model1 <- lm(tekanan_darah ~ umur + IMT + aktivitas, data = train)

# Model 2: Model Non-Linier (Menambahkan variabel umur kuadrat)
model2 <- lm(tekanan_darah ~ umur + IMT + aktivitas + I(umur^2), data = train)

# (1.4) Metrik Evaluasi Regresi
# Mengukur seberapa jauh "tebakan" model dari data aktual di dunia nyata (data test).
pred1 <- predict(model1, test)
pred2 <- predict(model2, test)

# Mean Squared Error (MSE) - Semakin kecil semakin baik
mse1 <- mean((test$tekanan_darah - pred1)^2)
mse2 <- mean((test$tekanan_darah - pred2)^2)

# Root Mean Squared Error (RMSE) - Skala nilainya sama dengan unit variabel (mmHg)
rmse1 <- sqrt(mse1)
rmse2 <- sqrt(mse2)

print(paste("RMSE Model Linier:", round(rmse1, 2)))
print(paste("RMSE Model Kuadratik:", round(rmse2, 2)))

# INTERPRETASI:
# Jika RMSE Model 1 < Model 2, maka penambahan variabel kuadratik tidak membantu
# dan kita sebaiknya memilih Model 1 yang lebih sederhana.


# ==========================================================
# (2) BAGIAN II – EVALUASI MODEL KLASIFIKASI
# ==========================================================

# (2.1) Data Simulasi Kelulusan Mahasiswa
set.seed(2026)
n <- 250

IPK       <- round(runif(n, 2.2, 4.0), 2)
kehadiran <- round(runif(n, 60, 100), 1)
bekerja   <- rbinom(n, 1, 0.35)

# Fungsi Logit untuk probabilitas
linpred    <- -15 + 4*IPK + 0.08*kehadiran - 1.2*bekerja
prob_lulus <- 1/(1+exp(-linpred))
lulus      <- rbinom(n, 1, prob_lulus)

data_kel <- data.frame(IPK, kehadiran, bekerja, lulus)

# (2.2) Model Logistik
model_log <- glm(lulus ~ IPK + kehadiran + bekerja, data = data_kel, family = binomial)
prob_pred <- predict(model_log, type="response")

# (2.3) Confusion Matrix
threshold  <- 0.5
pred_class <- ifelse(prob_pred > threshold, 1, 0)
conf_matrix <- table(Predicted = pred_class, Actual = data_kel$lulus)
print(conf_matrix)

# (2.4) Metrik Klasifikasi (Manual)
accuracy  <- sum(diag(conf_matrix)) / sum(conf_matrix)
precision <- conf_matrix[2,2] / sum(conf_matrix[2,])
recall    <- conf_matrix[2,2] / sum(conf_matrix[,2])

print(paste("Accuracy:", round(accuracy, 2)))
print(paste("Precision:", round(precision, 2)))
print(paste("Recall:", round(recall, 2)))

# INTERPRETASI:
# - Accuracy: Persentase total prediksi benar.
# - Precision: Dari semua yang diprediksi LULUS, berapa yang aslinya memang lulus?
# - Recall: Dari semua yang aslinya LULUS, berapa yang berhasil diprediksi oleh model?

# (2.5) ROC dan AUC
# Memvisualisasikan performa model pada berbagai threshold.
library(pROC)
roc_obj <- roc(data_kel$lulus, prob_pred)
plot(roc_obj, col="red", lwd=3, main="Kurva ROC Performa Model Kelulusan")
auc_value <- auc(roc_obj)
print(paste("Nilai AUC:", round(auc_value, 4)))

# INTERPRETASI AUC:
# Nilai > 0.8 dikategorikan sebagai model yang memiliki daya pembeda "Sangat Baik".


# ==========================================================
# (3) BAGIAN III - CROSS VALIDATION
# ==========================================================

# (3.1) K-Fold Cross Validation
# Teknik untuk memastikan model stabil dan tidak hanya jago di satu subset data saja.
library(caret)

train_control <- trainControl(
  method = "cv",     # Cross-Validation
  number = 5         # Membagi data menjadi 5 lipatan (folds)
)

cv_model <- train(
  tekanan_darah ~ umur + IMT + aktivitas,
  data = data_kes,
  method = "lm",
  trControl = train_control
)

print(cv_model)

# INTERPRETASI:
# Hasil dari cv_model menunjukkan rata-rata RMSE dari 5 percobaan berbeda.
# Ini adalah estimasi performa yang paling objektif untuk model regresi kita.

# ==========================================================
# TREE-BASED METHODS DENGAN R
# ==========================================================

# (1) PERSIAPAN
# (1.1) Instalasi dan Library
# install.packages(c("tree", "rpart", "rpart.plot", "randomForest", "gbm", "caret", "BART", "ISLR2"))

library(tree)
library(rpart)
library(rpart.plot)
library(randomForest)
library(gbm)
library(caret)
library(BART)
library(ISLR2)

# ==========================================================
# (2) DATASET
# ==========================================================
# Menggunakan Boston (untuk masalah Regresi) dan Carseats (Klasifikasi)
data(Boston)
data(Carseats)

# ==========================================================
# (3) REGRESSION TREE (BOSTON HOUSING)
# ==========================================================

# (3.1) Split Data
set.seed(123)
train_index <- createDataPartition(Boston$medv, p = 0.7, list = FALSE)
train <- Boston[train_index, ]
test <- Boston[-train_index, ]

# (3.2) Membangun CART (Classification and Regression Trees)
# Model ini membagi ruang prediktor menjadi beberapa wilayah kotak (rectangles).
tree_model <- tree(medv ~ ., data = train)
summary(tree_model)

# Visualisasi Pohon
plot(tree_model)
text(tree_model, pretty = 0)

# (3.3) Pruning (Pemangkasan)
# Dilakukan untuk mencegah overfitting dengan mencari ukuran pohon yang optimal via CV.
cv_tree <- cv.tree(tree_model)
plot(cv_tree$size, cv_tree$dev, type = "b", main = "Deviance vs Tree Size")

best_size <- cv_tree$size[which.min(cv_tree$dev)]
pruned_tree <- prune.tree(tree_model, best = best_size)

# (3.4) Evaluasi
pred_tree <- predict(pruned_tree, test)
rmse_tree <- sqrt(mean((pred_tree - test$medv)^2))

# INTERPRETASI:
# Regression Tree sangat mudah diinterpretasikan (visual). Namun, satu pohon tunggal 
# cenderung memiliki varians tinggi (kurang stabil jika data berubah sedikit).


# ==========================================================
# (4) BAGGING (BOOTSTRAP AGGREGATING)
# ==========================================================
# Bagging membangun banyak pohon dari sampel bootstrap dan mengambil rata-ratanya.
# mtry = jumlah variabel yang dicoba pada setiap split. Untuk Bagging, gunakan semua variabel.

bag_model <- randomForest(medv ~ ., data = train, 
                          mtry = ncol(train) - 1, 
                          importance = TRUE)

pred_bag <- predict(bag_model, test)
rmse_bag <- sqrt(mean((pred_bag - test$medv)^2))

# OOB (Out-of-Bag) Error: Estimasi error tanpa perlu test set terpisah.
oob_bag <- bag_model$mse[length(bag_model$mse)]

# INTERPRETASI:
# Bagging mengurangi varians secara drastis dibandingkan pohon tunggal dengan cara 
# merata-ratakan prediksi dari banyak pohon.


# ==========================================================
# (5) RANDOM FOREST
# ==========================================================
# Mirip Bagging, tapi setiap split hanya mempertimbangkan subset acak dari prediktor.
# Ini membantu "mencairkan" korelasi antar pohon jika ada variabel yang sangat dominan.

rf_model <- randomForest(medv ~ ., data = train, importance = TRUE)

pred_rf <- predict(rf_model, test)
rmse_rf <- sqrt(mean((pred_rf - test$medv)^2))

# (5.1) Variable Importance
# Menunjukkan variabel mana yang paling berkontribusi dalam menurunkan MSE.
importance(rf_model)
varImpPlot(rf_model)

# INTERPRETASI:
# Random Forest biasanya memberikan hasil yang lebih akurat daripada Bagging karena 
# membuat pohon-pohon penyusunnya tidak saling berkorelasi (decorrelated).


# ==========================================================
# (6) BOOSTING (GRADIENT BOOSTING)
# ==========================================================
# Berbeda dengan RF yang paralel, Boosting bekerja secara sekuensial: 
# setiap pohon baru memperbaiki kesalahan dari pohon sebelumnya.

boost_model <- gbm(medv ~ ., data = train,
                   distribution = "gaussian",
                   n.trees = 2000,
                   interaction.depth = 3,
                   shrinkage = 0.01,
                   cv.folds = 5)

# Menentukan jumlah pohon optimal untuk menghindari overfitting
best_iter <- gbm.perf(boost_model, method = "cv")

pred_boost <- predict(boost_model, test, n.trees = best_iter)
rmse_boost <- sqrt(mean((pred_boost - test$medv)^2))

# INTERPRETASI:
# Boosting sering kali menjadi "pemenang" dalam kompetisi akurasi, namun membutuhkan 
# tuning parameter yang lebih hati-hati (n.trees, shrinkage, depth).


# ==========================================================
# (7) BAYESIAN ADDITIVE REGRESSION TREES (BART)
# ==========================================================
# Pendekatan Bayesian untuk boosting pohon. BART menghasilkan distribusi probabilitas 
# sehingga kita bisa mendapatkan interval kepercayaan (uncertainty).

x_train <- as.matrix(train[, -which(names(train) == "medv")])
y_train <- train$medv
x_test  <- as.matrix(test[, -which(names(test) == "medv")])

set.seed(1)
bart_model <- wbart(x_train, y_train)

# Prediksi (mengambil rata-rata dari iterasi MCMC)
pred_bart <- predict(bart_model, x_test)
yhat_bart <- colMeans(pred_bart)

rmse_bart <- sqrt(mean((yhat_bart - test$medv)^2))

# (7.1) Interval Kredibel
lower <- apply(pred_bart, 2, quantile, 0.025)
upper <- apply(pred_bart, 2, quantile, 0.975)

# INTERPRETASI:
# Keunggulan utama BART adalah kemampuannya memberikan rentang prediksi (lower & upper) 
# bukan hanya satu angka tunggal, sangat berguna untuk analisis risiko.


# ==========================================================
# (8) PERBANDINGAN MODEL (RMSE)
# ==========================================================
results <- data.frame(
  Model = c("CART (Pruned)", "Bagging", "Random Forest", "Boosting", "BART"),
  RMSE  = c(rmse_tree, rmse_bag, rmse_rf, rmse_boost, rmse_bart)
)
print(results)


# ==========================================================
# (9) CLASSIFICATION TREE (CARSEATS)
# ==========================================================
# Membuat variabel biner: Apakah Sales > 8?
Carseats$High <- as.factor(ifelse(Carseats$Sales > 8, "Yes", "No"))
Carseats$Sales <- NULL # Hapus variabel asal agar tidak bocor ke model

set.seed(123)
train_idx_class <- createDataPartition(Carseats$High, p = 0.7, list = FALSE)
train_c <- Carseats[train_idx_class, ]
test_c  <- Carseats[-train_idx_class, ]

# Model Random Forest untuk Klasifikasi
rf_class   <- randomForest(High ~ ., data = train_c)
pred_class <- predict(rf_class, test_c)

# Confusion Matrix
confusionMatrix(pred_class, test_c$High)

# INTERPRETASI:
# Output Confusion Matrix akan menunjukkan Accuracy, Sensitivity, dan Specificity. 
# Ini memberi tahu kita seberapa baik model dalam mendeteksi lokasi dengan penjualan tinggi.