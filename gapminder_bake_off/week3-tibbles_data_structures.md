---
title: "Week 3 Tibbles and Data Structures"
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



# Data Structures 

## Vectors vs. Lists

<p style="text-align: left;">
A vector is a sequence of data elements of the same basic type. This is called "atomic" in R.
A list is a sequence of data elements of any type. There are 5 basic/common data types in R: logical, integer, double (i.e. a decimal number), character, and factor. 

The chief difference between atomic vectors and lists is that atomic vectors are homogeneous, while lists can be heterogeneous. One of the elements within a list can be another list, so they are recursive.

On a related note, there is NULL. NULL is often used to represent the absence of a vector (as opposed to NA which is used to represent the absence of a value in a vector). NULL typically behaves like a vector of length 0. 
</p>

### Vector arithmetic: recycling

Run this line of code, which seeks to add two vectors together that are not of equal length. Then describe how R is performing the vector addition. (Review the assigned reading if needed)


```r
1:2 + 1:10
```

```
##  [1]  2  4  4  6  6  8  8 10 10 12
```


## Lists vs. Data Frame vs. Tibbles

Understanding how lists work and the power of lists is an important key to becoming a master R programmer.  


### Is a data.frame a list?

Data frames are lists as well, but they have a few restrictions:

 - you can't use the same name for two different variables
 - all elements of a data frame are vectors
 - all elements of a data frame have an equal length.

Due to these restrictions and the resulting two-dimensional structure, data frames can mimick some of the behavior of matrices: You can select rows and do operations on rows. You can't do that with lists, since technically there is no such thing as a "row" in lists.


### What is a tibble?

A tibble is a new class of object, invented by the makers of the tidyverse. It is similar to a dataframe, but it's defaults are often preferred over the default behavior of data frames. Compare class of mtcars and mpg datasets.


```r
library(tidyverse)
class(mtcars)
```

```
## [1] "data.frame"
```

```r
class(mpg)
```

```
## [1] "tbl_df"     "tbl"        "data.frame"
```

A tibble `tbl` is also a `tbl_df` and a `data.frame`. One is strictly a data frame, the other can function as a data frame and a tibble, but will default to tibble behavior.

### data.frame and tbl

**What is the difference between tibbles and data frames?**

The most obvious difference between a dataframe and a tibble is how they are viewed.


```r
mtcars
```

```
##                      mpg cyl  disp  hp drat    wt  qsec vs am gear carb
## Mazda RX4           21.0   6 160.0 110 3.90 2.620 16.46  0  1    4    4
## Mazda RX4 Wag       21.0   6 160.0 110 3.90 2.875 17.02  0  1    4    4
## Datsun 710          22.8   4 108.0  93 3.85 2.320 18.61  1  1    4    1
## Hornet 4 Drive      21.4   6 258.0 110 3.08 3.215 19.44  1  0    3    1
## Hornet Sportabout   18.7   8 360.0 175 3.15 3.440 17.02  0  0    3    2
## Valiant             18.1   6 225.0 105 2.76 3.460 20.22  1  0    3    1
## Duster 360          14.3   8 360.0 245 3.21 3.570 15.84  0  0    3    4
## Merc 240D           24.4   4 146.7  62 3.69 3.190 20.00  1  0    4    2
## Merc 230            22.8   4 140.8  95 3.92 3.150 22.90  1  0    4    2
## Merc 280            19.2   6 167.6 123 3.92 3.440 18.30  1  0    4    4
## Merc 280C           17.8   6 167.6 123 3.92 3.440 18.90  1  0    4    4
## Merc 450SE          16.4   8 275.8 180 3.07 4.070 17.40  0  0    3    3
## Merc 450SL          17.3   8 275.8 180 3.07 3.730 17.60  0  0    3    3
## Merc 450SLC         15.2   8 275.8 180 3.07 3.780 18.00  0  0    3    3
## Cadillac Fleetwood  10.4   8 472.0 205 2.93 5.250 17.98  0  0    3    4
## Lincoln Continental 10.4   8 460.0 215 3.00 5.424 17.82  0  0    3    4
## Chrysler Imperial   14.7   8 440.0 230 3.23 5.345 17.42  0  0    3    4
## Fiat 128            32.4   4  78.7  66 4.08 2.200 19.47  1  1    4    1
## Honda Civic         30.4   4  75.7  52 4.93 1.615 18.52  1  1    4    2
## Toyota Corolla      33.9   4  71.1  65 4.22 1.835 19.90  1  1    4    1
## Toyota Corona       21.5   4 120.1  97 3.70 2.465 20.01  1  0    3    1
## Dodge Challenger    15.5   8 318.0 150 2.76 3.520 16.87  0  0    3    2
## AMC Javelin         15.2   8 304.0 150 3.15 3.435 17.30  0  0    3    2
## Camaro Z28          13.3   8 350.0 245 3.73 3.840 15.41  0  0    3    4
## Pontiac Firebird    19.2   8 400.0 175 3.08 3.845 17.05  0  0    3    2
## Fiat X1-9           27.3   4  79.0  66 4.08 1.935 18.90  1  1    4    1
## Porsche 914-2       26.0   4 120.3  91 4.43 2.140 16.70  0  1    5    2
## Lotus Europa        30.4   4  95.1 113 3.77 1.513 16.90  1  1    5    2
## Ford Pantera L      15.8   8 351.0 264 4.22 3.170 14.50  0  1    5    4
## Ferrari Dino        19.7   6 145.0 175 3.62 2.770 15.50  0  1    5    6
## Maserati Bora       15.0   8 301.0 335 3.54 3.570 14.60  0  1    5    8
## Volvo 142E          21.4   4 121.0 109 4.11 2.780 18.60  1  1    4    2
```


```r
mpg
```

```
## # A tibble: 234 × 11
##    manufacturer model      displ  year   cyl trans drv     cty   hwy fl    class
##    <chr>        <chr>      <dbl> <int> <int> <chr> <chr> <int> <int> <chr> <chr>
##  1 audi         a4           1.8  1999     4 auto… f        18    29 p     comp…
##  2 audi         a4           1.8  1999     4 manu… f        21    29 p     comp…
##  3 audi         a4           2    2008     4 manu… f        20    31 p     comp…
##  4 audi         a4           2    2008     4 auto… f        21    30 p     comp…
##  5 audi         a4           2.8  1999     6 auto… f        16    26 p     comp…
##  6 audi         a4           2.8  1999     6 manu… f        18    26 p     comp…
##  7 audi         a4           3.1  2008     6 auto… f        18    27 p     comp…
##  8 audi         a4 quattro   1.8  1999     4 manu… 4        18    26 p     comp…
##  9 audi         a4 quattro   1.8  1999     4 auto… 4        16    25 p     comp…
## 10 audi         a4 quattro   2    2008     4 manu… 4        20    28 p     comp…
## # ℹ 224 more rows
```

Here are some other key differences, a tibble:

* Never coerces inputs (i.e. strings stay as strings, they aren't converted to factors!).
* Never adds row.names.
* Never munges (i.e. changes) column names.
* Only recycles length 1 inputs.
* Evaluates its arguments lazily and in order.
* Adds tbl_df class to output.
* Automatically adds column names.
* When printed, the tibble reports the class of each variable. data.frame objects do not.
* When printing a tibble to screen, only the first ten rows are displayed. The number of columns printed depends on the window size.

## Working with lists and vectors

Here is a silly list we will use for the following examples.


```r
a <- list(a = 1:3, b = "a string", c = pi, d = list(-1, list(-5, "fish")))
a
```

```
## $a
## [1] 1 2 3
## 
## $b
## [1] "a string"
## 
## $c
## [1] 3.141593
## 
## $d
## $d[[1]]
## [1] -1
## 
## $d[[2]]
## $d[[2]][[1]]
## [1] -5
## 
## $d[[2]][[2]]
## [1] "fish"
```

### The Double bracket

There is an important variation of [ called [[. [[ only ever extracts a single element, and always drops names. It's a good idea to use whenever you want to make it clear that you're extracting a single item, as in a for loop. The distinction between [ and [[ is most important for lists, as we'll see shortly.

**Compare:** Can you describe what is happening in each one? 


```r
a[[c(4,2,2)]]
```

```
## [1] "fish"
```


```r
a[c(4,2,2)]
```

```
## $d
## $d[[1]]
## [1] -1
## 
## $d[[2]]
## $d[[2]][[1]]
## [1] -5
## 
## $d[[2]][[2]]
## [1] "fish"
## 
## 
## 
## $b
## [1] "a string"
## 
## $b
## [1] "a string"
```

In the double bracket code above, the double bracket selects the fourth item of the `a` list, which is in turn another list. Then it drills down to select the 2nd item in this embedded list, which is yet another list. The code is instructed to then select the 2nd item of that list.

In the single bracket code, the single brackets treat each number in the vector as trying to tell us which element**s** (plural) to return from item `a`. Therefore, it first returns the 4th item of `a`, which is a couple of embedded lists. It also returns the 2nd object of `a` twice.


