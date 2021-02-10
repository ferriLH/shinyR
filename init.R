my_packages = c(
  "shiny",
  "shiny.semantic",
  "semantic.dashboard",
  "ggplot2",
  "plotly",
  "DT",
  "rtweet",
  "dplyr",
  "tidyverse",
  "tidytext",
  "mongolite"
  )
install_if_missing = function(p){
  if (p %in% rownames(installed.packages())== FALSE){
    install.packages(p)    
  }
}

invisible(sapply(my_packages, install_if_missing))
