library(tidyverse)
library(DT)

w_topcand <- read.csv("data/expected_medals/f_total_probabilities.csv")
m_topcand <- read.csv("data/expected_medals/m_total_probabilities.csv")
m_byevent <- read.csv("data/expected_medals/usa_mens_avs.csv")
w_byevent <- read.csv("data/expected_medals/usa_womens_avs.csv")
# Define server logic for slider examples ----
server <- function(input, output) {
  
  #Reactive to Men's or Women's on Top Candidates Page
  tc_data <- reactive({
    if (input$var == "Women") {
      w_topcand
    } else {
      m_topcand
    }
  })
  
  #Top Candidates Data Table
  output$individuals <- renderDT({
    tc_data()   
  }
  )
  
  #Reactive to Mens/Womens on by Event Page
  
  events_data <- reactive({
    if (input$var == "Women") {
      w_byevent
    } else {
      m_byevent
    }
  })
  
  #Event Table
  output$byevent <-renderDT({
    events_data() %>% filter(Event == input$eventc) %>% arrange(desc(AverageScore))
  })
  
  #selector for events on by Event Page
  output$events_choices <- renderUI({
    selectInput("eventc", label = "Event", choices = unique(as.character(events_data()$Event)))
  })
  
}

