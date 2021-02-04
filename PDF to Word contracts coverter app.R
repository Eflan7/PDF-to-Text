# An app to upload a PDF file and automatically convert to an output file.
# Change directory to this app before running the app.
# Output file will be downloaded in the current directory of the app.

install.packages("shiny")
library(shiny)
install.packages("shinydashboard")
library(shinydashboard)
install.packages("tesseract")
library(tesseract)
install.packages("magick")
library(magick)
install.packages("pdftools")
library(pdftools)

ui <- dashboardPage(
  dashboardHeader(title = "PDF Converter"),
  dashboardSidebar(sidebarMenu(
    menuItem("English", tabName = "english", icon = icon("dashboard"))
  )),
  dashboardBody(
    # Boxes need to be put in a row (or column)
    tabItems(
      # First tab content
      tabItem(tabName = "english",
              fluidRow(
                fileInput("file", "Choose PDF File",
                          accept = c(
                            "pdf",
                            ".pdf")
                ),
                tags$hr()
              )
      )
      )
    )
  
)

server <- function(input, output) {
  fileURL <- NULL
  
  # this opens the file input dialog box. Once the user picks a PDF file, it
  # reads it into image_read_pdf() and converts to text. Final line writes the
  # text to our output file.
  
  converter <- observeEvent(input$file, {
    inFile <- input$file
    fileURL <- inFile$datapath
    
    pdfFile <- image_read_pdf(fileURL)
    convertedText <- image_ocr(pdfFile)
    
    write.table(convertedText, file = paste("converted_PDF-", format(Sys.time(), "%d-%b-%Y_%H.%M"), 
                    ".doc", sep=""), sep= "\t", row.names = FALSE, fileEncoding = "UTF-8")
  }, ignoreNULL = TRUE)
  

  # output$downloadData <- downloadHandler(
  #   filename = function() {
  #     paste("dataset-", Sys.Date(), ".doc", sep="")
  #   },
  #   content = function(file) {
  #     write.table(convertedText, file, sep= "\t", row.names = FALSE,
  #                 fileEncoding = "UTF-8")
  # })
  
  # output$contents <- renderTable({
  #   # validate(need(!is.null(fileURL), "Please wait ..."))
  #   as.data.frame(converter())
  #   })
  #observe(print(converter()))
  
  # observe(fileURL, {
  #   if(!is.null(fileURL)) {
  #     print("yiasiash")
  #     pdfFile <- image_read_pdf(fileURL)
  #     convertedText <- image_ocr(pdfFile)
  #   }
  # })
  
}

shinyApp(ui, server)