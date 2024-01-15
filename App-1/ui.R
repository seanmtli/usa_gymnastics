library(tidyverse)
library(DT)
library(shiny)
library(htmltools)
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
            p("The full details of our methodology can be found in our report, which can be found at https://github.com/sta440-fa23/Case2-BlueDevilSM"),
             
             # Source Data Information
             h3("Source Data"),
             p("The data used in this tool is sourced from major domestic and international gymnastics competitions worldwide."),
             p("We were provided with two datasets: Data from competitions leading up to the Tokyo Games in 2020 (2017 to 2021). Data from competitions leading up to the Paris Games in 2024 (2022 to 2023). We only used the 2022 to 2023 data, as the competition format changed between 2021 and 2022."),
             
             
             h3("Team | Contact Information | ",  tags$img(src = "dsac_logo.jpg", width = 50, height = 50, alt = "dsac logo")," "),
             p("Our team consists of 3 members: Ben Thorpe, Sean Li, and Chris Tsai. The three of us are all seniors at Duke University studying Statistics and part of the Duke Sports Analytics Club. You can find more information about the Duke Sports Analytics Club at https://dukesportsanalytics.com"),
            
             # Team Member A
             div(
               class = "team-member",
               h4("Ben Thorpe"),
               img(src = "path/to/team_member_a.jpg", alt = "Team Member A Photo", width = 100),
               p("Bio: Team Member A is an expert in gymnastics analytics with a background in statistics."),
               p("Contact: benjamin.thorpe@duke.edu")
             ),
             
             # Team Member B
             div(
               class = "team-member",
               h4("Sean Li"),
               img(src = "path/to/team_member_b.jpg", alt = "Team Member B Photo", width = 100),
               p("Bio: Team Member B is a web development specialist with a passion for sports analytics."),
               p("Contact: sean.li571@duke.edu")
             ),
             
             # Team Member C
             div(
               class = "team-member",
               h4("Chris Tsai"),
               img(src = "path/to/team_member_c.jpg", alt = "Team Member C Photo", width = 100),
               p("Bio: Team Member C is a data visualization expert with extensive experience in gymnastics."),
               p("Contact: christopher.tsai@duke.edu")
             )
             
             
        
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
      helpText("If a gymnast does not show up, they did not medal in any of our simulations."),
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
           p("Welcome to the team builder. This page allows you to enter 5 gymnasts of your choice to build a potential team to represent team USA at the Paris 2024 Olympics. First, type the full names of the gymnasts you want on the team in each of the gymnast text entry boxes. Next, select the events that each gymnast will be participating in. Note that selecting AA means that this athlete will be competing in the individual All-Around competition. After selecting the events, please press Enter Team to view the table with the team and expected medal contributions. "),
           fluidRow(
             column(3,
                     #h2("Full Name"),
                    selectInput("genderTeamBuilder", 
                                label = "Gender",
                                choices = list("Women", "Men"),
                                selected = "Women"),
                    textInput("g1input", h3("Gymnast 1")),
                    textInput("g2input", h3("Gymnast 2")),
                    textInput("g3input", h3("Gymnast 3")),
                    textInput("g4input", h3("Gymnast 4")),
                    textInput("g5input", h3("Gymnast 5")),
                    
             ),
             
             column(3,
                    h2("Individual Events"),
                    uiOutput("event_choices_tb1"),
                    uiOutput("event_choices_tb2"),
                    uiOutput("event_choices_tb3"),
                    uiOutput("event_choices_tb4"),
                    uiOutput("event_choices_tb5"),
                    actionButton("show_choices", "Build Team")
                    
                    
             ),
             column(3,DTOutput("selected_choices_output"))
             
           )
  )
  
)