

install.packages("raster")

install.packages("rgdal")
# load packages
library(raster)
library(rgdal)
library(dplyr)
library(stringr)
library(ggplot2)




# import data
aoi <- readOGR("C:\\Users\\Emilia\\Desktop\\12_BYU_spring_2023\\Data Wrangling and visualization ds350\\W11\\earthanalyticswk4\\california\\SJER\\vector_data\\SJER_crop.shp")



# view crs of the aoi
crs(aoi)

# import data
world <- readOGR("C:\\Users\\Emilia\\Desktop\\12_BYU_spring_2023\\Data Wrangling and visualization ds350\\W11\\earthanalyticswk4\\global\\ne_110m_land\\ne_110m_land.shp")
## OGR data source with driver: ESRI Shapefile 
## Source: "/root/earth-analytics/data/week-04/global/ne_110m_land/ne_110m_land.shp", layer: "ne_110m_land"
## with 127 features
## It has 2 fields
crs(world)
## CRS arguments:
##  +proj=longlat +datum=WGS84 +no_defs +ellps=WGS84 +towgs84=0,0,0


# create data frame of epsg codes
epsg <- make_EPSG()


# view data frame - top 6 results
head(epsg)

# view proj 4 string for the epsg code 4326
epsg %>%
  filter(code == 4326)

latlong <- epsg %>%
  filter(str_detect(prj4, 'longlat'))
head(latlong)


utm <- epsg %>%
  filter(str_detect(prj4, 'utm'))
head(utm)




#> Create CRS Objects
#> 
#> 
#> R has a class of type crs. You can use this to create CRS objects using both
#>  the text string itself and / or the EPSG code. Let’s give it a try. 
#>  You will use your geographic definition as an example.
#>  



# create a crs definition by copying the proj 4 string
a_crs_object <- crs("+proj=longlat +datum=WGS84 +no_defs")
class(a_crs_object)
## [1] "CRS"
## attr(,"package")
## [1] "sp"
a_crs_object
## CRS arguments:
##  +proj=longlat +datum=WGS84 +no_defs +ellps=WGS84 +towgs84=0,0,0




# create crs using epsg code
a_crs_object_epsg <- crs("+init=epsg:4326")
class(a_crs_object_epsg)
## [1] "CRS"
## attr(,"package")
## [1] "sp"
a_crs_object_epsg
## CRS arguments:
##  +init=epsg:4326 +proj=longlat +datum=WGS84 +no_defs +ellps=WGS84
## +towgs84=0,0,0




#> WKT or Well-Known Text
#> We won’t spend a lot of time on the Well-known text (WKT) format. 
#> However, it’s useful to recognize this format given many tools 
#> - including ESRI’s ArcMap and ENVI use this format.
#>  WKT is a compact machine- and human-readable representation of geometric objects. 
#>  It defines elements of coordinate reference system (CRS) definitions using a 
#>  combination of brackets [] and elements separated by commas (,).

#Here is an example of WKT for WGS84 geographic:
  
  GEOGCS["GCS_WGS_1984",DATUM["D_WGS_1984",SPHEROID["WGS_1984",6378137,298.257223563]],PRIMEM["Greenwich",0],UNIT["Degree",0.017453292519943295]]

#Notice here that the elements are described explicitly using all caps - for example:
  
 # UNIT
 # DATUM
  
  
  
  
#################################### From the tutorial #############################
  
  # https://byuistats.github.io/M335/online_class/week12-CRS_reading.html
  
library(sf)
ID_counties <- USAboundaries::us_counties(states = "ID")
st_crs(ID_counties)



#> First create the CRS using the proj4 string format.
#> 
#> Note, you don’t have to define much, 
#> in this case the datum and the projection method is sufficient.

my_proj <- "+proj=robin +datum=WGS84"  

#> Then use st_transform() to change the existing crs to the one defined in the line of code above.
#>  Then view the CRS of the newly created ID_tr to verify the change took place.

ID_tr <- ID_counties %>% st_transform(crs = my_proj)
st_crs(ID_tr)




#Now compare the maps: they both use the same geometries but have different CRS’s.

ggplot() + geom_sf(data = ID_counties) + theme_bw()

ggplot() + geom_sf(data = ID_tr) + theme_bw()



# Change the CRS of a map on the fly with a proj4 string

#> In the code below, the CRS of the visualization is changed, 
#> but the default CRS associated with ID_counties has not been changed.
#> 

ggplot() + 
  geom_sf(data = ID_counties) + 
  theme_bw() +
  coord_sf(crs = st_crs("+proj=robin +datum=WGS84"))


#> The next block of code illustrates using an
#>  EPSG code instead of a proj4 string as an 
#>  argument input to the st_crs() command and/or to the st_transform()command.


ggplot() + 
  geom_sf(data = ID_counties) + 
  theme_bw() +
  coord_sf(crs = st_crs(5041))


#> Note that st_crs() can work outside of the ggplot statement too, but only if 
#> the object doesn’t already have a CRS defined. That’s why we use st_transform() 
#> outside of the ggplot statement, because it will alter the CRS regardless of whether
#>  there is already CRS information attached to an object.
#>   However, st_transform() doesn’t work well in the coord_sf() statement of a ggplot, but st_crs() does.



