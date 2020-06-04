library(shinythemes)
library(ggplot2)
library(DT)
library("ggplot2")
library(shinythemes)


#------
ui = navbarPage(theme = shinytheme("flatly"),"ANTENATAL",
                tabPanel("Data", 
                         sidebarPanel(width = 3,
                                      
                                      fileInput("file", "Choose RDS File",
                                                accept = c("rds",".csv","text/csv","text/comma-separated-values,text/plain")),
                                      fileInput("file1", "Choose CSV File",
                                                accept = c("rds",".csv","text/csv","text/comma-separated-values,text/plain",".xlsx")),
                                      
                                      actionButton('Demo', 'Dataset(N)'),
                                      actionButton("print", "PRINT")
                                      #downloadButton("download", "Download")
                                      
                         ),
                         
                         mainPanel(
                           DT::dataTableOutput("table") 
                           
                         )
                )
                
                
)

server = function(input, output,session) {
  
  #-----import data set --------------
  v <- reactiveValues()  # store values to be changed by observers
  v$data <- data.frame()
  
  
  # Observer for uploaded file
  observe({
    inFile = input$file
    # if (is.null(inFile)) return(NULL)
    # values$data <- read.csv(inFile$datapath)
    if(is.null(inFile)){
      v$data <-readRDS("anten.samp.death.19.5.rds")
    }  
    else {
      v$data <-readRDS(inFile$datapath)
    }
    
  })
  
  observe({
    inFile2 = input$file1
    # if (is.null(inFile)) return(NULL)
    # values$data <- read.csv(inFile$datapath)
    
    if(is.null(inFile2)){
      return(NULL)
    }  
    else   {
      v$data <-read.csv(inFile2$datapath)
    }
    
  })
  #--table output views-------
  output$table <- DT::renderDataTable(
    DT::datatable(v$data, options = list(pageLength = 25))
  )
  
} 

shinyApp(ui, server)

