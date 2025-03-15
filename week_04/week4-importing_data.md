---
title: "Week 4 Data Structures and Data Import"
output: 
  html_document:  
    keep_md: true
    toc: true
    toc_float: true
    code_folding: show
    fig_height: 6
    fig_width: 12
    fig_align: 'center'
---



For the case study you will need to download, unzip, and then read in the files extracted from the zip file. See the section below "Read in zipped files" for more instruction on how to do this. This will be especially important later in the semester so that you do not try to push very large files to GitHub, which will stop you from being able to push.


# Download a file to your computer from the web

Excel files cannot be read in directly from the using using `read_excel()`. This section illustrates how to use some other commands so that you can programmatically read in Excel files without having to permanently store them.

This website contains interesting data about a study done to investigate the effects of caffeine and endurance: http://users.stat.ufl.edu/~winner/datasets.html

Exercise: find the "Caffeine and Endurance" study. Then read in the Excel version of the data so that it can be analyzed.


```r
library(tidyverse)
library(downloader)
library(readxl)
library(rio)

download("https://users.stat.ufl.edu/~winner/data/caffeine.xls", 
         dest = "caffeine.xls",
         mode = "wb")
read_excel("caffeine.xls")
```

```
## # A tibble: 9 × 6
##   Cyclist  mg13   mg5 `mg13-mg5` `abs(diff)`  rank
##     <dbl> <dbl> <dbl>      <dbl>       <dbl> <dbl>
## 1       9  36.2  35.0       1.15        1.15     1
## 2       7  46.5  44.5       1.98        1.98     2
## 3       6  69.5  73.2      -3.78        3.78     3
## 4       5  70.5  66.2       4.34        4.34     4
## 5       1  37.6  42.5      -4.92        4.92     5
## 6       4  58.3  52.1       6.23        6.23     6
## 7       8  66.4  57.2       9.18        9.18     7
## 8       3  79.1  63.2      15.9        15.9      8
## 9       2  59.3  85.2     -25.9        25.9      9
```

```r
# with rio
x <- import("https://users.stat.ufl.edu/~winner/data/caffeine.xls")
x
```

```
##   Cyclist  mg13   mg5 mg13-mg5 abs(diff) rank
## 1       9 36.20 35.05     1.15      1.15    1
## 2       7 46.48 44.50     1.98      1.98    2
## 3       6 69.47 73.25    -3.78      3.78    3
## 4       5 70.54 66.20     4.34      4.34    4
## 5       1 37.55 42.47    -4.92      4.92    5
## 6       4 58.33 52.10     6.23      6.23    6
## 7       8 66.35 57.17     9.18      9.18    7
## 8       3 79.12 63.20    15.92     15.92    8
## 9       2 59.30 85.15   -25.85     25.85    9
```

Here is a [solution video.](https://www.loom.com/share/165996b49fcb42f0b155227aa34a6944?sharedAppSource=personal_library)

Note that `rio::import("FILE_PATH")` greatly simplifies this process into just one step/line of code.

## Read in zipped files

[This video](https://www.loom.com/share/63766c55fa384a31afd1164dab5ab548?sharedAppSource=personal_library) will be helpful to complete the case study for this week.

```r
# Temporal files 
temporal <- tempfile()

download("https://users.stat.ufl.edu/~winner/data/caffeine.xls", 
         dest = temporal,
         mode = "wb")

read_excel(temporal)
```

```
## # A tibble: 9 × 6
##   Cyclist  mg13   mg5 `mg13-mg5` `abs(diff)`  rank
##     <dbl> <dbl> <dbl>      <dbl>       <dbl> <dbl>
## 1       9  36.2  35.0       1.15        1.15     1
## 2       7  46.5  44.5       1.98        1.98     2
## 3       6  69.5  73.2      -3.78        3.78     3
## 4       5  70.5  66.2       4.34        4.34     4
## 5       1  37.6  42.5      -4.92        4.92     5
## 6       4  58.3  52.1       6.23        6.23     6
## 7       8  66.4  57.2       9.18        9.18     7
## 8       3  79.1  63.2      15.9        15.9      8
## 9       2  59.3  85.2     -25.9        25.9      9
```

```r
# Temporal directories

temporal2 <- tempfile()
directemp <- tempdir()

download("https://byuistats.github.io/BYUI_M221_Book/Data/ExcelSpreadsheets.zip",
         destfile = temporal2, mode = "wb")

unzip(temporal2, exdir = directemp)

read_excel(paste(directemp,"CategoricalDataAnalysis_Hat.xlsx", sep = "\\"))
```

```
## # A tibble: 16 × 213
##    ...1   One Sample z-Test fo…¹ ...3  ...4  ...5  ...6  ...7  ...8  ...9  ...10
##    <chr>  <chr>                  <chr> <chr> <chr> <chr> <lgl> <lgl> <lgl> <lgl>
##  1 <NA>   Please Enter Data in … <NA>  <NA>  <NA>  <NA>  NA    NA    NA    NA   
##  2 Inputs <NA>                   <NA>  Hypo… <NA>  <NA>  NA    NA    NA    NA   
##  3 x      74                     <NA>  70    30.0… <NA>  NA    NA    NA    NA   
##  4 n      100                    <NA>  <NA>  <NA>  <NA>  NA    NA    NA    NA   
##  5 Confi… 0.95                   <NA>  Conf… <NA>  <NA>  NA    NA    NA    NA   
##  6 Null … 0.7                    <NA>  74    26    <NA>  NA    NA    NA    NA   
##  7 Type … Greater Than           <NA>  <NA>  <NA>  <NA>  NA    NA    NA    NA   
##  8 <NA>   <NA>                   <NA>  Desc… <NA>  <NA>  NA    NA    NA    NA   
##  9 <NA>   n                      <NA>  p-hat Stan… Stan… NA    NA    NA    NA   
## 10 <NA>   <NA>                   <NA>  <NA>  <NA>  <NA>  NA    NA    NA    NA   
## 11 <NA>   100                    <NA>  0.74  4.38… 4.58… NA    NA    NA    NA   
## 12 <NA>   <NA>                   <NA>  <NA>  <NA>  <NA>  NA    NA    NA    NA   
## 13 <NA>   One-Proportion z-test  <NA>  <NA>  <NA>  <NA>  NA    NA    NA    NA   
## 14 <NA>   Null Hypothesis:   H0… <NA>  <NA>  0.7   <NA>  NA    NA    NA    NA   
## 15 <NA>   z                      P-va… Conf… <NA>  <NA>  NA    NA    NA    NA   
## 16 <NA>   0.87287156094397023    0.19… 0.65… 0.82… <NA>  NA    NA    NA    NA   
## # ℹ abbreviated name: ¹​`One Sample z-Test for a Proportion`
## # ℹ 203 more variables: ...11 <lgl>, ...12 <lgl>, ...13 <lgl>, ...14 <lgl>,
## #   ...15 <lgl>, ...16 <lgl>, ...17 <lgl>, ...18 <lgl>, ...19 <lgl>,
## #   ...20 <lgl>, ...21 <lgl>, ...22 <lgl>, ...23 <lgl>, ...24 <lgl>,
## #   ...25 <lgl>, ...26 <lgl>, ...27 <lgl>, ...28 <lgl>, ...29 <lgl>,
## #   ...30 <lgl>, ...31 <lgl>, ...32 <lgl>, ...33 <lgl>, ...34 <lgl>,
## #   ...35 <lgl>, ...36 <lgl>, ...37 <lgl>, ...38 <lgl>, ...39 <lgl>, …
```


# Parsing and vector types

When you are ready to read in a file, R must parse each variable. In other words, R has to determine the data type and interpret the values in each vector or list of the file being read in.

Before diving directly into how to read in files, we will talk about the more basic step of parsing. 

Sometimes a column/vector of data may be parsed (interpreted or read-in) one way, when you actually want it to be treated as a different type of vector. 

Consider the following vector assigned to `money`. What class is it? If we want it to be treated as a numeric vector we have a couple of options. Compare the two lines of code

parse_number() is a more robust command for converting text to numbers if there are additional symbols. 


```r
money <- c('4,554,25', '$45', '8025.33cents', '288f45')

as.numeric(money) #from base R
```

```
## [1] NA NA NA NA
```

```r
library(tidyverse)
parse_number(money) #from readr package in tidyverse
```

```
## [1] 455425.00     45.00   8025.33    288.00
```


## Dealing with Factor Variables

Hypothesize what you think will happen for each line of code before running it


```r
(f<-factor(5:10)) #This creates a factor variable, f, with 6 levels: 5, 6, 7, 8, 9, 10
levels(f)[f]
levels(f)[[f]]
levels(f)[[3]]

as.numeric(f) # not what you'd expect
parse_number(f)

# what you typically meant and want:
as.numeric(as.character(f))
parse_number(as.character(f))
# the same, considerably more efficient (for long factors):
as.numeric(levels(f))
```

Notice, a factor variable actually is stored as numbers that are mapped to specific labels. So you must convert those values to their labels and store them as strings, before you can then convert them back to a numeric value.

# Data Ingestion {data-background=#e8d725}

## Why is read_csv() better than read.csv()?

The two main reasons read_csv() from the tidyverse's readr package is better than base R read.csv() is

  1. It reads the data in as a tibble instead of a data.frame
  2. For large datasets it is much faster
  

## Excel at Excel: related packages

readxl() is probably the simplest of the packages used to read excel files. However, it can't read directly from the web yet, so you will need to download the file first using the techniques described above, with `download()` from the `downloader` package. 

Here are a bunch of other packages designed to read in Excel files.

* [readxl](https://readxl.tidyverse.org/): fast and easy for structured data (by Hadley)
* [XLConnect](https://github.com/miraisolutions/xlconnect): reads in results of excel formulas. java based: cross platform, can be slow, memory hog
* [xlsx](https://github.com/colearendt/xlsx/): gives NA's for formulas. java based: cross platform, can be slow, memory hog
* [openxlsx](https://github.com/awalker89/openxlsx): slower than others. reads dates as numbers. not java dependent. Can read in protected sheets with macros
* [excel.link](https://github.com/gdemin/excel.link): allows access to data in running instance of Excel. a bit slower and much harder to learn than others.





