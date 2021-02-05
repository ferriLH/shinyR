#library(shinydashboard)
library(shiny)
library(shiny.semantic)
library(semantic.dashboard)
library(plyr)
library(ggplot2)
library(plotly)
library(DT)
library(rtweet)
library(dplyr)
library(tidyverse) 
library(tidytext)
library(mongolite)


source('ui.R', local = TRUE)
source('server.R', local = TRUE)
# LOCAL
shinyApp(
    ui = ui,
    server = server
)

# CLOUD
# port <- Sys.getenv('PORT')
# shiny::runApp(
#   appDir = getwd(),
#   host = '0.0.0.0',
#   port = as.numeric(port)
# )