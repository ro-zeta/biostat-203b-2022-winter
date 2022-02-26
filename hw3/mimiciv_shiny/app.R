library(shiny)
library(ggplot2)
library(dplyr)

icu_cohort <- readRDS("icu_cohort.rds")

ui <- fluidPage(

  titlePanel("Exploring ICU cohort using graphs"),

  sidebarLayout(
    sidebarPanel(
      helpText("Analyzing Demographics Variables of the 
               MIMIC IV Cohort Patients"),
      selectInput("var",
                 label = "Choose a variable to display",
                 choices = c("Age", "Gender", "Ethnicity", "Language",
                             "Marital Status", "Insurance"),
                 selected = "Age"
      )
    ),

    mainPanel(
      plotOutput(outputId = "plot_Demographics"),
      textOutput("demo_label"),
      verbatimTextOutput("summary_Demographics")
    )
  ),
  
  sidebarLayout(
    sidebarPanel(
      helpText("Analyzing Laboratory Tests of the MIMIC IV Cohort Patients"),
      selectInput("labs",
                  label = "Choose a lab test to display",
                  choices = c("bicarbonate", "calcium", "chloride", 
                              "creatinine", "glucose", "hematocrit", 
                              "magnesium", "potassium", "sodium", "WBC_count"),
                  selected = "bicarbonate"
      )
    ),
    
    mainPanel(
      plotOutput(outputId = "plot_Labs"),
      textOutput("lab_label"),
      verbatimTextOutput("summary_Labs")
    )
  ),
  
  sidebarLayout(
    sidebarPanel(
      helpText("Analyzing Vitals Measurements of the MIMIC IV Cohort Patients"),
      selectInput("vitals",
                  label = "Choose a vitals result to display",
                  choices = c("Heart Rate", "Mean Blood Pressure", 
                              "Blood Pressure Systolic", "Temperature", 
                              "Respiratory Rate"),
                  selected = "Heart Rate"
      )
    ),
    
    mainPanel(
      plotOutput(outputId = "plot_Vitals"),
      textOutput("vitals_label"),
      verbatimTextOutput("summary_Vitals")
    )
  ),
  
  sidebarLayout(
    sidebarPanel(
      helpText("First Care Unit at Admittance"),
      actionButton("on",
                  label = ""
      )
    ),
    
    mainPanel(
      plotOutput(outputId = "plot_FCU")
    )
  )
)



server <- function(input, output) {
  
  output$plot_Demographics <- renderPlot({
    data_demographics <- switch(input$var,
                   "Age"= icu_cohort$anchor_age,
                   "Gender" = icu_cohort$gender,
                   "Ethnicity" = icu_cohort$ethnicity,
                   "Language" = icu_cohort$language,
                   "Marital Status" = icu_cohort$marital_status,
                   "Insurance" = icu_cohort$insurance
    )
    
    ggplot(icu_cohort, aes(x = data_demographics, fill = thirty_day_mort)) +
             geom_bar(position = "stack", width = 0.6) +
             ggtitle("Patient Demographics and Thirty Day Mortality") +
             xlab("Demographic Characteristics of Patients") + 
             ylab("Thirty Day Mortality Indication") +
             theme(aspect.ratio = 1/2) +
             theme_light()

  })
  
  output$demo_label <- renderText({
    "Summary of Demographic Variable Selected"
  })
  
  output$summary_Demographics <- renderPrint({
    data_demographics <- switch(input$var,
                   "Gender" = icu_cohort$gender,
                   "Ethnicity" = icu_cohort$ethnicity,
                   "Language" = icu_cohort$language,
                   "Marital Status" = icu_cohort$marital_status,
                   "Insurance" = icu_cohort$insurance
    )
    
    summary(data_demographics) 
  })
  
  output$plot_Labs <- renderPlot({
    data_Labs <- switch(input$labs,
                   "bicarbonate" = icu_cohort$lab50882, 
                   "calcium" = icu_cohort$lab50893, 
                   "chloride" = icu_cohort$lab50902, 
                   "creatinine" = icu_cohort$lab50912, 
                   "glucose" = icu_cohort$lab50931,
                   "hematocrit" = icu_cohort$lab51221, 
                   "magnesium" = icu_cohort$lab50960, 
                   "potassium" = icu_cohort$lab50971, 
                   "sodium" = icu_cohort$lab50983, 
                   "WBC_count" = icu_cohort$lab51301
                        )
   
    ggplot(icu_cohort, aes(x = label, y = data_Labs, color = thirty_day_mort)) +
      geom_boxplot() +
      ggtitle("Lab Test Results of Patients and Thirty Day Mortality Rate") +
      scale_x_discrete(labels = abbreviate) +
      xlab("Lab Test Name") +
      ylab("Lab Test Results") +
      theme_light()
  })
  
  output$lab_label <- renderText({
    "Summary of Laboratory Test Selected"
  })
  
  output$summary_Labs <- renderPrint({
    data_Labs <- switch(input$labs,
                                "bicarbonate" = icu_cohort$lab50882, 
                                "calcium" = icu_cohort$lab50893, 
                                "chloride" = icu_cohort$lab50902, 
                                "creatinine" = icu_cohort$lab50912, 
                                "glucose" = icu_cohort$lab50931,
                                "hematocrit" = icu_cohort$lab51221, 
                                "magnesium" = icu_cohort$lab50960, 
                                "potassium" = icu_cohort$lab50971, 
                                "sodium" = icu_cohort$lab50983, 
                                "WBC_count" = icu_cohort$lab51301
    )
    
    summary(data_Labs) 
  })
  
  output$plot_Vitals <- renderPlot({
    data_vitals <- switch(input$vitals,
                        "Heart Rate" = icu_cohort$vitals220045, 
                        "Mean Blood Pressure" = icu_cohort$vitals220181, 
                        "Blood Pressure Systolic" = icu_cohort$vitals220179, 
                        "Temperature" = icu_cohort$vitals223761, 
                        "Respiratory Rate" = icu_cohort$vitals220210,
    )
    
    ggplot(icu_cohort, aes(x = abbreviation, y = data_vitals, 
                           color = thirty_day_mort)) +
      geom_boxplot() +
      ggtitle("Vitals Signs of Patients and Thirty Day Mortality Rate") +
      scale_x_discrete(labels = abbreviate) +
      xlab("Vital Signs") +
      ylab("Vitals Measurement Results") +
      theme_light()
  })
  
  output$vitals_label <- renderText({
    "Summary of Vital Sign Measurement Selected"
  })
  
  output$summary_Vitals <- renderPrint({
    data_vitals <- switch(input$vitals,
                        "Heart Rate" = icu_cohort$vitals220045, 
                        "Mean Blood Pressure" = icu_cohort$vitals220181, 
                        "Blood Pressure Systolic" = icu_cohort$vitals220179, 
                        "Temperature" = icu_cohort$vitals223761, 
                        "Respiratory Rate" = icu_cohort$vitals220210,
    )
    
    summary(data_vitals) 
  })
  
  output$plot_FCU <- renderPlot({
    ggplot(icu_cohort, aes(x = first_careunit, fill = thirty_day_mort)) +
      geom_bar(position = "stack", width = 0.6) +
      scale_x_discrete(labels = abbreviate) +
      ggtitle("First Care Unit of Admittance and Thirty Day Mortality Count") +
      xlab("Number of Patients in Each Survival Category") + 
      ylab("First Care Unit") +
      theme_light() +
      coord_flip()
  })
   

}


shinyApp(ui, server)