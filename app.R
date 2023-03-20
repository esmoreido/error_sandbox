#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
library(ggplot2)
library(dplyr)
library(tidyverse)
library(lubridate)

df <- read.csv('qdata.csv', 
               colClasses = c('integer', 'Date', 'numeric'), 
               col.names = c('index', 'date', 'q_fact'))

# Define UI for application that draws a histogram
ui <- fluidPage(

    # Application title
    titlePanel("Ошибки гидрологического моделирования"),

    # Sidebar with a slider input for number of bins 
    sidebarLayout(
        sidebarPanel(
            sliderInput("err_mean",
                        "Среднее случайной ошибки:",
                        min = -5, max = 5, value = 0, step = 1),
            sliderInput("err_sd",
                        "Дисперсия случайной ошибки:",
                        min = 0, max = 3, value = 0, step = 0.1),
            tableOutput("table")
        ),

        # Show a plot of the generated distribution
        mainPanel(
           plotOutput("hydrograph"),
           plotOutput("scatterplot")
        )
    )
)

server <- function(input, output) {
  
  
  dat <- reactive({
    q <- df %>%
      dplyr::filter(year(date) == 2009)
      error <- rnorm(n = 365, mean = input$err_mean, sd = input$err_sd)
      q$q_mod <- q$q_fact + error
      q
  })
  
  err <- reactive({
    # rmse <- rmse(sim = dat()$q_mod, obs = dat()$q_fact)
    # nse <- NSE(sim = dat()$q_mod, obs = dat()$q_fact)
    cor <- cor(y = dat()$q_mod, x = dat()$q_fact)
    # err <- data.frame(rmse, nse, cor)
    err <- data.frame(cor)
  })
    output$hydrograph <- renderPlot({
      ggplot(dat(), aes(x=date)) + 
        geom_line(aes(y=q_fact, col='Факт'), size=1) + 
        geom_line(aes(y=q_mod, col='Модель'), size = 1, type = 'dash') + 
        labs(x='', y=expression('Расход воды, м'^3*'/с')) + 
        theme_light(base_size = 16) + scale_x_date(date_breaks = '1 month', date_labels = '%b')
    })
    output$scatterplot <- renderPlot({
      ggplot(dat(), aes(x=q_fact, y=q_mod)) + geom_point() + 
        geom_abline() + labs(x='Факт', y='Модель') + 
        geom_smooth(method = 'lm', se = F) + 
        xlim(0, 60) + ylim(0,60) + theme_light(base_size = 16)
    })
    output$table <- renderTable(err())
}

# Run the application 
shinyApp(ui = ui, server = server)
