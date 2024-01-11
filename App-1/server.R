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
  ## Reactive to Mens/Womens on Team Builder Page
  events_data2 <- reactive({
    if (input$genderTeamBuilder == "Women") {
      w_byevent
    } else {
      m_byevent
    }
  })
  
  #Event Table
  output$byevent <-renderDT({
    events_data() %>% filter(Event == input$eventc) %>% arrange(desc(AverageScore))
  })
  
  #selector for events on By Event Page in Gymnasts Tab
  output$events_choices <- renderUI({
    selectInput("eventc", label = "Event", choices = unique(as.character(events_data()$Event)))
  })
  
  #selectors for events on By Event Page in Gymnasts Tab
  output$event_choices_tb1 <- renderUI({
    selectInput("event_g1", label = "Team Events: Gymnast 1", choices = unique(as.character(events_data2()$Event)), multiple = TRUE)
  })
  output$event_choices_tb2 <- renderUI({
    selectInput("event_g2", label = "Team Events: Gymnast 2", choices = unique(as.character(events_data2()$Event)), multiple = TRUE)
  })
  output$event_choices_tb3 <- renderUI({
    selectInput("event_g3", label = "Team Events: Gymnast 3", choices = unique(as.character(events_data2()$Event)), multiple = TRUE)
  })
  output$event_choices_tb4 <- renderUI({
    selectInput("event_g4", label = "Team Events: Gymnast 4", choices = unique(as.character(events_data2()$Event)), multiple = TRUE)
  })
  output$event_choices_tb5 <- renderUI({
    selectInput("event_g5", label = "Team Events: Gymnast 5", choices = unique(as.character(events_data2()$Event)), multiple = TRUE)
  })
  
  observeEvent(input$show_choices, {
    # Create a list to store selected choices
    selected_choices <- list()
    
    # Retrieve and store selected gymnasts
    selected_choices$gymnasts <- c(
      input$g1input, input$g2input, input$g3input, input$g4input, input$g5input
    )
    
    # Retrieve and store selected events for each gymnast
    selected_choices$events <- lapply(1:5, function(i) {
      dropdown_id <- paste0("event_g", i)
      input[[dropdown_id]]
    })
    
    # Display selected choices
    output$selected_choices_output <- renderText({
      paste("Selected Gymnasts: ", paste(selected_choices$gymnasts, collapse = ", "), "\n",
            "Selected Events:")
      for (i in 1:5) {
        dropdown_id <- paste0("event_g", i)
        events_text <- paste(input[[dropdown_id]], collapse = ", ")
        cat(paste("  Gymnast", i, ":", events_text, "\n"))
      }
    })
  })
  
  
  
}






