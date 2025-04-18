---
title: "Leaflet Day 1: COVID Class Activity"
author: "David Palmer"
date: "July 04, 2023"
output:
  html_document:  
    keep_md: true
    toc: true
    toc_float: true
    code_folding: hide
    fig_height: 6
    fig_width: 12
    fig_align: 'center'
---





Practice Using Leaflet for Interactive Maps 

- We will use leaflet to create interactive maps of the cumulative confirmed cases of COVID-19.
- First, we will plot the cities with the most confirmed cases.

Note, rather than doing copying and pasting, you may learn more by actually typing things out. This will force your mind to actually read over and digest the syntax.

Read in the COVID data. Replace the stars with the last date in the dataset or a date of your choice using the format m/d/y. (For example, March 9th, 2021 would be 3/9/21). This will give us a column called "confirmed" that contains the cumulative confirmed cases up to that date. 


```r
# Use this R-Chunk to import all your datasets!
covid <- read_csv("https://raw.githubusercontent.com/CSSEGISandData/COVID-19/master/csse_covid_19_data/csse_covid_19_time_series/time_series_covid19_confirmed_US.csv") %>% 
  
  rename(confirmed = `2/29/20`) #replace the stars with the most recent date in the dataset (i.e. the last column)
```

Take a minute to look at the data and understand it's structure.

## Plotting the Top Cities

We will plot just a few cities that had the most COVID cases (cumulative). You get to decide how many cities to plot. (I'd recommend somewhere between 20 and 40). The code in the next chunk selects just those cities and stores it in the a new dataset.

Don't forget to fill in the other blank in the code below.


```r
# Use this R-Chunk to clean & wrangle your data!
# dont know yet why this doesnt work 
covid_top_cities <- covid %>% 
  slice_max(confirmed) %>% 
  dplyr::select(confirmed, everything()) #This line reorders the columns so that `confirmed` is first, followed by everything else


covid_top_cities <- covid %>% arrange(desc(confirmed)) %>% top_n(35) %>% dplyr::select(confirmed, everything())

#version
```

Now create a plot with a marker placed in the location of each of the top cities.
Note the use of the ~ in order to reference a column name.


```r
leaflet(data=covid_top_cities) %>% addTiles() %>% 
  addMarkers(lng = ~Long_, lat = ~Lat)
```

```{=html}
<div class="leaflet html-widget html-fill-item-overflow-hidden html-fill-item" id="htmlwidget-124bdbc2eb83454250bd" style="width:1152px;height:576px;"></div>
<script type="application/json" data-for="htmlwidget-124bdbc2eb83454250bd">{"x":{"options":{"crs":{"crsClass":"L.CRS.EPSG3857","code":null,"proj4def":null,"projectedBounds":null,"options":{}}},"calls":[{"method":"addTiles","args":["https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",null,null,{"minZoom":0,"maxZoom":18,"tileSize":256,"subdomains":"abc","errorTileUrl":"","tms":false,"noWrap":false,"zoomOffset":0,"zoomReverse":false,"opacity":1,"zIndex":1,"detectRetina":false,"attribution":"&copy; <a href=\"https://openstreetmap.org\">OpenStreetMap<\/a> contributors, <a href=\"https://creativecommons.org/licenses/by-sa/2.0/\">CC-BY-SA<\/a>"}]},{"method":"addMarkers","args":[[47.49137892,33.03484597,41.84144849,33.34835867,34.30828379,33.70147516,33.74314981,37.23104908,37.64629437,38.45106826,34.84060306,26.15184651,27.9276559,25.6112362,28.51367621,26.64676272,42.48607732,42.66090111,42.28098405,45.00761521,36.21458855,40.85209301,40.6361825,40.74066522,40.7672726,40.71088124,40.88320119,35.24469268,35.78879266,40.00338507,29.44928723,32.76670599,29.85864939,32.77143818,40.66616532],[-121.8346131,-116.7365326,-87.81658794,-112.4918154,-118.2282411,-117.7645998,-115.9933578,-121.6970462,-121.8929271,-121.3425374,-116.1774685,-80.48725556,-82.32013172,-80.55170587,-81.31799498,-80.46536002,-71.39049229,-83.38595416,-83.281255,-93.47694895,-115.0130241,-73.86282755,-73.94935552,-73.58941873,-73.97152637,-73.81684712,-72.8012172,-80.8317671,-78.65249174,-75.1379271,-98.52019748,-96.7779605,-95.39339521,-97.29101614,-111.9216011],null,null,null,{"interactive":true,"draggable":false,"keyboard":true,"title":"","alt":"","zIndexOffset":0,"opacity":1,"riseOnHover":false,"riseOffset":250},null,null,null,null,null,{"interactive":false,"permanent":false,"direction":"auto","opacity":1,"offset":[0,0],"textsize":"10px","textOnly":false,"className":"","sticky":true},null]}],"limits":{"lat":[25.6112362,47.49137892],"lng":[-121.8929271,-71.39049229]}},"evals":[],"jsHooks":[]}</script>
```

Alternatively, you can change the underlying tiles of the base map to something provided by a third-party. Type the first three letters in the blank to use the auto-fill feature to find an option you like (they don't all work because some require registration with the third-party). You can preview the tile maps and their names: http://leaflet-extras.github.io/leaflet-providers/preview/index.html. 

Take a couple of minutes to play with different third-party tiles and find one that you like or that is unique. 


```r
leaflet(data = covid_top_cities) %>% addProviderTiles(providers$Esri.NatGeoWorldMap) %>% 
  addMarkers(lng = ~Long_, lat = ~Lat)
```

```{=html}
<div class="leaflet html-widget html-fill-item-overflow-hidden html-fill-item" id="htmlwidget-62a608b38189d62db1d2" style="width:1152px;height:576px;"></div>
<script type="application/json" data-for="htmlwidget-62a608b38189d62db1d2">{"x":{"options":{"crs":{"crsClass":"L.CRS.EPSG3857","code":null,"proj4def":null,"projectedBounds":null,"options":{}}},"calls":[{"method":"addProviderTiles","args":["Esri.NatGeoWorldMap",null,null,{"errorTileUrl":"","noWrap":false,"detectRetina":false}]},{"method":"addMarkers","args":[[47.49137892,33.03484597,41.84144849,33.34835867,34.30828379,33.70147516,33.74314981,37.23104908,37.64629437,38.45106826,34.84060306,26.15184651,27.9276559,25.6112362,28.51367621,26.64676272,42.48607732,42.66090111,42.28098405,45.00761521,36.21458855,40.85209301,40.6361825,40.74066522,40.7672726,40.71088124,40.88320119,35.24469268,35.78879266,40.00338507,29.44928723,32.76670599,29.85864939,32.77143818,40.66616532],[-121.8346131,-116.7365326,-87.81658794,-112.4918154,-118.2282411,-117.7645998,-115.9933578,-121.6970462,-121.8929271,-121.3425374,-116.1774685,-80.48725556,-82.32013172,-80.55170587,-81.31799498,-80.46536002,-71.39049229,-83.38595416,-83.281255,-93.47694895,-115.0130241,-73.86282755,-73.94935552,-73.58941873,-73.97152637,-73.81684712,-72.8012172,-80.8317671,-78.65249174,-75.1379271,-98.52019748,-96.7779605,-95.39339521,-97.29101614,-111.9216011],null,null,null,{"interactive":true,"draggable":false,"keyboard":true,"title":"","alt":"","zIndexOffset":0,"opacity":1,"riseOnHover":false,"riseOffset":250},null,null,null,null,null,{"interactive":false,"permanent":false,"direction":"auto","opacity":1,"offset":[0,0],"textsize":"10px","textOnly":false,"className":"","sticky":true},null]}],"limits":{"lat":[25.6112362,47.49137892],"lng":[-121.8929271,-71.39049229]}},"evals":[],"jsHooks":[]}</script>
```


Consider the next chunk of code where we set some defaults for the map. What is this setView() doing and what values should you put in the blanks?


```r
leaflet(data=covid_top_cities) %>% addTiles() %>% 
  setView(lng = -97, lat = 38, zoom = 3) %>% 
  addMarkers(lng = ~Long_, lat = ~Lat)
```

```{=html}
<div class="leaflet html-widget html-fill-item-overflow-hidden html-fill-item" id="htmlwidget-6bd7377c271791f1bf6f" style="width:1152px;height:576px;"></div>
<script type="application/json" data-for="htmlwidget-6bd7377c271791f1bf6f">{"x":{"options":{"crs":{"crsClass":"L.CRS.EPSG3857","code":null,"proj4def":null,"projectedBounds":null,"options":{}}},"calls":[{"method":"addTiles","args":["https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",null,null,{"minZoom":0,"maxZoom":18,"tileSize":256,"subdomains":"abc","errorTileUrl":"","tms":false,"noWrap":false,"zoomOffset":0,"zoomReverse":false,"opacity":1,"zIndex":1,"detectRetina":false,"attribution":"&copy; <a href=\"https://openstreetmap.org\">OpenStreetMap<\/a> contributors, <a href=\"https://creativecommons.org/licenses/by-sa/2.0/\">CC-BY-SA<\/a>"}]},{"method":"addMarkers","args":[[47.49137892,33.03484597,41.84144849,33.34835867,34.30828379,33.70147516,33.74314981,37.23104908,37.64629437,38.45106826,34.84060306,26.15184651,27.9276559,25.6112362,28.51367621,26.64676272,42.48607732,42.66090111,42.28098405,45.00761521,36.21458855,40.85209301,40.6361825,40.74066522,40.7672726,40.71088124,40.88320119,35.24469268,35.78879266,40.00338507,29.44928723,32.76670599,29.85864939,32.77143818,40.66616532],[-121.8346131,-116.7365326,-87.81658794,-112.4918154,-118.2282411,-117.7645998,-115.9933578,-121.6970462,-121.8929271,-121.3425374,-116.1774685,-80.48725556,-82.32013172,-80.55170587,-81.31799498,-80.46536002,-71.39049229,-83.38595416,-83.281255,-93.47694895,-115.0130241,-73.86282755,-73.94935552,-73.58941873,-73.97152637,-73.81684712,-72.8012172,-80.8317671,-78.65249174,-75.1379271,-98.52019748,-96.7779605,-95.39339521,-97.29101614,-111.9216011],null,null,null,{"interactive":true,"draggable":false,"keyboard":true,"title":"","alt":"","zIndexOffset":0,"opacity":1,"riseOnHover":false,"riseOffset":250},null,null,null,null,null,{"interactive":false,"permanent":false,"direction":"auto","opacity":1,"offset":[0,0],"textsize":"10px","textOnly":false,"className":"","sticky":true},null]}],"setView":[[38,-97],3,[]],"limits":{"lat":[25.6112362,47.49137892],"lng":[-121.8929271,-71.39049229]}},"evals":[],"jsHooks":[]}</script>
```

Let's add labels to the markers so we know the name of the city and the cumulative # of confirmed cases. In addition to blanks, this code has 3 errors in it. One will prevent the code from running, the others are just mistakes. Can you find and correct them?


```r
# Use this R-Chunk to plot & visualize your data!
leaflet(data=covid_top_cities) %>% addTiles() %>% 
  setView(lng = -97, lat = 38, zoom = 4) %>%  
  addMarkers(lng = ~Long_, lat = ~Lat, label = paste(covid_top_cities$Admin2, "confirmed" , "=", covid_top_cities$confirmed))
```

```{=html}
<div class="leaflet html-widget html-fill-item-overflow-hidden html-fill-item" id="htmlwidget-9556441e6c208aa54569" style="width:1152px;height:576px;"></div>
<script type="application/json" data-for="htmlwidget-9556441e6c208aa54569">{"x":{"options":{"crs":{"crsClass":"L.CRS.EPSG3857","code":null,"proj4def":null,"projectedBounds":null,"options":{}}},"calls":[{"method":"addTiles","args":["https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",null,null,{"minZoom":0,"maxZoom":18,"tileSize":256,"subdomains":"abc","errorTileUrl":"","tms":false,"noWrap":false,"zoomOffset":0,"zoomReverse":false,"opacity":1,"zIndex":1,"detectRetina":false,"attribution":"&copy; <a href=\"https://openstreetmap.org\">OpenStreetMap<\/a> contributors, <a href=\"https://creativecommons.org/licenses/by-sa/2.0/\">CC-BY-SA<\/a>"}]},{"method":"addMarkers","args":[[47.49137892,33.03484597,41.84144849,33.34835867,34.30828379,33.70147516,33.74314981,37.23104908,37.64629437,38.45106826,34.84060306,26.15184651,27.9276559,25.6112362,28.51367621,26.64676272,42.48607732,42.66090111,42.28098405,45.00761521,36.21458855,40.85209301,40.6361825,40.74066522,40.7672726,40.71088124,40.88320119,35.24469268,35.78879266,40.00338507,29.44928723,32.76670599,29.85864939,32.77143818,40.66616532],[-121.8346131,-116.7365326,-87.81658794,-112.4918154,-118.2282411,-117.7645998,-115.9933578,-121.6970462,-121.8929271,-121.3425374,-116.1774685,-80.48725556,-82.32013172,-80.55170587,-81.31799498,-80.46536002,-71.39049229,-83.38595416,-83.281255,-93.47694895,-115.0130241,-73.86282755,-73.94935552,-73.58941873,-73.97152637,-73.81684712,-72.8012172,-80.8317671,-78.65249174,-75.1379271,-98.52019748,-96.7779605,-95.39339521,-97.29101614,-111.9216011],null,null,null,{"interactive":true,"draggable":false,"keyboard":true,"title":"","alt":"","zIndexOffset":0,"opacity":1,"riseOnHover":false,"riseOffset":250},null,null,null,null,["King confirmed = 6","San Diego confirmed = 2","Cook confirmed = 2","Maricopa confirmed = 1","Los Angeles confirmed = 1","Orange confirmed = 1","Riverside confirmed = 1","Santa Clara confirmed = 1","Alameda confirmed = 0","Sacramento confirmed = 0","San Bernardino confirmed = 0","Broward confirmed = 0","Hillsborough confirmed = 0","Miami-Dade confirmed = 0","Orange confirmed = 0","Palm Beach confirmed = 0","Middlesex confirmed = 0","Oakland confirmed = 0","Wayne confirmed = 0","Hennepin confirmed = 0","Clark confirmed = 0","Bronx confirmed = 0","Kings confirmed = 0","Nassau confirmed = 0","New York confirmed = 0","Queens confirmed = 0","Suffolk confirmed = 0","Mecklenburg confirmed = 0","Wake confirmed = 0","Philadelphia confirmed = 0","Bexar confirmed = 0","Dallas confirmed = 0","Harris confirmed = 0","Tarrant confirmed = 0","Salt Lake confirmed = 0"],{"interactive":false,"permanent":false,"direction":"auto","opacity":1,"offset":[0,0],"textsize":"10px","textOnly":false,"className":"","sticky":true},null]}],"setView":[[38,-97],4,[]],"limits":{"lat":[25.6112362,47.49137892],"lng":[-121.8929271,-71.39049229]}},"evals":[],"jsHooks":[]}</script>
```

## Circles on the map

Instead of markers we would like to use circles on the map. Let's encode the number of cases into the size of the circles.


```r
leaflet(data=covid_top_cities) %>% addTiles() %>% 
  setView(lng = -99, lat = 40, zoom = 4) %>% 
  addCircles(lng = ~Long_, lat = ~Lat, 
        radius = ~sqrt(confirmed)* 200000,
        label = ~paste(covid_top_cities$Admin2, "confirmed" , "=", covid_top_cities$confirmed))
```

```{=html}
<div class="leaflet html-widget html-fill-item-overflow-hidden html-fill-item" id="htmlwidget-a5974ccf639dd5fd21b3" style="width:1152px;height:576px;"></div>
<script type="application/json" data-for="htmlwidget-a5974ccf639dd5fd21b3">{"x":{"options":{"crs":{"crsClass":"L.CRS.EPSG3857","code":null,"proj4def":null,"projectedBounds":null,"options":{}}},"calls":[{"method":"addTiles","args":["https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",null,null,{"minZoom":0,"maxZoom":18,"tileSize":256,"subdomains":"abc","errorTileUrl":"","tms":false,"noWrap":false,"zoomOffset":0,"zoomReverse":false,"opacity":1,"zIndex":1,"detectRetina":false,"attribution":"&copy; <a href=\"https://openstreetmap.org\">OpenStreetMap<\/a> contributors, <a href=\"https://creativecommons.org/licenses/by-sa/2.0/\">CC-BY-SA<\/a>"}]},{"method":"addCircles","args":[[47.49137892,33.03484597,41.84144849,33.34835867,34.30828379,33.70147516,33.74314981,37.23104908,37.64629437,38.45106826,34.84060306,26.15184651,27.9276559,25.6112362,28.51367621,26.64676272,42.48607732,42.66090111,42.28098405,45.00761521,36.21458855,40.85209301,40.6361825,40.74066522,40.7672726,40.71088124,40.88320119,35.24469268,35.78879266,40.00338507,29.44928723,32.76670599,29.85864939,32.77143818,40.66616532],[-121.8346131,-116.7365326,-87.81658794,-112.4918154,-118.2282411,-117.7645998,-115.9933578,-121.6970462,-121.8929271,-121.3425374,-116.1774685,-80.48725556,-82.32013172,-80.55170587,-81.31799498,-80.46536002,-71.39049229,-83.38595416,-83.281255,-93.47694895,-115.0130241,-73.86282755,-73.94935552,-73.58941873,-73.97152637,-73.81684712,-72.8012172,-80.8317671,-78.65249174,-75.1379271,-98.52019748,-96.7779605,-95.39339521,-97.29101614,-111.9216011],[489897.948556636,282842.712474619,282842.712474619,200000,200000,200000,200000,200000,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],null,null,{"interactive":true,"className":"","stroke":true,"color":"#03F","weight":5,"opacity":0.5,"fill":true,"fillColor":"#03F","fillOpacity":0.2},null,null,["King confirmed = 6","San Diego confirmed = 2","Cook confirmed = 2","Maricopa confirmed = 1","Los Angeles confirmed = 1","Orange confirmed = 1","Riverside confirmed = 1","Santa Clara confirmed = 1","Alameda confirmed = 0","Sacramento confirmed = 0","San Bernardino confirmed = 0","Broward confirmed = 0","Hillsborough confirmed = 0","Miami-Dade confirmed = 0","Orange confirmed = 0","Palm Beach confirmed = 0","Middlesex confirmed = 0","Oakland confirmed = 0","Wayne confirmed = 0","Hennepin confirmed = 0","Clark confirmed = 0","Bronx confirmed = 0","Kings confirmed = 0","Nassau confirmed = 0","New York confirmed = 0","Queens confirmed = 0","Suffolk confirmed = 0","Mecklenburg confirmed = 0","Wake confirmed = 0","Philadelphia confirmed = 0","Bexar confirmed = 0","Dallas confirmed = 0","Harris confirmed = 0","Tarrant confirmed = 0","Salt Lake confirmed = 0"],{"interactive":false,"permanent":false,"direction":"auto","opacity":1,"offset":[0,0],"textsize":"10px","textOnly":false,"className":"","sticky":true},null,null]}],"setView":[[40,-99],4,[]],"limits":{"lat":[25.6112362,47.49137892],"lng":[-121.8929271,-71.39049229]}},"evals":[],"jsHooks":[]}</script>
```


In addition to circle size, we will encode the cumulative confirmed case count into the color of the circle. This is not as simple and straight forward as one would like. It is explained here: https://rstudio.github.io/leaflet/colors.html

First the set-up

```r
pal<-colorNumeric(palette = c("yellow", "red"), domain = covid_top_cities$confirmed/10)

pal #this is to see what pal contains/is
```

```
## function (x) 
## {
##     if (length(x) == 0 || all(is.na(x))) {
##         return(pf(x))
##     }
##     if (is.null(rng)) 
##         rng <- range(x, na.rm = TRUE)
##     rescaled <- scales::rescale(x, from = rng)
##     if (any(rescaled < 0 | rescaled > 1, na.rm = TRUE)) 
##         warning("Some values were outside the color scale and will be treated as NA")
##     if (reverse) {
##         rescaled <- 1 - rescaled
##     }
##     pf(rescaled)
## }
## <bytecode: 0x00000200db5e1e00>
## <environment: 0x00000200db5e0820>
## attr(,"colorType")
## [1] "numeric"
## attr(,"colorArgs")
## attr(,"colorArgs")$na.color
## [1] "#808080"
```

Take the time to answer the following questions about the above line of code:

- What is the domain argument providing? What is it used for?
- Why are we dividing the confirmed cases by 10? (try the plot without dividing it to see)
- What is pal?

Now to actually create the plot. **Can you find the 2 errors?**


```r
leaflet(data=covid_top_cities) %>% addTiles() %>% 
  setView(lng = -99, lat = 40, zoom = 4) %>% 
  addCircles(lng = ~Long_, lat = ~Lat, 
             radius = ~covid_top_cities$confirmed/10,
             label = ~paste0(Admin2," County = ", covid_top_cities$confirmed , " confirmed cases"), 
             fillOpacity = .1,
             color = ~pal(covid_top_cities$confirmed/10),  #color is the border color
             fillColor =  pal(covid_top_cities$confirmed)) #notice the domain above must match exactly what is fed to pal
```

```{=html}
<div class="leaflet html-widget html-fill-item-overflow-hidden html-fill-item" id="htmlwidget-5f1adb644c602ed1279a" style="width:1152px;height:576px;"></div>
<script type="application/json" data-for="htmlwidget-5f1adb644c602ed1279a">{"x":{"options":{"crs":{"crsClass":"L.CRS.EPSG3857","code":null,"proj4def":null,"projectedBounds":null,"options":{}}},"calls":[{"method":"addTiles","args":["https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",null,null,{"minZoom":0,"maxZoom":18,"tileSize":256,"subdomains":"abc","errorTileUrl":"","tms":false,"noWrap":false,"zoomOffset":0,"zoomReverse":false,"opacity":1,"zIndex":1,"detectRetina":false,"attribution":"&copy; <a href=\"https://openstreetmap.org\">OpenStreetMap<\/a> contributors, <a href=\"https://creativecommons.org/licenses/by-sa/2.0/\">CC-BY-SA<\/a>"}]},{"method":"addCircles","args":[[47.49137892,33.03484597,41.84144849,33.34835867,34.30828379,33.70147516,33.74314981,37.23104908,37.64629437,38.45106826,34.84060306,26.15184651,27.9276559,25.6112362,28.51367621,26.64676272,42.48607732,42.66090111,42.28098405,45.00761521,36.21458855,40.85209301,40.6361825,40.74066522,40.7672726,40.71088124,40.88320119,35.24469268,35.78879266,40.00338507,29.44928723,32.76670599,29.85864939,32.77143818,40.66616532],[-121.8346131,-116.7365326,-87.81658794,-112.4918154,-118.2282411,-117.7645998,-115.9933578,-121.6970462,-121.8929271,-121.3425374,-116.1774685,-80.48725556,-82.32013172,-80.55170587,-81.31799498,-80.46536002,-71.39049229,-83.38595416,-83.281255,-93.47694895,-115.0130241,-73.86282755,-73.94935552,-73.58941873,-73.97152637,-73.81684712,-72.8012172,-80.8317671,-78.65249174,-75.1379271,-98.52019748,-96.7779605,-95.39339521,-97.29101614,-111.9216011],[0.6,0.2,0.2,0.1,0.1,0.1,0.1,0.1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],null,null,{"interactive":true,"className":"","stroke":true,"color":["#FF0000","#FFC200","#FFC200","#FFE100","#FFE100","#FFE100","#FFE100","#FFE100","#FFFF00","#FFFF00","#FFFF00","#FFFF00","#FFFF00","#FFFF00","#FFFF00","#FFFF00","#FFFF00","#FFFF00","#FFFF00","#FFFF00","#FFFF00","#FFFF00","#FFFF00","#FFFF00","#FFFF00","#FFFF00","#FFFF00","#FFFF00","#FFFF00","#FFFF00","#FFFF00","#FFFF00","#FFFF00","#FFFF00","#FFFF00"],"weight":5,"opacity":0.5,"fill":true,"fillColor":["#808080","#808080","#808080","#808080","#808080","#808080","#808080","#808080","#FFFF00","#FFFF00","#FFFF00","#FFFF00","#FFFF00","#FFFF00","#FFFF00","#FFFF00","#FFFF00","#FFFF00","#FFFF00","#FFFF00","#FFFF00","#FFFF00","#FFFF00","#FFFF00","#FFFF00","#FFFF00","#FFFF00","#FFFF00","#FFFF00","#FFFF00","#FFFF00","#FFFF00","#FFFF00","#FFFF00","#FFFF00"],"fillOpacity":0.1},null,null,["King County = 6 confirmed cases","San Diego County = 2 confirmed cases","Cook County = 2 confirmed cases","Maricopa County = 1 confirmed cases","Los Angeles County = 1 confirmed cases","Orange County = 1 confirmed cases","Riverside County = 1 confirmed cases","Santa Clara County = 1 confirmed cases","Alameda County = 0 confirmed cases","Sacramento County = 0 confirmed cases","San Bernardino County = 0 confirmed cases","Broward County = 0 confirmed cases","Hillsborough County = 0 confirmed cases","Miami-Dade County = 0 confirmed cases","Orange County = 0 confirmed cases","Palm Beach County = 0 confirmed cases","Middlesex County = 0 confirmed cases","Oakland County = 0 confirmed cases","Wayne County = 0 confirmed cases","Hennepin County = 0 confirmed cases","Clark County = 0 confirmed cases","Bronx County = 0 confirmed cases","Kings County = 0 confirmed cases","Nassau County = 0 confirmed cases","New York County = 0 confirmed cases","Queens County = 0 confirmed cases","Suffolk County = 0 confirmed cases","Mecklenburg County = 0 confirmed cases","Wake County = 0 confirmed cases","Philadelphia County = 0 confirmed cases","Bexar County = 0 confirmed cases","Dallas County = 0 confirmed cases","Harris County = 0 confirmed cases","Tarrant County = 0 confirmed cases","Salt Lake County = 0 confirmed cases"],{"interactive":false,"permanent":false,"direction":"auto","opacity":1,"offset":[0,0],"textsize":"10px","textOnly":false,"className":"","sticky":true},null,null]}],"setView":[[40,-99],4,[]],"limits":{"lat":[25.6112362,47.49137892],"lng":[-121.8929271,-71.39049229]}},"evals":[],"jsHooks":[]}</script>
```


## Big Data and Spatial Data

Pause to read the following article: Spatial Data Often Becomes Big Data
https://blogs.esri.com/esri/arcgis/2017/10/17/strategies-to-effectively-display-large-amounts-of-data-in-web-apps/

Identify the 4 stratagies for displaying map data. Consider recording them in your Readme.md

1. Display data that is important
2. Aggregate the data into equal-sized hexagons (hexbins) to visualize patterns
3. Use scale visibility and/or multiscale rendering to show information when it is visually helpful.
4. Use clustering to group points into one symbol and apply Smart Mapping Styles

Time permitting, read through the [Leaflet guide](https://rstudio.github.io/leaflet/) and find 1-2 additional map features you would like to play with.
