
library(shiny)
library(htmlwidgets)
library(D3TableFilter)
library(shinythemes)
library(shinydashboard)

shinyUI(
  dashboardPage(
    dashboardHeader(title = "Digital Qual via D3TableFilter in Shiny",titleWidth = 450),
    dashboardSidebar(
      tags$head(
      tags$style(HTML("
                      .sidebar { height: 90vh; overflow-y: auto; }
                      .dataTables_wrapper { overflow-x: scroll; }
                      " )
                )),
                     
      
      menuItem("Digital Data",tabName = "digital_data"),
      br(),
      
      menuItem("Download filtered data",icon = icon("download")),
      
      br(),
      
      downloadButton(outputId = "download_filtered",
                     label = "Download Filtered Data")
    ),
    
    dashboardBody(
      
      tabItem(tabName = "digital_data"),
      fluidRow(
        column(width = 12, d3tfOutput('mtcars', height = "auto"))
         ),
      

              mainPanel(
                htmlOutput("intro")
    ))
    )
    
    )

