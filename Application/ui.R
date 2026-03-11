library(shiny)
library(bs4Dash)
library(plotly)
library(DT)
library(wordcloud2)
library(shinyWidgets)

# DEFINISI PALET BARU (Berdasarkan gambar Cyan-Magenta)
temps_pal <- c("#009B9E", "#159B91", "#33C1B1", "#E0F2F1", "#F8BBD0", "#F06292", "#CB5280")

ui <- bs4DashPage(
  dark = NULL, help = NULL,
#------------------------------------------- Header ----------------------------------------------------------------------------------------------------
header = bs4DashNavbar(
  status = NULL,
  fixed = TRUE,
  tags$head(tags$style(paste0("
   .main-header {
      background: linear-gradient(90deg, #009B9E 0%, #29B6B9 100%) !important;
      border-bottom: none !important;
    }
    
   .main-header .nav-link {
      color: white !important;
    }

    .nav-link-btn {
      color: #009B9E !important; 
      background: white !important;
      border-radius: 20px;
      padding: 6px 15px !important;
      margin: 0 5px;
      font-weight: 800;
      font-size: 11px;
      text-transform: uppercase;
      box-shadow: 0 4px 10px rgba(0,0,0,0.1);
      border: none;
      transition: 0.3s;
    }

    .nav-link-btn:hover {
      background: ", temps_pal[6], " !important;
      color: white !important;
      transform: translateY(-2px);
    }
  "))),
  title = bs4DashBrand(
    title = span("DJIWA MEDICAL", 
                 style = "font-family: 'Plus Jakarta Sans', sans-serif; font-weight: 700; color: white; margin-left: 10px;"), 
    color = NULL,
    image = "https://raw.githubusercontent.com/avinrahmadian/Dashboard-Profil-Klinik/main/Images/logo-circle.png"
  ),
  rightUi = tagList(
    uiOutput("dynamic_nav_buttons"),
    tags$li(
      class="dropdown", 
      style="padding:10px 20px;", 
      tags$style(paste0("#filter_global + .selectize-control .selectize-input { background: rgba(255,255,255,0.9) !important; border-radius: 10px; }"))
    )
  )
),
  
  sidebar = bs4DashSidebar(
    skin = "light", 
    elevation = 4,
    tags$style(paste0("
          .main-sidebar, .sidebar { 
           background-color: ", temps_pal[2], " !important; 
            }
          .brand-link { 
          background-color: ", temps_pal[2], " !important; 
          border-bottom: 1px solid rgba(255,255,255,0.1) !important;
          }
          .nav-sidebar .nav-link p, 
          .nav-sidebar .nav-link i { 
          color: white !important; 
          opacity: 0.9;
          }
          .nav-pills .nav-link.active {
           background-color: ", temps_pal[6], " !important; 
          color: white !important;
         font-weight: bold;
          }

          .nav-pills .nav-link.active i {
           color: white !important;
          }
    ")),
    bs4SidebarMenu(
      id = "current_tab",
      menuItem("Home", tabName = "tab_home", icon = icon("house-medical")),
      menuItem("Klinik", tabName = "tab_klinik", icon = icon("hospital")),
      menuItem("Dokter", tabName = "tab_dokter", icon = icon("user-doctor")),
      menuItem("Pasien", tabName = "tab_pasien", icon = icon("user-nurse")),
      menuItem("Obat", tabName = "tab_obat", icon = icon("pills")),
      menuItem("Team", tabName = "tab_team", icon = icon("users-cog")) 
    )
  ),
#----------------------------------------- Body ----------------------------------------------------------------------------------------------------  
  body = bs4DashBody(
    tags$head(

      tags$link(rel = "stylesheet", href = "https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@400;600;800&display=swap"),
      
      tags$style(paste0("
          body,.content-wrapper { 
          background: radial-gradient(circle at center, #ffffff 10%, #d1d9e6 100%) !important; 
          background-attachment: fixed !important;
        }


        @keyframes floating {
          0% { transform: translateY(0px); }
          50% { transform: translateY(-10px); }
          100% { transform: translateY(0px); }
        }
        
        .welcome-banner-animated {
          animation: floating 3s ease-in-out infinite;
          transition: all 0.3s ease;
        }
     
        .bmi-filter-container {
          background: #ffffff !important;
          border: 1.5px solid #f1f3f5 !important;
          border-left: 4px solid #F06292 !important; /* Aksen Pink sesuai tema */
          transition: all 0.3s ease;
        }
        
        .bmi-filter-container:hover {
          box-shadow: 0 5px 15px rgba(0,0,0,0.05);
        }
        
        .filter-title {
          font-weight: 800;
          font-size: 12px;
          color: #009B9E;
          text-transform: uppercase;
          letter-spacing: 1px;
          margin-bottom: 10px;
          display: flex;
          align-items: center;
        }
        
        .filter-title i {
          margin-right: 8px;
        }
        
        .card { 
          border-radius: 20px !important; 
          border-left: 5px solid ", temps_pal[1], " !important; 
          background: white !important;
          box-shadow: 0 4px 15px rgba(0,0,0,0.05) !important; 
          margin-bottom: 24px;
          border-top: none !important;
        }

        .card-header {
           background-color: transparent !important;
           border-bottom: 1px solid rgba(0,0,0,0.05) !important;
        }
        
        .kpi-label-top { 
          font-size: 11px; font-weight: 700; color: #636E72; 
          text-transform: uppercase; letter-spacing: 1px; margin-bottom: 8px; display: block;
        }
        
        .kpi-box-small {
          padding: 20px; border-radius: 18px; color: white; text-align: center;
          min-height: 80px; display: flex; align-items: center; justify-content: center;
          box-shadow: 0 6px 15px rgba(0,0,0,0.08);
        }
        .kpi-val-output { font-size: 28px; font-weight: 800; }
        
        .bg-v1 { background: ", temps_pal[1], "; }
        .bg-v2 { background: ", temps_pal[2], "; }
        .bg-v3 { background: linear-gradient(135deg, ", temps_pal[3], ", ", temps_pal[4], "); color: ", temps_pal[1], " !important; }
        .bg-v4 { background: linear-gradient(135deg, ", temps_pal[5], ", ", temps_pal[6], "); }
        .bg-v5 { background: linear-gradient(135deg, ", temps_pal[6], ", ", temps_pal[7], "); }

        .section-header { margin: 30px 0 15px 5px; border-left: 4px solid ", temps_pal[6], "; padding-left: 15px; }
        .section-header h4 { font-weight: 800; color: #2D3436; }

        .form-control:focus {
          border-color: ", temps_pal[1], " !important;
          box-shadow: none !important;
        }

        .control-label { font-weight: 700; color: #2d3436; margin-bottom: 8px; }
      
        .selectize-input { 
          border-radius: 12px !important; 
          border: 1px solid #dfe6e9 !important;
          padding: 10px !important;
          box-shadow: none !important;
        }
      
        .selectize-input.focus { border-color: ", temps_pal[1], " !important; }
        
        .dataTables_filter input { 
          border-radius: 10px !important; 
          border: 1px solid #dfe6e9 !important; 
        }

        .banner-home {
          background: white; 
          padding: 35px; 
          border-radius: 25px; 
          margin-bottom: 20px;
          border-right: 10px solid ", temps_pal[6], "; 
          box-shadow: 0 10px 25px rgba(0,0,0,0.03);
        }
        .banner-home h1 { color: ", temps_pal[1], "; }
        
        .filter-panel {
          background: linear-gradient(135deg, ", temps_pal[1], " 0%, ", temps_pal[6], " 120%); 
          padding: 30px; 
          border-radius: 25px; 
          margin-bottom: 25px; 
          box-shadow: 0 10px 30px rgba(0,0,0,0.06);
          color: white;
              "))
    ),
    
    tabItems(
#------------------------------------------------------------ Menu Home -----------------------------------------------------------------------------------------------------------------------------      
      tabItem(tabName = "tab_home",
              div(class = "welcome-banner-animated", 
                  style = "text-align: left; 
             padding: 50px 60px; 
             background: linear-gradient(135deg, #e0f7f7 0%, #ffffff 50%, #fff0f5 100%); 
             border-radius: 30px; 
             margin-bottom: 30px; 
             position: relative; 
             box-shadow: 0 15px 35px rgba(0,155,158,0.1);
             border-right: 20px solid #e91e63; 
             border-left: 5px solid #009B9E;",
                  
                  h1("Welcome to Djiwa Medical!", 
                     style = "font-weight: 900; color: #F06292; margin: 0; font-size: 40px; letter-spacing: -1px;"),
                  
                  p("Dashboard monitoring kesehatan berbagai klinik di Indonesia", 
                    style = "color: #4b4b4b; font-size: 20px; margin-top: 15px; font-weight: 400; max-width: 600px;")
              ),
              div(class="section-header", h4("Ringkasan Performa"), p("Indikator utama operasional klinik.")),
              fluidRow(
                column(width = 2, span("Total Visit", class="kpi-label-top"), div(class="kpi-box-small bg-v1", span(textOutput("val_visit", inline = TRUE), class="kpi-val-output"))),
                column(width = 3, span("Total Revenue", class="kpi-label-top"), div(class="kpi-box-small bg-v2", span(textOutput("val_revenue", inline = TRUE), class="kpi-val-output"))),
                column(width = 2, span("Total Klinik", class="kpi-label-top"), div(class="kpi-box-small bg-v3", span(textOutput("val_unit", inline = TRUE), class="kpi-val-output"))),
                column(width = 3, span("Jumlah Pasien", class="kpi-label-top"), div(class="kpi-box-small bg-v4", span(textOutput("val_pasien", inline = TRUE), class="kpi-val-output"))),
                column(width = 2, span("Jumlah Dokter", class="kpi-label-top"), div(class="kpi-box-small bg-v5", span(textOutput("val_dokter", inline = TRUE), class="kpi-val-output")))
              ), br(),
              # Barisan Visualisasi Utama (Tren & Prediksi)
              div(id = "sec_h_tren", 
                  div(class="section-header", h4("Analisis Tren & Prediksi"), p("Visualisasi data historis dan estimasi kunjungan mendatang."))),
              fluidRow(
                column(width = 9, 
                       box(title = tagList(icon("chart-line"), " Tren Kunjungan Bulanan"), 
                           width = 12, status = "primary", solidHeader = FALSE,
                           plotlyOutput("h_trend", height = "350px"))
                ),
                column(width = 3, 
                       box(title = tagList(icon("crystal-ball"), " Prediksi Kunjungan (Forecasting)"), 
                           width = 12, status = "primary", solidHeader = FALSE,
                           plotlyOutput("h_prediction", height = "250px")) # Output baru untuk prediksi
                )
              ),
              
              # Barisan Geografis & Insight (Peta & Wordcloud)
              div(id = "sec_h_map",
                  div(class="section-header", h4("Sebaran Klinik & Insight Penyakit"), p("Pemetaan lokasi klinik dan keluhan pasien terbanyak."))),
              fluidRow(
                column(width = 4, 
                       box(title = tagList(icon("cloud"), "Heatmap Penyakit"), 
                           width = 12, plotlyOutput("h_wordcloud", height = "450px"))),
                column(width = 8, 
                       box(title = tagList(icon("map-location-dot"), " Peta Sebaran Titik Klinik"), 
                           width = 12,plotlyOutput("h_map", height = "450px"))
                )
              )
                
      ),

#------------------------------------------------- Menu Klinik -----------------------------------------------------------------------------------------------------------------------------      
      
      tabItem(tabName = "tab_klinik",
              fluidRow(
                column(width = 12,
                       div(style = paste0("background: linear-gradient(180deg, ", temps_pal[1], " 0%, ", temps_pal[6], " 100%); 
                   padding: 30px; border-radius: 25px; 
                   margin-bottom: 25px; 
                   box-shadow: 0 10px 30px rgba(0,0,0,0.07);"),
               fluidRow(
                column(width = 4, 
                   h3(style = "font-weight: 800; color: white; margin-bottom: 5px;", "Pencarian"),
                   p(style = "color: rgba(255,255,255,0.8); font-size: 14px;", "Filter data berdasarkan wilayah dan unit klinik.")
                             ),
                   column(width = 4,
                   div(style = "color: white;",
                       selectInput("k_filter_provinsi", "Pilih Provinsi", 
                                   choices = c("Semua Provinsi"), width = "100%"))),
                   column(width = 4, 
                    div(style = "color: white;",
                       selectInput("k_filter_klinik", "Pilih Klinik", 
                                   choices = c("Semua Klinik"), width = "100%")))
                 )
               )
             )
              ),
              
             div(id = "sec_k_fin",
                 div(class="section-header", h4("Finansial & Kunjungan"), p("Perbandingan metrik biaya dan volume kunjungan antar klinik."))),
              fluidRow(
                column(width = 8, 
                       box(title = tagList(icon("chart-pie"), "Radar Revenue"), 
                           width = 12, 
                           plotlyOutput("k_radar_revenue", height = "400px"),
                           hr(),
                           p(style = "color: #636E72; font-style: italic; font-size: 13px;", 
                             "Perbandingan rata-rata biaya admin, konsultasi, obat, dan tindakan antar klinik.")
                       )
                ),
                column(width = 4,
                       box(title = tagList(icon("ranking-star"), "Top 5 Klinik"), 
                           width = 12, 
                           plotlyOutput("k_top_clinic", height = "350px"), 
                           hr(),
                           p(style = "color: #636E72; font-style: italic; font-size: 12px;", 
                             "Lima unit klinik dengan volume kunjungan tertinggi.")
                       )
                )),
            
             div(id = "sec_k_loyal",
                 div(class="section-header", h4("Loyalitas & Kapasitas SDM"), p("Analisis retensi pasien dan sebaran keahlian dokter."))),
              fluidRow(
                column(width = 4, 
                       box(title = tagList(icon("user-heart"), "Loyalitas Pasien"), 
                           width = 12, 
                           plotlyOutput("k_loyalty_donut", height = "350px"),
                           hr(),
                           p(style = "color: #636E72; font-style: italic; font-size: 13px;", 
                             "Persentase pasien yang datang kembali (Retensi) vs pasien sekali kunjungan.")
                       )
                ),
                column(width = 8, 
                       box(title = tagList(icon("stethoscopes"), "Sebaran Spesialis"), 
                           width = 12, 
                           plotlyOutput("k_spec_treemap", height = "350px"),
                           hr(),
                           p(style = "color: #636E72; font-style: italic; font-size: 13px;", 
                             "Distribusi bidang spesialisasi dokter yang tersedia di setiap cabang klinik.")
                       )
                )
              ),
              
             div(id = "sec_k_db",
                 div(class="section-header", h4("Database Informasi Klinik"), p("Tabel lengkap histori dan detail operasional."))),
              fluidRow(
                column(width = 12, 
                       box(title = tagList(icon("table"), "Database Klinik"), 
                           width = 12, 
                           DTOutput("k_table_detail"),
                           hr(),
                           p(style = "color: #636E72; font-style: italic; font-size: 13px;", 
                             "Data mentah operasional klinik untuk keperluan audit dan ekspor.")
                       )
                )
              )
      ),
#---------------------------------------- Menu DOkter-----------------------------------------------------------------------------------------------------------------------------      
      tabItem(tabName = "tab_dokter",
              fluidRow(
                column(width = 12,
                       div(class = "filter-panel",
                           fluidRow(
                             column(width = 4, 
                                    h3(style = "font-weight: 800; color: white; margin-bottom: 5px;", "Pencarian"),
                                    p(style = "color: rgba(255,255,255,0.9); font-size: 14px;", "Analisis kinerja dokter.")
                             ),
                             column(width = 4, div(style = "color: white;", selectInput("d_filter_provinsi", "Pilih Provinsi", choices = c("Semua Provinsi"), width = "100%"))),
                             column(width = 4, div(style = "color: white;", selectInput("d_filter_klinik", "Pilih Klinik", choices = c("Semua Klinik"), width = "100%")))
                           ) )
                )
              ),
              div(id = "sec_d_perf",
                  div(class="section-header", h4("Performa & Profil Bintang"), p("Ringkasan statistik tenaga medis dan profil dokter dengan kontribusi tertinggi."))),
              fluidRow(
                column(width = 4, 
                       span("Total Dokter", class="kpi-label-top"), 
                       div(class="kpi-box-small bg-v1", 
                           span(textOutput("d_val_total", inline = TRUE), class="kpi-val-output"))),
                
                column(width = 4, 
                       span("Rasio Dokter dan Pasien", class="kpi-label-top"), 
                       div(class="kpi-box-small bg-v2", 
                           span(textOutput("d_val_ratio", inline = TRUE), class="kpi-val-output"))),
                
                column(width = 4, 
                       span("Spesialis Terbanyak", class="kpi-label-top"), 
                       div(class="kpi-box-small bg-v4", 
                           span(textOutput("d_val_modus", inline = TRUE), style="font-size:24px; font-weight:800;")))
              ), br(),

              fluidRow(
                column(width = 12,
                       div(style = paste0("background: white; border-radius: 25px; padding: 35px; display: flex; align-items: center; min-height: 280px; border-left: 12px solid ", temps_pal[1], "; box-shadow: 0 10px 25px rgba(0,0,0,0.05);"),
                           div(style = "flex: 1; text-align: center;", uiOutput("d_top_photo")),
                           div(style = "flex: 3; padding-left: 50px;",
                               span("DOCTOR OF THE MONTH", style=paste0("color:", temps_pal[6], "; font-weight:800; font-size:14px; letter-spacing:3px;")),
                               h1(textOutput("d_top_name", inline = TRUE), style="font-weight: 800; margin-top: 10px; color:#2D3436; font-size: 36px;"),
                               h4(textOutput("d_top_spec", inline = TRUE), style="color:#636E72; margin-bottom: 25px;"),
                               hr(),
                               fluidRow(
                                 column(width = 6, 
                                        span("TOTAL PASIEN", style="font-size:12px; color:#B2BEC3; font-weight:700;"), 
                                        h2(textOutput("d_top_visit", inline = TRUE), style=paste0("font-weight:800; color:", temps_pal[1], ";"))
                                 )
                               )
                           )
                       )
                )
              ), br(),
              
              div(id = "sec_d_cap",
                  div(class="section-header", h4("Analisis Kapasitas & Prestasi"), p("Komposisi tenaga medis dan daftar dokter dengan tarif premium."))),
              fluidRow(
                column(width = 4, 
                       box(title = tagList(icon("venus-mars"), "Gender & Spesialisasi"), width = 12,
                           plotlyOutput("d_gender_plot", height = "300px"),
                           hr(), p(style="color: #636E72; font-style: italic; font-size: 13px;", "Distribusi gender dokter berdasarkan bidang keahlian.")
                       )
                ),
                column(width = 8, 
                       box(title = tagList(icon("crown"), "Top 3 Dokter"), width = 12,
                           plotlyOutput("d_top_premium", height = "300px"),
                           hr(), p(style="color: #636E72; font-style: italic; font-size: 13px;", "Tiga dokter dengan biaya konsultasi tertinggi per kunjungan.")
                       )
                )
              ),
              
              div(id = "sec_d_price",
                  div(class="section-header", h4("Analisis Tarif"), p("Sebaran harga konsultasi dengan dokter."))),
              fluidRow(
                column(width = 12, 
                       box(title = tagList(icon("magnifying-glass-chart"), "Perbandingan Tarif antar Spesialis"), width = 12,
                           plotlyOutput("d_price_boxplot", height = "350px"),
                           hr(), p(style="color: #636E72; font-style: italic; font-size: 13px;", "Analisis boxplot untuk melihat rata-rata dan rentang tarif tiap spesialisasi.")
                       )
                )
              ),
              
              div(id = "sec_d_db",
                  div(class="section-header", h4("Database Informasi Dokter"), p("Tabel histori data dokter."))),
              fluidRow(
                column(width = 12, 
                       box(title = tagList(icon("table"), "Database Informasi Dokter"), width = 12,
                           DTOutput("d_table_full"),
                           hr(), p(style="color: #636E72; font-style: italic; font-size: 13px;", "Daftar lengkap seluruh tenaga medis beserta rincian tarif dan lokasi.")
                       )
                )
              )
      ),
      
#------------------------------------------------------------- Menu Pasien ---------------------------------------------------------------------------------------------------------------------------------------------------

tabItem(tabName = "tab_pasien",
        fluidRow(
          column(width = 12,
                 div(class = "filter-panel",
                     fluidRow(
                       column(width = 4, 
                              h3(style = "font-weight: 800; color: white; margin-bottom: 5px;", "Pencarian"),
                              p(style = "color: rgba(255,255,255,0.9); font-size: 14px;", "Analisis karakteristik dan perilaku pasien.")
                       ),
                       column(width = 4, div(style="color:white;", selectInput("p_filter_wilayah", "Pilih Provinsi", choices = c("Semua Provinsi"), width = "100%"))),
                       column(width = 4, div(style="color:white;", selectInput("p_filter_tipe", "Pilih Klinik", choices = c("Semua Klinik"), width = "100%")))
                     )
                 )
          )
        ),
        
        # SECTION 1: PROFIL DEMOGRAFI & GIZI
        div(id = "sec_p_prof",
            div(class="section-header", h4("Profil & Karakteristik Pasien"), p("Analisis struktur umur, gender, dan kondisi fisik (BMI)."))),
        fluidRow(
          column(width = 6, 
                 box(title = tagList(icon("people-arrows"), "Piramida Penduduk Pasien"), width = 12,
                     plotlyOutput("p_pyramid_plot", height = "400px"),
                     hr(), p(style="color: #636E72; font-style: italic; font-size: 13px;", "Distribusi umur pasien berdasarkan gender (Laki-laki vs Perempuan).")
                 )
          ),
          column(width = 6,
                 box(
                   title = tagList(icon("weight-scale"), "Analisis Status Gizi (BMI)"),
                   width = 12,
                   
                   # Area Filter dengan background soft dan rapi
                   div(style = "padding: 20px; background: #F8FAFC; border-radius: 15px; border: 1px solid #E2E8F0; margin-bottom: 20px;",
                       fluidRow(
                         # Filter Gender
                         column(width = 6, 
                                shinyWidgets::pickerInput(
                                  inputId = "p_bmi_gender", 
                                  label = "Pilih Gender:", 
                                  choices = c("Laki-Laki", "Perempuan"), 
                                  selected = c("Laki-Laki", "Perempuan"),
                                  multiple = TRUE, 
                                  options = list(
                                    `selected-text-format` = "count > 1",
                                    `actions-box` = TRUE, # Menambah tombol Select All/Deselect All
                                    `none-selected-text` = "Kosong"
                                  ),
                                  width = "100%"
                                )
                         ),
                         
                         # Filter Rentang Umur (Sekarang Seragam dengan Gender)
                         column(width = 6,
                                shinyWidgets::pickerInput(
                                  inputId = "p_bmi_age", 
                                  label = "Pilih Rentang Umur:", 
                                  choices = c("0-9", "10-19", "20-29", "30-39", "40-49", "50-59", "60-69", "70+"), 
                                  selected = c("0-9", "10-19", "20-29", "30-39", "40-49", "50-59", "60-69", "70+"),
                                  multiple = TRUE, 
                                  options = list(
                                    `selected-text-format` = "count > 1",
                                    `actions-box` = TRUE,
                                    `none-selected-text` = "Pilih"
                                  ),
                                  width = "100%"
                                )
                         )
                       )
                   ),
                   
                   # Output Grafik
                   plotlyOutput("p_bmi_scatter", height = "350px"),
                   hr(),
                   p(style="color: #636E72; font-style: italic; font-size: 13px; text-align: center;", 
                     "Hubungan Tinggi vs Berat Badan untuk melihat distribusi status gizi pasien.")
                 )
          )
        ),
        
        # SECTION 2: TREN KUNJUNGAN & DIAGNOSIS
        div(id = "sec_p_diag",
            div(class="section-header", h4("Tren Keluhan & Waktu"), p("Analisis volume kunjungan berdasarkan diagnosis dari waktu ke waktu."))),
        fluidRow(
          column(width = 12, 
                 box(
                   title = tagList(icon("chart-line"), "Tren Diagnosis"), 
                   width = 12, 
                   
                   # Area Filter Dropdown Checklist yang Seragam dengan BMI
                   div(style = "margin-bottom: 20px; padding: 20px; background: #F8FAFC; border-radius: 15px; border: 1px solid #E2E8F0;",
                       fluidRow(
                         column(width = 12,
                                div(class = "filter-title", 
                                    style = "font-weight: 800; color: #009B9E; margin-bottom: 10px;", 
                                    icon("virus-covid"), " Pilih Penyakit untuk Ditampilkan:"),
                                
                                shinyWidgets::pickerInput(
                                  inputId = "p_filter_diagnosis", 
                                  label = NULL, 
                                  choices = c(
                                    "Bronkospasme", "Dehidrasi Ringan", "Dermatitis Alergi", 
                                    "Diare Akut", "Dispepsia", "Faringitis", "Gastritis", 
                                    "Gingivitis", "Hipertensi", "Influenza", "ISPA", 
                                    "Karies Gigi", "Kecurigaan Hiperglikemia", "Kehamilan", 
                                    "Keputihan", "Myalgia", "Nyeri Kepala", "Otitis Media", 
                                    "Rhinitis Alergi", "Tinea", "Tonsilitis"
                                  ),
                                  selected = c("Influenza", "ISPA", "Hipertensi"),
                                  multiple = TRUE, 
                                  width = "100%",
                                  options = list(
                                    `actions-box` = TRUE,     
                                    `live-search` = TRUE,     
                                    `selected-text-format` = "count > 3",
                                    `none-selected-text` = "Pilih penyakit...",
                                    `count-selected-text` = "{0} Penyakit Dipilih",
                                    `deselect-all-text` = "Hapus Semua",
                                    `select-all-text` = "Pilih Semua"
                                  )
                                )
                         )
                       )
                   ),
                   
                   # Area Chart
                   plotlyOutput("p_trend_line", height = "400px"), 
                   hr(), 
                   p(style="color: #636E72; font-style: italic; font-size: 13px; text-align: center;", 
                     "Grafik di atas membandingkan volume kunjungan harian berdasarkan diagnosis yang dipilih.")
                 )
          )
        ),
        
        # SECTION 3: KEUANGAN & TIPE PASIEN
        div(id = "sec_p_admin",
            div(class="section-header", h4("Analisis Administrasi"), p("Distribusi metode pembayaran dan kategori kepesertaan pasien."))),
        fluidRow(
          column(width = 5, 
                 box(title = tagList(icon("id-card"), "Tipe Pasien"), width = 12,
                     plotlyOutput("p_type_pie", height = "350px"),
                     hr(), p(style="color: #636E72; font-style: italic; font-size: 13px;", "Perbandingan proporsi pasien BPJS dengan Pasien Umum.")
                 )
          ),
          column(width = 7, 
                 box(title = tagList(icon("wallet"), "Metode Pembayaran"), width = 12,
                     plotlyOutput("p_pay_lollipop", height = "350px"),
                     hr(), p(style="color: #636E72; font-style: italic; font-size: 13px;", "Ranking metode pembayaran berdasarkan frekuensi penggunaan.")
                 )
          )
        ),
        
        # SECTION 4: DATABASE
        div(id = "sec_p_db",
            div(class="section-header", h4("Detail Informasi Pasien"), p("Database lengkap riwayat kunjungan dan data demografi."))),
        fluidRow(
          column(width = 12, 
                 box(title = tagList(icon("table"), "Direktori Pasien"), width = 12,
                     DTOutput("p_table_full"),
                     hr(), p(style="color: #636E72; font-style: italic; font-size: 13px;", "Informasi menyeluruh data pasien untuk kebutuhan operasional.")
                 )
          )
        )
),

#---------------------------------- Menu Obat-------------------------------------------------------------------------------------------------
tabItem(tabName = "tab_obat",
        fluidRow(
          column(width = 12,
                 div(class = "filter-panel",
                     fluidRow(
                       column(width = 4, 
                              h3(style = "font-weight: 800; color: white; margin-bottom: 5px;", "Pencarian"),
                              p(style = "color: rgba(255,255,255,0.9); font-size: 14px;", "Analisis distribusi, harga, dan pola peresepan obat.")
                       ),
                       column(width = 4, div(style = "color: white;", selectInput("o_filter_provinsi", "Pilih Provinsi", choices = c("Semua Provinsi"), width = "100%"))),
                       column(width = 4, div(style = "color: white;", selectInput("o_filter_klinik", "Pilih Klinik", choices = c("Semua Klinik"), width = "100%")))
                       )
                 )
          )
        ),
        
        # SECTION 1: RINGKASAN FARMASI
        div(id = "sec_m_sum",
            div(class="section-header", h4("Performa Penjualan & Harga"), p("Ringkasan volume obat dan kategori harga tertinggi."))),
        fluidRow(
          column(width = 4, span("Total Item Terjual", class="kpi-label-top"), 
                 div(class="kpi-box-small bg-v1", span(textOutput("m_val_terjual", inline = TRUE), class="kpi-val-output"))),
          column(width = 4, span("Rata-rata Jenis Obat / Resep", class="kpi-label-top"), 
                 div(class="kpi-box-small bg-v2", span(textOutput("m_val_avg_resep", inline = TRUE), class="kpi-val-output"))),
          column(width = 4, span("Kategori Termahal", class="kpi-label-top"), 
                 div(class="kpi-box-small bg-v4", span(textOutput("m_val_mahal", inline = TRUE), style="font-size:22px; font-weight:800;")))
        ), br(),
        
        # SECTION 2: POPULARITAS & DISTRIBUSI DOSIS
        div(id = "sec_m_cons",
            div(class="section-header", h4("Analisis Konsumsi & Dosis"), p("Tren obat paling laris dan pola pemakaian harian."))),
        fluidRow(
          column(width = 7, 
                 box(title = tagList(icon("pills"), "Top 10 Obat Paling Laris"), width = 12,
                     plotlyOutput("m_top_laris", height = "400px"),
                     hr(), p(style="color: #636E72; font-style: italic; font-size: 13px;", "Peringkat obat berdasarkan frekuensi muncul dalam resep.")
                 )
          ),
          column(width = 5, 
                 box(title = tagList(icon("clock-rotate-left"), "Distribusi Dosis per Hari"), width = 12,
                     plotlyOutput("m_dosis_hist", height = "400px"),
                     hr(), p(style="color: #636E72; font-style: italic; font-size: 13px;", "Frekuensi aturan dosis yang paling sering diberikan kepada pasien.")
                 )
          )
        ),
        
        # SECTION 3: KORELASI & JARINGAN OBAT
        div(id = "sec_m_corr",
            div(class="section-header", h4("Hubungan & Pola Peresepan"), p("Analisis korelasi harga dan keterkaitan antar jenis obat."))),
        fluidRow(
          column(width = 6, 
                 box(title = tagList(icon("hand-holding-dollar"), "Harga Satuan vs Durasi"), width = 12,
                     plotlyOutput("m_price_duration_scatter", height = "400px"),
                     hr(), p(style="color: #636E72; font-style: italic; font-size: 13px;", "Melihat hubungan antara mahalnya obat dengan lama waktu pengobatan.")
                 )
          ),
          column(width = 6, 
                 box(title = tagList(icon("hubspot"), "Analisis Obat Pendamping (Co-occurrence)"), width = 12,
                     plotlyOutput("m_network_graph", height = "400px"),
                     hr(), p(style="color: #636E72; font-style: italic; font-size: 13px;", "Grafik jaringan menunjukkan obat yang sering diresepkan secara bersamaan.")
                 )
          )
        ),
        
        # SECTION 4: DATABASE
        div(id = "sec_o_db",
            div(class="section-header", h4("Inventaris Farmasi"), p("Data lengkap transaksi dan detail obat."))),
        fluidRow(
          column(width = 12, box(title = "Log Transaksi Obat", width = 12, DTOutput("m_table_full"),
                                 hr(), p(style="color: #636E72; font-style: italic; font-size: 13px;", "Detail harga, dosis, dan durasi untuk setiap kunjungan.")))
        )
),

# ------------------------------------------ Menu Tim ---------------------------------------------------------------------------------------------------------------------------
tabItem(tabName = "tab_team",
        div(style = "text-align: center; 
                     padding: 30px 20px; 
                     background: linear-gradient(135deg, #009B9E 0%, #007A7C 100%); 
                     border-radius: 20px; 
                     margin-bottom: 25px; 
                     box-shadow: 0 10px 20px rgba(0,0,0,0.1);",
            h2("THE MINDS BEHIND DJIWA", 
               style="font-weight:900; color:white; letter-spacing: 2px; margin: 0; font-size: 24px;"),
            p("Dibalik layar pengembangan Dashboard Monitoring DJIWA", 
              style="color: rgba(255,255,255,0.9); font-size: 14px; margin-top: 5px;"),
            span("DJIWA (Dashboard Joy, Ika, Wita, dan Avin) MEDICAL", 
                 style="color: rgba(255,255,255,0.7); font-size: 12px; font-weight: 300;"),
            hr(style="width: 40px; border-top: 3px solid white; margin: 15px auto; opacity: 0.6;")
        ),
        fluidRow(
          column(width = 6,
                 div(style = "background: linear-gradient(135deg, #f0fff4 0%, #d1fae5 100%); 
                      border-radius: 30px; padding: 30px; margin-bottom: 30px; 
                      display: flex; align-items: center; min-height: 280px;
                      border-left: 12px solid #00b894; 
                      box-shadow: 0 15px 35px rgba(0,0,0,0.08);",
                     div(style = "flex: 1.2; text-align: center;", uiOutput("t_photo_db")),
                     div(style = "flex: 2.5; padding-left: 25px;",
                         span("STRUCTURE & FLOW", style="color:#059669; font-weight:800; font-size:12px; letter-spacing:2px;"),
                         h2("Joice Junansi Tandirerung", style="font-weight: 800; margin: 8px 0; color:#064e3b; font-size: 26px;"),
                         h4("Database Manager", style="color:#047857; font-weight:700; margin-bottom: 12px;"),
                         p("Mendesain ERD, skema tabel, dan mengoptimalkan query SQL untuk memastikan performa data tetap cepat dan akurat.", style="font-size:14.5px; color:#065f46; line-height: 1.5;")
                     )
                 )
          ),
          
          column(width = 6,
                 div(style = "background: linear-gradient(135deg, #eff6ff 0%, #dbeafe 100%); 
                      border-radius: 30px; padding: 30px; margin-bottom: 30px; 
                      display: flex; align-items: center; min-height: 280px;
                      border-left: 12px solid #3b82f6; 
                      box-shadow: 0 15px 35px rgba(0,0,0,0.08);",
                     div(style = "flex: 1.2; text-align: center;", uiOutput("t_photo_analyst")),
                     div(style = "flex: 2.5; padding-left: 25px;",
                         span("INSIGHT & TRENDS", style="color:#2563eb; font-weight:800; font-size:12px; letter-spacing:2px;"),
                         h2("Ika Lailia Nur Rohmatun Nazila", style="font-weight: 800; margin: 8px 0; color:#1e3a8a; font-size: 26px;"),
                         h4("Data Analyst", style="color:#1d4ed8; font-weight:700; margin-bottom: 12px;"),
                         p("Menentukan KPI strategis, memvalidasi integritas data, dan menyusun interpretasi wawasan bisnis bagi pemangku kepentingan.", style="font-size:14.5px; color:#1e40af; line-height: 1.5;")
                     )
                 )
          )
        ),
        
        fluidRow(
          column(width = 6,
                 div(style = "background: linear-gradient(135deg, #f5f3ff 0%, #ede9fe 100%); 
                      border-radius: 30px; padding: 30px; margin-bottom: 30px; 
                      display: flex; align-items: center; min-height: 280px;
                      border-left: 12px solid #8b5cf6; 
                      box-shadow: 0 15px 35px rgba(0,0,0,0.08);",
                     div(style = "flex: 1.2; text-align: center;", uiOutput("t_photo_front")),
                     div(style = "flex: 2.5; padding-left: 25px;",
                         span("USER EXPERIENCE", style="color:#7c3aed; font-weight:800; font-size:12px; letter-spacing:2px;"),
                         h2("Baiq Wita Rachmatia", style="font-weight: 800; margin: 8px 0; color:#4c1d95; font-size: 26px;"),
                         h4("Frontend Developer", style="color:#6d28d9; font-weight:700; margin-bottom: 12px;"),
                         p("Merancang arsitektur UI yang responsif, estetika visual dashboard, dan menjamin integrasi output yang intuitif bagi pengguna.", style="font-size:14.5px; color:#5b21b6; line-height: 1.5;")
                     )
                 )
          ),
          column(width = 6,
                 div(style = "background: linear-gradient(135deg, #fff1f2 0%, #ffe4e6 100%); 
                      border-radius: 30px; padding: 30px; margin-bottom: 30px; 
                      display: flex; align-items: center; min-height: 280px;
                      border-left: 12px solid #f43f5e; 
                      box-shadow: 0 15px 35px rgba(0,0,0,0.08);",
                     div(style = "flex: 1.2; text-align: center;", uiOutput("t_photo_back")),
                     div(style = "flex: 2.5; padding-left: 25px;",
                         span("LOGIC & SERVERS", style="color:#e11d48; font-weight:800; font-size:12px; letter-spacing:2px;"),
                         h2("Avin Rahmadian", style="font-weight: 800; margin: 8px 0; color:#881337; font-size: 26px;"),
                         h4("Backend Developer", style="color:#be123c; font-weight:700; margin-bottom: 12px;"),
                         p("Mengelola reaktivitas sistem Shiny, arsitektur logika server, serta optimasi fungsi pengolahan data yang kompleks.", style="font-size:14.5px; color:#9f1239; line-height: 1.5;")
                     )
                 )
          )
        )
)

    )
  )
)
