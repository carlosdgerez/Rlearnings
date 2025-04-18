

install.packages("geofacet")
# or from github:
# remotes::install_github("hafen/geofacet")

library(geofacet)
library(ggplot2)

ggplot(state_ranks, aes(variable, rank, fill = variable)) +
  geom_col() +
  coord_flip() +
  facet_geo(~ state) +
  theme_bw()


state_ranks
state_unemp


# take a look to  the function on the fly to extract the last years digits from the year variable

ggplot(state_unemp, aes(year, rate)) +
  geom_line() +
  facet_geo(~ state, grid = "us_state_grid2") +
  scale_x_continuous(labels = function(x) paste0("'", substr(x, 3, 4))) +
  ylab("Unemployment Rate (%)") +
  xlab(" my experiment")


# GDP per capita in relation to EU index (100) for each country in the European Union:
eu_gdp

ggplot(eu_gdp, aes(year, gdp_pc)) +
  geom_line(color = "steelblue") +
  facet_geo(~ name, grid = "eu_grid1", scales = "free_y") +
  scale_x_continuous(labels = function(x) paste0("'", substr(x, 3, 4))) +
  ylab("GDP Per Capita in Relation to EU Index (100)") +
  theme_bw()



