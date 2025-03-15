
# This code is a resume of R course dont run it!!!


labs(x= "Life Expentancy",
     y = "GDP per capita",
     size = "Population (100 k)") +
  guides(size = guide_legend(order = 1), color = guide_legend(order = 2)) # FIX ORDER OF LEGENDS

################################################################
require(gridExtra)
grid.arrange(departures, arrivals, ncol = 2) #ARRANGE PLOTS

####################################################################################

ggplot(data = combined ) + 
  geom_point(mapping = aes(x = dep_delay / 60,
                           y = arr_delay / 60,
                           color = months), 
             na.rm = TRUE) +         # DEAL WITH NA:RM
  labs(x= "Departures Delays in hours",
       y = "Arrival Delays in hours",
       title = "Arrivals and Departures Delays by Months",         # LABS TITLES; AND LEGENDS TITLES
       color = "Months") +
  theme_light() +
  theme(plot.title = element_text(face = "bold")) +
  theme(plot.title = element_text(hjust = 0.5)) 

####################################################################################



scale_color_manual(values = c("purple", "orange", "blue"))  # CHANGE COLORS IN REPRESENTATION
scale_color_brewer(palette = "Set1")


####################################################################################


scale_shape_manual(values =  c(1, 5, 7)) +  # OTHERS SCALES CHANGES
  scale_x_log10() +
  scale_y_log10() +
  scale_color_manual(values = c("purple", "orange", "blue"))

####################################################################################


geom_hline(data = averages, 
           mapping = aes( yintercept = avglength)) # LINES HORIZONTAL


####################################################################################

W3 gapminder2
gap_weight <- gapminder1 %>% 
  group_by(continent, year) %>%
  summarise(gdp_wt_mean = weighted.mean(gdpPercap, w = pop),
            gdpPercap,
            country,  # LOOK AT THE WEIGHTED MEAN
            popsum = sum(pop),
            pop)
####################################################################################

output:
  html_document:
  theme: cerulean  
keep_md: true
toc: true
toc_float: true
code_folding: hide  # BETTER OUTPUT IN KNITED RMARKDOWN WITH CERULEAN THEME:
fig_height: 6
fig_width: 16
fig_align: 'center'

####################################################################################

w3
ggplot(gap_weight) + 
  aes(x = year, y = gdpPercap, color = continent) + 
  geom_line(aes(group = country), size = 0.9) +
  geom_point(aes (size = pop / 1000000 )) +
  geom_point(aes(x = year,y = gdp_wt_mean, size = popsum/1000000),col = "black") +
  geom_line(aes(x = year, y = gdp_wt_mean),col  = "black", size = 0.9) + #> Thiis add a line with
                                                                        #    the weighted mean
  facet_grid( . ~ continent) +
  theme_bw() +
  labs(x = "Year",
       y = "GDP per capita",
       size = "Population (100 k)",
       color = "Continent") +
  guides(size = guide_legend(order = 1), color = guide_legend(order = 2))


####################################################################################

# Ways to look the data 
library(nycflights13)
?flights
?weather
View(flights)
glimpse(flights)
summary(flights)
#f <- flights
unique(f$carrier)
unique(f$origin)
names(flights)


############################################

# #################################### CHANGE COL NAMES AND ORDER OF COLUMNS AT THE END

colnames(df) <- c(new_col1_name,new_col2_name,new_col3_name)

colnames(df)[2] <- "new_col2"

setNames(df, c("names of new columns"))

my_data %>% 
  rename(
    sepal_length = Sepal.Length,
    sepal_width = Sepal.Width
  )




# Change the order of columns to match the example

worldp <- worldp[, c(1, 2, 4, 5, 6, 7, 3, 8)]

###############################################################################



# PERCENTILES !!!!!


airline <- flights %>% 
  select(origin, dep_delay, carrier, sched_dep_time ) %>%         #Select data necesary
  filter(sched_dep_time < 1200 & dep_delay > 0) %>%               #Filter before noon and just delays
  group_by(origin, carrier) %>%                                   #Group to calculate percentile 
  mutate(percentile_75  = quantile(dep_delay, probs = 0.75)) %>%  #Create a new variable with the percentile 
  distinct(carrier, percentile_75) %>%                            #Eliminate innecesary data and reduce just to what we need
  arrange(origin, percentile_75) %>%                              #Sort the data
  left_join(airlines, by = "carrier")                             #add the names of the airlines



##################################################################################
                        # THEMES guides, scales




# Themes for graphs with: 
library("ggthemes")


theme(legend.title = element_blank())  # NO LEGEND TITLES

# ADJUST BREAKS AN FORMAT AXIS TICKS

scale_x_continuous(breaks = 0:6,
                   labels = paste(0:6, "Hours", sep=""))



scale_y_continuous(expand = expansion(mult = c(0.1,.01))) # CHANGE THE PADDING in the axes

####################################################


##################### CHANGE ANGLES, DISTANCE FROM AXE AND REMOVE A GRID ################


theme(axis.text = element_text(angle = 45, hjust = 1),
      panel.grid.major.x = element_blank() )

##################### REMOVE TITLES IN AXE, REMOVE LINE, LENGHT OF TICKS ADJUSTMENTS #########

theme(axis.title.y = element_blank(),
      axis.line = element_blank(),
      axis.ticks.length.y = unit(1.5, "mm"),
      panel.grid.major.y = element_line(color = "grey",linetype = 2))


scale_y_continuous(labels = scales::percent(0.01)) # adjust percents in scales



##################################### MAPPING SIZE AND COLOR TO A VARIABLE OF THE SET ###########
#                               TO SHOW IN THE GRAPH
########################################## GERMANY ##################################

ggplot(data = worldp ) + 
  geom_point(mapping = aes(x = year_decade,
                           y = height.in,
                           color = (country == "Germany"),
                           size = (country == "Germany")), 
             na.rm = TRUE) +
  labs(x= "Decades",
       y = "Height in inches",
       title = "Evolution of Height through time by inches",
       color = "") +
  theme_fivethirtyeight() +
  theme(plot.title = element_text(face = "bold")) +
  theme(plot.title = element_text(hjust = 0.5)) +
  guides(size = "none") +
  scale_color_manual(values = c("#537188", "#CBB279"),labels = c('Rest of the World','Germany'))


################################# ANNOTATE EXAMPLE ###############################

ggplot(data = alld, 
       mapping = aes(x = birth_year, y = height.in, color = birth_year) ) +
  geom_point(alpha = 0.1) +
  scale_y_continuous(limits=c(50, 85))+
  facet_wrap(~ study, nrow = 2) +
  geom_hline(yintercept = 75, color = "green") +
  annotate("text", x = 1800, y = 76.5, label = "Cut line", size = 3) +
  labs(x= "Centuries",
       y = "Height in inches",
       title = "The green line shows an increase in height") +
  theme(plot.title = element_text(face = "bold")) +
  theme(plot.title = element_text(hjust = 0.5)) 
##############################################################################################
######################### CHANGING THE TITLES OF THE FACETS #################


p5 <- ggplot(data = guns, aes(x = age_group, y = n_distinct(age_group), fill = age_group) ) +
  geom_col() +
  facet_grid( ~ factor(season, levels = c("Spring", "Summer", "Fall", "Winter"))) + # LOOK HERE
  labs(x = "",
       y = "Number of Deaths",
       title = "Ages 35 to 50 have the higher rate of deaths, the second age group is 51 to 64, but during fall is paired in numbers \nwith 25 to 34 years range.  ",
       subtitle = "Spring and Summer have the higher amounts of deaths. ",
       fill = "",
       caption = "Data from FiveThirtyEight.com ") + 
  theme_hc() +
  scale_x_discrete(labels = element_blank()) +
  scale_fill_brewer(palette = "Set1")  +
  scale_fill_discrete(breaks = c("Under 15", "15 - 24", "25 - 34", "35 - 50", "51 - 64", "65+"  )) +
  theme(axis.ticks =  element_blank(),
        axis.title.y = element_text(vjust = 3))

################################### LABELS #########################################

#library(extrafont)
library(ggrepel)

#install.packages("directlabels")
library(directlabels)

#You can use the directlabels package in two different ways:
  
#  -   geom.dl(), or
#  -   direct.label()

##################################################################

p <- gapminder %>% filter(continent == "Oceania") %>% 
  ggplot(mapping = aes(x = year, y = gdpPercap, color = country)) +
  geom_line()

direct.label(p, list("last.points")) # labels off the edge of the chart
direct.label(p, list("last.points", dl.trans(x = x-1.5, y = y+.2)))

#OR ##############################################################

direct.label(p, list("last.points", hjust = 1, vjust = .2))

p + geom_dl(aes(label = country), 
            method = list("last.points", hjust = 1, vjust = .1, cex = 1))

##################################################################






########################### ggrepel############################

library(ggrepel)
ggplot(mpg, aes(displ, cty)) +
  geom_point(aes(colour = class)) +
  geom_point(size = 3, shape = 1, data = best_in_class) +
  ggrepel::geom_label_repel(aes(label = model), data = best_in_class)

############## GEOM LABEL BORDER blank ##
#              GEOM TEXT JUST COLORED 

ggplot(data = mpg, mapping = aes(x = displ, y = cty)) +
  geom_point(aes(colour = class)) +
  geom_point(size = 3, shape = 1, data = best_in_class) +
  ggrepel::geom_text_repel(data = best_in_class,
                           aes(label = model, colour = class),# this colored the labels according to class
                           show.legend = FALSE, nudge_x = 2.8, # MINOR adjustments and not showing a legends
                           nudge_y = 0.6) + 
  theme(panel.grid.minor = element_blank())



########################## GOOD USE OF LABELS AND BREAKS #####################################

p <- ggplot(data = pop,aes( x = year, y = population, group = cat, color = cat)) +
  geom_line(size = 1) +
  geom_line(data = pop2, size = 1, linetype = 3) +
  theme_classic() +
  scale_x_continuous(breaks = c(1950, 1980, 2000, 2020, 2040, 2060, 2080, 2100),
                     expand = expansion(add = c(0,40))) +               ######### PADDING
  scale_y_continuous(labels = label_number(suffix = " billion", scale = 1e-9), # LABELS FORMAT
                     breaks = c( 2e+9,4e+9, 6e+9, 8e+9, 10e+9),        # BREAKS FORMATS
                     expand = expansion(add = c(0,1e+9))) +            # PADDING
  theme(axis.title = element_blank(),
        axis.line = element_blank(),
        axis.ticks.y = element_blank(),
        #  panel.grid.major.y = element_line(color = "gray", linetype = 2),
        legend.position = "none") +
  #geom_text_repel(data = lastyear, aes(label = cat), size = 4, nudge_x = 6)
  geom_dl(data = pop2, aes(label = cat), method = list(dl.trans( x = x + 0.2), "last.bumpup")) + # LABEL TITLES WITH GEOMDL
  geom_segment(aes(x = 1950, xend = 2100, y = 0, yend = 0), col = "black") + ## LINE AXYS
  geom_segment(aes(x = 1950, xend = 2100, y = 2e+9, yend = 2e+9), col = "grey", linetype = 2) + # GRIDS
  geom_segment(aes(x = 1950, xend = 2100, y = 4e+9, yend = 4e+9), col = "grey", linetype = 2) +
  geom_segment(aes(x = 1950, xend = 2100, y = 6e+9, yend = 6e+9), col = "grey", linetype = 2) +
  geom_segment(aes(x = 1950, xend = 2100, y = 8e+9, yend = 8e+9), col = "grey", linetype = 2) +
  geom_segment(aes(x = 1950, xend = 2100, y = 10e+9, yend = 10e+9), col = "grey", linetype = 2)  
p +  labs(
  title = "Population by age group, including UN projections, World",
  subtitle = "Historic estimates from 1950 to 2021, and projected to 2100 based on the UN medium-fertility scenario. This is shown for various
age brackets and the total population. ",
  fill = "",
  caption = c("OurWorldInData.org/world-population-growth • CC BY","Source: United Nations, World Population Prospects (2022)") )+
  theme(plot.caption = element_text(hjust = c(1,0),vjust = c(0.2,0))) + # PLACE OF 2 CAPTIONS
  theme(plot.title = element_text(family = "Lucida Fax")) +
  scale_color_manual(values = c("#4fa082","#bb4e2c","#843034","#6c3f91", "#3573be","#ac7f4e"))























               ###############################

                          # ORDER

+ scale_x_discrete(limits = month.abb) # orders months

# Or
your_data$month = factor(your_data$month, levels = month.abb)


p+scale_x_date(date_labels = "%b") #APR
p+scale_x_date(date_labels = "%Y %b %d") # 2016 APR 1
p+scale_x_date(date_labels = "%W") # WEEKS NUMBERS
p+scale_x_date(date_labels = "%m-%Y") # 04-2016


p + scale_x_date(date_breaks = "1 week", date_labels = "%W")
p + scale_x_date(date_minor_breaks = "2 day")


scale_x_date(limit=c(as.Date("2017-01-01"),as.Date("2017-02-11"))) # select date brakes

                 ###############################

                          # ANGLES AXIS

theme(axis.text.x=element_text(angle=60, hjust=1)) 

##########################################################
labs(x= "Decades",
     y = "Height in inches",
     title = "Evolution of Height through time by inches",
     color = "") + # NO COLOR LEGEND
  theme_fivethirtyeight() +
  theme(plot.title = element_text(face = "bold")) +
  theme(plot.title = element_text(hjust = 0.5)) +
  guides(size = "none") +
  scale_color_manual(values = c("#537188", "#CBB279"), # CHANGE COLORS 
                     labels = c('Rest of the World','Germany')) # CHANGE INDICATORS


##################################################################################

# GEOM_BARS WITH IDENTITY ( X and Y COORD, FLIP coordinates and reorder for visuals)

g1 <- ggplot(data = airline,
             mapping = aes(reorder_within(name, desc(percentile_75), origin ), y = percentile_75, color = name, fill = name) ) +
  geom_bar( stat = "identity", na.rm = TRUE) +
  facet_wrap(~ origin, nrow = 2, scales = "free") +
  coord_flip() 

########################## TIDY DATA ######################################################
# PIVOT LONGER



seasons2 <- seasons %>% 
  pivot_longer(c(`First`, `Last`), names_to = "Episode", values_to = "first_last")

dat_long <- dat_wide %>% 
  pivot_longer(cols = Chem:PHY,names_to = "Department", values_to = "count")

# PIVOT WIDER  

#convert it to wide here
dat_wide <- dat %>% pivot_wider(names_from = Department, values_from = Count)
dat_wide

###################################### NA VALUES ########################





dat2 <- dat1

dat2 <- dat2 %>% complete()

dat2$count <- replace(dat2$count, is.na(dat2$count), 0)

dat2

dat2[is.na(dat2)] <- 0
dat2
?complete()

############################### NA vALUES AFTER TIDY #####################


# Using complete
# Just to show that add new combinations (emties)
dat %>% complete(Year,Semester, Department, fill = list(Count = 0, Semester_Date = "2") )

# work well without adding any new combination, and fill 
dat %>% complete(Department, nesting(Year, Semester, Semester_Date), fill = list(Count = 0))


# Expand with a left join to add the counts and replace-na
dat %>% expand(Department,nesting(Year, Semester, Semester_Date)) %>% 
  left_join(dat) %>% replace_na(list(Count = 0))



# Lokking to the data found few nas 
# guns 
#filter(guns, is.na(guns$intent) == TRUE) # 1 na
#filter(guns, is.na(guns$sex) == TRUE)
#filter(guns, is.na(guns$month) == TRUE)
#filter(guns, is.na(guns$race) == TRUE)
#filter(guns, is.na(guns$place) == TRUE)  # 1384 na
#filter(guns, is.na(guns$year) == TRUE)
#filter(guns, is.na(guns$age) == TRUE) # 18 na
#unique(guns$year)


############### ELIMINATE all THE NA in  SEt ###############
na.omit(df)

sum(is.na(df))

length(unique(df$columnname))

############################### REPLACE NAS WITH A TEXT O VALUE ###########
######################## VERY VERY SPECIFIC #######################

guns <- guns %>% mutate(
  place = stringi::stri_replace_na(guns$place, replacement = "Not Informed"))





#################################### SEPARATE #################################

dat2 <- dat2 %>% separate(col = Semester_Date, into = (c("day","month", "year"))) %>%
  mutate(day = as.numeric(day))


############################ PASTE UNITING ##########################

# with paste into mutate

zeros %>% mutate(yrsem = paste(Year, Semester, sep = ""))


# with unite
zeros <- zeros %>% unite("yrsem",c(Year, Semester,), sep = "", remove = FALSE)

#dat2 <- dat2 %>% unite(new, month, year)
dat2 <- dat2 %>% unite(year_semester, Year, Semester, sep = "-")

################################### FACTOR ############################

#TO ORDER DATES OR ANY OUTPUT  IN A GRAPH

# factor year semester 

dat2 <- dat2 %>% mutate(year_semester = factor( level = c("2016Spring","2016Fall",
                                                          "2017Winter","2017Spring",
                                                          "2017Fall","2018Winter")))



# FOR MONTH WE CAN USE :
unique(airquality$Month)

#[1] 5 6 7 8 9


month.name[unique(airquality$Month)]

#[1] "May"       "June"      "July"      "August"    "September"


month.abb[unique(airquality$Month)]

#[1] "May" "Jun" "Jul" "Aug" "Sep"

#WITH MUTATE from dplyr

airquality %>% 
  mutate('MonthName' = month.abb[Month]) %>% 
  head()

# WITH lubridate 
airquality$MonthName <- format(airquality$Date, "%B")

airquality$MonthNameAbb <- format(airquality$Date, "%b")

airquality$LubriMonthName <- lubridate::month(airquality$Date, label = TRUE)





############################# CREATE columns and rows content WITH A CRITERIA ##################

################### FROM AGE IF IS BETWEEN 0 TO 14 IN AGE_GROUP WRITE "Under 15", etc

guns <- guns %>% mutate(
  age_group = case_when(
    age %in% as.character(c(0:14)) ~ "Under 15",
    age %in% as.character(c(15:24)) ~ "15 - 24",
    age %in% as.character(c(25:34)) ~ "25 - 34",
    age %in% as.character(c(35:50)) ~ "35 - 50",
    age %in% as.character(c(51:64)) ~ "51 - 64",
    age %in% as.character(c(65:107)) ~ "65+",
  ),
  season = case_when(
    month %in% c('12', '1', '2') ~ 'Winter',
    month %in% c('3', '4', '5') ~ 'Spring',
    month %in% c('6', '7', '8') ~ 'Summer',
    month %in% c('9', '10', '11') ~ 'Fall'),
  sex = case_when(
    sex %in% "F" ~ "Female",
    sex %in% "M" ~ "Male"
  ))


########################################## SUMMARISSE WITH N() ####################


sex_total <- guns %>% group_by(sex) %>%
  summarise(sex_totals = n())



###############################################################################

# EXTRANGE FUNCTIONAL CODE
mean_rate <- mean_rating %>% slice(rep(row_number(), 10)) %>% # SLICE 10
  arrange(series) %>%
  mutate(episode = rep(1:10,8)) # CREATE 10 of 8 diferent 
# original example in w 3 great_british_bake_off

################################################################################

# AND MORE
# 1. generate a sequence of years by decades from 1810 (first registered year) to 1980 (last registered year)

decades <- seq(from = 1810, to = 1980, by = 10)

# 2. Tidy by change names, eliminates na, select the years with data, and pivot longer.
#    use na.omit() to eliminate all rows with na, arrange and create height in cmt. 

worldp <- worldp %>%  
  rename(country = "Continent, Region, Country") %>%
  filter(!is.na(country)) %>%
  select(Code, country, as.character(decades)) %>%
  pivot_longer(cols = `1810`:`1980`,
               names_to = "year_decade",
               values_to = "height.cm") %>%
  na.omit(.) %>%
  arrange(year_decade) %>%
  separate(year_decade, into = c("century", "decade", "year"), sep = c(2,-1), remove = FALSE) %>%
  mutate(height.in = height.cm / 2.54)



####################################################################################

# NICE COLORED PLOT WITH A LINE IN THE MEAN HORIZONTAL



ggplot(data = viewers, mapping = aes(x = episode, y = viewers_7day)) + 
  geom_point(size = 2, color = "#F99B7D") + 
  geom_line(color = "#B04759") + 
  geom_line(data = mean_rate, aes(y = average), color = "#19A7CE") + 
  geom_line() + 
  facet_wrap(~ series, nrow = 2) + 
  theme_bw() +
  scale_x_discrete(name = "Episodes",
                   limits = c("1","2","3","4","5","6","7","8","9","10")) +
  
  labs(x = "Episodes" ,
       y = "Viewers per episode on first week (millions)",
       title = "Each episode’s 7-day viewership and mean rating for each season" ) +
  theme(plot.title = element_text(size = 15)) +
  theme(plot.title = element_text(hjust = 0.5)) +
  theme(plot.title = element_text(color = "#E06469"))



####################################################
# PLOTS WITH JITTERED AND BOXPLOTS

g <-   ggplot(dart_csv, aes(x = value, y = (group = variable), color = variable)) +
  geom_jitter(alpha = 0.5 ) + 
  geom_boxplot(outlier.color = ("black"), alpha = 0.5) +
  geom_point(x = dart_csv$avrg, color = "red") +
  labs(y = "",
       x = "Returns",
       title = "Performance of the Dart, DJIA, and Pro-stock selections",
       color = "Selections",
       caption = "Average point marked in red") +
  theme(plot.title = element_text(face = "bold", hjust = 0.5)) 



######################## DOWNLOAD #####################################

library(tidyverse)
library(downloader)
library(readxl)
library(rio)


# The excel version
dartExpert <- tempfile()

download("https://github.com/byuistats/data/raw/master/Dart_Expert_Dow_6month_anova/Dart_Expert_Dow_6month_anova.xlsx", 
         dest = dartExpert,
         mode = "wb")

dart_xlsx <- read_excel(dartExpert)

# The RDS file
read_rds() #read in an .rds file. This is a wrapper around base R readRDS()
dart_rds <- read_rds("https://github.com/byuistats/data/raw/master/Dart_Expert_Dow_6month_anova/Dart_Expert_Dow_6month_anova.RDS")

# The csv file

dart_csv <- read_csv("https://github.com/byuistats/data/raw/master/Dart_Expert_Dow_6month_anova/Dart_Expert_Dow_6month_anova.csv")

# The dta file reading from haven

library(haven)

dart_dta <- read_dta("https://github.com/byuistats/data/raw/master/Dart_Expert_Dow_6month_anova/Dart_Expert_Dow_6month_anova.dta")




# the sav file reading from haven

dart_sav <- read_sav("https://github.com/byuistats/data/raw/master/Dart_Expert_Dow_6month_anova/Dart_Expert_Dow_6month_anova.sav")

################### TEMP FILES reading ##############################

h1 <- tempfile()

download("https://byuistats.github.io/M335/data/heights/Height.xlsx", 
         dest = h1,
         mode = "wb")

# Reading without the first row !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

worldp <- read_excel(h1, skip = 1)
######################################## READ CSV FILES #######################

# SELECT COLUMNS SKIP 1 ROW IN THE BEGINING


read_csv("happy_over_time.csv", col_names = c("country","code","year","happiness"), skip = 1)





########################################### ZIP FILES ################################


# Third file (a zip file)

h2 <- tempfile()
directemp <- tempdir()

download("https://byuistats.github.io/M335/data/heights/Heights_south-east.zip",
         destfile = h2, mode = "wb",show_col_types = FALSE)

unzip(h2, exdir = directemp)

g18 <- read.dbf(paste(directemp,"B6090.DBF", sep = "\\"))

########################## SELECTING COLUMNS #########################
#> file needs to filter columns to use DOBY for the year of birth
#>  and 2 separate columns for feet and inches
#>  
#>  
w20 <- read_sav("http://www.ssc.wisc.edu/nsfh/wave3/NSFH3%20Apr%202005%20release/main05022005.sav",
                col_select = c("DOBY","RT216F","RT216I"))


###################### OR ###################################
# ######################## Create a function to extract the zip files to objects in r ################

my_xtract_zip_sf <-  function(path){
  df <- tempfile(); uf <- tempfile()
  download(path, df, mode = "wb")
  unzip(df, exdir = uf)
  x <- read_sf(uf)
  file_delete(df); dir_delete(uf)
  return(x)
}


# THIS WHERE THE FILES RETRIEVED :
wells_path <- "https://byuistats.github.io/M335/data/Wells.zip"
dams_path <- "https://byuistats.github.io/M335/data/Idaho_Dams.zip"
water_path <- "https://byuistats.github.io/M335/data/water.zip"
state_shape <- "https://byuistats.github.io/M335/data/shp.zip"



############################## MORE EXAMPLES #############################

# A. Download to a temporary file 

rdsfile <- tempfile()

# Create a temporal directory
 rdir <- tempdir()

url = "https://github.com/byuistats/data/raw/master/Dart_Expert_Dow_6month_anova/Dart_Expert_Dow_6month_anova.RDS"

download(url,destfile = rdsfile, mode ="wb")

# B. Read from the temporary file 
myRDS <- readRDS(rdsfile)

# C. Read direct to an object wth readRDS

myRDScopy <- readRDS(url(url))



# D. Save an object to a file

saveRDS(object, file = "my_data.rds") # or use write_rds(object,file)


# E. Read with read_rds
myrds <- read_rds(url)


########################################## RIO DOWNLOAD CSV ##################################


temporal <- tempfile()
download("https://github.com/fivethirtyeight/guns-data/raw/master/full_data.csv",
         dest = temporal,
         mode = "wb")
guns <- read.csv(temporal)


#############################################################################

# BIND BY ROWS, IS AN OPTION FOR COLUMNS


alld <- bind_rows(b19, g18, g19, us20, w20)

############################# SAVE ##########################################


#     SAVE:
# GRAPHS JUST THE LAST
  ggsave("gapminder.png")

# Saving part 1 dataset tidy *OBJECTS

write_rds(worldp, "part1.rds")

write_rds(alld, "part2.rds")


#two ways to save a dataset as a .rds file
saveRDS(mtcars, file = "my_data.rds") #base R
#OR
write_rds(mtcars, "my_data.rds") #readr package, faster



############################# 2 DATASETS IN ONE SAVE #####################

save(mtcars, iris, file = "my_2_datasets.RData")
load("my_2_datasets.RData") #read it back in


##### MORE SAVES RMD
# Saving part 1 dataset tidy

write_rds(worldp, "part1.rds")

write_rds(alld, "part2.rds")





####################### CREATE GOOD TABLES ##########################


myTable <- tidy_rds %>%
  mutate(Year = as.character(Year), Returns = as.character(Returns)) %>%
  select(Month, variable, Year, Returns) %>%
  filter(variable == "Dow Jones") %>%
  pivot_wider(names_from = Year, values_from = Returns, values_fill = "-" ) %>%
  mutate(Month = factor(Month, levels = month.name)) %>%
  arrange(Month) %>%
  select( - variable) 


myTable <- head(myTable, -1)


knitr::kable(myTable)  




########################### GRaphs ########################################


######################## BOXPLOTS and facet_wraps #######################################

g2 <- ggplot(data = tidy_rds) + 
  aes(x = variable, y = Returns, color = variable) + 
  geom_boxplot() +
  facet_wrap( ~ Year, nrow = 3) +
  labs(y= "Returns",
       x = "",
       title = "Stock returns from Pros and DARTS are more spread than Down Jones",
       color = "Seleccions") +
  theme(plot.title = element_text(face = "bold", hjust = 0.5))



############################## GEOM_LINES WITH GROUPS REMEMBER ####################


dat2 <- dat2 %>% mutate(year_semester = factor( level = c("2016Spring","2016Fall","2017Winter","2017Spring","2017Fall","2018Winter")))

ggplot(dat2) + 
  aes(x = year_semester, y = count, group = Department, color = Department) + 
  geom_line() 
  #  facet_grid( . ~ year) +
  




########################################## FACETS BIGGER WITH paginate########################

library(ggforce)



for (i in 1:9){
  print( visits_by_day_g +
           labs(
             title = "Visits by day in all the restaurants.",
             subtitle = "A start point for regional campaigns.",
             caption = "Shows number of visitors by regions") +
           facet_wrap_paginate( ~ region, ncol = 3, nrow = 2,
                                scales = "free", strip.position = "top", page = i))
} 

