library(shiny)
library(tidyverse)
library(DT)
women <- read.csv("data/expected_medals/f_total_probabilities.csv")
men <- read.csv("data/expected_medals/m_total_probabilities.csv")
# Define server logic required to draw a histogram ----
server <- function(input, output) {
  
  selected_data <- reactive({
    print(input$var)  # Debugging line
    if (input$var == "Men") {
      return(men)
    } else {
      return(women)
    }
  })
  
  output$individuals <- renderDT(
    selected_data()   
  )
  
}

