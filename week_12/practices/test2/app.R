#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#
library(tidyverse)
library(shiny)
library(raster)
library(shiny)
library(leaflet)
library(RColorBrewer)
library(USAboundaries)
library(sf, warn.conflicts = F)

devtools::install_github("hathawayj/buildings")


#load in shapefiles for state and county level 
#states <- getData("GADM", country = "usa", level = 1)
#counties <- getData("GADM", country = "usa", level = 2)


# Getting and preparing the dataset

states <- us_states()
counties <- us_counties()
buildings_p_state <- buildings::permits 

buildings_p_state <- buildings_p_state %>% group_by(StateAbbr,year, variable ) %>% 
                      summarise(StateAbbr,
                                permitTotals = sum(value)) %>% 
                     distinct()



statesBuildings <-   buildings_p_state %>% 
  full_join(states, by = c("StateAbbr" = "state_abbr") )


statesBuildings <- statesBuildings %>% filter(
  variable == "Single Family")  






#define color palettes for states
pal <- brewer.pal(12, "Set3")
statePal <- colorFactor(pal, statesBuildings$permitTotals)


pal2 <- colorNumeric(
  palette = "YlGnBu",
  domain = statesBuildings$permitTotals
)

shinyApp(
  
  ui = fluidPage(
    mainPanel(
    # Application title
    titlePanel("Single House Permits by year"),
    
    #  A Basic Slider with Step Size
    sliderInput(
      inputId = "Slider2",
      label = "Look at historical information",
      min = 1980,
      max = 2010,
      value = 1992,
      step = 1,
      sep = ""
    ),
      
    
    
    
    
############################################################# 

    leafletOutput('myMap', width = "100%"), 
    br(), 
    leafletOutput("myMap2", width = "100%")
  )), #END UI
  
  server <- function(input, output, session){
    
    output$Slider2Out <- renderText({
      paste("You've selected: ", input$Slider2)})
    
##############################################################    
    
    #default state level map output
    output$myMap <- renderLeaflet({
      leaflet() %>% 
        addTiles() %>% 
        setView(lat = 37.58 , lng = -103.46, zoom = 3.5) %>% 
        addPolygons(data = states, 
                    fillColor = ~pal2(scale(statesBuildings$permitTotals)), 
                    fillOpacity = 1, 
                    color = ~pal2(statesBuildings$permitTotals), 
                    stroke = T, 
                    weight = 1, 
                    layerId = states$state_name, #this sets the click id, very important!
                    highlightOptions = highlightOptions(color = "black",
                                                        weight = 3,
                                                        bringToFront = TRUE)) %>% 
        addLegend(data = statesBuildings, values = ~permitTotals, pal = pal2)
    }) #END RENDERLEAFLET OUTPUT
    
    observeEvent(input$myMap_shape_click, {
      
      #define click object
      click <- input$myMap_shape_click
      
      #subset counties shapefile so that only counties from the clicked state are mapped
      selected <- counties[counties$state_name == click$id,]
      
      #define color palette for counties 
      countyPal <- colorFactor(pal, selected$name)
      
      #if click id isn't null (i.e. if ANY polygon is clicked on), draw map of counties
      if(!is.null(click$id)){
        output$myMap2 <- renderLeaflet({
          leaflet() %>% 
            addTiles() %>% 
            addPolygons(data = selected, 
                        fillColor = ~countyPal(selected$name), 
                        fillOpacity = 1, 
                        color = "white", 
                        stroke = T, 
                        weight = 1)
        }) #END RENDERLEAFLET
      } #END CONDITIONAL
    }) #END OBSERVE EVENT 
  }) #END SHINYAPP