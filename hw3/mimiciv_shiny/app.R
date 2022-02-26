library(shiny)
library(ggplot2)

icu_cohort <- readRDS("icu_cohort.rds")

# Define UI for app that draws a histogram ----
ui <- fluidPage(
  
  titlePanel("Exploring ICU cohort using graphs"),
  
  sidebarLayout(
    
    sidebarPanel(
      
      helpText("Analyzing demographics variables from MIMIC IV ICU Cohort"),
      
      selectInput("var",
                 label = "Choose a variable to display",
                 choices = c("Age", "Gender", "Ethnicity", "Language", 
                             "Marital Status", "Insurance")
        
      ),
      
    ),
    
    mainPanel(
      
      plotOutput(outputId = "distPlot")
      
    )
  )
)




# Define server logic required to draw a histogram ----
server <- function(input, output) {
  
  output$distPlot <- renderPlot({
    data <- switch(input$var,
                   "Age"= icu_cohort$anchor_age,
                   "Gender" = icu_cohort$gender,
                   "Ethnicity" = icu_cohort$ethnicity,
                   "Language" = icu_cohort$language,
                   "Marital Status" = icu_cohort$marital_status,
                   "Insurance" = icu_cohort$insurance
    )
    
    ggplot(icu_cohort, aes(x = data)) + #TODO: add fill = icu_cohort$thirtyDayMortality
             geom_bar(position = "stack", width = 0.6) +
             ggtitle("Patient Demographics and Thirty Day Mortality") +
             xlab("Demographic Characteristics of Patients") + 
             ylab("Thirty Day Mortality Indication") +
             theme(aspect.ratio = 1/2) +
             theme_light()
    
  })
  
  summarise(group_by(icu_cohort, thirty_day_mort),   
            means = mean(data),
            sd = sd(data)
    )
  
}


shinyApp(ui, server)