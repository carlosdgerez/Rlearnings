# this file is to store code that slow my knits for latter integrations in a markdown. 
leaflet() %>% 
  addTiles() %>% 
  setView(lat = 37.58 , lng = -103.46, zoom = 3.5) %>% 
  addPolygons(data = data_foodInsecurity_filtered,
              group = "Low Level of food security",
              fillColor = ~pal1(data_foodInsecurity_filtered$low_security), 
              fillOpacity = 1, 
              color = "black", 
              stroke = T, 
              weight = 1, 
              #                   layerId = states$state_name, #this sets the click id, very important! when translated to shiny
              highlightOptions = highlightOptions(color = "black",
                                                  weight = 3,
                                                  bringToFront = TRUE),
              label = labels,
              labelOptions = labelOptions(style = list("font-weight" = "normal",padding = "3px 8px"),
                                          textsize = "15px",
                                          direction = "auto")) %>% 
  
  addPolygons(data = data_foodInsecurity_filtered, 
              group = "Very Low Level of Food Security",
              fillColor = ~pal2(data_foodInsecurity_filtered$very_low_security), 
              fillOpacity = 1, 
              color = "black", 
              stroke = T, 
              weight = 1, 
              #                   layerId = states$state_name, #this sets the click id, very important! when translated to shiny
              highlightOptions = highlightOptions(color = "black",
                                                  weight = 3,
                                                  bringToFront = TRUE),
              label = labels2,
              labelOptions = labelOptions(style = list("font-weight" = "normal",padding = "3px 8px"),
                                          textsize = "15px",
                                          direction = "auto")) %>% 
  
  addLayersControl(
    baseGroups = c("Low Level of food security","Very Low Level of Food Security"),
    
    options = layersControlOptions(collapsed = FALSE) )



#################################### ANImation

library(gapminder)

p <- ggplot(animation, aes(perc_obesity, perc_poverty, size = perc_obesity, colour = LocationDesc)) +
  geom_point(alpha = 0.7, show.legend = FALSE) +
  
  #  scale_size(range = c(2, 12)) +
  #  scale_x_log10() +
  #  facet_wrap(~continent) +
  # Here comes the gganimate specific bits
  labs(title = 'Poverty and obesity relation by year: {round(frame_time)}', x = 'Obesity percent', y = 'Poverty percent') +
  transition_time(YearStart) +
  ease_aes('linear')





animate(p, fps = 10, duration =  40 )





############################### Insecurity levels of food( must add descriptions of graphs) ####################################

usa <-  us_states()
data_foodInsecurity_filtered <- data_foodInsecurity %>% filter(!State == "U.S.")

data_foodInsecurity_filtered <- data_foodInsecurity_filtered %>% inner_join(usa, by = c("State" = "state_abbr"))


data_foodInsecurity_filtered <-  st_as_sf(data_foodInsecurity_filtered)
### first graph titles

labels <- sprintf(
  "<strong>%s</strong><br/>%g percent not altered eating patterns<sup></sup>",
  data_foodInsecurity_filtered$name, data_foodInsecurity_filtered$low_security
) %>% lapply(htmltools::HTML)


labels2 <- sprintf(
  "<strong>%s</strong><br/>%g percent altered eating patterns.<sup></sup>",
  data_foodInsecurity_filtered$name, data_foodInsecurity_filtered$very_low_security
) %>% lapply(htmltools::HTML)




titles1 <- sprintf(
  "<strong>Low Food Security Level</strong><br/>(Percent)<br/> <strong></strong><sup></sup>"
  
) %>% lapply(htmltools::HTML)

titles2 <- sprintf(
  "<strong>Very Low Food Security Level</strong><br/>(Percent)<br/> <strong></strong><sup></sup>"
  
) %>% lapply(htmltools::HTML)

pal1 <- colorNumeric(
  palette = "Blues",
  domain = data_foodInsecurity_filtered$low_security
)

pal2 <- colorNumeric(
  palette = "Blues",
  domain = data_foodInsecurity_filtered$very_low_security 
)
###############################
#install.packages("oceanis")
library(oceanis)
################################

leaflet() %>% 
  addTiles() %>% 
  setView(lat = 37.58 , lng = -103.46, zoom = 3.5) %>% 
  addPolygons(data = data_foodInsecurity_filtered,
              group = "Eating patterns not disrupted",
              fillColor = ~pal1(data_foodInsecurity_filtered$low_security), 
              fillOpacity = 1, 
              color = "black", 
              stroke = T, 
              weight = 1, 
              #                   layerId = states$state_name, #this sets the click id, very important! when translated to shiny
              highlightOptions = highlightOptions(color = "black",
                                                  weight = 3,
                                                  bringToFront = TRUE),
              label = labels,
              labelOptions = labelOptions(style = list("font-weight" = "normal",padding = "3px 8px"),
                                          textsize = "15px",
                                          direction = "auto")) %>% 
  
  addPolygons(data = data_foodInsecurity_filtered, 
              group = "Eating patterns disrupted",
              fillColor = ~pal2(data_foodInsecurity_filtered$very_low_security), 
              fillOpacity = 1, 
              color = "black", 
              stroke = T, 
              weight = 1, 
              #                   layerId = states$state_name, #this sets the click id, very important! when translated to shiny
              highlightOptions = highlightOptions(color = "black",
                                                  weight = 3,
                                                  bringToFront = TRUE),
              label = labels2,
              labelOptions = labelOptions(style = list("font-weight" = "normal",padding = "3px 8px"),
                                          textsize = "15px",
                                          direction = "auto")) %>%
  # add_titre("Insecurity of having food.
  #          (2019 - 2021 prevalescence Estimated From USDA)") %>% 
  # This are the controls of the chart   
  addLayersControl(
    baseGroups = c("Eating patterns not disrupted","Eating patterns disrupted"),
    
    options = layersControlOptions(collapsed = FALSE) )






#####################################################################################################################################

# ANIMATIONS








