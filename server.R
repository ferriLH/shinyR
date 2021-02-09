
server <- shinyServer(function(input, output, session) {

  ## Time Series
  output$ts <- renderPlotly({
    progress <- Progress$new(session, min=0, max=15)
    on.exit(progress$close())
    
    progress$set(message = 'Penghitungan sedang berlangsung',
                 detail = 'Ini mungkin memakan waktu cukup lama...')
    
    for (i in 1:15) {
      progress$set(value = i)
      Sys.sleep(0.5)
    }
    ts_plot(df_tweets, "days", trim = 0L, tz ="UTC") +
      ggplot2::theme_minimal() +
      ggplot2::theme(plot.title = ggplot2::element_text(face = "bold")) +
      ggplot2::labs(
        x = NULL, y = NULL,
        title = "Frekuensi tweet tentang covid-19",
        subtitle =paste0(strftime(min(df_tweets$created_at), "%d %B %Y"), " to ", strftime(max(df_tweets$created_at),"%d %B %Y")),
        caption = "\nSource: Data dikumpulkan dari REST API Twitter melalui rtweet"
      )
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
                                    'rgba(58, 71, 80, 0.6)','rgba(58, 71, 80, 0.6)',
                                    'rgba(222, 45, 38,0.6)','rgba(222, 45, 38,0.6)',
                                    'rgba(222, 45, 38,0.6)','rgba(222, 45, 38,0.6)'),
                          line = list(color = c('rgba(58, 71, 80, 1.0)','rgba(58, 71, 80, 1.0)',
                                                'rgba(58, 71, 80, 1.0)','rgba(58, 71, 80, 1.0)',
                                                'rgba(58, 71, 80, 1.0)','rgba(58, 71, 80, 1.0)',
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
  
  output$dataTable <- renderDataTable(df_tweetsCleaned, class = 'cell-border stripe')
  
})