library(shiny)
library(tidyverse)
library(DT)
women <- read.csv("data/expected_medals/f_total_probabilities.csv")
men <- read.csv("data/expected_medals/m_total_probabilities.csv")
# Define server logic required to draw a histogram ----
server <- function(input, output) {
  
  output$individuals <- renderDT(
    women
  )
  
}

