



install.packages("rnaturalearth")


library(rnaturalearth)

devtools::install_github("ropensci/rnaturalearthdata")
devtools::install_github("ropensci/rnaturalearthhires")


library(sp)


plot(ne_countries())


# uk
sp::plot(ne_countries(country = "united kingdom"))


# states, admin level1 boundaries
sp::plot(ne_states(country = "spain"))


vignette("rnaturalearth", package = "rnaturalearth")



#> To download Natural Earth data not already in the package
#> 
#> https://www.naturalearthdata.com/downloads/50m-physical-vectors/
#> 
#> 
#> 
#>  Specify the scale, category and type of the vector you want as in the examples below.


# lakes
lakes110 <- ne_download(scale = 110, type = "lakes", category = "physical")
sp::plot(lakes110)

# rivers
rivers50 <- ne_download(
  scale = 50,
  type = "rivers_lake_centerlines",
  category = "physical",
  returnclass = "sf"
)

library(ggplot2)
library(sf)

ggplot(rivers50) +
  geom_sf() +
  theme_minimal()


vignette("what-is-a-country", package = "rnaturalearth")


