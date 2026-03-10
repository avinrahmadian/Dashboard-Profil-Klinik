library(shiny)
library(DBI)
library(RMariaDB)
library(dplyr)
library(lubridate)
library(plotly)
library(DT)
library(wordcloud2)
library(forecast)
library(sf)
library(rnaturalearth)


# DEFINISI PALET WARNA
temps_pal <- c("#009B9E", "#159B91", "#33C1B1", "#E0F2F1", "#F8BBD0", "#F06292", "#CB5280")

# -----------------------------------------------------------------
# 1. KONEKSI DATABASE GLOBAL (Ditaruh di LUAR fungsi server)
# -----------------------------------------------------------------
con <- dbConnect(
  RMariaDB::MariaDB(),
  dbname = "db_klinik_normalisasi",
  host = "127.0.0.1",
  port = 3312,
  user = "root", 
  password = "" 
)

# Memastikan koneksi ditutup saat aplikasi Shiny benar-benar dimatikan
onStop(function() {
  dbDisconnect(con)
})

server <- function(input, output, session) {

  output$dynamic_nav_buttons <- renderUI({
    req(input$current_tab) # Memastikan ID sidebar terdeteksi
    
    # Fungsi bantuan untuk membuat tombol
    nav_btn <- function(id, label, icon_name) {
      tags$a(class = "nav-link-btn", 
             onclick = sprintf("document.getElementById('%s').scrollIntoView({behavior: 'smooth'});", id),
             icon(icon_name), label)
    }
    
    # Logika pemilihan tombol berdasarkan Tab
    if (input$current_tab == "tab_home") {
      tagList(nav_btn("sec_h_tren", "Tren", "chart-line"), nav_btn("sec_h_map", "Peta", "map-location-dot"))
      
    } else if (input$current_tab == "tab_klinik") {
      tagList(nav_btn("sec_k_fin", "Finansial", "dollar-sign"), nav_btn("sec_k_loyal", "Loyalitas", "heart"), nav_btn("sec_k_db", "Data", "table"))
      
    } else if (input$current_tab == "tab_dokter") {
      tagList(nav_btn("sec_d_perf", "Performa", "star"), nav_btn("sec_d_cap", "Kapasitas", "users-gear"), nav_btn("sec_d_price", "Tarif", "tags"), nav_btn("sec_d_db", "Data", "table"))
      
    } else if (input$current_tab == "tab_pasien") {
      tagList(nav_btn("sec_p_prof", "Demografi", "users"), nav_btn("sec_p_diag", "Diagnosis", "stethoscope"), nav_btn("sec_p_admin", "Admin", "file-invoice-dollar"), nav_btn("sec_p_db", "Data", "table"))
      
    } else if (input$current_tab == "tab_obat") {
      tagList(nav_btn("sec_m_sum", "Ringkasan", "pills"), nav_btn("sec_m_cons", "Konsumsi", "chart-bar"), nav_btn("sec_m_corr", "Analisis", "hubspot"), nav_btn("sec_o_db", "Data", "table"))
    }
  })
  
  
  ## ini buat potooo
  output$t_photo_db <- renderUI({
    tags$img(
      src = "https://raw.githubusercontent.com/avinrahmadian/Dashboard-Profil-Klinik/main/Images/joy1.png",
      style = "width: 100%; max-width: 180px; height: auto; border-radius: 5px; object-fit: cover; box-shadow: 0 8px 15px rgba(0,0,0,0.15); border: 1px solid white;"
    )
  })
  
  output$t_photo_analyst <- renderUI({
    tags$img(
      src = "https://raw.githubusercontent.com/avinrahmadian/Dashboard-Profil-Klinik/main/Images/ika2.png",
      style = "width: 100%; max-width: 180px; height: auto; border-radius: 5px; object-fit: cover; box-shadow: 0 8px 15px rgba(0,0,0,0.15); border: 1px solid white;"
    )
  })
  
  output$t_photo_front <- renderUI({
    tags$img(
      src = "https://raw.githubusercontent.com/avinrahmadian/Dashboard-Profil-Klinik/main/Images/wita2.png",
      style = "width: 100%; max-width: 180px; height: auto; border-radius: 5px; object-fit: cover; box-shadow: 0 8px 15px rgba(0,0,0,0.15); border: 1px solid white;"
    )
  })
  
  output$t_photo_back <- renderUI({
    tags$img(
      src = "https://raw.githubusercontent.com/avinrahmadian/Dashboard-Profil-Klinik/main/Images/avin2.png",
      style = "width: 100%; max-width: 180px; height: auto; border-radius: 5px; object-fit: cover; box-shadow: 0 8px 15px rgba(0,0,0,0.15); border: 1px solid white;"
    )
  })
  
  # ======================================================================================
  # 🏠 BAGIAN 1: TAB HOME (DASHBOARD UTAMA)
  # ======================================================================================
  
  # --- KPI 1: TOTAL VISIT ---
  output$val_visit <- renderText({ 
    res <- dbGetQuery(con, "SELECT COUNT(visit_id) as total FROM visit")
    format(res$total, big.mark = ",") 
  })
  
  # --- KPI 2: TOTAL REVENUE ---
  output$val_revenue <- renderText({ 
    res <- dbGetQuery(con, "SELECT SUM(total_amount) as total FROM transactions")
    val <- res$total
    if(is.na(val) || val == 0) return("Rp 0")
    if(val >= 1e9) paste0("Rp ", round(val/1e9, 2), " M") else paste0("Rp ", round(val/1e6, 2), " Jt")
  })
  
  # --- KPI 3: TOTAL KLINIK ---
  output$val_unit <- renderText({ 
    res <- dbGetQuery(con, "SELECT COUNT(clinic_id) as total FROM clinic")
    paste(res$total, "Unit") 
  })
  
  # --- KPI 4: JUMLAH PASIEN ---
  output$val_pasien <- renderText({ 
    res <- dbGetQuery(con, "SELECT COUNT(DISTINCT patient_id) as total FROM visit")
    format(res$total, big.mark = ",") 
  })
  
  # --- KPI 5: JUMLAH DOKTER ---
  output$val_dokter <- renderText({ 
    res <- dbGetQuery(con, "SELECT COUNT(doctor_id) as total FROM doctor")
    paste(res$total, "Ahli") 
  })
  
  # --- GRAFIK 1: TREN KUNJUNGAN ---
  output$h_trend <- renderPlotly({
    query <- "SELECT DATE_FORMAT(visit_datetime, '%Y-%m-01') as bulan, COUNT(visit_id) as jumlah 
              FROM visit GROUP BY bulan ORDER BY bulan ASC"
    df_trend <- dbGetQuery(con, query)
    if(nrow(df_trend) == 0) return(plotly_empty() %>% layout(title = "Data tren tidak tersedia"))
    
    df_trend$bulan <- as.Date(df_trend$bulan)
    plot_ly(df_trend, x = ~bulan, y = ~jumlah, type = 'scatter', mode = 'lines+markers',
            line = list(color = temps_pal[1], width = 3, shape = 'spline'), 
            marker = list(color = temps_pal[6], size = 8, line = list(color = 'white', width = 2)),
            hoverinfo = 'text',
            text = ~paste("<b>Bulan:</b>", format(bulan, "%B %Y"), "<br><b>Kunjungan:</b>", format(jumlah, big.mark=","), "Pasien")) %>%
      layout(
        xaxis = list(title = "", type = 'date', tickformat = "%b %Y", showgrid = FALSE,
                     rangeselector = list(
                       buttons = list(list(step = "all", label = "Semua Waktu"), list(count = 36, label = "36 Bulan", step = "month", stepmode = "backward"), list(count = 24, label = "24 Bulan", step = "month", stepmode = "backward"), list(count = 12, label = "12 Bulan", step = "month", stepmode = "backward")),
                       x = 0.02, y = 0.98, bgcolor = "rgba(224, 242, 241, 0.9)", activecolor = temps_pal[3]
                     ),
                     rangeslider = list(visible = TRUE, thickness = 0.12, bgcolor = "#E0F2F1", bordercolor = temps_pal[1], borderwidth = 2)
        ),
        yaxis = list(title = "Jumlah Kunjungan", gridcolor = '#f0f0f0'),
        paper_bgcolor = 'rgba(0,0,0,0)', plot_bgcolor = 'rgba(0,0,0,0)', margin = list(t = 20, b = 20, l = 40, r = 20)
      )
  })
  
  # --- GRAFIK 2: PREDIKSI (FORECASTING) ---
  output$h_prediction <- renderPlotly({
    query <- "SELECT DATE_FORMAT(visit_datetime, '%Y-%m-01') as bulan, COUNT(visit_id) as jumlah 
              FROM visit GROUP BY bulan ORDER BY bulan ASC"
    df_ts <- dbGetQuery(con, query)
    if(nrow(df_ts) < 12) return(plotly_empty() %>% layout(title = "Data historis < 12 Bulan"))
    
    df_ts$bulan <- as.Date(df_ts$bulan)
    df_ts$jumlah <- as.numeric(df_ts$jumlah) 
    
    start_year <- as.numeric(format(min(df_ts$bulan), "%Y"))
    start_month <- as.numeric(format(min(df_ts$bulan), "%m"))
    
    ts_data <- ts(df_ts$jumlah, start = c(start_year, start_month), frequency = 12)
    fit <- auto.arima(ts_data)
    fc <- forecast(fit, h = 6)
    
    last_date <- max(df_ts$bulan)
    waktu_prediksi <- seq(last_date, by = "month", length.out = 7)[-1] 
    angka_prediksi <- round(as.numeric(fc$mean)) 
    angka_prediksi <- ifelse(angka_prediksi < 0, 0, angka_prediksi)
    
    bulan_teks <- format(waktu_prediksi, "%B %Y")
    angka_teks <- paste(format(angka_prediksi, big.mark = ","), "Pasien")
    
    plot_ly(type = 'table', columnwidth = c(5, 5), 
            header = list(values = c("<b>Bulan</b>", "<b>Estimasi</b>"), align = c('left', 'center'), fill = list(color = temps_pal[1]), font = list(color = 'white', size = 14, family = "Plus Jakarta Sans"), height = 35),
            cells = list(values = rbind(bulan_teks, angka_teks), align = c('left', 'center'), fill = list(color = c('white', '#F8F9FA')), font = list(color = '#2D3436', size = 13, family = "Plus Jakarta Sans"), height = 30)
    ) %>% layout(paper_bgcolor = 'rgba(0,0,0,0)', plot_bgcolor = 'rgba(0,0,0,0)', margin = list(t = 10, b = 10, l = 10, r = 10))
  })
  
  # --- GRAFIK 3: PETA INDONESIA ---
  output$h_map <- renderPlotly({
    query <- "SELECT clinic_province AS provinsi, COUNT(clinic_id) as jumlah FROM clinic GROUP BY clinic_province"
    df_db <- dbGetQuery(con, query)
    if(nrow(df_db) == 0) return(plotly_empty() %>% layout(title = "Data sebaran klinik kosong"))
    
    indo_coords <- data.frame(
      provinsi = c("Aceh", "Bali", "Banten", "Bengkulu", "DI Yogyakarta", "DKI Jakarta", "Gorontalo", "Jambi", "Jawa Barat", "Jawa Tengah", "Jawa Timur", "Kalimantan Barat", "Kalimantan Selatan", "Kalimantan Tengah", "Kalimantan Timur", "Kalimantan Utara", "Kepulauan Bangka Belitung", "Kepulauan Riau", "Lampung", "Maluku", "Maluku Utara", "Nusa Tenggara Barat", "Nusa Tenggara Timur", "Papua", "Papua Barat", "Riau", "Sulawesi Barat", "Sulawesi Selatan", "Sulawesi Tengah", "Sulawesi Tenggara", "Sulawesi Utara", "Sumatera Barat", "Sumatera Selatan", "Sumatera Utara"),
      lat = c(4.6951, -8.4095, -6.4058, -3.7928, -7.7956, -6.2088, 0.6999, -1.6110, -6.9147, -7.1509, -7.5360, -0.2787, -3.0926, -1.6814, 0.5386, 3.0730, -2.7410, 3.9456, -4.5585, -3.2384, 1.5709, -8.6529, -8.6500, -4.2699, -1.3361, 0.5333, -2.8441, -4.1449, -1.4300, -4.1449, 0.6246, -0.7390, -3.3194, 2.1153),
      lon = c(96.7363, 115.1889, 106.0640, 102.2607, 110.3694, 106.8456, 122.4467, 103.6131, 107.6098, 110.1402, 112.2384, 111.4703, 115.2837, 113.3823, 116.4193, 116.0413, 106.1008, 108.1428, 105.4068, 130.1452, 127.8087, 117.3616, 121.0793, 138.0803, 133.1747, 101.7068, 119.2320, 119.9265, 121.4456, 122.1746, 124.0901, 100.8000, 104.0454, 99.5450)
    )
    
    df_db$kunci <- tolower(trimws(df_db$provinsi))
    indo_coords$kunci <- tolower(indo_coords$provinsi)
    df_plot <- merge(indo_coords, df_db, by = "kunci")
    if(nrow(df_plot) == 0) return(plotly_empty() %>% layout(title = "Gagal mencocokkan nama provinsi"))
    
    indo_map <- ne_states(country = "indonesia", returnclass = "sf")
    
    plot_ly() %>%
      add_sf(data = indo_map, color = I(temps_pal[1]), stroke = I("white"), span = I(1.5), hoverinfo = "none") %>%
      add_markers(data = df_plot, x = ~lon, y = ~lat, marker = list(size = ~jumlah * 5, sizemode = 'area', sizemin = 14, color = temps_pal[6], opacity = 1, line = list(color = 'white', width = 1.5)), hovertext = ~paste("<b>Provinsi:</b>", provinsi.x, "<br><b>Total Klinik:</b>", jumlah, "Unit"), hoverinfo = "text") %>%
      add_text(data = df_plot, x = ~lon, y = ~lat, text = ~paste("<b>", jumlah, "</b>"), textposition = 'middle center', textfont = list(color = 'white', size = 12, family = "Plus Jakarta Sans"), hoverinfo = "none") %>%
      layout(showlegend = FALSE, xaxis = list(visible = FALSE), yaxis = list(visible = FALSE), paper_bgcolor = 'rgba(0,0,0,0)', plot_bgcolor = 'rgba(0,0,0,0)', margin = list(t = 0, b = 0, l = 0, r = 0))
  })
  
  # --- GRAFIK 4: WORDCLOUD PENYAKIT (KATA-KATA ASLI) ---
  output$h_wordcloud <- renderWordcloud2({
    # 1. Query Data (Wajib bernama 'word' dan 'freq' untuk wordcloud2)
    query <- "
      SELECT d.diagnosis_name as word, COUNT(t.transaction_id) as freq
      FROM transactions t
      JOIN diagnosis d ON t.primary_diagnosis_id = d.diagnosis_id
      WHERE d.diagnosis_name IS NOT NULL
      GROUP BY d.diagnosis_name
      ORDER BY freq DESC
    "
    df_wc <- dbGetQuery(con, query)
    
    if(nrow(df_wc) == 0) return(NULL)
    
    # 2. Buat urutan warna sesuai palet Djiwa Medical (Tosca, Pink, Teal)
    warna_custom <- rep(c(temps_pal[1], temps_pal[6], temps_pal[3], "#636E72"), length.out = nrow(df_wc))
    
    # 3. Render Wordcloud
    wordcloud2(
      data = df_wc, 
      size = 0.8,                     # Ukuran dasar teks (bisa dinaikkan/diturunkan)
      fontFamily = "Plus Jakarta Sans",
      color = warna_custom,           # Warna-warni sesuai tema dashboard
      backgroundColor = "transparent",# Latar belakang transparan
      rotateRatio = 0.3,              # 30% kata akan berputar vertikal/miring biar estetik
      shape = 'circle'                # Bentuk gumpalan kata-katanya
    )
  })
  
  # --- GRAFIK 4: INSIGHT PENYAKIT (TREEMAP - 100% RAPI) ---
  output$h_wordcloud <- renderPlotly({
    # 1. Query Data
    query <- "
      SELECT d.diagnosis_name as penyakit, COUNT(t.transaction_id) as frekuensi
      FROM transactions t
      JOIN diagnosis d ON t.primary_diagnosis_id = d.diagnosis_id
      WHERE d.diagnosis_name IS NOT NULL
      GROUP BY d.diagnosis_name
      ORDER BY frekuensi DESC
    "
    df_wc <- dbGetQuery(con, query)
    
    if(nrow(df_wc) == 0) return(plotly_empty() %>% layout(title = "Data diagnosis belum tersedia"))
    
    # 2. Render Plotly Treemap
    plot_ly(
      data = df_wc,
      type = "treemap",
      labels = ~penyakit,
      parents = rep("", nrow(df_wc)), # Wajib ada, diset kosong agar semua sejajar
      values = ~frekuensi,
      textinfo = "label+value",       # Menampilkan nama penyakit + angkanya di dalam kotak
      hoverinfo = "label+value+percent root",
      textfont = list(family = "Plus Jakarta Sans", size = 14, color = "white"),
      marker = list(
        # Mengambil gradasi warna dari palet dashboard Anda
        colors = colorRampPalette(c(temps_pal[1], temps_pal[3], temps_pal[6]))(nrow(df_wc)),
        line = list(color = 'white', width = 1.5) # Garis pemisah antar kotak
      )
    ) %>%
      layout(
        # Treemap otomatis menghilangkan sumbu x dan y, jadi sudah pasti bersih!
        paper_bgcolor = 'transparent',
        plot_bgcolor = 'transparent',
        margin = list(t = 0, b = 0, l = 0, r = 0)
      )
  })
  
  # ======================================================================================
  # 🏥 BAGIAN 2: TAB KLINIK (INTERAKTIF PENUH)
  # ======================================================================================
  
  # --- K.1 LOGIKA FILTER DROPDOWN ---
  observe({
    # Mengambil data provinsi
    prov_list <- dbGetQuery(con, "SELECT DISTINCT clinic_province FROM clinic WHERE clinic_province IS NOT NULL ORDER BY clinic_province")
    
    # Mengirim ke UI yang ID-nya k_filter_provinsi
    updateSelectInput(session, "k_filter_provinsi", 
                      choices = c("Semua Provinsi", prov_list$clinic_province),
                      selected = "Semua Provinsi")
  })
  
  observeEvent(input$k_filter_provinsi, {
    req(input$k_filter_provinsi) 
    
    query <- if(input$k_filter_provinsi == "Semua Provinsi") {
      "SELECT clinic_name FROM clinic ORDER BY clinic_name"
    } else {
      sprintf("SELECT clinic_name FROM clinic WHERE clinic_province = '%s' ORDER BY clinic_name", input$k_filter_provinsi)
    }
    df_klinik <- dbGetQuery(con, query)
    
    full_names <- df_klinik$clinic_name
    short_names <- gsub("Klinik Sehat Bersama ", "", full_names)
    
    updateSelectInput(session, "k_filter_klinik", 
                      choices = c("Semua Klinik", setNames(full_names, short_names)),
                      selected = "Semua Klinik")
  })
  
  # --- K.2 TOP 5 KLINIK (BAR CHART) ---
  output$k_top_clinic <- renderPlotly({
    req(input$k_filter_provinsi, input$k_filter_klinik)
    
    cond <- ""
    if (input$k_filter_klinik != "Semua Klinik") {
      cond <- paste0("WHERE c.clinic_name = '", input$k_filter_klinik, "' ")
    } else if (input$k_filter_provinsi != "Semua Provinsi") {
      cond <- paste0("WHERE c.clinic_province = '", input$k_filter_provinsi, "' ")
    }
    
    query <- paste0("SELECT REPLACE(c.clinic_name, 'Klinik Sehat Bersama ', '') as nama_ringkas, 
                            COUNT(v.visit_id) as total 
                     FROM visit v JOIN clinic c ON v.clinic_id = c.clinic_id ",
                    cond, " GROUP BY c.clinic_name ORDER BY total DESC LIMIT 5")
    df_top <- dbGetQuery(con, query)
    if(nrow(df_top) == 0) return(plotly_empty() %>% layout(title = "Data tidak tersedia"))
    
    plot_ly(df_top, x = ~total, y = ~reorder(nama_ringkas, total), type = 'bar', orientation = 'h', marker = list(color = temps_pal[1], line = list(color = 'white', width = 1)), text = ~paste("<b>", nama_ringkas, "</b><br>", total, " Kunjungan"), textposition = 'inside', insidetextanchor = 'middle', textfont = list(color = 'white', family = "Plus Jakarta Sans"), hoverinfo = 'none') %>%
      layout(xaxis = list(title = "Jumlah Kunjungan", showgrid = FALSE), yaxis = list(title = "", showticklabels = FALSE), margin = list(l = 10, r = 10, t = 10, b = 30), paper_bgcolor = 'rgba(0,0,0,0)', plot_bgcolor = 'rgba(0,0,0,0)')
  })

  # --- K.3 RADAR REVENUE ---
  output$k_radar_revenue <- renderPlotly({
    req(input$k_filter_provinsi, input$k_filter_klinik)
    
    cond <- ""
    if (input$k_filter_klinik != "Semua Klinik") {
      cond <- paste0("WHERE c.clinic_name = '", input$k_filter_klinik, "'")
    } else if (input$k_filter_provinsi != "Semua Provinsi") {
      cond <- paste0("WHERE c.clinic_province = '", input$k_filter_provinsi, "'")
    }
    
    # 1. Membulatkan angka agar tidak ada desimal / recehan yang bikin pusing
    query <- paste0(
      "SELECT 
        ROUND(AVG(t.administration_fee), 0) as admin, 
        ROUND(AVG(t.doctor_consultation_fee), 0) as konsultasi, 
        ROUND(AVG(t.medicine_total), 0) as obat, 
        ROUND(AVG(t.treatment_total), 0) as tindakan 
      FROM transactions t
      JOIN visit v ON t.visit_id = v.visit_id
      JOIN clinic c ON v.clinic_id = c.clinic_id ", 
      cond
    )
    
    df_radar <- dbGetQuery(con, query)
    
    if(nrow(df_radar) == 0 || is.na(df_radar$admin[1])) {
      df_radar <- data.frame(admin = 0, konsultasi = 0, obat = 0, tindakan = 0)
    }
    
    max_val <- max(df_radar[1, ], na.rm = TRUE)
    range_max <- ifelse(max_val == 0, 100000, max_val * 1.1) 
    
    plot_ly(
      type = 'scatterpolar', 
      fill = 'toself', 
      r = as.numeric(c(df_radar$admin[1], df_radar$konsultasi[1], df_radar$obat[1], df_radar$tindakan[1], df_radar$admin[1])), 
      theta = c('Admin', 'Konsultasi', 'Obat', 'Tindakan', 'Admin'), 
      fillcolor = 'rgba(0, 155, 158, 0.4)', 
      line = list(color = temps_pal[1], width = 2),
      
      # 2. INI KUNCINYA: Mengubah kotak info menjadi kalimat bahasa manusia
      hovertemplate = '<b>%{theta}</b><br>Rata-rata tagihan: Rp %{r:,.0f}<extra></extra>'
    ) %>%
      layout(
        polar = list(
          radialaxis = list(
            visible = TRUE, 
            range = c(0, range_max),
            # Menyederhanakan angka di garis jaring agar tidak terlalu berdempetan
            nticks = 5, 
            tickfont = list(size = 10, color = "gray")
          )
        ), 
        showlegend = FALSE, 
        paper_bgcolor = 'rgba(0,0,0,0)', 
        plot_bgcolor = 'rgba(0,0,0,0)',
        # Memastikan margin tidak terpotong
        margin = list(t = 30, b = 30, l = 30, r = 30)
      )
  })
    
  
  # --- K.4 LOYALITAS PASIEN (DONUT CHART) ---
  output$k_loyalty_donut <- renderPlotly({
    req(input$k_filter_provinsi, input$k_filter_klinik)
    
    cond <- ""
    if (input$k_filter_klinik != "Semua Klinik") {
      cond <- paste0("WHERE c.clinic_name = '", input$k_filter_klinik, "' ")
    } else if (input$k_filter_provinsi != "Semua Provinsi") {
      cond <- paste0("WHERE c.clinic_province = '", input$k_filter_provinsi, "' ")
    }
    
    query <- paste0("SELECT status, COUNT(patient_id) as jumlah FROM (SELECT v.patient_id, CASE WHEN COUNT(v.visit_id) > 1 THEN 'Returning' ELSE 'New' END as status FROM visit v JOIN clinic c ON v.clinic_id = c.clinic_id ", cond, " GROUP BY v.patient_id) t GROUP BY status")
    df_loyalty <- dbGetQuery(con, query)
    if(nrow(df_loyalty) == 0) return(plotly_empty() %>% layout(title = "Data tidak tersedia"))
    
    plot_ly(df_loyalty, labels = ~status, values = ~jumlah, type = 'pie', hole = 0.6, marker = list(colors = c(temps_pal[6], temps_pal[1]))) %>%
      layout(showlegend = TRUE, paper_bgcolor = 'rgba(0,0,0,0)', plot_bgcolor = 'rgba(0,0,0,0)')
  })
  
  # =================================================================
  # 6. SEBARAN SPESIALIS (DIUBAH MENJADI BAR CHART)
  # =================================================================
  output$k_spec_treemap <- renderPlotly({
    # PENGAMAN: Tunggu sampai filter provinsi & klinik ter-load
    req(input$k_filter_provinsi, input$k_filter_klinik)
    
    # LOGIKA FILTER INTERAKTIF
    cond <- ""
    if (input$k_filter_klinik != "Semua Klinik") {
      cond <- paste0("WHERE c.clinic_name = '", input$k_filter_klinik, "' ")
    } else if (input$k_filter_provinsi != "Semua Provinsi") {
      cond <- paste0("WHERE c.clinic_province = '", input$k_filter_provinsi, "' ")
    }
    
    # QUERY DATABASE: Menggunakan nama kolom yang benar 'doctor_specialty'
    query <- paste0("SELECT d.doctor_specialty as spesialisasi, COUNT(d.doctor_id) as jumlah 
                     FROM doctor d 
                     JOIN clinic c ON d.clinic_id = c.clinic_id ", 
                    cond, " 
                     GROUP BY d.doctor_specialty 
                     ORDER BY jumlah ASC") # Urutkan ASC agar yang paling banyak ada di paling atas Bar Chart
    
    df_spec <- dbGetQuery(con, query)
    
    # Jika datanya kosong setelah di-filter
    if(nrow(df_spec) == 0) return(plotly_empty() %>% layout(title = "Data tidak tersedia"))
    
    # RENDER BAR CHART HORIZONTAL
    plot_ly(df_spec, 
            x = ~jumlah, 
            y = ~reorder(spesialisasi, jumlah), 
            type = 'bar', 
            orientation = 'h',
            marker = list(color = temps_pal[1], line = list(color = 'white', width = 1)),
            text = ~jumlah, # Menampilkan angka di batang
            textposition = 'auto', 
            textfont = list(color = 'white', family = "Plus Jakarta Sans", weight = "bold"),
            hoverinfo = 'text',
            hovertext = ~paste("<b>", spesialisasi, "</b><br>Total:", jumlah, "Dokter")) %>%
      layout(
        xaxis = list(title = "Jumlah Dokter", showgrid = FALSE),
        yaxis = list(title = "", tickfont = list(family = "Plus Jakarta Sans")),
        margin = list(l = 120, r = 20, t = 20, b = 40), # Margin kiri (l=120) dilebarkan agar nama spesialis tidak terpotong
        paper_bgcolor = 'rgba(0,0,0,0)', 
        plot_bgcolor = 'rgba(0,0,0,0)'
      )
  })
  
  # --- K.6 TABEL DATABASE KLINIK (DIUBAH MENAMPILKAN DAFTAR DOKTER) ---
  output$k_table_detail <- renderDT({
    req(input$k_filter_provinsi, input$k_filter_klinik)
    
    cond <- ""
    if (input$k_filter_klinik != "Semua Klinik") {
      cond <- paste0("WHERE c.clinic_name = '", input$k_filter_klinik, "'")
    } else if (input$k_filter_provinsi != "Semua Provinsi") {
      cond <- paste0("WHERE c.clinic_province = '", input$k_filter_provinsi, "'")
    }
    
    # KUNCI PERUBAHAN: Menarik data dari tabel 'doctor', di-JOIN dengan 'clinic'
    query <- paste0("SELECT d.doctor_name, d.doctor_specialty, d.doctor_gender, 
                            d.doctor_consultation_fee,
                            REPLACE(c.clinic_name, 'Klinik Sehat Bersama ', '') as nama_klinik 
                     FROM doctor d 
                     JOIN clinic c ON d.clinic_id = c.clinic_id ", cond)
    
    df_tab <- dbGetQuery(con, query)
    
    # Jika datanya kosong
    if(nrow(df_tab) == 0) return(datatable(data.frame(Info = "Tidak ada data dokter"), rownames = FALSE))
    
    # Merapikan label jenis kelamin
    df_tab$doctor_gender <- ifelse(df_tab$doctor_gender %in% c("L", "M"), "Laki-Laki", "Perempuan")
    
    # Render Tabel (Menampilkan 10 baris per halaman agar 49 dokter lebih enak dilihat)
    datatable(df_tab, 
              options = list(pageLength = 10, scrollX = TRUE), 
              colnames = c("Nama Dokter", "Spesialisasi", "Gender", "Tarif Konsultasi", "Klinik Praktik"), 
              selection = 'none', rownames = FALSE) %>%
      formatCurrency('doctor_consultation_fee', currency = "Rp ", mark = ".", dec.mark = ",")
  })

  # ======================================================================================
  # 👨‍⚕️ BAGIAN 3: TAB DOKTER (INTERAKTIF PENUH)
  # ======================================================================================
  
  # --- D.1 LOGIKA FILTER DROPDOWN KHUSUS DOKTER ---
  observe({
    prov_list <- dbGetQuery(con, "SELECT DISTINCT clinic_province FROM clinic WHERE clinic_province IS NOT NULL ORDER BY clinic_province")
    updateSelectInput(session, "d_filter_provinsi", 
                      choices = c("Semua Provinsi", prov_list$clinic_province),
                      selected = "Semua Provinsi")
  })
  
  observeEvent(input$d_filter_provinsi, {
    req(input$d_filter_provinsi) 
    query <- if(input$d_filter_provinsi == "Semua Provinsi") {
      "SELECT clinic_name FROM clinic ORDER BY clinic_name"
    } else {
      sprintf("SELECT clinic_name FROM clinic WHERE clinic_province = '%s' ORDER BY clinic_name", input$d_filter_provinsi)
    }
    
    full_names <- dbGetQuery(con, query)$clinic_name
    short_names <- gsub("Klinik Sehat Bersama ", "", full_names)
    
    updateSelectInput(session, "d_filter_klinik", 
                      choices = c("Semua Klinik", setNames(full_names, short_names)),
                      selected = "Semua Klinik")
  })
  
  # ======================================================================================
  # 🔄 GLOBAL REACTIVE: KONDISI FILTER SQL (PENGHEMAT KODE)
  # ======================================================================================
  # Fungsi ini menghasilkan string "WHERE..." sesuai input filter. 
  # Dipanggil oleh semua output di bawahnya untuk menghindari repetisi kode.
  d_sql_cond <- reactive({
    req(input$d_filter_provinsi, input$d_filter_klinik)
    if (input$d_filter_klinik != "Semua Klinik") {
      paste0("WHERE c.clinic_name = '", input$d_filter_klinik, "' ")
    } else if (input$d_filter_provinsi != "Semua Provinsi") {
      paste0("WHERE c.clinic_province = '", input$d_filter_provinsi, "' ")
    } else {
      ""
    }
  })
  
  # ======================================================================================
  # 📊 RENDER OUTPUT VISUALISASI
  # ======================================================================================
  
  # --- D.2 KPI: TOTAL DOKTER ---
  output$d_val_total <- renderText({
    res <- dbGetQuery(con, paste0("SELECT COUNT(d.doctor_id) as total FROM doctor d JOIN clinic c ON d.clinic_id = c.clinic_id ", d_sql_cond()))
    paste(res$total, "Orang")
  })
  
  # --- D.3 KPI: RASIO DOKTER DAN PASIEN ---
  output$d_val_ratio <- renderText({
    res_doc <- dbGetQuery(con, paste0("SELECT COUNT(d.doctor_id) as total FROM doctor d JOIN clinic c ON d.clinic_id = c.clinic_id ", d_sql_cond()))$total[1]
    res_pat <- dbGetQuery(con, paste0("SELECT COUNT(DISTINCT v.patient_id) as total FROM visit v JOIN clinic c ON v.clinic_id = c.clinic_id ", d_sql_cond()))$total[1]
    
    if(res_doc == 0 || is.na(res_doc)) return("0 : 0")
    paste("1 :", round(res_pat / res_doc))
  })
  
  # --- D.4 KPI: SPESIALIS TERBANYAK ---
  output$d_val_modus <- renderText({
    query <- paste0("SELECT d.doctor_specialty, COUNT(d.doctor_id) as total FROM doctor d JOIN clinic c ON d.clinic_id = c.clinic_id ", 
                    d_sql_cond(), " GROUP BY d.doctor_specialty ORDER BY total DESC LIMIT 1")
    res <- dbGetQuery(con, query)
    if(nrow(res) == 0) return("-")
    res$doctor_specialty[1]
  })
  
  # --- D.5 PROFIL BINTANG (DOCTOR OF THE MONTH) ---
  top_doctor_data <- reactive({
    query <- paste0("SELECT d.doctor_name, d.doctor_specialty, d.doctor_gender, COUNT(v.visit_id) as total_visit 
                     FROM doctor d JOIN visit v ON d.doctor_id = v.doctor_id JOIN clinic c ON d.clinic_id = c.clinic_id ", 
                    d_sql_cond(), " GROUP BY d.doctor_id ORDER BY total_visit DESC LIMIT 1")
    dbGetQuery(con, query)
  })
  
  output$d_top_name <- renderText({ df <- top_doctor_data(); if(nrow(df) == 0) return("Tidak Ada Data"); df$doctor_name[1] })
  output$d_top_spec <- renderText({ df <- top_doctor_data(); if(nrow(df) == 0) return("-"); paste("Spesialis", df$doctor_specialty[1]) })
  output$d_top_visit <- renderText({ df <- top_doctor_data(); if(nrow(df) == 0) return("0"); paste(format(df$total_visit[1], big.mark = ","), "Orang") })
  output$d_top_rating <- renderText({ df <- top_doctor_data(); if(nrow(df) == 0) return("-"); "4.9 / 5.0" })
  
  output$d_top_photo <- renderUI({
    df <- top_doctor_data()
    if(nrow(df) == 0) return(tags$img(src = "https://cdn-icons-png.flaticon.com/512/822/822118.png", width = "150px"))
    img_url <- if(toupper(df$doctor_gender[1]) %in% c("L", "M", "PRIA", "MALE", "LAKI-LAKI")) "https://cdn-icons-png.flaticon.com/512/387/387561.png" else "https://cdn-icons-png.flaticon.com/512/387/387569.png"
    tags$img(src = img_url, width = "180px", style = "border-radius: 50%; box-shadow: 0 10px 20px rgba(0,0,0,0.1); background-color: #f8f9fa; padding: 10px;")
  })
  
  # --- D.6 GENDER & SPESIALISASI ---
  output$d_gender_plot <- renderPlotly({
    df_gen <- dbGetQuery(con, paste0("SELECT d.doctor_specialty, d.doctor_gender, COUNT(d.doctor_id) as jumlah FROM doctor d JOIN clinic c ON d.clinic_id = c.clinic_id ", d_sql_cond(), " GROUP BY d.doctor_specialty, d.doctor_gender"))
    if(nrow(df_gen) == 0) return(plotly_empty() %>% layout(title = "Data tidak tersedia"))
    
    df_gen$doctor_gender <- ifelse(df_gen$doctor_gender %in% c("L", "M"), "Laki-Laki", "Perempuan")
    
    plot_ly(df_gen, x = ~jumlah, y = ~doctor_specialty, color = ~doctor_gender, colors = c(temps_pal[1], temps_pal[6]), type = 'bar', orientation = 'h', text = ~jumlah, textposition = 'outside', hoverinfo = 'text', hovertext = ~paste(doctor_gender, "-", doctor_specialty, ":", jumlah, "Orang")) %>%
      layout(barmode = 'group', xaxis = list(title = "Jumlah Dokter", showgrid = FALSE), yaxis = list(title = ""), legend = list(orientation = 'h', x = 0.5, xanchor = 'center', y = 1.1, yanchor = 'bottom'), paper_bgcolor = 'transparent', plot_bgcolor = 'transparent', margin = list(l = 100, r = 20, t = 50, b = 40)) 
  })
  
  # --- D.7 TOP 3 DOKTER TERMAHAL ---
  output$d_top_premium <- renderPlotly({
    df_prem <- dbGetQuery(con, paste0("SELECT d.doctor_name, MAX(d.doctor_specialty) as doctor_specialty, d.doctor_consultation_fee as tarif FROM doctor d JOIN clinic c ON d.clinic_id = c.clinic_id ", d_sql_cond(), " GROUP BY d.doctor_name, d.doctor_consultation_fee ORDER BY tarif DESC LIMIT 3"))
    if(nrow(df_prem) == 0) return(plotly_empty() %>% layout(title = "Data tidak tersedia"))
    
    plot_ly(df_prem, x = ~tarif, y = ~reorder(doctor_name, tarif), type = 'bar', orientation = 'h', marker = list(color = temps_pal[1], line = list(color = 'white', width = 1)), text = ~paste("Rp", format(tarif, big.mark = ".", scientific = FALSE), "<br>", doctor_specialty), textposition = 'inside', insidetextanchor = 'middle', textfont = list(color = 'white', family = "Plus Jakarta Sans"), hoverinfo = 'none') %>%
      layout(xaxis = list(title = "Tarif Konsultasi (Rp)", showgrid = FALSE, range = list(0, max(df_prem$tarif) * 1.3)), yaxis = list(title = ""), margin = list(l = 150), paper_bgcolor = 'transparent', plot_bgcolor = 'transparent')
  })
  
  # --- D.8 BOXPLOT SEBARAN TARIF ---
  output$d_price_boxplot <- renderPlotly({
    df_box <- dbGetQuery(con, paste("SELECT d.doctor_specialty, d.doctor_consultation_fee AS tarif FROM doctor d JOIN clinic c ON d.clinic_id = c.clinic_id", d_sql_cond()))
    if (nrow(df_box) == 0) return(plotly_empty() %>% layout(title = "Data tidak tersedia"))
    
    plot_ly(df_box, x = ~doctor_specialty, y = ~tarif, type = 'box', fillcolor = temps_pal[1], line = list(color = temps_pal[6]), marker = list(color = temps_pal[6]), boxpoints = "outliers") %>%
      layout(xaxis = list(title = "", tickangle = -45, categoryorder = "median descending"), yaxis = list(title = "Tarif Konsultasi (Rp)", gridcolor = '#f0f0f0', zeroline = FALSE), showlegend = FALSE, paper_bgcolor = 'transparent', plot_bgcolor = 'transparent', margin = list(b = 80, t = 20))
  })  
  
  # --- D.9 DATABASE DOKTER (TABEL) ---
  output$d_table_full <- renderDT({
    df_tab <- dbGetQuery(con, paste0("SELECT d.doctor_name, d.doctor_specialty, d.doctor_gender, REPLACE(c.clinic_name, 'Klinik Sehat Bersama ', '') as nama_klinik, d.doctor_consultation_fee FROM doctor d JOIN clinic c ON d.clinic_id = c.clinic_id ", d_sql_cond()))
    df_tab$doctor_gender <- ifelse(df_tab$doctor_gender %in% c("L", "M"), "Laki-Laki", "Perempuan")
    
    datatable(df_tab, options = list(pageLength = 5, scrollX = TRUE), colnames = c("Nama Dokter", "Spesialisasi", "Gender", "Praktik Di", "Tarif Konsultasi"), selection = 'none', rownames = FALSE) %>%
      formatCurrency('doctor_consultation_fee', currency = "Rp ", mark = ".", dec.mark = ",")
  })
  
  # ======================================================================================
  # 🧑‍⚕️ BAGIAN 4: TAB PASIEN (VERSI TURBO + FILTER CHECKBOX)
  # ======================================================================================
  
  # --- P.1 LOGIKA FILTER DROPDOWN WILAYAH & KLINIK ---
  observe({
    prov_list <- dbGetQuery(con, "SELECT DISTINCT clinic_province FROM clinic WHERE clinic_province IS NOT NULL ORDER BY clinic_province")
    updateSelectInput(session, "p_filter_wilayah", choices = c("Semua Provinsi", prov_list$clinic_province), selected = "Semua Provinsi")
  })
  
  observeEvent(input$p_filter_wilayah, {
    req(input$p_filter_wilayah) 
    query <- if (input$p_filter_wilayah == "Semua Provinsi") {
      "SELECT clinic_name FROM clinic ORDER BY clinic_name"
    } else {
      sprintf("SELECT clinic_name FROM clinic WHERE clinic_province = '%s' ORDER BY clinic_name", input$p_filter_wilayah)
    }
    df_klinik <- dbGetQuery(con, query)
    updateSelectInput(session, "p_filter_tipe", 
                      choices = c("Semua Klinik", setNames(df_klinik$clinic_name, gsub("Klinik Sehat Bersama ", "", df_klinik$clinic_name))), 
                      selected = "Semua Klinik")
  })
  
  # --- MASTER DATA PASIEN (REACTIVE GLOBAL TAB 4) ---
  patient_master <- reactive({
    req(input$p_filter_wilayah, input$p_filter_tipe)
    
    cond <- if (input$p_filter_tipe != "Semua Klinik") {
      paste0("WHERE c.clinic_name = '", input$p_filter_tipe, "'")
    } else if (input$p_filter_wilayah != "Semua Provinsi") {
      paste0("WHERE c.clinic_province = '", input$p_filter_wilayah, "'")
    } else ""
    
    query <- paste(
      "SELECT p.patient_id, p.patient_name, p.gender, p.patient_type, p.height, p.weight,",
      "TIMESTAMPDIFF(YEAR, p.date_of_birth, CURDATE()) AS umur, DATE_FORMAT(v.visit_datetime, '%Y-%m-01') AS bulan,",
      "v.visit_id, t.transaction_id, t.payment_method, dg.diagnosis_name AS diagnosis,",
      "REPLACE(c.clinic_name, 'Klinik Sehat Bersama ', '') AS nama_klinik",
      "FROM patient p JOIN visit v ON p.patient_id = v.patient_id JOIN clinic c ON v.clinic_id = c.clinic_id",
      "LEFT JOIN transactions t ON v.visit_id = t.visit_id LEFT JOIN diagnosis dg ON t.primary_diagnosis_id = dg.diagnosis_id", cond
    )
    
    df <- tryCatch({ dbGetQuery(con, query) }, error = function(e) NULL)
    
    # Efisiensi: Transformasi data dengan mutate sekaligus
    if(!is.null(df) && nrow(df) > 0) { 
      df <- df %>%
        mutate(
          umur = as.numeric(umur), height = as.numeric(height), weight = as.numeric(weight),
          gender = ifelse(gender %in% c("L", "M"), "Laki-Laki", "Perempuan"),
          age_group = cut(umur, breaks = c(0, 10, 20, 30, 40, 50, 60, 70, 150), 
                          labels = c("0-9", "10-19", "20-29", "30-39", "40-49", "50-59", "60-69", "70+"), right = FALSE)
        )
    }
    return(df)
  })
  
  # --- MENGISI DROPDOWN DIAGNOSIS SECARA OTOMATIS (DUPLIKASI DIHAPUS) ---
  observe({
    df <- patient_master()
    if(!is.null(df) && nrow(df) > 0) {
      daftar_penyakit <- df %>% filter(!is.na(diagnosis)) %>% distinct(diagnosis) %>% pull(diagnosis) %>% sort()
      updateSelectizeInput(session, "p_filter_diagnosis", 
                           choices = c("Semua Diagnosis", daftar_penyakit), 
                           server = TRUE, selected = "Semua Diagnosis")
    }
  })
  
  # --- P.2 PIRAMIDA PENDUDUK PASIEN ---  
  output$p_pyramid_plot <- renderPlotly({
    df <- patient_master()
    if(is.null(df) || nrow(df) == 0) return(plotly_empty() %>% layout(title = "Data tidak tersedia"))
    
    kategori_umur <- c("0-9", "10-19", "20-29", "30-39", "40-49", "50-59", "60-69", "70+")
    df_agg <- df %>% 
      distinct(patient_id, .keep_all = TRUE) %>% filter(!is.na(age_group)) %>% 
      group_by(age_group, gender) %>% summarise(count = n(), .groups = 'drop') %>% 
      tidyr::complete(age_group, gender = c("Laki-Laki", "Perempuan"), fill = list(count = 0)) %>%
      mutate(
        plot_count = ifelse(gender == "Laki-Laki", -count, count),
        teks_label = ifelse(count > 0, paste(count, "Pasien"), "")
      )
    
    plot_ly(df_agg, x = ~plot_count, y = ~age_group, color = ~gender, colors = c(temps_pal[1], temps_pal[6]), type = 'bar', orientation = 'h', text = ~teks_label, textposition = 'auto', textfont = list(color = 'white', family = "Plus Jakarta Sans", size=10), hoverinfo = 'text', hovertext = ~paste("Total:", count, "Pasien")) %>%
      layout(barmode = 'relative', xaxis = list(title = "Jumlah Pasien", tickformat = "d"), yaxis = list(title = "Kelompok Umur", categoryorder = "array", categoryarray = kategori_umur), paper_bgcolor = 'transparent', plot_bgcolor = 'transparent', legend = list(orientation = 'h', x = 0.5, y = 1.1, xanchor = 'center'))
  })
  
  # --- P.3 ANALISIS STATUS GIZI ---
  output$p_bmi_scatter <- renderPlotly({
    df <- patient_master()
    if(is.null(df) || nrow(df) == 0) return(plotly_empty() %>% layout(title = "Data tidak tersedia"))
    
    df_unik <- df %>% distinct(patient_id, .keep_all = TRUE) %>% filter(!is.na(height) & !is.na(weight))
    
    if(is.null(input$p_bmi_gender) || length(input$p_bmi_gender) == 0) return(plotly_empty() %>% layout(title = "Silakan centang minimal 1 Gender"))
    if(is.null(input$p_bmi_age) || length(input$p_bmi_age) == 0) return(plotly_empty() %>% layout(title = "Silakan centang minimal 1 Kelompok Umur"))
    
    df_unik <- df_unik %>% filter(gender %in% input$p_bmi_gender, age_group %in% input$p_bmi_age)
    if(nrow(df_unik) == 0) return(plotly_empty() %>% layout(title = "Tidak ada pasien di kategori tersebut"))
    
    plot_ly(df_unik, x = ~weight, y = ~height, color = ~gender, colors = c(temps_pal[1], temps_pal[6]), type = 'scatter', mode = 'markers', marker = list(size = 8, opacity = 0.6), hoverinfo = 'text', hovertext = ~paste("Gender:", gender, "<br>Umur:", umur, "Tahun<br>Tinggi:", height, "cm<br>Berat:", weight, "kg")) %>%
      layout(xaxis = list(title = "Berat Badan (kg)"), yaxis = list(title = "Tinggi Badan (cm)"), paper_bgcolor = 'transparent', plot_bgcolor = 'transparent', legend = list(orientation = 'h', x = 0.5, y = 1.15, xanchor = 'center'))
  })
  
  # --- P.4 TREN DIAGNOSIS ---
  output$p_trend_line <- renderPlotly({
    df <- patient_master()
    if(is.null(df) || nrow(df) == 0) return(plotly_empty() %>% layout(title = "Data tidak tersedia"))
    if(is.null(input$p_filter_diagnosis)) return(plotly_empty() %>% layout(title = "Silakan pilih minimal 1 penyakit di atas"))
    
    # Efisiensi logika filter diagnosis
    df_diag <- df %>% filter(!is.na(diagnosis) & !is.na(bulan))
    if (!"Semua Diagnosis" %in% input$p_filter_diagnosis) {
      df_diag <- df_diag %>% filter(diagnosis %in% input$p_filter_diagnosis)
    }
    df_diag <- df_diag %>% group_by(bulan, diagnosis) %>% summarise(jumlah = n_distinct(visit_id), .groups = 'drop') %>% mutate(bulan = as.Date(paste0(bulan, "-01")))
    
    if(nrow(df_diag) == 0) return(plotly_empty() %>% layout(title = "Tidak ada data untuk kriteria tersebut"))
    
    plot_ly(df_diag, x = ~bulan, y = ~jumlah, color = ~diagnosis, colors = colorRampPalette(c(temps_pal[1], temps_pal[6], temps_pal[3]))(length(unique(df_diag$diagnosis))), type = 'scatter', mode = 'lines+markers', line = list(shape = 'spline', width = 3), marker = list(size = 8), hoverinfo = 'text', text = ~paste("<b>Diagnosis:</b>", diagnosis, "<br><b>Bulan:</b>", format(bulan, "%B %Y"), "<br><b>Jumlah:</b>", jumlah, "Kasus")) %>%
      layout(xaxis = list(title = "", type = 'date', tickformat = "%Y", dtick = "M12", ticklabelmode = "period", showgrid = TRUE, gridcolor = '#f0f0f0', range = c('2020-01-01', '2024-12-31')), yaxis = list(title = "Jumlah Kasus", gridcolor = '#f0f0f0'), paper_bgcolor = 'transparent', plot_bgcolor = 'transparent', legend = list(orientation = 'h', x = 0.5, y = 1.2, xanchor = 'center'))
  })
  
  # --- P.5 TIPE PASIEN ---
  output$p_type_pie <- renderPlotly({
    df <- patient_master()
    if(is.null(df) || nrow(df) == 0) return(plotly_empty() %>% layout(title = "Data tidak tersedia"))
    
    df_tipe <- df %>% distinct(patient_id, .keep_all = TRUE) %>% group_by(patient_type) %>% summarise(jumlah = n(), .groups = 'drop')
    plot_ly(df_tipe, labels = ~patient_type, values = ~jumlah, type = 'pie', hole = 0.5, marker = list(colors = c(temps_pal[3], temps_pal[6], temps_pal[1]))) %>% 
      layout(showlegend = TRUE, paper_bgcolor = 'transparent', plot_bgcolor = 'transparent')
  })
  
  # --- P.6 METODE PEMBAYARAN ---
  output$p_pay_lollipop <- renderPlotly({
    df <- patient_master()
    if(is.null(df) || nrow(df) == 0) return(plotly_empty() %>% layout(title = "Data tidak tersedia"))
    
    df_pay <- df %>% filter(!is.na(payment_method)) %>% group_by(payment_method) %>% summarise(jumlah = n_distinct(transaction_id), .groups = 'drop')
    if(nrow(df_pay) == 0) return(plotly_empty() %>% layout(title = "Data Pembayaran tidak tersedia"))
    
    plot_ly(df_pay) %>% add_segments(x = 0, xend = ~jumlah, y = ~reorder(payment_method, jumlah), yend = ~reorder(payment_method, jumlah), line = list(color = temps_pal[3], width = 3)) %>% add_markers(x = ~jumlah, y = ~reorder(payment_method, jumlah), marker = list(color = temps_pal[1], size = 12)) %>% 
      layout(xaxis = list(title = "Frekuensi Penggunaan"), yaxis = list(title = ""), showlegend = FALSE, paper_bgcolor = 'transparent', plot_bgcolor = 'transparent', margin=list(l=100))
  })
  
  # --- P.7 TABEL DIREKTORI PASIEN ---
  output$p_table_full <- renderDT({
    df <- patient_master()
    if(is.null(df) || nrow(df) == 0) return(datatable(data.frame(Info = "Data kosong")))
    
    df_tab <- df %>% select(patient_name, gender, umur, diagnosis, nama_klinik) %>% head(1000)
    datatable(df_tab, options = list(pageLength = 10, scrollX = TRUE), colnames = c("Nama Pasien", "Gender", "Umur", "Diagnosis", "Klinik Praktik"), selection = 'none', rownames = FALSE)
  })  
  
  # ======================================================================================
  # 💊 BAGIAN 5: TAB OBAT (VERSI TURBO - REACTIVE DATA & OPTIMIZED PLOTLY)
  # ======================================================================================
  
  # --- O.1 LOGIKA FILTER DROPDOWN OBAT ---
  observe({
    prov_list <- dbGetQuery(con, "SELECT DISTINCT clinic_province FROM clinic WHERE clinic_province IS NOT NULL ORDER BY clinic_province")
    updateSelectInput(session, "o_filter_provinsi", choices = c("Semua Provinsi", prov_list$clinic_province), selected = "Semua Provinsi")
  })
  
  observeEvent(input$o_filter_provinsi, {
    req(input$o_filter_provinsi) 
    # [BUG FIX]: Sebelumnya tertulis input$p_filter_wilayah, sudah diganti jadi input$o_filter_provinsi
    query <- if(input$o_filter_provinsi == "Semua Provinsi") {
      "SELECT clinic_name FROM clinic ORDER BY clinic_name" 
    } else {
      sprintf("SELECT clinic_name FROM clinic WHERE clinic_province = '%s' ORDER BY clinic_name", input$o_filter_provinsi)
    }
    df_klinik <- dbGetQuery(con, query)
    updateSelectInput(session, "o_filter_klinik", choices = c("Semua Klinik", setNames(df_klinik$clinic_name, gsub("Klinik Sehat Bersama ", "", df_klinik$clinic_name))), selected = "Semua Klinik")
  })
  
  # --- O.2 MASTER DATA OBAT (HANYA 1x QUERY UNTUK SEMUA OUTPUT) ---
  medicine_master <- reactive({
    req(input$o_filter_provinsi, input$o_filter_klinik)
    
    cond <- ""
    if (input$o_filter_klinik != "Semua Klinik") {
      cond <- paste0("WHERE c.clinic_name = '", input$o_filter_klinik, "' ")
    } else if (input$o_filter_provinsi != "Semua Provinsi") {
      cond <- paste0("WHERE c.clinic_province = '", input$o_filter_provinsi, "' ")
    }
    
    query <- paste0("
      SELECT 
        vm.visit_id, m.medicine_name, m.medicine_category, m.medicine_unit_price, 
        m.medicine_dosage_per_day, m.medicine_duration_days
      FROM visit_medicine vm
      INNER JOIN medicine m ON vm.medicine_id = m.medicine_id
      INNER JOIN visit v ON vm.visit_id = v.visit_id
      INNER JOIN clinic c ON v.clinic_id = c.clinic_id ", 
                    cond
    )
    
    df <- tryCatch({ dbGetQuery(con, query) }, error = function(e) { NULL })
    if(!is.null(df)) {
      df$medicine_unit_price <- as.numeric(df$medicine_unit_price)
      df$medicine_dosage_per_day <- as.numeric(df$medicine_dosage_per_day)
      df$medicine_duration_days <- as.numeric(df$medicine_duration_days)
    }
    return(df)
  })
  
  # --- 1. KPI PERFORMA ---
  output$m_val_terjual <- renderText({ 
    df <- medicine_master()
    if(is.null(df)) return("0")
    format(nrow(df), big.mark = ",") 
  })
  
  output$m_val_avg_resep <- renderText({ 
    df <- medicine_master()
    if(is.null(df) || nrow(df) == 0) return("0")
    avg <- round(nrow(df) / n_distinct(df$visit_id), 1)
    paste(avg, "Jenis")
  })
  
  output$m_val_mahal <- renderText({ 
    df <- medicine_master()
    if(is.null(df) || nrow(df) == 0) return("-")
    top_cat <- df %>% group_by(medicine_category) %>% summarise(avg = mean(medicine_unit_price, na.rm = TRUE)) %>% arrange(desc(avg)) %>% head(1)
    top_cat$medicine_category[1]
  })
  
  # --- 2. GRAFIK-GRAFIK (SUDAH DIOPTIMALKAN AGAR TIDAK NGE-LAG) ---
  output$m_top_laris <- renderPlotly({
    df <- medicine_master()
    if(is.null(df) || nrow(df) == 0) return(plotly_empty())
    
    df_plot <- df %>% count(medicine_name) %>% arrange(desc(n)) %>% head(10)
    plot_ly(df_plot, x = ~n, y = ~reorder(medicine_name, n), type = 'bar', orientation = 'h', marker = list(color = temps_pal[1]),
            hovertemplate = "<b>%{y}</b><br>Diresepkan: %{x:,.0f} kali<extra></extra>") %>%
      layout(xaxis = list(title = "Frekuensi Muncul di Resep"), yaxis = list(title = ""), paper_bgcolor = 'rgba(0,0,0,0)', plot_bgcolor = 'rgba(0,0,0,0)')
  })
  
  output$m_dosis_hist <- renderPlotly({
    df <- medicine_master()
    if(is.null(df) || nrow(df) == 0) return(plotly_empty())
    
    # [OPTIMASI]: Menghitung jumlah per dosis di R, BUKAN di browser Plotly
    df_plot <- df %>% count(medicine_dosage_per_day)
    
    plot_ly(df_plot, x = ~medicine_dosage_per_day, y = ~n, type = "bar", marker = list(color = temps_pal[6]),
            hovertemplate = "Dosis %{x} kali: %{y:,.0f} obat<extra></extra>") %>%
      layout(xaxis = list(title = "Dosis per Hari (kali)", dtick = 1), 
             yaxis = list(title = "Jumlah Obat", tickformat = ",.0f"), 
             paper_bgcolor = 'rgba(0,0,0,0)', plot_bgcolor = 'rgba(0,0,0,0)')
  })
  
  output$m_price_duration_scatter <- renderPlotly({
    df <- medicine_master()
    if(is.null(df) || nrow(df) == 0) return(plotly_empty())
    
    # [OPTIMASI]: Mengambil 1 titik per obat agar browser tidak menggambar titik bertumpuk
    df_unik <- df %>% select(medicine_name, medicine_category, medicine_duration_days, medicine_unit_price) %>% distinct()
    
    plot_ly(df_unik, x = ~medicine_duration_days, y = ~medicine_unit_price, color = ~medicine_category, type = 'scatter', mode = 'markers', marker = list(size = 10, opacity = 0.7),
            text = ~medicine_name, hovertemplate = "<b>%{text}</b><br>Durasi: %{x} Hari<br>Harga: Rp %{y:,.0f}<extra></extra>") %>%
      layout(xaxis = list(title = "Durasi Konsumsi (Hari)"), yaxis = list(title = "Harga Satuan (Rp)"), paper_bgcolor = 'rgba(0,0,0,0)', plot_bgcolor = 'rgba(0,0,0,0)')
  })
  
  output$m_network_graph <- renderPlotly({
    df <- medicine_master()
    if(is.null(df) || nrow(df) == 0) return(plotly_empty())
    
    df_pie <- df %>% group_by(medicine_category) %>% summarise(total = n()) %>% arrange(desc(total)) %>% head(10)
    plot_ly(df_pie, labels = ~medicine_category, values = ~total, type = 'pie', hole = 0.4, marker = list(colors = colorRampPalette(c(temps_pal[1], temps_pal[6]))(10)),
            hovertemplate = "<b>%{label}</b><br>Jumlah: %{value:,.0f} (%{percent})<extra></extra>") %>%
      layout(showlegend = TRUE, paper_bgcolor = 'rgba(0,0,0,0)', plot_bgcolor = 'rgba(0,0,0,0)', legend = list(orientation = 'h', x = 0.5, xanchor = 'center', y = -0.1))
  })
  
  output$m_table_full <- renderDT({
    df <- medicine_master()
    if(is.null(df) || nrow(df) == 0) return(datatable(data.frame(Info = "Data kosong")))
    
    datatable(df %>% head(1000), options = list(pageLength = 10, scrollX = TRUE), rownames = FALSE,
              colnames = c("ID Visit", "Nama Obat", "Kategori", "Harga", "Dosis", "Durasi")) %>%
      formatCurrency('medicine_unit_price', currency = "Rp ", mark = ".", dec.mark = ",")
  })
  
} # Akhir dari fungsi Server

shinyApp(ui, server)

