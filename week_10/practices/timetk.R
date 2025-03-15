library(dplyr)
library(ggplot2)
library(lubridate)
library(timetk)


# From https://business-science.github.io/timetk/articles/TK04_Plotting_Time_Series.html

taylor_30_min


taylor_30_min %>% 
  plot_time_series(date, value, 
                   .interactive = interactive,
                   .plotly_slider = TRUE)

#Plotting Groups

m4_daily %>% group_by(id)


m4_daily %>%
  group_by(id) %>%
  plot_time_series(date, value, 
                   .facet_ncol = 2, .facet_scales = "free",
                   .interactive = interactive)
# Visualizing Transformations & Sub-Groups


#>The intent is to showcase the groups in faceted plots, 
#>but to highlight weekly windows (sub-groups) within the data while
#> simultaneously doing a log() transformation to the value. This is simple to do:
#> 
#> .value = log(value) Applies the Log Transformation
#> .color_var = week(date) The date column is transformed to a lubridate::week() number. 
#> The color is applied to each of the week numbers.

m4_hourly %>%
  group_by(id) %>%
  plot_time_series(date, log(value),             # Apply a Log Transformation
                   .color_var = week(date),      # Color applied to Week transformation
                   # Facet formatting
                   .facet_ncol = 2, 
                   .facet_scales = "free", 
                   .interactive = interactive)


#> Static ggplot2 Visualizations & Customizations
#> 
#> All of the visualizations can be converted from interactive plotly 
#> (great for exploring and shiny apps)
#>  to static ggplot2 visualizations (great for reports).


taylor_30_min %>%
  plot_time_series(date, value, 
                   .color_var = month(date, label = TRUE),
                   
                   # Returns static ggplot
                   .interactive = FALSE,  
                   
                   # Customization
                   .title = "Taylor's MegaWatt Data",
                   .x_lab = "Date (30-min intervals)",
                   .y_lab = "Energy Demand (MW)",
                   .color_lab = "Month") +
  scale_y_continuous(labels = scales::comma_format())



#>Box Plots (Time Series)

#> The plot_time_series_boxplot() function can be used to make box plots.

#> Box plots use an aggregation, which is a key parameter defined by the .period argument.


m4_monthly %>%
  group_by(id) %>%
  plot_time_series_boxplot(
    date, value,
    .period      = "1 year",
    .facet_ncol  = 2,
    .interactive = FALSE)





#> Regression Plots (Time Series)

#> A time series regression plot, plot_time_series_regression(),
#>  can be useful to quickly assess key features that are correlated to a time series.

#> Internally the function passes a formula to the stats::lm() function.
#> A linear regression summary can be output by toggling show_summary = TRUE.

m4_monthly %>%
  group_by(id) %>%
  plot_time_series_regression(
    .date_var     = date,
    .formula      = log(value) ~ as.numeric(date) + month(date, label = TRUE),
    .facet_ncol   = 2,
    .interactive  = FALSE,
    .show_summary = TRUE
  )


#------------------------- Time Series Data Wrangling -------------------------


#>         Summarise by Time - For time-based aggregations
#>         Filter by Time - For complex time-based filtering
#>         Pad by Time - For filling in gaps and going from low to high frequency
#>         Slidify - For turning any function into a sliding (rolling) function
#>         
#>         Imputation - Needed for Padding (See Low to High Frequency)
#>         Advanced Filtering - Using the new add time %+time infix operation 
#>                         (See Padding Data: Low to High Frequency)
#>         Visualization - plot_time_series() for all visualizations



FANG


FANG %>%
  group_by(symbol) %>%
  plot_time_series(date, volume, .facet_ncol = 2, .interactive = TRUE) 


FANG %>%
  group_by(symbol) %>%
  plot_time_series(date, volume, .facet_ncol = 2, .interactive = FALSE)


#> Summarize by Time

#> summarise_by_time() aggregates by a period. It’s great for:
  
#   Period Aggregation - sum()
#   Period Smoothing - mean(), first(), last()

# ------------------ Period Summarization ------------------------

# Objective: Get the total trade volume by quarter

#Use sum()
#Aggregate using .by = "quarter"


FANG %>%
  group_by(symbol) %>%
  summarise_by_time(
    date, 
    .by    = "quarter",
    volume = sum(volume)
  ) %>%
  plot_time_series(date, volume, .facet_ncol = 2, .interactive = FALSE, .y_intercept = 0)

#------------------------ Period Smoothing ----------------------------------

# Objective: Get the first value in each month

# We can use first() to get the first value, which has the effect of 
# reducing the data (i.e. smoothing). We could use mean() or median().
# Use the summarization by time: .by = "month" to aggregate by month.


FANG %>%
  group_by(symbol) %>%
  summarise_by_time(
    date, 
    .by = "month",
    adjusted = first(adjusted)
  ) %>%
  plot_time_series(date, adjusted, .facet_ncol = 2, .interactive = FALSE)



# --------------------- Filter By Time ----------------

# Used to quickly filter a continuous time range.
# Time Range Filtering

# Objective: Get the adjusted stock prices in the 3rd quarter of 2013.

#  .start_date = "2013-09": Converts to “2013-09-01
#  .end_date = "2013": Converts to “2013-12-31
#> A more advanced example of filtering using %+time and %-time 
#> is shown in “Padding Data: Low to High Frequency”.

FANG %>%
  group_by(symbol) %>%
  filter_by_time(date, "2013-09", "2013") %>%
  plot_time_series(date, adjusted, .facet_ncol = 2, .interactive = FALSE)




#----------------------------- Padding Data ------------------------------------

#> Used to fill in (pad) gaps and to go from from low frequency to high frequency.
#>  This function uses the awesome padr library for filling and expanding timestamps.
#>  
#>  
#          Fill in Gaps

# Objective: Make an irregular series regular.

# We will leave padded values as NA.
#> We can add a value using .pad_value or we can impute using a function
#>  like ts_impute_vec() (shown next).

FANG %>%
  group_by(symbol) %>%
  pad_by_time(date, .by = "auto") # Guesses .by = "day"




#         Low to High Frequency

# Objective: Go from Daily to Hourly timestamp intervals for 1 month from the start date. Impute the missing values.

#  .by = "hour" pads from daily to hourly
#>  Imputation of hourly data is accomplished with ts_impute_vec(), which performs 
#>  linear interpolation when period = 1.
#  Filtering is accomplished using:
#          “start”: A special keyword that signals the start of a series
#           FIRST(date) %+time% "1 month": Selecting the first date in the sequence
#>               then using a special infix operation, %+time%, called “add time”.
#>                In this case I add “1 month”.

FANG %>%
  group_by(symbol) %>%
  pad_by_time(date, .by = "hour") %>%
  mutate_at(vars(open:adjusted), .funs = ts_impute_vec, period = 1) %>%
  filter_by_time(date, "start", first(date) %+time% "1 month") %>%
  plot_time_series(date, adjusted, .facet_ncol = 2, .interactive = FALSE) 






#----------------------- Sliding (Rolling) Calculations-------------


#> We have a new function, slidify() that turns any function into a sliding (rolling) 
#> window function.
#>  It takes concepts from tibbletime::rollify() and it improves them with the R package slider.


#> Rolling Mean

# Objective: Calculate a “centered” simple rolling average with partial window rolling and the start and end windows.

# slidify() turns the mean() function into a rolling average.

# 1. Make the rolling function
roll_avg_30 <- slidify(.f = mean, .period = 30, .align = "center", .partial = TRUE)

# 2. Apply the rolling function
FANG %>%
  select(symbol, date, adjusted) %>%
  group_by(symbol) %>%
  # Apply Sliding Function
  mutate(rolling_avg_30 = roll_avg_30(adjusted)) %>%
  pivot_longer(cols = c(adjusted, rolling_avg_30)) %>%
  plot_time_series(date, value, .color_var = name,
                   .facet_ncol = 2, .smooth = FALSE, 
                   .interactive = FALSE)

#> For simple rolling calculations (rolling average), we can accomplish this operation faster
#>  with slidify_vec() - A vectorized rolling function for simple
#>   summary rolls (e.g. mean(), sd(), sum(), etc)


FANG %>%
  select(symbol, date, adjusted) %>%
  group_by(symbol) %>%
  # Apply roll apply Function
  mutate(rolling_avg_30 = slidify_vec(adjusted,  ~ mean(.), 
                                      .period = 30, .partial = TRUE))



#--------------------- Rolling Regression --------------------------------------

# Objective: Calculate a rolling regression.

# This is a complex sliding (rolling) calculation that requires multiple columns to be involved.
# slidify() is built for this.
# Use the multi-variable purrr ..1, ..2, ..3, etc notation to setup a function


# Rolling regressions are easy to implement using `.unlist = FALSE`
lm_roll <- slidify(~ lm(..1 ~ ..2 + ..3), .period = 90, 
                   .unlist = FALSE, .align = "right")
lm_roll

FANG %>%
  select(symbol, date, adjusted, volume) %>%
  group_by(symbol) %>%
  mutate(numeric_date = as.numeric(date)) %>%
  # Apply rolling regression
  mutate(rolling_lm = lm_roll(adjusted, volume, numeric_date)) %>%
  filter(!is.na(rolling_lm))
