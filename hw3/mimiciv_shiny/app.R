library(shiny)
library(ggplot2)
library(dplyr)

icu_cohort <- readRDS("icu_cohort.rds")


ui <- navbarPage("Exploring ICU cohort using graphs",
                 tabPanel("Demographic variables",
                 fluidPage(
                   
                   sidebarLayout(
                            
                     sidebarPanel(
                              
                       helpText("Analyzing demographics variables from 
                                MIMIC IV ICU Cohort"),
                              
                       selectInput("var",
                         label = "Choose a variable to display",
                         choices = c("Age", "Gender", "Ethnicity", "Language", 
                                              "Marital Status", "Insurance")
                              ),
                            ),
                   mainPanel(plotOutput(outputId = "distPlot"))            
                   )
                 )
                 ),
                 
                 tabPanel("Laboratory Tests and Vital Measurements",
                 fluidPage(
                   sidebarLayout(
                            
                     sidebarPanel(
                              
                       helpText("Analyzing Lab and Vital Measurements from 
                                MIMIC IV ICU Cohort"),
                              
                       selectInput("var",
                         label = "Choose a variable to display",
                         choices = c("Age", "Gender", "Ethnicity", "Language", 
                                                "Marital Status", "Insurance")
                              ),
                            ),
                            mainPanel(plotOutput(outputId = "distPlot"))            
                   )
                 )
                 ),
                 
                 tabPanel("First Care Unit after Admittance",
                 fluidPage(
                   sidebarLayout(
                            
                     sidebarPanel(
                              
                       helpText("First Care Unit after Admittance"),
                              
                       selectInput("var",
                         label = "Choose a variable to display",
                         choices = c("Age", "Gender", "Ethnicity", "Language", 
                                                "Marital Status", "Insurance")
                              ),
                            ),
                            mainPanel(plotOutput(outputId = "distPlot"))            
                   )
                 )
                 )
)

# ui <- fluidPage(
#   
#   titlePanel("Exploring ICU cohort using graphs"),
#   
#   sidebarLayout(
#     
#     sidebarPanel(
#       
#       helpText("Analyzing demographics variables from MIMIC IV ICU Cohort"),
#       
#       selectInput("var",
#                  label = "Choose a variable to display",
#                  choices = c("Age", "Gender", "Ethnicity", "Language", 
#                              "Marital Status", "Insurance")
#         
#       ),
#       
#     ),
#     
#     mainPanel(
#       
#       plotOutput(outputId = "distPlot")
#       
#     )
#   )
# )



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
    
    ggplot(icu_cohort, aes(x = data, fill = thirty_day_mort)) +
             geom_bar(position = "stack", width = 0.6) +
             ggtitle("Patient Demographics and Thirty Day Mortality") +
             xlab("Demographic Characteristics of Patients") + 
             ylab("Thirty Day Mortality Indication") +
             theme(aspect.ratio = 1/2) +
             theme_light()
    
  })
  
# sum_tble <- icu_cohort %>% 
#   group_by(thirty_day_mort) %>% 
#   summarize(
#     mean = mean(na.omit(icu_cohort$gender)),
#     sd = sd(na.omit(icu_cohort$gender))
#     ) 

}



shinyApp(ui, server)