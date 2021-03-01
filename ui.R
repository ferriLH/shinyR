ui <- shinyUI({dashboardPage(
  dashboardHeader(color = "blue", title = "Dashboard", inverted = TRUE, menu_button_label=""),
  dashboardSidebar(
    size = "thin", color = "blue",
    sidebarMenu(
      menuItem(tabName = "main", "Main", icon = icon("dashboard")),
      menuItem("Rank", icon = icon("caret down"),
               menuSubItem(tabName = "active", "Akun Paling Aktif", icon = icon("keyboard")),
               menuSubItem(tabName = "mention", "Akun Paling Banyak di-mention", icon = icon("at")),
               menuSubItem(tabName = "hashtag", "Hashtag Paling banyak digunakan", icon = icon("hashtag"))
      ),
      menuItem(tabName = "sentimen", "Text Sentiment", icon = icon("braille"))
    )
  ),
  dashboardBody(
    tabItems(
      selected = 1,
      tabItem(
        tabName = "main",
        fluidRow(
          column(
            width = 4,
            infoBoxOutput("maxTraff")            ),
          column(
            width = 4,
            infoBoxOutput("minTraff")
          ),
          column(
            width = 4,
            infoBoxOutput("meanTraff")
          ),
          column(
            width = 4,
            infoBoxOutput("sumTraff")
          )
        ),
        fluidRow(
          box(width = 16,
              title = "Time Series",
              color = "blue", ribbon = TRUE, title_side = "top right",
              column(width = 16,
                     plotlyOutput("ts")
              )
          )
        )
      ),
      tabItem(
        tabName = "active",
        fluidRow(
          box(
            width = 16,
            title = "Ranking akun paling aktif men-tweet terkait covid-19",
            color = "blue", ribbon = TRUE, title_side = "top right",collapsible = TRUE,
            column(width = 16,
                   tags$div(
                     HTML("Lima akun teratas yang aktif men-<i>tweet</i> tentang Covid-19 adalah 
                         <b style='color:'#de2d26;'>akun kepolisian</b>"
                     )),
                   plotlyOutput("mostActive")
            )
          )
        )
      ),
      tabItem(
        tabName = "mention",
        fluidRow(
          box(
            width = 16,
            title = "Ranking akun paling banyak di-mention",
            color = "blue", ribbon = TRUE, title_side = "top right",collapsible = TRUE,
            column(width = 8,
                   tags$div(
                     HTML("Akun yang paling banyak di-<i>mention</i> 
                         <b style='color:'#de2d26;'>di dominasi oleh akun yang
                         terkait dengan Pemerintahan</b>"
                     )),
                   plotlyOutput("mostMentioned")
            )
          )
        )
      ),
      tabItem(
        tabName = "hashtag",
        fluidRow(
          box(
            width = 16,
            title = "peringkat tagar yang paling banyak digunakan di tweet tentang covid-19",
            color = "blue", ribbon = TRUE, title_side = "top right",collapsible = TRUE,
            column(width = 8,
                   tags$div(
                     HTML("Tiga peringkat teratas penggunaan hashtag adalah
                         <b style='color:'#de2d26;'>covid19 hashtag</b>
                         dengan huruf besar dan kecil yang berbeda"
                     )),
                   plotlyOutput("usedHashtag")
            )
          )
        )
      ),
      tabItem(
        tabName = "sentimen",
        fluidRow(
          column(width = 8,
                 plotlyOutput("sentimentBar")
          ),
          column(width = 8,
                 plotlyOutput("sentimentPie")
          )
        ),
        box(width = 8,
            title = "Data Sentimen Positif",
            color = "blue", ribbon = TRUE, title_side = "top right",
            column(width = 16,
                   h1('Data sentimen tweet positif'),
                   DT::dataTableOutput("dataTablePos"),style = "height:100%;overflow-x: scroll;"
            )
        ),
        box(width = 8,
            title = "Data Sintemen Netral",
            color = "blue", ribbon = TRUE, title_side = "top right",
            column(width = 8,
                   h1('Data sentimen tweet netral'),
                   DT::dataTableOutput("dataTableNet"),style = "height:100%;overflow-x: scroll;"
            )
        ),
        box(width = 8,
            title = "Data Sentimen Negatif",
            color = "blue", ribbon = TRUE, title_side = "top right",
            column(width = 8,
                   h1('Data sentimen tweet negatif'),
                   DT::dataTableOutput("dataTableNeg"),style = "height:100%;overflow-x: scroll;"
            )
        )
      )
    )
  ),
  theme = "cerulean",
  suppress_bootstrap = TRUE,
  margin = FALSE
)
})
