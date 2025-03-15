library(shiny)

ui <- fluidPage(
  # 1. A Basic Slider
  sliderInput(
    inputId = "Slider1",
    label = "Basic Slider",
    min = 0,
    max = 10,
    value = 5
  ),
  
  verbatimTextOutput("Slider1Out")
)

server <- function(input, output){
  
  output$Slider1Out <- renderText({
    paste("You've selected: ", input$Slider1)
  })
  
  
}

shinyApp(ui, server)