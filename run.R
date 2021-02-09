library(shiny)
library(shiny.semantic)
library(semantic.dashboard)
library(dplyr)
library(tidyverse) 
library(tidytext)
library(ggplot2)
library(plotly)
library(DT)
library(rtweet)
library(mongolite)

source('connection.R', local = TRUE)
source('ui.R', local = TRUE)
source('server.R', local = TRUE)

# LOCAL
shinyApp(
    ui = ui,
    server = server
)
