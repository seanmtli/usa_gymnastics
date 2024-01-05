library(tidyverse)
library(DT)

women <- read.csv("data/expected_medals/f_total_probabilities.csv")
men <- read.csv("data/expected_medals/m_total_probabilities.csv")
# Define UI for app that draws a histogram ----
ui <- fluidPage(
  
  # App title ----
  titlePanel("USA Gymnastics Web App"),
  
  # Sidebar layout with input and output definitions ----
  sidebarLayout(
    
    # Sidebar panel for inputs ----
    sidebarPanel(
      helpText("Help text caption"),
      
      # Input: Slider for the number of bins ----
      selectInput("var", 
                  label = "Gender",
                  choices = list("Women", 
                                 "Men"),
                  selected = "Women"),
    ),
    # Main panel for displaying outputs ----
    mainPanel(
      tabsetPanel(
        id = 'dataset',
        tabPanel("Top Candidates", DTOutput("individuals"))
        #tabPanel("Team Builder", DT::dataTableOutput("team"))
      )
    )
  )
)
