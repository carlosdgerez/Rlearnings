
install.packages("leaflet")
install.packages("maps")

library(leaflet)

m <- leaflet() %>%
  addTiles() %>%  # Add default OpenStreetMap map tiles
  addMarkers(lng=174.768, lat=-36.852, popup="The birthplace of R")
m  # Print the map


# add some circles to a map
df = data.frame(Lat = 1:10, Long = rnorm(10))
leaflet(df) %>% addCircles()


leaflet() %>% addCircles(data = df)
leaflet() %>% addCircles(data = df, lat = ~ Lat, lng = ~ Long)

library(maps)
mapStates = map("state", fill = TRUE, plot = FALSE)
leaflet(data = mapStates) %>% addTiles() %>%
  addPolygons(fillColor = topo.colors(10, alpha = NULL), stroke = FALSE)




" The Formula Interface"



m = leaflet() %>% addTiles()
df = data.frame(
  lat = rnorm(100),
  lng = rnorm(100),
  size = runif(100, 5, 20),
  color = sample(colors(), 100)
)
m = leaflet(df) %>% addTiles()
m %>% addCircleMarkers(radius = ~size, color = ~color, fill = FALSE)
m %>% addCircleMarkers(radius = runif(100, 4, 10), color = c('red'))




# Using Basemaps


m <- leaflet() %>% setView(lng = -71.0589, lat = 42.3601, zoom = 12)
m %>% addTiles()

# Third-Party Tiles

m %>% addProviderTiles(providers$Stamen.Toner)

m %>% addProviderTiles(providers$CartoDB.Positron)

m %>% addProviderTiles(providers$Esri.NatGeoWorldMap)

names(providers)





leaflet() %>% addTiles() %>% setView(-93.65, 42.0285, zoom = 4) %>%
  addWMSTiles(
    "http://mesonet.agron.iastate.edu/cgi-bin/wms/nexrad/n0r.cgi",
    layers = "nexrad-n0r-900913",
    options = WMSTileOptions(format = "image/png", transparent = TRUE),
    attribution = "Weather data © 2012 IEM Nexrad"
  )






m %>% addProviderTiles(providers$MtbMap) %>%
  addProviderTiles(providers$Stamen.TonerLines,
                   options = providerTileOptions(opacity = 0.35)) %>%
  addProviderTiles(providers$Stamen.TonerLabels)







# Icon Markers


data(quakes)

# Show first 20 rows from the `quakes` dataset
leaflet(data = quakes[1:20,]) %>% addTiles() %>%
  addMarkers(~long, ~lat, popup = ~as.character(mag), label = ~as.character(mag))


# Customizing Marker Icons


greenLeafIcon <- makeIcon(
  iconUrl = "https://leafletjs.com/examples/custom-icons/leaf-green.png",
  iconWidth = 38, iconHeight = 95,
  iconAnchorX = 22, iconAnchorY = 94,
  shadowUrl = "https://leafletjs.com/examples/custom-icons/leaf-shadow.png",
  shadowWidth = 50, shadowHeight = 64,
  shadowAnchorX = 4, shadowAnchorY = 62
)

leaflet(data = quakes[1:4,]) %>% addTiles() %>%
  addMarkers(~long, ~lat, icon = greenLeafIcon)


##########################################################
#> If you have several icons to apply that vary only by a couple
#>  of parameters (i.e. they share the same size and anchor points 
#>  but have different URLs), use the icons() function.
#>   icons() performs similarly to data.frame(), 
#>   in that any arguments that are shorter than the number of markers 
#>   will be recycled to fit.


quakes1 <- quakes[1:10,]

leafIcons <- icons(
  iconUrl = ifelse(quakes1$mag < 4.6,
                   "https://leafletjs.com/examples/custom-icons/leaf-green.png",
                   "https://leafletjs.com/examples/custom-icons/leaf-red.png"
  ),
  iconWidth = 38, iconHeight = 95,
  iconAnchorX = 22, iconAnchorY = 94,
  shadowUrl = "https://leafletjs.com/examples/custom-icons/leaf-shadow.png",
  shadowWidth = 50, shadowHeight = 64,
  shadowAnchorX = 4, shadowAnchorY = 62
)

leaflet(data = quakes1) %>% addTiles() %>%
  addMarkers(~long, ~lat, icon = leafIcons)

###########################################################################


#> Finally, if you have a set of icons that vary in multiple parameters,
#>  it may be more convenient to use the iconList() function. It lets you
#>   create a list of (named or unnamed) makeIcon() icons, and select from
#>    that list by position or name.
#>    


# Make a list of icons. We'll index into it based on name.
oceanIcons <- iconList(
  ship = makeIcon("ferry-18.png", "ferry-18@2x.png", 18, 18),
  pirate = makeIcon("danger-24.png", "danger-24@2x.png", 24, 24)
)

# Some fake data
df <- sp::SpatialPointsDataFrame(
  cbind(
    (runif(20) - .5) * 10 - 90.620130,  # lng
    (runif(20) - .5) * 3.8 + 25.638077  # lat
  ),
  data.frame(type = factor(
    ifelse(runif(20) > 0.75, "pirate", "ship"),
    c("ship", "pirate")
  ))
)

leaflet(df) %>% addTiles() %>%
  # Select from oceanIcons based on df$type
  addMarkers(icon = ~oceanIcons[type])


########################################################################


# Awesome Icons

#> Leaflet supports even more customizable markers using the awesome markers leaflet plugin.
#> The addAwesomeMarkers() function is similar to addMarkers() function but additionally allows you
#>  to specify custom colors for the markers as well as icons from the Font Awesome, Bootstrap Glyphicons, 
#>  and Ion icons icon libraries.
#>  
#>  
#>  Similar to the makeIcon, icons, and iconList functions described above, 
#>  you have makeAwesomeIcon, awesomeIcons and awesomeIconList functions,
#>   which enable you to add awesome icons.
#>   

# first 20 quakes
df.20 <- quakes[1:20,]

getColor <- function(quakes) {
  sapply(quakes$mag, function(mag) {
    if(mag <= 4) {
      "green"
    } else if(mag <= 5) {
      "orange"
    } else {
      "red"
    } })
}

icons <- awesomeIcons(
  icon = 'ios-close',
  iconColor = 'black',
  library = 'ion',
  markerColor = getColor(df.20)
)

leaflet(df.20) %>% addTiles() %>%
  addAwesomeMarkers(~long, ~lat, icon=icons, label=~as.character(mag))


#######################################################################

# Popups

content <- paste(sep = "<br/>",
                 "<b><a href='http://www.samurainoodle.com'>Samurai Noodle</a></b>",
                 "606 5th Ave. S",
                 "Seattle, WA 98138"
)

leaflet() %>% addTiles() %>%
  addPopups(-122.327298, 47.597131, content,
            options = popupOptions(closeButton = FALSE)
  )

##############################################################
# A common use for popups is to have them appear when markers or 
# shapes are clicked. Marker and shape functions in the Leaflet 
# package take a popup argument, where you can pass in HTML to 
# easily attach a simple popup.

library(htmltools)

df <- read.csv(textConnection(
  "Name,Lat,Long
Samurai Noodle,47.597131,-122.327298
Kukai Ramen,47.6154,-122.327157
Tsukushinbo,47.59987,-122.326726"
))

leaflet(df) %>% addTiles() %>%
  addMarkers(~Long, ~Lat, popup = ~htmlEscape(Name))



#####################################################################
states <- us_states()
counties <- us_counties() 
states

leaflet(counties) %>%
  addPolygons(color = "#444444", weight = 1, smoothFactor = 0.5,
              opacity = 1.0, fillOpacity = 0.5,
              fillColor = ~colorFactor("YlOrRd", name)(name),
              highlightOptions = highlightOptions(color = "white", weight = 2,
              bringToFront = TRUE))
                                                  
                                                  
                                                  
######################################################################                                                 
#define color palettes for states
pal <- brewer.pal(12, "Set3")
statePal <- colorFactor(pal, states$name)

leaflet(states) %>% 
#  addTiles() %>% 
  addPolygons(data = counties, 
              fillColor = ~statePal(states$name), 
              fillOpacity = 1, 
              color = "white", 
              stroke = T, 
              weight = 1)                                                 
                                                                                                    
