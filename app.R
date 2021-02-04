#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

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


source('myUI.R', local = TRUE)
source('myServer.R', local = TRUE)

shinyApp(
    ui = myUI,
    server = myServer
)

# port <- Sys.getenv('PORT')
# shiny::runApp(
#   appDir = getwd(),
#   host = '0.0.0.0',
#   port = as.numeric(port),
#   ui = myUI,
#   server = myServer
# )