

install.packages("sf")
install.packages("USA.state.boundaries")


#install.packages(“USAboundaries”, repos = “https://ropensci.r-universe.dev”, type = “source”)
#install.packages(“USAboundariesData”, repos = “https://ropensci.r-universe.dev”, type = “source”)


remotes::install_github("ropensci/USAboundaries")
remotes::install_github("ropensci/USAboundariesData")


install.packages(ropensci)
library(sf, warn.conflicts = F)
library(tidyverse)
# The counties of North Carolina
nc <- read_sf(system.file("shape/nc.shp", package = "sf"))


glimpse(nc$geometry)
view(nc)
nc

#------------------ another way to get the data ----------------------


library(USAboundaries)
nc2 <- us_counties(states = "NC")
nc2




str(nc$geometry[[1]])


plot(nc$geometry)



plot(nc$geometry[[1]]) #This just plots the polygon(s) in the first item in the list column




n <- nc$geometry %>% map_int(length)
table(n)
 #>This will show that 94 rows of the geometry column are lists with just one element,
 #> 4 rows have lists with 2 elements, and 2 rows have lists with 3 elements (i.e. nested lists)
 #> 
 
interesting <- nc$geometry[n == 3][[1]] #filter the column to only include the list with 3 elements
plot(interesting)




########################################################################################

library(sf)
## Linking to GEOS 3.10.2, GDAL 3.4.1, PROJ 8.2.1; sf_use_s2() is TRUE
nc3 <- st_read(system.file("shape/nc.shp", package = "sf"))
## Reading layer `nc' from data source 
##   `/home/runner/work/_temp/Library/sf/shape/nc.shp' using driver `ESRI Shapefile'
## Simple feature collection with 100 features and 14 fields
## Geometry type: MULTIPOLYGON
## Dimension:     XY
## Bounding box:  xmin: -84.32385 ymin: 33.88199 xmax: -75.45698 ymax: 36.58965
## Geodetic CRS:  NAD27

nc3
attr(nc3, "sf_column")
## [1] "geometry"




print(nc[9:15], n = 3)




methods(class = "sf")
##  [1] [                            [[<-                        
##  [3] $<-                          aggregate                   
##  [5] as.data.frame                cbind                       
##  [7] coerce                       dbDataType                  
##  [9] dbWriteTable                 duplicated                  
## [11] filter                       identify                    
## [13] initialize                   merge                       
## [15] plot                         print                       
## [17] rbind                        show                        
## [19] slotsFromS3                  st_agr                      
## [21] st_agr<-                     st_area                     
## [23] st_as_s2                     st_as_sf                    
## [25] st_as_sfc                    st_bbox                     
## [27] st_boundary                  st_break_antimeridian       
## [29] st_buffer                    st_cast                     
## [31] st_centroid                  st_collection_extract       
## [33] st_concave_hull              st_convex_hull              
## [35] st_coordinates               st_crop                     
## [37] st_crs                       st_crs<-                    
## [39] st_difference                st_drop_geometry            
## [41] st_filter                    st_geometry                 
## [43] st_geometry<-                st_inscribed_circle         
## [45] st_interpolate_aw            st_intersection             
## [47] st_intersects                st_is_valid                 
## [49] st_is                        st_join                     
## [51] st_line_merge                st_m_range                  
## [53] st_make_valid                st_minimum_rotated_rectangle
## [55] st_nearest_points            st_node                     
## [57] st_normalize                 st_point_on_surface         
## [59] st_polygonize                st_precision                
## [61] st_reverse                   st_sample                   
## [63] st_segmentize                st_set_precision            
## [65] st_shift_longitude           st_simplify                 
## [67] st_snap                      st_sym_difference           
## [69] st_transform                 st_triangulate_constrained  
## [71] st_triangulate               st_union                    
## [73] st_voronoi                   st_wrap_dateline            
## [75] st_write                     st_z_range                  
## [77] st_zm                        transform                   
## see '?methods' for accessing help and source code


(nc_geom <- st_geometry(nc3))
## Geometry set for 100 features 
## Geometry type: MULTIPOLYGON
## Dimension:     XY
## Bounding box:  xmin: -84.32385 ymin: 33.88199 xmax: -75.45698 ymax: 36.58965
## Geodetic CRS:  NAD27
## First 5 geometries:
## MULTIPOLYGON (((-81.47276 36.23436, -81.54084 3...
## MULTIPOLYGON (((-81.23989 36.36536, -81.24069 3...
## MULTIPOLYGON (((-80.45634 36.24256, -80.47639 3...
## MULTIPOLYGON (((-76.00897 36.3196, -76.01735 36...
## MULTIPOLYGON (((-77.21767 36.24098, -77.23461 3...



nc_geom[[1]]
#> MULTIPOLYGON (((-81.47276 36.23436, -81.54084 36.27251, -81.56198 36.27359, 
#> -81.63306 36.34069, -81.74107 36.39178, -81.69828 36.47178, -81.7028 36.51934,
#>  -81.67 36.58965, -81.3453 36.57286, -81.34754 36.53791, -81.32478 36.51368, 
#>  -81.31332 36.4807, -81.26624 36.43721, -81.26284 36.40504, -81.24069 36.37942,
#>   -81.23989 36.36536, -81.26424 36.35241, -81.32899 36.3635, -81.36137 36.35316,
#>    -81.36569 36.33905, -81.35413 36.29972, -81.36745 36.2787, -81.40639 36.28505,
#>     -81.41233 36.26729, -81.43104 36.26072, -81.45289 36.23959, -81.47276 36.23436)))
#>     
#>     


par(mar = c(0,0,1,0))
plot(nc[1], reset = FALSE) # reset = FALSE: we want to add to a plot with a legend
plot(nc[1,1], col = 'grey', add = TRUE)



par(mar = c(0,0,1,0))
(w <- which(sapply(nc_geom, length) > 1))
## [1]  4 56 57 87 91 95
plot(nc[w,1], col = 2:7)



methods(class = 'sfc')
##  [1] [                            [<-                         
##  [3] as.data.frame                c                           
##  [5] coerce                       format                      
##  [7] identify                     initialize                  
##  [9] Ops                          print                       
## [11] rep                          show                        
## [13] slotsFromS3                  st_area                     
## [15] st_as_binary                 st_as_grob                  
## [17] st_as_s2                     st_as_sf                    
## [19] st_as_text                   st_bbox                     
## [21] st_boundary                  st_break_antimeridian       
## [23] st_buffer                    st_cast                     
## [25] st_centroid                  st_collection_extract       
## [27] st_concave_hull              st_convex_hull              
## [29] st_coordinates               st_crop                     
## [31] st_crs                       st_crs<-                    
## [33] st_difference                st_geometry                 
## [35] st_inscribed_circle          st_intersection             
## [37] st_intersects                st_is_valid                 
## [39] st_is                        st_line_merge               
## [41] st_m_range                   st_make_valid               
## [43] st_minimum_rotated_rectangle st_nearest_points           
## [45] st_node                      st_normalize                
## [47] st_point_on_surface          st_polygonize               
## [49] st_precision                 st_reverse                  
## [51] st_sample                    st_segmentize               
## [53] st_set_precision             st_shift_longitude          
## [55] st_simplify                  st_snap                     
## [57] st_sym_difference            st_transform                
## [59] st_triangulate_constrained   st_triangulate              
## [61] st_union                     st_voronoi                  
## [63] st_wrap_dateline             st_write                    
## [65] st_z_range                   st_zm                       
## [67] str                          summary                     
## [69] vec_cast.sfc                 vec_ptype2.sfc              
## see '?methods' for accessing help and source code


attributes(nc_geom)
## $n_empty
## [1] 0
## 
## $crs
## Coordinate Reference System:
##   User input: NAD27 
##   wkt:
## GEOGCRS["NAD27",
##     DATUM["North American Datum 1927",
##         ELLIPSOID["Clarke 1866",6378206.4,294.978698213898,
##             LENGTHUNIT["metre",1]]],
##     PRIMEM["Greenwich",0,
##         ANGLEUNIT["degree",0.0174532925199433]],
##     CS[ellipsoidal,2],
##         AXIS["latitude",north,
##             ORDER[1],
##             ANGLEUNIT["degree",0.0174532925199433]],
##         AXIS["longitude",east,
##             ORDER[2],
##             ANGLEUNIT["degree",0.0174532925199433]],
##     ID["EPSG",4267]]
## 
## $class
## [1] "sfc_MULTIPOLYGON" "sfc"             
## 
## $precision
## [1] 0
## 
## $bbox
##      xmin      ymin      xmax      ymax 
## -84.32385  33.88199 -75.45698  36.58965



(mix <- st_sfc(st_geometrycollection(list(st_point(1:2))),
               st_geometrycollection(list(st_linestring(matrix(1:4,2))))))
## Geometry set for 2 features 
## Geometry type: GEOMETRYCOLLECTION
## Dimension:     XY
## Bounding box:  xmin: 1 ymin: 2 xmax: 2 ymax: 4
## CRS:           NA
## GEOMETRYCOLLECTION (POINT (1 2))
## GEOMETRYCOLLECTION (LINESTRING (1 3, 2 4))
class(mix)
## [1] "sfc_GEOMETRYCOLLECTION" "sfc"



















##################################### manual creation for ilustration ####################


(x <- st_point(c(1,2)))
## POINT (1 2)
str(x)
##  'XY' num [1:2] 1 2
(x <- st_point(c(1,2,3)))
## POINT Z (1 2 3)
str(x)
##  'XYZ' num [1:3] 1 2 3
(x <- st_point(c(1,2,3), "XYM"))
## POINT M (1 2 3)
str(x)
##  'XYM' num [1:3] 1 2 3
(x <- st_point(c(1,2,3,4)))
## POINT ZM (1 2 3 4)
str(x)
##  'XYZM' num [1:4] 1 2 3 4
st_zm(x, drop = TRUE, what = "ZM")
## POINT (1 2)


p <- rbind(c(3.2,4), c(3,4.6), c(3.8,4.4), c(3.5,3.8), c(3.4,3.6), c(3.9,4.5))
(mp <- st_multipoint(p))
## MULTIPOINT ((3.2 4), (3 4.6), (3.8 4.4), (3.5 3.8), (3.4 3.6), (3.9 4.5))
s1 <- rbind(c(0,3),c(0,4),c(1,5),c(2,5))
(ls <- st_linestring(s1))
## LINESTRING (0 3, 0 4, 1 5, 2 5)
s2 <- rbind(c(0.2,3), c(0.2,4), c(1,4.8), c(2,4.8))
s3 <- rbind(c(0,4.4), c(0.6,5))
(mls <- st_multilinestring(list(s1,s2,s3)))
## MULTILINESTRING ((0 3, 0 4, 1 5, 2 5), (0.2 3, 0.2 4, 1 4.8, 2 4.8), (0 4.4, 0.6 5))
p1 <- rbind(c(0,0), c(1,0), c(3,2), c(2,4), c(1,4), c(0,0))
p2 <- rbind(c(1,1), c(1,2), c(2,2), c(1,1))
pol <-st_polygon(list(p1,p2))
p3 <- rbind(c(3,0), c(4,0), c(4,1), c(3,1), c(3,0))
p4 <- rbind(c(3.3,0.3), c(3.8,0.3), c(3.8,0.8), c(3.3,0.8), c(3.3,0.3))[5:1,]
p5 <- rbind(c(3,3), c(4,2), c(4,3), c(3,3))
(mpol <- st_multipolygon(list(list(p1,p2), list(p3,p4), list(p5))))
#> MULTIPOLYGON (((0 0, 1 0, 3 2, 2 4, 1 4, 0 0), (1 1, 1 2, 2 2, 1 1)),
#>  ((3 0, 4 0, 4 1, 3 1, 3 0), (3.3 0.3, 3.3 0.8, 3.8 0.8, 3.8 0.3, 3.3 0.3)),
#>   ((3 3, 4 2, 4 3, 3 3)))
(gc <- st_geometrycollection(list(mp, mpol, ls)))
#> GEOMETRYCOLLECTION (MULTIPOINT ((3.2 4), (3 4.6), (3.8 4.4),
#>  (3.5 3.8), (3.4 3.6), (3.9 4.5)), MULTIPOLYGON (((0 0, 1 0, 3 2, 2 4, 1 4, 0 0), 
#>  (1 1, 1 2, 2 2, 1 1)), ((3 0, 4 0, 4 1, 3 1, 3 0), (3.3 0.3, 3.3 0.8, 3.8 0.8, 3.8 0.3, 3.3 0.3)),
#>   ((3 3, 4 2, 4 3, 3 3))), LINESTRING (0 3, 0 4, 1 5, 2 5))
#>   





########################################## Writing ##################################

st_write(nc, "nc.shp")
## Writing layer `nc' to data source `nc.shp' using driver `ESRI Shapefile'
## Writing 100 features with 14 fields and geometry type Multi Polygon.


# OR

write_sf(nc, "nc.shp") # silently overwrites




############################# COORDINATES ####################################

#> Coordinate reference system transformations can be carried out using st_transform,
#>  e.g. converting longitudes/latitudes in NAD27 to web mercator (EPSG:3857) can be done by:

nc.web_mercator <- st_transform(nc3, 3857)
st_geometry(nc.web_mercator)[[4]][[2]][[1]][1:3,]
##          [,1]    [,2]
## [1,] -8463267 4377519
## [2,] -8460094 4377510
## [3,] -8450437 4375553



#>The commands st_buffer, st_boundary, st_convexhull, st_union_cascaded, st_simplify, 
#> st_triangulate, st_polygonize, st_centroid, st_segmentize, and st_union return new geometries, e.g.:

sel <- c(1,5,14)
geom = st_geometry(nc.web_mercator[sel,])
buf <- st_buffer(geom, dist = 30000)
plot(buf, border = 'red')
plot(geom, add = TRUE)
plot(st_buffer(geom, -5000), add = TRUE, border = 'blue')


#> Commands st_intersection, st_union, st_difference, st_sym_difference return new geometries
#>  that are a function of pairs of geometries:
#>  

par(mar = rep(0,4))
u <- st_union(nc)
plot(u)


#> The following code shows how computing an intersection between two polygons may yield a 
#>  GEOMETRYCOLLECTION with a point, line and polygon:
#>  
opar <- par(mfrow = c(1, 2))
a <- st_polygon(list(cbind(c(0,0,7.5,7.5,0),c(0,-1,-1,0,0))))
b <- st_polygon(list(cbind(c(0,1,2,3,4,5,6,7,7,0),c(1,0,.5,0,0,0.5,-0.5,-0.5,1,1))))
plot(a, ylim = c(-1,1))
title("intersecting two polygons:")
plot(b, add = TRUE, border = 'red')
(i <- st_intersection(a,b))
## GEOMETRYCOLLECTION (POLYGON ((7 0, 7 -0.5, 6 -0.5, 5.5 0, 7 0)), LINESTRING (4 0, 3 0), POINT (1 0))
plot(a, ylim = c(-1,1))
title("GEOMETRYCOLLECTION")
plot(b, add = TRUE, border = 'red')
plot(i, add = TRUE, col = 'green', lwd = 2)



#> Units
#> 
#> Where possible geometric operations such as st_distance(), st_length() and st_area()
#>  report results with a units attribute appropriate for the CRS:

a <- st_area(nc[1,])
attributes(a)
## $units
## $numerator
## [1] "m" "m"
## 
## $denominator
## character(0)
## 
## attr(,"class")
## [1] "symbolic_units"
## 
## $class
## [1] "units"


#> The units package can be used to convert between units:

units::set_units(a, km^2) # result in square kilometers
## 1137.108 [km^2]
units::set_units(a, ha) # result in hectares
## 113710.8 [ha]

############################### Manipulating with dplyr ############################

nc %>%
  mutate(area = as.numeric(st_area(geometry))) %>%
  select(NAME, FIPS, geometry, area)

nc %>%
  mutate(area = st_area(geometry)) %>%
  select(NAME, geometry, area)





#################################### ggplot2 ##########################################
ggplot() +
  geom_sf(data = nc)




ggplot() +
  geom_sf(aes(fill = AREA), data = nc, colour = "white")



## Gets the geometry for all the contiguous 48 states ##
state_shape <- us_states() %>% 
  filter(jurisdiction_type == "state", 
         state_abbr != "AK", 
         state_abbr != "HI")  

## Plots the two datasets ##
ggplot() +
  geom_sf(data = state_shape) + 
  geom_sf(data = nc)
###############################################################
id <- us_counties(states = "ID")  


ggplot() +
  geom_sf(data = state_shape, alpha = 0) + 
  geom_sf(data = id, alpha = 0) +
  theme_tq()


##############################################################


ggplot() +
  geom_sf(data = nc) +
  annotate("point", x = -80, y = 35, colour = "red", size = 4)






######################### From the video ###########################

#https://www.loom.com/share/535ff204fb0143ec9301e636216f28ec


covid <-  read_csv("https://raw.githubusercontent.com/nytimes/covid-19-data/master/us-states.csv")

states_48 <-  us_states() %>% 
  filter(state_name %in% state.name,
          state_name != "Alaska",
          state_name != "Hawaii")
states_48
us_states()
state.name
view(covid)
filter <- "2021-02-22"
covid_filtered <- covid %>% filter(date == filter )
  
  
  
  
coronaplot <- inner_join(states_48, covid_filtered, by = c("name" = "state")) %>% 
   mutate(cases = cases / 1000000)


class(coronaplot)
coronaplot
today()
library(tidyquant)
library(ggrepel)
library(ggplot2)


myplot <- ggplot(data = coronaplot) +
          geom_sf(mapping = aes(fill = cases)) +
  theme_bw() +
  labs(fill = "Confirmed Cases in Millions",
       title = "Millions of Confirmed Corona Cases by State",
       subtitle = paste("as of ", filter, " presented " ,today() - 1)) +
  scale_fill_continuous(labels = scales::comma) +
  theme(axis.title = element_blank())

myplot + geom_sf_label(mapping = aes(label = format(cases, big.mark = ",")))


myplot + geom_sf_text(mapping = aes(label = format(cases, big.mark = ",", digits = 1)),
                      check_overlap = TRUE, color = "white") 
               

myplot + geom_label_repel(mapping = aes(label = format(cases, big.mark = ",", digits = 1),
                          geometry = geometry), 
                          stat = "sf_coordinates",
                          label.padding  = unit(0.9,"mm"),
                          size = unit(3, "mm"))
                          
#force = 0
myplot + geom_label_repel(mapping = aes(label = name,
                                        geometry = geometry), 
                          stat = "sf_coordinates",
                          direction = "y",
                          label.padding = unit(0.22,"char"),
                          size = 2.5,
                          hjust = 0.5)





myplot + geom_label_repel(mapping = aes(label = format(name, big.mark = ",", digits = 1),
                                        geometry = geometry), 
                          stat = "sf_coordinates",
                          size = 3,
                          box.padding = unit(0.25, "lines"),
                          point.padding = unit(0.5, "lines"))


################### how to obtain coordinates from a geometry that has just a point(xy) like us_cities #################


test <- us_cities()
test <- test %>% mutate(
  coordenadas = st_coordinates(test$geometry)
)
view(test)

#########################################################################################################################