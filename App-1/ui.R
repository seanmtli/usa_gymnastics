library(tidyverse)
library(DT)
library(shiny)
ui <- navbarPage(
  
  # App title ----
  "USA Gymnastics Web App",
  
  ## About Page || Landing Page
  tabPanel("About",
    p("Filler Stuff")
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