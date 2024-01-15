library(tidyverse)
library(DT)

w_topcand <- read.csv("data/expected_medals/f_total_probabilities.csv")
m_topcand <- read.csv("data/expected_medals/m_total_probabilities.csv")
m_byevent <- read.csv("data/expected_medals/usa_mens_avs.csv")
w_byevent <- read.csv("data/expected_medals/usa_womens_avs.csv")
BBw <- read.csv("data/sims/BB_usa_womens_sims.csv")
FXw <- read.csv("data/sims/FX_usa_womens_sims.csv")
VTw <- read.csv("data/sims/VT_usa_womens_sims.csv")
UBw <- read.csv("data/sims/UB_usa_womens_sims.csv")

HBm <- read.csv("data/sims/HB_usa_mens_sims.csv")
PBm <- read.csv("data/sims/PB_usa_mens_sims.csv")
PHm <- read.csv("data/sims/PH_usa_mens_sims.csv")
FXm <- read.csv("data/sims/FX_usa_mens_sims.csv")
SRm <- read.csv("data/sims/SR_usa_mens_sims.csv")
VTm <- read.csv("data/sims/VT_usa_mens_sims.csv")
teamMencutoffs <- read.csv("data/team_cutoffs/team_men_cutoffs.csv")
teamWomenscutoffs <- read.csv("data/team_cutoffs/team_women_cutoffs.csv")

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
    tc_data() %>% filter(rowSums(select(., starts_with("Total")) != 0) > 0)
      #filter(across(starts_with("Total"), ~. > 0))
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
      w_byevent #%>% filter(Event!="AA")
    } else {
      m_byevent #%>% filter(Event!="AA")
    }
  })
  
  #Event Table
  output$byevent <-renderDT({
    events_data() %>% filter(Event == input$eventc) %>% 
      filter(rowSums(select(., ends_with("Percentage")) != 0) > 0) %>% 
      arrange(desc(AverageScore))
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
        total_medal_contribution <- total_medal_contribution + medal_contribution
      }
  
      
      total_medal_contributions[[gymnast_name]] <- total_medal_contribution
    }
    
    
    
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
    
    output$teamMedal <- renderDataTable({
      names()
      
      if (input$genderTeamBuilder == "Men") {
        cutoffs <- teamMencutoffs
      }
      else{
        cutoffs <- teamWomenscutoffs
      }
      
      sims <- teamsims(selected_choices$gymnasts, input$genderTeamBuilder)
      mp <- calculateTeamPodiumPercentages(sims,cutoffs)
      
      colnames(mp) <- c("Gymnasts", "Bronze Probability", "Silver Probability", "Gold Probability")
      mp <- select(mp,"Gold Probability","Silver Probability", "Bronze Probability")
      
      mp$`Gold Probability` <- sprintf("%.1f%%", mp$`Gold Probability`)
      mp$`Silver Probability` <- sprintf("%.1f%%", mp$`Silver Probability`)
      mp$`Bronze Probability` <- sprintf("%.1f%%", mp$`Bronze Probability`)
      
      return (datatable(mp, options = list(dom = 't'), rownames = FALSE))
    })
    
  })
  
  # Correcting the case of the LastName in the f dataset
  nfix <- function(dataset) {
    dataset <- as.data.frame(dataset)
    dataset$LastName <- sapply(strsplit(tolower(dataset$LastName), " "), function(x) {
      paste(sapply(x, function(y) {
        paste0(toupper(substring(y, 1, 1)), substring(y, 2))
      }), collapse = " ")
    })
    
    # Create FullName in f dataset
    dataset$FullName <- paste(dataset$FirstName, dataset$LastName, sep=" ")
    
    fnd <- select(dataset,1004,3:1003)
    return (fnd)
  }
  
  process_dataset <- function(nm, dataset) {
    # Step 1: Filter for 5 names
    #fix_data
    
    fixed_data <- nfix(dataset)
    
    filtered_dataset <- fixed_data[fixed_data$FullName %in% nm, ]
    
    # Step 2: Sort by average points
    sorted_dataset <- filtered_dataset %>% 
      arrange(desc(AverageScore)) %>% 
      head(3)
    
    # Step 3: Aggregate the top 3 scores into one row
    aggregated_row <- sorted_dataset %>%
      mutate(across(2:1001, ~ sum(.))) %>% 
      head(1)
    
    return(aggregated_row)
  }
  
  teamsims <- function(gymnasts,gender) {
    
    if (gender == "Men") {
      dataevents <- list(HBm,PHm,PBm,FXm,VTm,SRm) 
    }
    else{
      dataevents <- list(BBw,VTw,UBw,FXw)
    }
    
    
    #print(nm)
    pds <- data.frame()
    
    for (event_data in dataevents) {
      e <- process_dataset(gymnasts, event_data)
      pds <- rbind(pds,e)
      
    }
    
    # Combine the results into one big dataframe
    
    final_result <- pds %>% 
      mutate(across(2:1001, ~ sum(.))) %>% 
      head(1)
    
    return(final_result)
    
  }
  
  calculateTeamPodiumPercentages <- function(df, thresholds) {
    # Number of gymnasts
    num_gymnasts <- nrow(df)
    
    # Initialize an empty dataframe for the results
    results <- data.frame(
      firstName = df[, 1],
      bronze_percentage = numeric(num_gymnasts),
      silver_percentage = numeric(num_gymnasts),
      gold_percentage = numeric(num_gymnasts),
      stringsAsFactors = FALSE
    )
    
    # Iterating over each set of scores
    for (i in 1:1000) {
      # Extract the scores for the ith sample and the thresholds
      sample_scores <- df[, i + 1]
      gold_threshold <- thresholds[1, i]
      silver_threshold <- thresholds[2, i]
      bronze_threshold <- thresholds[3, i]
      
      # Count placements based on thresholds
      results$gold_percentage <- results$gold_percentage + (sample_scores >= gold_threshold)
      results$silver_percentage <- results$silver_percentage + (sample_scores >= silver_threshold & sample_scores < gold_threshold)
      results$bronze_percentage <- results$bronze_percentage + (sample_scores >= bronze_threshold & sample_scores < silver_threshold)
    }
    
    # Convert counts to percentages
    results$gold_percentage <- (results$gold_percentage / 10)
    results$silver_percentage <- (results$silver_percentage / 10)
    results$bronze_percentage <- (results$bronze_percentage / 10)
    
    # Sort the dataframe by gold_percentage in descending order
    results <- results[order(-results$gold_percentage), ]
    
    return(results)
  }
  
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






