



# FRom https://www.cdc.gov/obesity/data/prevalence-maps.html

# Obesity by state ############################################################################# working 
# LINK : https://www.cdc.gov/obesity/data/maps/2021/Obesity-prevalence-by-state-2021.csv



path <-  "https://www.cdc.gov/obesity/data/maps/2021/Obesity-prevalence-by-state-2021.csv"




data_obesity <- import(path)

names(data_obesity)
data_obesity <- as.data.frame(data_obesity)
write.csv(data_obesity, "week_14/projectSemester/data_obesity.csv")


 datatest <- read_csv("week_14/projectSemester/data_obesity.csv")
 class(data_obesity)
####################################################################################################

#State-level Prevalence of Food Insecurity
# Data from USDA Department of Agriculture  
# This is a xlsx data file that I downloaded from the source and convert to csv for a fast work.
# https://www.ers.usda.gov/media/rbmpu1zi/mapdata2021.xlsx

# DEFINITIONS : 
 
 
#> Low food security—Households reduced the quality, variety, and desirability of their diets, 
#> but the quantity of food intake and normal eating patterns were not substantially disrupted.
 
#> Very low food security—At times during the year, eating patterns of one or more household
#>  members were disrupted and food intake reduced because the household lacked money and other resources for food.
 
 
path <- "https://www.ers.usda.gov/media/rbmpu1zi/mapdata2021.xlsx"

data_foodInsecurity <- import_list(path)
data_foodInsecurity













# POVERTY RATES BY COUNTY AND STATE
https://www2.census.gov/library/visualizations/time-series/demo/Poverty-Rates-by-County-1960-2010.xlsm




########################################################################### Not working but interesting need fix data into 
 # THIS POVERTY DATASET PROVIDES THE LINK BETWEEN OBESITY AND POVERTY IN TIME
library(rio)


path <-  "C:\Users\Emilia\Desktop\12_BYU_spring_2023\Data Wrangling and visualization ds350\gitSpace\dataWranglingGitHub\week_14\projectSemester/Poverty-Rates-by-County-1960-2010.xlsm"


# reading data from all sheets
data <- import_list(path)


data <- import(path)


#########################################################################


# importing the required library
library(openxlsx)

# getting data from sheets
sheets <- openxlsx::getSheetNames(path)
data_frame <- lapply(sheets, openxlsx::read.xlsx, xlsxFile=path)

# assigning names to data frame
names(data_frame) <- sheets

# printing the data
print (data_frame)

#################################################
path


# importing required packages
library(readxl)    
multiplesheets <- function(fname) {
  
  # getting info about all excel sheets
  sheets <- readxl::excel_sheets(fname)
  tibble <- lapply(sheets, function(x) readxl::read_excel(fname, sheet = x))
  data_frame <- lapply(tibble, as.data.frame)
  
  # assigning names to data frames
  names(data_frame) <- sheets
  
  # print data frame
  print(data_frame)
}

# specifying the path name

multiplesheets(path)




############################################################################# Working
# 2019     2020 data of obesity  and other deseases in the USA
https://chronicdata.cdc.gov/api/views/qnzd-25i4/rows.csv?accessType=DOWNLOAD&api_foundry=true


path <- "https://chronicdata.cdc.gov/api/views/qnzd-25i4/rows.csv?accessType=DOWNLOAD&api_foundry=true"

data_better_health_ obesity <-  import(path)
data_better_health









#################### OTHER SURVEYS################################ from census.gob

library(tidyverse)
library(downloader)
library(haven)

#poverty status in the past 12 months



