myUI <- shinyUI({dashboardPage(
    dashboardHeader(color = "blue", title = "Dashboard", inverted = TRUE),
    # dashboardHeader(color = "blue"),
    dashboardSidebar(
      size = "thin", color = "blue",
      sidebarMenu(
        menuItem(tabName = "main", "Main", icon = icon("dashboard")),
        menuItem(tabName = "rank", "Rank", icon = icon("chart line")),
        menuItem(tabName = "sentimen", "Text Sentiment", icon = icon("braille"))
        # menuItem(tabName = "data", "Data", icon = icon("table"))
      )
    ),
    dashboardBody(
      tabItems(
        selected = 1,
        tabItem(
          tabName = "main",
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
          tabName = "rank",
          fluidRow(
            # box(width = 8,
            #     title = "Top 10 Location",
            #     color = "blue", ribbon = TRUE, title_side = "top right",
            #     column(width = 8,
            #            # plotlyOutput("place")
            #     )
            # ),
            box(width = 8,
                title = "Ranking akun paling aktif men-tweet terkait covid-19",
                color = "blue", ribbon = TRUE, title_side = "top right",
                column(width = 8,
                       tags$div(
                         HTML("Empat akun teratas yang aktif men-<i>tweet</i> tentang Covid-19 adalah 
                         <b style='color:'#de2d26;'>akun kepolisian</b>"
                       )),
                       plotlyOutput("mostActive")
                )
            )
          ),
          fluidRow(
            box(width = 8,
                title = "Ranking akun paling banyak di-mention",
                color = "blue", ribbon = TRUE, title_side = "top right",
                column(width = 8,
                       tags$div(
                         HTML("akun yang paling banyak di-<i>mention</i> 
                         <b style='color:'#de2d26;'>di dominasi oleh akun yang
                         terkait dengan Pemerintahan</b>"
                       )),
                       plotlyOutput("mostMentioned")
                )
            ),
            box(width = 8,
                title = "peringkat tagar yang paling banyak digunakan di tweet tentang covid-19",
                color = "blue", ribbon = TRUE, title_side = "top right",
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
          box(width = 16,
              title = "Data",
              color = "blue", ribbon = TRUE, title_side = "top right",
              column(width = 16,
                     h1('Cleaned data tweet'),
                     DT::dataTableOutput("dataTable"),style = "height:100%;overflow-x: scroll;"
                     )
              )
          )
        # tabItem(
          # tabName = "data",
          # fluidRow(
            # h1('A Table Using Server-side Processing'),
            #div(style = 'overflow-x: scroll',DT::dataTableOutput("dataTable",height = "500px"))
            # DT::dataTableOutput("dataTable"),style = "height:100%;overflow-x: scroll;"
          # )
        # )
      )
    ), theme = "cerulean"
  )
})
