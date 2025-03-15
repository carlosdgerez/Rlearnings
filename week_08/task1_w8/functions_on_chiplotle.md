---
title: "Functions on Chiplotle"
author: "Carlos Gerez"
date: "June 07, 2023"
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

# ------------------------------ get the file --------------------------------------------------


chiplotle_base <-  read_csv("https://byuistats.github.io/M335/data/chipotle_reduced.csv", col_select = c("region","placekey", "popularity_by_day"))

#head(chiplotle_base)


# chiplotle_base$popularity_by_day[7] %>%  parse_json() %>% unlist() %>% enframe()
 
#------------------------------------------------------ Filter to a smaller dataset ----------------------------------

chiplotle_1 <- chiplotle_base %>% select("region","placekey", "popularity_by_day")
```

## Background

1. Read in the restaurant level data: https://byuistats.github.io/M335/data/chipotle_reduced.csv  
    - Here is a data dictionary  
2. Create 2 functions. Both functions should take as input the character string that contains a count of visits by day of the week. In other words, the string contained in popularity_by_day for just one site (aka row).(We will worry about expanding the function to multiple sites or rows in the next task. For now the input is just one string). The 2 functions will differ in what they return:  
    - Function 1 should return a dataframe (or tibble to be more precise) that contains the name of each day of the week in one column and the number of visits at that store in the other column  
    - Function 2 should build on Function 1 and take it a step further. Namely, it should return the most popular day of the week (in terms of visits) at that store
3. Verify your functions are working by calling them on the data for the following restaurants.

## Data Wrangling


```r
# Use this R-Chunk to clean & wrangle your data!


# pop_day <- chiplotle_1 %>%  filter(placekey == "zzw-222@5vg-nwf-mp9") %>% 
#                select(popularity_by_day)




# pop_day[[1]] %>% parse_json() %>% unlist() %>% enframe()




#pop_day[[1]]

#--------------------------------------------- FUNCTION 1 -----------------------------------

get_days <- function(chiplotle_1, placekeyn){
               pop_day <- chiplotle_1 %>%  filter(placekey == placekeyn) %>% 
                                           select(popularity_by_day)
               pop_day <- pop_day[[1]] %>% parse_json() %>% unlist() %>% enframe()
               pop_day <- pop_day %>% mutate(restaurant_placement_key = placekeyn)
               pop_day
}


#---------------------------------------------------------------------

#which.max(result_get_days$value)

#result_get_days$name[[3]]


#--------------------------------------- FUNCTION 2 --------------------------------------

# find the 2 higher values
#maxim <- which(result_get_days$value == max(result_get_days$value))

#maxim[[1]]
#length(maxim)


get_max_days <- function(result_get_days){
      max_names <- ""
      maxim <- which(result_get_days$value == max(result_get_days$value))
      for (i in maxim) {
        if (length(maxim) == 1) {
          max_names <- paste(result_get_days$name[[i]])
        } else{
        max_names <- paste(max_names,result_get_days$name[[i]], sep = ", ")
        }
      }
      if (length(maxim) > 1) {
        max_names <- sub(".","",max_names) %>% trimws()
      }
      max_names
}

#------------------------------------ Show functions -----------------------------------



show_table <- function(result_get_days){
  table <- result_get_days %>% select(name, value) %>% rename("Day" = name ,
                                                            "Visits" = value)
  knitr::kable(table, caption = result_get_days$restaurant_placement_key[[1]], align = "lccrr")
}


show_table2 <- function(result_get_max){
knitr::kable(result_get_max, col.names = "Most Popular Day:")
}






#--------------------------------------------- TESTING -------------------------------------

placekey <- "zzw-222@5vg-nwf-mp9"

result_get_days <- get_days(chiplotle_1, placekey)



show_table(result_get_days)
```

<table>
<caption>zzw-222@5vg-nwf-mp9</caption>
 <thead>
  <tr>
   <th style="text-align:left;"> Day </th>
   <th style="text-align:center;"> Visits </th>
  </tr>
 </thead>
<tbody>
  <tr>
   <td style="text-align:left;"> Monday </td>
   <td style="text-align:center;"> 94 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Tuesday </td>
   <td style="text-align:center;"> 76 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Wednesday </td>
   <td style="text-align:center;"> 89 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Thursday </td>
   <td style="text-align:center;"> 106 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Friday </td>
   <td style="text-align:center;"> 130 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Saturday </td>
   <td style="text-align:center;"> 128 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Sunday </td>
   <td style="text-align:center;"> 58 </td>
  </tr>
</tbody>
</table>

```r
result_get_max <- get_max_days(result_get_days)



show_table2(result_get_max)
```

<table>
 <thead>
  <tr>
   <th style="text-align:left;"> Most Popular Day: </th>
  </tr>
 </thead>
<tbody>
  <tr>
   <td style="text-align:left;"> Friday </td>
  </tr>
</tbody>
</table>

```r
#---------------------------------------------------------------------
placekey <- "22c-222@5z5-3rs-hwk"

result_get_days <- get_days(chiplotle_1, placekey)

show_table(result_get_days)
```

<table>
<caption>22c-222@5z5-3rs-hwk</caption>
 <thead>
  <tr>
   <th style="text-align:left;"> Day </th>
   <th style="text-align:center;"> Visits </th>
  </tr>
 </thead>
<tbody>
  <tr>
   <td style="text-align:left;"> Monday </td>
   <td style="text-align:center;"> 18 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Tuesday </td>
   <td style="text-align:center;"> 16 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Wednesday </td>
   <td style="text-align:center;"> 14 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Thursday </td>
   <td style="text-align:center;"> 27 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Friday </td>
   <td style="text-align:center;"> 26 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Saturday </td>
   <td style="text-align:center;"> 36 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Sunday </td>
   <td style="text-align:center;"> 20 </td>
  </tr>
</tbody>
</table>

```r
result_get_max <- get_max_days(result_get_days)



show_table2(result_get_max)
```

<table>
 <thead>
  <tr>
   <th style="text-align:left;"> Most Popular Day: </th>
  </tr>
 </thead>
<tbody>
  <tr>
   <td style="text-align:left;"> Saturday </td>
  </tr>
</tbody>
</table>

```r
#---------------------------------------------------------------------

placekey <- "zzw-223@5r8-fqv-xkf"

result_get_days <- get_days(chiplotle_1, placekey)

show_table(result_get_days)
```

<table>
<caption>zzw-223@5r8-fqv-xkf</caption>
 <thead>
  <tr>
   <th style="text-align:left;"> Day </th>
   <th style="text-align:center;"> Visits </th>
  </tr>
 </thead>
<tbody>
  <tr>
   <td style="text-align:left;"> Monday </td>
   <td style="text-align:center;"> 0 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Tuesday </td>
   <td style="text-align:center;"> 0 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Wednesday </td>
   <td style="text-align:center;"> 1 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Thursday </td>
   <td style="text-align:center;"> 0 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Friday </td>
   <td style="text-align:center;"> 0 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Saturday </td>
   <td style="text-align:center;"> 1 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Sunday </td>
   <td style="text-align:center;"> 0 </td>
  </tr>
</tbody>
</table>

```r
result_get_max <- get_max_days(result_get_days)



show_table2(result_get_max)
```

<table>
 <thead>
  <tr>
   <th style="text-align:left;"> Most Popular Day: </th>
  </tr>
 </thead>
<tbody>
  <tr>
   <td style="text-align:left;"> Wednesday, Saturday </td>
  </tr>
</tbody>
</table>

## Data Visualization


```r
# Use this R-Chunk to plot & visualize your data!
```

## Conclusions
