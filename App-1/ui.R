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
             h2("USA Gymnastics Olympic Selection Tool"),
             p("Welcome to the USA Gymnastics Olympic Selection Tool for the Paris 2024 Olympics. This tool is designed to assist the USA Gymnastics Olympic Committee in making informed decisions about athlete selection."),
             
             # Placeholder for App Logo/Image
             img(src = "path/to/your/logo.png", alt = "App Logo", width = 200),
             
             # App Features
             h3("Key Features"),
             tags$ul(
               tags$li("Statistical analysis visualized for athlete potential."),
               tags$li("Insights into medal probability for athletes in specific events."),
               tags$li("Predicted team medal performance."),
               tags$li("Empowering the selection process for the Paris 2024 Olympics.")
             ),
             
             # Placeholder for Screenshots/Images
             h3("Screenshots"),
             div(
               class = "screenshot-container",
               img(src = "path/to/screenshot1.png", alt = "Screenshot 1", width = 300),
               img(src = "path/to/screenshot2.png", alt = "Screenshot 2", width = 300),
               # Add more screenshots as needed
             ),
             
             # Source Data Information
             h3("Source Data"),
             p("The data used in this tool is sourced from major domestic and international gymnastics competitions worldwide."),
             p("We were provided with two datasets: Data from competitions leading up to the Tokyo Games in 2020 (2017 to 2021). Data from competitions leading up to the Paris Games in 2024 (2022 to 2023). We only used the 2022 to 2023 data, as the competition format changed between 2021 and 2022."),
             
             
             h3("Team | Contact Information"),
             p("Our team consists of 3 members: A, B, C."),
             
             # Team Member A
             div(
               class = "team-member",
               h4("Team Member A"),
               img(src = "path/to/team_member_a.jpg", alt = "Team Member A Photo", width = 100),
               p("Bio: Team Member A is an expert in gymnastics analytics with a background in statistics."),
               p("Contact: team_member_a@usagymselectiontool.com")
             ),
             
             # Team Member B
             div(
               class = "team-member",
               h4("Team Member B"),
               img(src = "path/to/team_member_b.jpg", alt = "Team Member B Photo", width = 100),
               p("Bio: Team Member B is a web development specialist with a passion for sports analytics."),
               p("Contact: team_member_b@usagymselectiontool.com")
             ),
             
             # Team Member C
             div(
               class = "team-member",
               h4("Team Member C"),
               img(src = "path/to/team_member_c.jpg", alt = "Team Member C Photo", width = 100),
               p("Bio: Team Member C is a data visualization expert with extensive experience in gymnastics."),
               p("Contact: team_member_c@usagymselectiontool.com")
             )
             
             
        
           )
  ),
  
  ## Gymnasts Page
  tabPanel( "Gymnasts",
    sidebarLayout(
    # Sidebar panel for inputs ----
    sidebarPanel(
      helpText("Help text caption"),
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
  tabPanel("Team Builder", textInput("g1input", h3("Gymnast 1")),
           textInput("g2input", h3("Gymnast 2")),
           textInput("g3input", h3("Gymnast 3")),
           textInput("g4input", h3("Gymnast 4")),
           textInput("g5input", h3("Gymnast 5")))
  
)