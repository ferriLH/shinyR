
server <- shinyServer(function(input, output, session) {
  
  ## TIME SERIES
  data_ts <- ts_data(df_tweets, "days", 0L, "UTC")
  
  output$maxTraff <- renderInfoBox({
    infoBox(
      "traffic tertinggi", max(data_ts$n), icon = icon(""),
      color = "green"
    )
  })
  output$minTraff <- renderInfoBox({
    infoBox(
      "traffic terendah", min(data_ts$n), icon = icon(""),
      color = "red"
    )
  })
  output$meanTraff <- renderInfoBox({
    infoBox(
      "Rata-rata traffic", format(round(mean(data_ts$n), 2), nsmall = 2), icon = icon(""),
      color = "blue"
    )
  })
  output$sumTraff <- renderInfoBox({
    infoBox(
      "Total tweet", sum(data_ts$n), icon = icon(""),
      color = "blue"
    )
  })
  
  output$ts <- renderPlotly({
    progress <- Progress$new(session, min=0, max=15)
    on.exit(progress$close())
    
    progress$set(message = 'Pengambilan Data dan Penghitungan sedang berlangsung',
                 detail = 'Ini mungkin memakan waktu cukup lama...')
    
    for (i in 1:15) {
      progress$set(value = i)
      Sys.sleep(0.5)
    }
    plot_ly(
      x = ~data_ts$time, y = ~data_ts$n, type = 'scatter', mode = 'lines', fill = 'tozeroy'
    )%>% layout(xaxis = list(title = ''),
                yaxis = list(title = ''))
    
  })
  
  ## Most Active
  output$mostActive <- renderPlotly({
    progress <- Progress$new(session, min=0, max=15)
    on.exit(progress$close())
    
    progress$set(message = 'Penghitungan akun paling aktif sedang berlangsung',
                 detail = 'Ini mungkin memakan waktu cukup lama...')
    
    for (i in 1:15) {
      progress$set(value = i)
      Sys.sleep(0.5)
    }
    active <- df_tweets %>%
      count(screen_name, sort = TRUE) %>%
      top_n(10) %>%
      mutate(screen_name = paste0("@", screen_name))
    plot_ly(x = c(active$n [order(active$n)]),
            y = c(active$screen_name [order(active$n)]),
            type = 'bar',
            orientation = 'h',
            marker = list(color = c('rgba(58, 71, 80, 0.6)','rgba(58, 71, 80, 0.6)',
                                    'rgba(58, 71, 80, 0.6)','rgba(58, 71, 80, 0.6)',
                                    'rgba(58, 71, 80, 0.6)','rgba(222, 45, 38,0.6)',
                                    'rgba(222, 45, 38,0.6)','rgba(222, 45, 38,0.6)',
                                    'rgba(222, 45, 38,0.6)','rgba(222, 45, 38,0.6)'),
                          line = list(color = c('rgba(58, 71, 80, 1.0)','rgba(58, 71, 80, 1.0)',
                                                'rgba(58, 71, 80, 1.0)','rgba(58, 71, 80, 1.0)',
                                                'rgba(58, 71, 80, 1.0)','rgba(222, 45, 38,1.0)',
                                                'rgba(222, 45, 38,1.0)','rgba(222, 45, 38,1.0)',
                                                'rgba(222, 45, 38,1.0)','rgba(222, 45, 38,1.0)'),
                                      width = 3))
    )%>%
      layout(
        
        yaxis = list(
          type = "category",
          categoryorder = "array",
          categoryarray = active$n [order(active$n)])
      )
  })
  
  ## Most mentioned
  output$mostMentioned <- renderPlotly({
    progress <- Progress$new(session, min=0, max=15)
    on.exit(progress$close())
    
    progress$set(message = 'Penghitungan akun paling banyak di-mention sedang berlangsung',
                 detail = 'Ini mungkin memakan waktu cukup lama...')
    
    for (i in 1:15) {
      progress$set(value = i)
      Sys.sleep(0.5)
    }
    mentioned <- df_tweets %>%
      unnest_tokens(mentions, text, "tweets", to_lower = FALSE) %>%
      filter(str_detect(mentions, "^@")) %>%
      count(mentions, sort = TRUE) %>%
      top_n(10)
    plot_ly(x = c(mentioned$n [order(mentioned$n)]),
            y = c(mentioned$mentions [order(mentioned$n)]),
            type = 'bar', orientation = 'h',
            marker = list(color = c('rgba(58, 71, 80, 0.6)','rgba(58, 71, 80, 0.6)',
                                    'rgba(222, 45, 38,0.6)','rgba(222, 45, 38,0.6)',
                                    'rgba(222, 45, 38,0.6)','rgba(222, 45, 38,0.6)',
                                    'rgba(222, 45, 38,0.6)','rgba(222, 45, 38,0.6)',
                                    'rgba(222, 45, 38,0.6)','rgba(58, 71, 80, 0.6)'),
                          line = list(color = c('rgba(58, 71, 80, 1.0)','rgba(58, 71, 80, 1.0)',
                                                'rgba(222, 45, 38,1.0)','rgba(222, 45, 38,1.0)',
                                                'rgba(222, 45, 38,1.0)','rgba(222, 45, 38,1.0)',
                                                'rgba(222, 45, 38,1.0)','rgba(222, 45, 38,1.0)',
                                                'rgba(222, 45, 38,1.0)','rgba(58, 71, 80, 1.0)'),
                                      width = 3))
    )%>%
      layout(
        yaxis = list(
          type = "category",
          categoryorder = "array",
          categoryarray = mentioned$n [order(mentioned$n)])
      )
  })
  
  ## Most used hashtag
  output$usedHashtag <- renderPlotly({
    progress <- Progress$new(session, min=0, max=15)
    on.exit(progress$close())
    
    progress$set(message = 'Penghitungan hastag paling banyak digunakan sedang berlangsung',
                 detail = 'Ini mungkin memakan waktu cukup lama...')
    
    for (i in 1:15) {
      progress$set(value = i)
      Sys.sleep(0.5)
    }
    hashtag <- df_tweets %>%
      unnest_tokens(hashtag, text, "tweets", to_lower = FALSE) %>%
      filter(str_detect(hashtag, "^#")) %>%
      count(hashtag, sort = TRUE) %>%
      top_n(10)
    plot_ly(x = c(hashtag$n [order(hashtag$n)]),
            y = c(hashtag$hashtag [order(hashtag$n)]),
            type = 'bar',
            orientation = 'h',
            marker = list(color = c('rgba(58, 71, 80, 0.6)','rgba(58, 71, 80, 0.6)',
                                    'rgba(58, 71, 80, 0.6)','rgba(58, 71, 80, 0.6)',
                                    'rgba(58, 71, 80, 0.6)','rgba(58, 71, 80, 0.6)',
                                    'rgba(58, 71, 80, 0.6)','rgba(222, 45, 38,0.6)',
                                    'rgba(222, 45, 38,0.6)','rgba(222, 45, 38,0.6)'),
                          line = list(color = c('rgba(58, 71, 80, 1.0)','rgba(58, 71, 80, 1.0)',
                                                'rgba(58, 71, 80, 1.0)','rgba(58, 71, 80, 1.0)',
                                                'rgba(58, 71, 80, 1.0)','rgba(58, 71, 80, 1.0)',
                                                'rgba(58, 71, 80, 1.0)','rgba(222, 45, 38,1.0)',
                                                'rgba(222, 45, 38,1.0)','rgba(222, 45, 38,1.0)'),
                                      width = 3))
    )%>%
      layout(
        yaxis = list(
          type = "category",
          categoryorder = "array",
          categoryarray = hashtag$n [order(hashtag$n)])
      )
  })
  
  # SENTIMENT
  hitung <- count(df_tweetsCleaned,df_tweetsCleaned$score)
  npos <- sum(hitung$n[hitung$`df_tweetsCleaned$score` > 0]) 
  nneg <- sum(hitung$n[hitung$`df_tweetsCleaned$score` < 0]) 
  nnet <- hitung$n[hitung$`df_tweetsCleaned$score` == 0]
  senti = data.frame(sentimen = c("positive","negative","neutral"), jumlah = c(npos,nneg,nnet))
  
  output$sentimentBar <-renderPlotly({
    plot_ly(x = c(hitung$`df_tweetsCleaned$score`),
            y = c(hitung$n),
            type = 'bar',
            marker = list(color = 'rgba(158,202,225,1.0)',
                          line = list(color = 'rgba(8,48,107,1.0)',
                                      width = 2))
    )%>%
      layout(
        title = "Score Point",
        xaxis = list(title = ""),
        yaxis = list(title = "")
      )
  })
  
  output$sentimentPie <-renderPlotly({
    colors <- c('rgb(114,147,203)','rgb(211,94,96)', 'rgb(128,133,133)')
    plot_ly(senti, labels = ~sentimen, values = ~jumlah, type = 'pie',
            textposition = 'inside',
            textinfo = 'label+percent',
            insidetextfont = list(color = '#FFFFFF'),
            hoverinfo = 'text',
            text = ~paste('jumlah score =', jumlah),
            marker = list(colors = colors,
                          line = list(color = '#FFFFFF', width = 1)),
            showlegend = FALSE
    )%>% 
      layout(
        title = 'Persentase Sentimen',
        xaxis = list(showgrid = FALSE, zeroline = FALSE, showticklabels = FALSE),
        yaxis = list(showgrid = FALSE, zeroline = FALSE, showticklabels = FALSE))
  })
  
  output$dataTablePos <- DT::renderDataTable(DT::datatable({
    positive <- filter(df_combine, skor > 0)
    data <- positive %>% 
      mutate(url = paste0("<a href='", positive$url,"' target='_blank'>", positive$url,"</a>"))
    data
  },
  escape = FALSE))
  
  output$dataTableNet <- DT::renderDataTable(DT::datatable({
    neutral <- filter(df_combine, skor == 0)
    data <- neutral %>% 
      mutate(url = paste0("<a href='", neutral$url,"' target='_blank'>", neutral$url,"</a>"))
    data
  },
  escape = FALSE))
  
  output$dataTableNeg <- DT::renderDataTable(DT::datatable({
    negative <- filter(df_combine, skor < 0)
    data <- negative %>% 
      mutate(url = paste0("<a href='", negative$url,"' target='_blank'>", negative$url,"</a>"))
    data
  },
  escape = FALSE))
  
})