## ui.R
library(shiny)
library(shinydashboard)
library(recommenderlab)
library(data.table)
library(ShinyRatingInput)
library(shinyjs)

source('functions/helpers.R')

shinyUI(
    dashboardPage(
          skin = "red",
          dashboardHeader(title = "Book Recommender"),
          
          dashboardSidebar(disable = TRUE),

          dashboardBody(includeCSS("css/books.css"),
              fluidRow(
                  box(width = 12, title = "Book Rater", status = "info", solidHeader = FALSE, collapsible = FALSE,
                      div(uiOutput('ratings'))
                  )
                ),
              fluidRow(
                  useShinyjs(),
                  box(
                    width = 12, status = "info", solidHeader = FALSE,
                    br(),
                    withBusyIndicatorUI(
                      actionButton("btn", "Click here to get your recommendations", class = "btn")
                    ),
                    tableOutput("results")
                  )
               )
          )
    )
) 