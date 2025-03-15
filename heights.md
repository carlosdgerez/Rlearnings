---
title: "Heights"
author: "Carlos Gerez"
date: "May 13, 2023"
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






```r
# Use this R-Chunk to import all your datasets!

# Part 1

h1 <- tempfile()

download("https://byuistats.github.io/M335/data/heights/Height.xlsx", 
         dest = h1,
         mode = "wb")
# Reading without the first row

worldp <- read_excel(h1, skip = 1)

 

# Part 2

# First file

b19 <- read_dta("https://byuistats.github.io/M335/data/heights/germanconscr.dta")  
  
     



# Second file

g19 <- read_dta("https://byuistats.github.io/M335/data/heights/germanprison.dta")





# Third file (a zip file)

h2 <- tempfile()
directemp <- tempdir()

download("https://byuistats.github.io/M335/data/heights/Heights_south-east.zip",
         destfile = h2, mode = "wb",show_col_types = FALSE)

unzip(h2, exdir = directemp)

g18 <- read.dbf(paste(directemp,"B6090.DBF", sep = "\\"))



# fourth file

us20 <- read_csv("https://raw.githubusercontent.com/hadley/r4ds/main/data/heights.csv",show_col_types = FALSE)




# fifth file needs to filter columns to use DOBY for the year of birth and 2 separate columns for feet and inches. 


w20 <- read_sav("http://www.ssc.wisc.edu/nsfh/wave3/NSFH3%20Apr%202005%20release/main05022005.sav", col_select = c("DOBY","RT216F","RT216I"))
```

## Background


### Part 1: Heights by Nation  
1. Read in and tidy the Worldwide estimates .xlsx file  
    - Make sure the file is in long format with year as a column. See Example of the Tidy Excel File after formatting  
    - Use the separate() and mutate() functions to create a decade column.
2. Make a plot with decade on the x-axis and and all the countries heights in inches on the y-axis; with the points from Germany highlighted based on the data from the .xlsx file.  

### Part 2: Heights from individuals from different centuries  
1. Now work with datasets where each row represents an individual. Import these five datasets into R and combine them into one tidy dataset.  
    - German male conscripts in Bavaria, 19th century: Stata format.  
    - Heights of bavarian male conscripts, 19th century: Stata format.  
    - Heights of south-east and south-west german soldiers born in the 18th century: DBF format.  
      - This file is zipped. After downloading it with download(), trying using unzip() and read.dbf() to load the data into R.  
      - Can you tell which column is the birth year? HINT: Google translate may be helpful.  
    - Bureau of Labor Statistics Height Data: csv format  
      - Note: There is no birth year, so just assume mid-20th century and use 1950 as birth year  
    - University of Wisconsin National Survey Data: SPSS (.sav) format  
      - You’ll want to look here to understand this dataset and know which columns to use: National Survey Codebook  
2. After your wrangling, each dataset should only contain the following columns:  
    - select(birth_year, height.in, height.cm, study)  
3. Use the following code to combine your five individual dataset into one dataset:  
    - alld <- bind_rows(b19, g18, g19, us20, w20)  
4. Make a small-multiples plot (i.e. facets) of the five studies containing individual heights to examine the question of height distribution across centuries.  

### Part 3: Putting it All Together  
1. Save the two tidy datasets from Part 1 and Part 2 above to your project as R datasets.  
2. Create an .Rmd file for your plots and a sentence or two describing what you see.

## Data Wrangling





