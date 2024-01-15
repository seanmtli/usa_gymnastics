# Vaulting into Victory
## Optimizing for USA Gymnastics Medal Count at the Paris 2024 Olympics

This is a project that creates a tool to choose the best lineup for the total expected medal count in artistic gymnastics at the Paris 2024 Olympics. It is part of a submission to the UCSAS 2024 data challenge. Our goal is to use a simulation based approach to predict the best five-member lineups for both the
USA Men’s and Women’s artistic gymnastics teams, optimizing for total medal count. The research report with full methodology can be found in the REPORT.PDF file in this repository. 

We also built an interactive web app which can be found here: https://seanmtli.shinyapps.io/usa_gymnastics2024/

## Blue Devil Statistics Magicians | Team Members: Benjamin Thorpe, Sean Li, Chris Tsai
The three of us are all seniors at Duke University studying Statistics and part of the Duke Sports Analytics Club. You can find more information about the Duke Sports Analytics Club at https://dukesportsanalytics.com Feel free to reach out with questions or comments to Sean Li at sean.li571@duke.edu 

### File Directory

- App-1/
  - ui.R: file that generates the UI for our web app
  - server.R: server file for web app backend
  - data/
    - sims/: folder of simulations for all events for USA gymnasts
    - data_2017_2021: given data on gymnastic meet results from 2017-2021
    - data_2022_2023: given data on gymnastic meet results from 2022-2023
    - event_percentages/: a per gender per event folder of medal probabilities
    - expected_medals/: consolidated and transformed datasets of medal probabilities for use in web app
- REPORT.Rmd: code and writeup that generates our final report
- REPORT.PDF: main report in PDF form
- Optimization.Rmd: creation of datasets to use in web app + an attempt at using optimization code methods
- simulations.Rmd: code to simulate a specific gymnast in an event based on historical data
- expectedmedals.Rmd: contains the process to generate medal cutoffs and generate medaling probabilities 


