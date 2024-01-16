library(tidyverse)
library(DT)
library(shiny)
library(htmltools)

w_topcand <- read.csv("data/expected_medals/f_total_probabilities.csv")
m_topcand <- read.csv("data/expected_medals/m_total_probabilities.csv")
gymnast_names <- c(w_topcand$Name, m_topcand$Name)
gymnast_names <- gsub("Frederick Richard", "Fred Richard", gymnast_names)

ui <- navbarPage(
  
  # App title ----
  "USA Gymnastics Web App",
  
  tabPanel("About",
           div(
             class = "about-content",
             
             # App Description
             h2("USA Gymnastics Olympic Selection Tool", tags$img(src = "usagymnastics.png", alt = "App Logo", width = 120, height = 75), " "),
             p("Welcome to the USA Gymnastics Olympic Selection Tool for the Paris 2024 Olympics. This tool is designed to assist the USA Gymnastics Olympic Committee in making informed decisions about athlete selection."),
             
             # Placeholder for App Logo/Image
             
             
             # App Features
             h3("Key Features"),
             tags$ul(
               tags$li("Statistical analysis visualized for athlete potential"),
               tags$li("Insights into medal probability for athletes in specific events"),
               tags$li("Predicted medal performance"),
               tags$li("Empowering the selection process for the Paris 2024 Olympics")
             ),
             
            h3("How it works"),
            p("Our methodology was a three step process consisting of weighting, simulating, sampling. We first weight each individual gymnast’s scores from their competitions since 2022 based on the recency of the competition as well as if the score came from a qualifying or final round performance to get an expected score on each apparatus."),
            p("Then, we simulated the following process 1000 times: "),
            tags$ul(
              tags$li("Create a distribution for the top 24 gymnasts based on past scores for each apparatus"),
              tags$li("Sample from the t-distribution created from these scores"),
              tags$li("The top 3 sampled scores in each simulation correspond to gold, silver, and bronze medal thesholds scores"),
              tags$li("Create a t-distribution of an individual USA gymnast for each apparatus, obtaining a mean and variance"),
              tags$li("Sample from the individual gymnast t-distribution"),
              tags$li("If that gymnast’s score was above the Gold medal threshold they received Gold for the given simulation, if above Silver, but below Gold, a Silver, and so on")
            ),
            p("Adding up the amount of times a gymnast received a medal and dividing it by the number of simulations (1000) gave us expected medal probabilities."),
            p("The full details of our methodology can be found in our report, which can be found at", tags$a(href="https://github.com/sta440-fa23/Case2-BlueDevilSM", "https://github.com/sta440-fa23/Case2-BlueDevilSM"), " " ),
             
             # Source Data Information
             h3("Source Data"),
             p("The data used in this tool is sourced from major domestic and international gymnastics competitions worldwide."),
             p("We were provided with two datasets: Data from competitions leading up to the Tokyo Games in 2020 (2017 to 2021). Data from competitions leading up to the Paris Games in 2024 (2022 to 2023). We only used the 2022 to 2023 data, as the competition format changed between 2021 and 2022."),
             
             
             h3("Team | Contact Information | ",  tags$img(src = "dsac_logo.jpg", width = 50, height = 50, alt = "dsac logo")," "),
             p("Our team consists of 3 members: Ben Thorpe, Sean Li, and Chris Tsai. The three of us are all seniors at Duke University studying Statistics and part of the Duke Sports Analytics Club. You can find more information about the Duke Sports Analytics Club at", tags$a(href="https://dukesportsanalytics.com", "https://dukesportsanalytics.com")),
        
           )
  ),
  
  ## Gymnasts Page
  tabPanel( "Gymnasts",
    sidebarLayout(
    # Sidebar panel for inputs ----
    sidebarPanel(
      h3("Gymnast Database"),
      p("This page is a display of the top USA gymnasts based upon expected medals. You may choose to view it by event or consolidated."),
      p("For example, a row with Simone Biles with 0.715 under Total_BB means that we can expect Simone Biles to have a 71.5% chance of medaling in the Balance Beam individual apparatus."),
      helpText("Note: If a gymnast does not show up, they did not medal in any of our simulations."),
      selectInput("var", 
                  label = "Gender",
                  choices = list("Women", "Men"),
                  selected = "Women"),
    ),
    # Main panel for displaying outputs ----
    mainPanel(
      tabsetPanel(
        id = 'dataset',
        tabPanel("Top Candidates", DTOutput("individuals")),
        tabPanel("By Event", 
                 uiOutput("events_choices"),
                 DTOutput("byevent"))
        
      )
    )
    )
  ),
  
  ### Team Builder
  tabPanel("Team Builder",
           h2("Build Your Own Team!"),
           p("Welcome to the team builder. This page allows you to enter 5 gymnasts of your choice to build a potential team to represent team USA at the Paris 2024 Olympics. First, type the full names of the gymnasts you want on the team in each of the gymnast text entry boxes. Next, select the events that each gymnast will be participating in. Note that selecting AA means that this athlete will be competing in the individual All-Around competition. After selecting the events, please press Enter Team to view the table with the team and expected medal contributions. "),
           fluidRow(
             column(3,
                     #h2("Full Name"),
                    selectInput("genderTeamBuilder", 
                                label = "Gender",
                                choices = list("Women", "Men"),
                                selected = "Women"),
                    selectizeInput("g1input", label = h3("Gymnast 1"), choices = gymnast_names,
                                   selected = "Simone Biles", multiple = FALSE, options = NULL),
                    selectizeInput("g2input", label = h3("Gymnast 2"), choices = gymnast_names,
                                   selected = "Shilese Jones", multiple = FALSE, options = NULL),
                    selectizeInput("g3input", label = h3("Gymnast 3"), choices = gymnast_names,
                                   selected = "Jade Carey", multiple = FALSE, options = NULL),
                    selectizeInput("g4input", label = h3("Gymnast 4"), choices = gymnast_names,
                                   selected = "Kaliya Lincoln", multiple = FALSE, options = NULL),
                    selectizeInput("g5input", label = h3("Gymnast 5"), choices = gymnast_names,
                                   selected = "Zoe Miller", multiple = FALSE, options = NULL),
                    
             ),
             
             column(3,
                    h2("Individual Events"),
                    p("Please select 2 athletes for all-around and a maximum of two athletes for any individual event."),
                    uiOutput("event_choices_tb1"),
                    uiOutput("event_choices_tb2"),
                    uiOutput("event_choices_tb3"),
                    uiOutput("event_choices_tb4"),
                    uiOutput("event_choices_tb5"),
                    actionButton("show_choices", "Build Team")
                    
                    
             ),
             column(3, h2("Individual Expected Medal Contributions"),
                    DTOutput("selected_choices_output"),
                    h2("Team Medal Probabilities"),
                    DTOutput("teamMedal")),
             column(3, h2("Total Medals"), textOutput("totalM"), helpText("Note: This is assuming that the USA team qualifies to the final round in all events"))
             
           )
  )
  
)