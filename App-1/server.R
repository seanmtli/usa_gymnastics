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
  
  #selectors for events in Team Builder Tab
  output$event_choices_tb1 <- renderUI({
    selectInput("event_g1", label = "Events: Gymnast 1", choices = unique(as.character(events_data2()$Event)), multiple = TRUE)
  })
  output$event_choices_tb2 <- renderUI({
    selectInput("event_g2", label = "Events: Gymnast 2", choices = unique(as.character(events_data2()$Event)), multiple = TRUE)
  })
  output$event_choices_tb3 <- renderUI({
    selectInput("event_g3", label = "Events: Gymnast 3", choices = unique(as.character(events_data2()$Event)), multiple = TRUE)
  })
  output$event_choices_tb4 <- renderUI({
    selectInput("event_g4", label = "Events: Gymnast 4", choices = unique(as.character(events_data2()$Event)), multiple = TRUE)
  })
  output$event_choices_tb5 <- renderUI({
    selectInput("event_g5", label = "Events: Gymnast 5", choices = unique(as.character(events_data2()$Event)), multiple = TRUE)
  })
  
  name_errors <- function(n1, n2, n3, n4, n5, gender) {
 
    if (gender == "Men") {
      dt <- m_byevent
    }
    else{
      dt <- w_byevent
    }
    
    # Condition 1: Any of the names are blank or empty strings
    if (any(sapply(list(n1, n2, n3, n4, n5), function(name) trimws(name) == ""))) {
      return("Please enter a full team")
    }
    
    # Condition 2: Any of the names are not found in the dataset
    all_names <- c(n1, n2, n3, n4, n5)
    if (any(!all_names %in% dt$FullName)) {
      return("Gymnast not found, please ensure all names are spelled correctly")
    }
    
    # If none of the conditions are met, return TRUE
    return(NULL)
  }
  
  
  names <- reactive({
    validate(
      name_errors(input$g1input, input$g2input, input$g3input, input$g4input, input$g5input,input$genderTeamBuilder)
    )
    c(input$g1input, input$g2input, input$g3input, input$g4input, input$g5input)
  })
  
  observeEvent(input$show_choices, {
    # Create a list to store selected choices
    selected_choices <- list()
    
    # Retrieve and store selected gymnasts
    selected_choices$gymnasts <- names()
    
    # Retrieve and store selected events for each gymnast
    selected_choices$events <- lapply(1:5, function(i) {
      dropdown_id <- paste0("event_g", i)
      input[[dropdown_id]]
    })
    
    # Call calculating medal contribution function for each selected event and gymnast
    total_medal_contributions <- list()
    
    for (i in 1:5) {
      gymnast_name <- selected_choices$gymnasts[i]
      total_medal_contribution <- 0
      
      for (event_name in selected_choices$events[[i]]) {
        # Call your custom function with gymnast name and event name
        medal_contribution <- calcMC(gymnast_name, event_name, input$genderTeamBuilder)
        #if (medal_contribution == -1) {
          
        #}
        total_medal_contribution <- total_medal_contribution + medal_contribution
      }
  
      
      total_medal_contributions[[gymnast_name]] <- total_medal_contribution
    }
    # Display total expected medal contributions
    # output$selected_choices_output <- renderText({
    #   result_text <- paste("Total Expected Medal Contributions:")
    #   for (i in 1:5) {
    #     gymnast_name <- selected_choices$gymnasts[i]
    #     result_text <- paste(result_text, "\n", gymnast_name, ":", total_medal_contributions[[gymnast_name]])
    #   }
    #   result_text
    # })
    
    output$selected_choices_output <- renderDataTable({
      names()
      # Create a data frame with gymnast names and total expected medal contributions
      result_df <- data.frame(
        Gymnast = selected_choices$gymnasts,
        Total_Medal_Contribution = sapply(selected_choices$gymnasts, function(gymnast_name) {
          total_medal_contributions[[gymnast_name]]
        })
      )
      
      # Calculate and add the overall total across all team members
      overall_total <- sum(result_df$Total_Medal_Contribution)
      result_data <- rbind(result_df, c("Overall Total", overall_total))
      
      # Rename the columns
      colnames(result_data) <- c("Gymnast", "Total Medal Contribution")
      
      # Display the data table
      return(datatable(result_data, options = list(dom = 't'), rownames = FALSE))
    })
    
    
    
  })
  
  calcMC <- function(gymnast_name, event_name, gender) {
    # Filter the dataset for the specified gymnast
    if (gender == "Men") {
      dt <- m_byevent
    }
    else{
      dt <- w_byevent
    }
    
    gymnast_data <- dt[dt$FullName == gymnast_name,]
    
    # Check if the gymnast name is found
    #if (nrow(gymnast_data) == 0) {
    #  return(-1)
      #stop(paste("Error: Gymnast", gymnast_name, "not found in the dataset."))
    #}
    
    # Filter the gymnast's data for the specified event
    event_data <- gymnast_data[gymnast_data$Event == event_name, ]
    
    # Calculate the total expected medal contribution
    total_medal_contribution <- event_data$GoldPercentage + event_data$SilverPercentage + event_data$BronzePercentage
    
    return(total_medal_contribution)
  }
  
  
}






