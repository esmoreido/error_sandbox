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
# library(hydroGOF)
library(reshape2)
library(lubridate)

df <- read.csv('qdata.csv', 
               colClasses = c('integer', 'Date', 'numeric'), 
               col.names = c('index', 'date', 'q_fact'))

# Define UI for application that draws a histogram
ui <- fluidPage(

    # Application title
    titlePanel("Ошибки гидрологического моделирования"),
    tabsetPanel(
      tabPanel("Гидрограф",
    sidebarLayout(
        sidebarPanel(
            sliderInput("err_mean",
                        "Среднее случайной ошибки:",
                        min = -5, max = 5, value = 0, step = 1),
            sliderInput("err_sd",
                        "Дисперсия случайной ошибки:",
                        min = 0, max = 3, value = 0, step = 0.1),
            # tableOutput("table"),
            tableOutput("errtable")
        ),

        mainPanel(
           plotOutput("hydrograph"),
           plotOutput("scatterplot")
        )
    )
  ),
  tabPanel("Графики ошибок",
           mainPanel(
                     plotOutput("ugraph"),
                     plotOutput("sdgraph"))
           ),
  tabPanel("Матрицы",
           mainPanel(
             plotOutput("heatmap"))
  )
    )
)

server <- function(input, output) {
  
  count <- reactiveValues(count = 0)
  
  rval <- reactiveValues(df = data.frame()) 
  
  observeEvent(input$err_mean & input$err_sd, {
    count$count <- count$count + 1
    rval$df <- rbind(rval$df, err())
  } )
  
  dat <- reactive({
    q <- df %>%
      dplyr::filter(year(date) == 2009)
      error <- rnorm(n = 365, mean = input$err_mean, sd = input$err_sd)
      q$q_mod <- q$q_fact + error
      q
  })
  
  err <- reactive({
    # rmse <- rmse(sim = dat()$q_mod, obs = dat()$q_fact)
    rmse <- dat() %>%
      mutate(rmse = sqrt(sum((q_fact - q_mod)^2)))
    # nse <- NSE(sim = dat()$q_mod, obs = dat()$q_fact)
    cor <- cor(y = dat()$q_mod, x = dat()$q_fact)
    # kge <- KGE(sim = dat()$q_mod, obs = dat()$q_fact)
    err <- data.frame(n = count$count, u = input$err_mean, 
                      sd = input$err_sd,
                      RMSE = rmse, NSE = nse, R = cor, KGE = kge)
  })
  
  
    output$hydrograph <- renderPlot({
      ggplot(dat(), aes(x=date)) + 
        geom_line(aes(y=q_fact, col='Факт'), size=1) + 
        geom_line(aes(y=q_mod, col='Модель'), size = 1) + 
        labs(x='', y=expression('Расход воды, м'^3*'/с')) + 
        theme_light(base_size = 16) + scale_x_date(date_breaks = '1 month', date_labels = '%b')
    })
    
    output$scatterplot <- renderPlot({
      ggplot(dat(), aes(x=q_fact, y=q_mod)) + geom_point() + 
        geom_abline() + labs(x='Факт', y='Модель') + 
        geom_smooth(method = 'lm', se = F) + 
        xlim(0, 60) + ylim(0,60) + theme_light(base_size = 16)
    })
    
    output$ugraph <- renderPlot({
      ggplot(melt(rval$df[,-3], id.vars = c('n', 'u')), aes(x=u, y=value, col=variable)) + 
        geom_line() + geom_point() + facet_wrap(variable~., scales='free_y', ncol = 2)
    })
    output$sdgraph <- renderPlot({
      ggplot(melt(rval$df[,-2], id.vars = c('n', 'sd')), aes(x=sd, y=value, col=variable)) + 
        geom_line() + geom_point() + facet_wrap(variable~., scales='free_y', ncol = 2)
    })
    output$heatmap <- renderPlot({
      ggplot(melt(rval$df, id.vars = c('n', 'u', 'sd')), aes(x=u, y=sd, fill=value)) + 
      geom_tile() + facet_wrap(variable~., ncol = 2)
    })
    # output$table <- renderTable(err())
    output$errtable <- renderTable(rval$df)
}

# Run the application 
shinyApp(ui = ui, server = server)
