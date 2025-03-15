


# Loading libraries 


library(nycflights13)
library(tidyverse)


# Looking to the data and his dictionary

view(flights)
?flights
flights


# The five verbs :
# 
# Pick observations by their values (filter()).
# Reorder the rows (arrange()).
# Pick variables by their names (select()).
# Create new variables with functions of existing variables (mutate()).
# Collapse many values down to a single summary (summarise()).

# Filter()

#  select all flights on January 1st with:

filter(flights, month == 1, day == 1)

# save results in a variable and print the results

(dec25 <- filter(flights, month == 12, day == 25))

dec25

# The following code finds all flights that departed in November or December:

filter(flights, month == 11 | month == 12)

# The number of flights in november and december
count(filter(flights, month == 11 | month == 12))


# Shorthand way with %in%

nov_dec <- filter(flights, month %in% c(11, 12))
nov_dec

# De Morgan’s law: !(x & y) is the same as !x | !y, and !(x | y) is the same as !x & !y
# For example, if you wanted to find flights that weren’t delayed (on arrival or departure) 
# by more than two hours, you could use either of the following two filters:


filter(flights, !(arr_delay > 120 | dep_delay > 120))
filter(flights, arr_delay <= 120, dep_delay <= 120)

# If you want to determine if a value is missing, use is.na():

x <- NA
is.na(x)

# filter() only includes rows where the condition is TRUE; 
# it excludes both FALSE and NA values. If you want to preserve 
# missing values, ask for them explicitly:

df <- tibble(x = c(1, NA, 3))
filter(df, x > 1)
#> # A tibble: 1 × 1
#>       x
#>   <dbl>
#> 1     3
filter(df, is.na(x) | x > 1)
#> # A tibble: 2 × 1
#>       x
#>   <dbl>
#> 1    NA
#> 2     3

# Uses of between()

?between()



# Arrange rows with arrange()
# It takes a data frame and a set of column names (or more complicated expressions) to order by. 

arrange(flights, year, month, day)

# Use desc() to re-order by a column in descending order:

arrange(flights, desc(dep_delay))

# Missing values are always sorted at the end:

?desc()

# Select columns with select()

# Select columns by name
select(flights, year, month, day)

# Select all columns between year and day (inclusive)
select(flights, year:day)

# Select all columns except those from year to day (inclusive)
select(flights, -(year:day))

# starts_with("abc"): matches names that begin with “abc”.

# ends_with("xyz"): matches names that end with “xyz”.

# contains("ijk"): matches names that contain “ijk”.

# matches("(.)\\1"): selects variables that match a regular expression.

select(flights, starts_with("a"))
select(flights, starts_with("y"))

# Use rename() to rename variables


rename(flights, tail_num = tailnum)
?rename

# Move variables to the start of the dataframe
select(flights, time_hour, air_time, everything())

?any_of()
?select


select(flights, contains("TIME"))

select(flights, contains("TIME", ignore.case = FALSE))


# Add new variables with mutate()

flights_sml <- select(flights, 
                      year:day, 
                      ends_with("delay"), 
                      distance, 
                      air_time
)
mutate(flights_sml,
       gain = dep_delay - arr_delay,
       speed = distance / air_time * 60
)


# Note that you can refer to columns that you’ve just created:

mutate(flights_sml,
       gain = dep_delay - arr_delay,
       hours = air_time / 60,
       gain_per_hour = gain / hours
)

# If you only want to keep the new variables, use transmute():

transmute(flights,
          gain = dep_delay - arr_delay,
          hours = air_time / 60,
          gain_per_hour = gain / hours
)

# Useful combinations of arithmetic functions
# x / sum(x) calculates the proportion of a total, and
# y - mean(y) computes the difference from the mean.



# Modular arithmetic: %/% (integer division) and %% (remainder), 
# where x == y * (x %/% y) + (x %% y). Modular arithmetic is
# a handy tool because it allows you to break integers up into pieces.
# For example, in the flights dataset, you can compute hour and minute 
# from dep_time with:

transmute(flights,
          dep_time,
          hour = dep_time %/% 100,
          minute = dep_time %% 100
)

# LOGS
# Logs: log(), log2(), log10(). Logarithms are an incredibly useful 
# transformation for dealing with data that ranges across multiple orders of magnitude. 
# All else being equal, I recommend using log2() because it’s easy to interpret:
# a difference of 1 on the log scale corresponds to doubling on the original scale
# and a difference of -1 corresponds to halving.

# OFFSETS
# Offsets: lead() and lag() allow you to refer to leading or lagging values. 
# This allows you to compute running differences (e.g. x - lag(x)) or
# find when values change (x != lag(x)). 

(x <- 1:10)
#>  [1]  1  2  3  4  5  6  7  8  9 10
lag(x)
#>  [1] NA  1  2  3  4  5  6  7  8  9
lead(x)
#>  [1]  2  3  4  5  6  7  8  9 10 NA


# Cumulative and rolling aggregates: R provides functions for 
#running sums, products, mins and maxes: cumsum(), cumprod(), 
# cummin(), cummax(); and dplyr provides cummean() for cumulative means.

x
#>  [1]  1  2  3  4  5  6  7  8  9 10
cumsum(x)
#>  [1]  1  3  6 10 15 21 28 36 45 55
cummean(x)
#>  [1] 1.0 1.5 2.0 2.5 3.0 3.5 4.0 4.5 5.0 5.5


# Ranking: there are a number of ranking functions, 
# but you should start with min_rank()

y <- c(1, 2, 2, NA, 3, 4)
min_rank(y)
#> [1]  1  2  2 NA  4  5
min_rank(desc(y))
#> [1]  5  3  3 NA  2  1

# If min_rank() doesn’t do what you need,
# look at the variants row_number(), dense_rank(),
# percent_rank(), cume_dist(), ntile().

row_number(y)
#> [1]  1  2  3 NA  4  5
dense_rank(y)
#> [1]  1  2  2 NA  3  4
percent_rank(y)
#> [1] 0.00 0.25 0.25   NA 0.75 1.00
cume_dist(y)
#> [1] 0.2 0.6 0.6  NA 0.8 1.0

# Compare air_time with arr_time - dep_time. 
# What do you expect to see? What do you see? What do you need to do to fix it?


transmute(flights,
          air_time,
          arr_time,
          dep_time,
          diference = arr_time - dep_time)
view(flights)

?min_rank

# Find the 10 most delayed flights 
# using a ranking function. How do you want to handle ties?
# Carefully read the documentation for min_rank().

new4 <- flights %>% 
  mutate(total_delay = dep_delay + arr_delay) %>% 
  arrange(desc(total_delay)) 
 
# not completely sure of the use of rank instead of arrange.  


test <- mutate(new4,
       tail_rank = min_rank(total_delay) <= 10)

# a way to slice the head
test2 <- head(new4, 10)


view(test2)


# summarise(). It collapses a data frame to a single row:

summarise(flights, delay = mean(dep_delay, na.rm = TRUE))


# if we applied exactly the same code to a data frame grouped by date, we get the average delay per date:

by_day <- group_by(flights, year, month, day)

view(by_day)

summarise(by_day, delay = mean(dep_delay, na.rm = TRUE))

?n()

#>we want to explore the relationship between the distance and average
#> delay for each location. Using what you know about dplyr,
#>  you might write code like this:

by_dest <- group_by(flights, dest)
delay <- summarise(by_dest,
                   count = n(),
                   dist = mean(distance, na.rm = TRUE),
                   delay = mean(arr_delay, na.rm = TRUE)
)
delay <- filter(delay, count > 20, dest != "HNL")
delay


# It looks like delays increase with distance up to ~750 miles 
# and then decrease. Maybe as flights get longer there's more 
# ability to make up delays in the air?
ggplot(data = delay, mapping = aes(x = dist, y = delay)) +
  geom_point(aes(size = count), alpha = 1/3) +
  geom_smooth(se = FALSE)



#  another way to tackle the same problem with the pipe, %>%:

delays <- flights %>% 
  group_by(dest) %>% 
  summarise(
    count = n(),
    dist = mean(distance, na.rm = TRUE),
    delay = mean(arr_delay, na.rm = TRUE)
  ) %>% 
  filter(count > 20, dest != "HNL")


#> all aggregation functions have an na.rm argument which
#>  removes the missing values prior to computation:


flights %>% 
  group_by(year, month, day) %>% 
  summarise(mean = mean(dep_delay, na.rm = TRUE))



#>  In this case, where missing values represent
#>  cancelled flights, we could also tackle the problem 
#>  by first removing the cancelled flights.
#>  We’ll save this dataset so we can reuse it in the next few examples.


not_cancelled <- flights %>% 
  filter(!is.na(dep_delay), !is.na(arr_delay))

not_cancelled %>% 
  group_by(year, month, day) %>% 
  summarise(mean = mean(dep_delay))

# Counts sum(!is.na(x)) and n()

# let’s look at the planes (identified by their tail number)
# that have the highest average delays:


delays <- not_cancelled %>% 
  group_by(tailnum) %>% 
  summarise(
    delay = mean(arr_delay)
  )

ggplot(data = delays, mapping = aes(x = delay)) + 
  geom_freqpoly(binwidth = 10)

?summarise

# We can get more insight if we draw a scatterplot of number of flights vs. average delay:

delays <- not_cancelled %>% 
  group_by(tailnum) %>% 
  summarise(
    delay = mean(arr_delay, na.rm = TRUE),
    n = n()
  )

ggplot(data = delays, mapping = aes(x = n, y = delay)) + 
  geom_point(alpha = 1/10)

#> whenever you plot a mean (or other summary) vs. group size, 
#> you’ll see that the variation decreases as the sample size increases.
#> 
#> 


#> When looking at this sort of plot, it’s often useful to filter out 
#> the groups with the smallest numbers of observations, so you can see more
#> of the pattern and less of the extreme variation in the smallest groups. 
#> 


delays %>% 
  filter(n > 25) %>% 
  ggplot(mapping = aes(x = n, y = delay)) + 
  geom_point(delays %>% 
               filter(n > 25) %>% 
               ggplot(mapping = aes(x = n, y = delay)) + 
               geom_point(alpha = 1/10))



#> Let’s look at how the average performance of batters in baseball is related to the number 
#> of times they’re at bat. Here I use data from the Lahman package to compute the batting average 
#> (number of hits / number of attempts) of every major league baseball player.
#> When I plot the skill of the batter (measured by the batting average, ba) 
#> against the number of opportunities to hit the ball (measured by at bat, ab), 
#> you see two patterns:
#>   As above, the variation in our aggregate decreases as we get more data points.
#>   There’s a positive correlation between skill (ba) and opportunities to hit the ball (ab).
#>   This is because teams control who gets to play, and obviously they’ll pick their best players.

# Convert to a tibble so it prints nicely
batting <- as_tibble(Lahman::Batting)

batters <- batting %>% 
  group_by(playerID) %>% 
  summarise(
    ba = sum(H, na.rm = TRUE) / sum(AB, na.rm = TRUE),
    ab = sum(AB, na.rm = TRUE)
  )

batters %>% 
  filter(ab > 100) %>% 
  ggplot(mapping = aes(x = ab, y = ba)) +
  geom_point() + 
  geom_smooth(se = FALSE)

?geom_smooth


# Useful summary functions

#> Measures of location: we’ve used mean(x), but median(x) is also useful.
#> The mean is the sum divided by the length; 
#> the median is a value where 50% of x is above it, and 50% is below it.

not_cancelled %>% 
  group_by(year, month, day) %>% 
  summarise(
    avg_delay1 = mean(arr_delay),
    avg_delay2 = mean(arr_delay[arr_delay > 0]) # the average positive delay
  )



#> Measures of spread: sd(x), IQR(x), mad(x). 
#> The root mean squared deviation, or standard deviation sd(x), is the standard measure of spread. 
#> The interquartile range IQR(x) and
#> median absolute deviation mad(x) are robust equivalents that may be more useful if you have outliers

# Why is distance to some destinations more variable than to others?
not_cancelled %>% 
  group_by(dest) %>% 
  summarise(distance_sd = sd(distance)) %>% 
  arrange(desc(distance_sd))


#> Measures of rank: min(x), quantile(x, 0.25), max(x). Quantiles are a generalisation of the median.
#> For example, quantile(x, 0.25) will find a value of x that is greater than 25% of the values, 
#> and less than the remaining 75%.

not_cancelled %>% 
  group_by(year, month, day) %>% 
  summarise(
    first = min(dep_time),
    last = max(dep_time)
  )

#> Measures of position: first(x), nth(x, 2), last(x). These work similarly to x[1], x[2], and x[length(x)]
#> but let you set a default value if that position does not exist
#> (i.e. you’re trying to get the 3rd element from a group that only has two elements). 
#> For example, we can find the first and last departure for each day:

not_cancelled %>% 
  group_by(year, month, day) %>% 
  summarise(
    first_dep = first(dep_time), 
    last_dep = last(dep_time)
  )


#> These functions are complementary to filtering on ranks. 
#> Filtering gives you all variables, with each observation in a separate row:

not_cancelled %>% 
  group_by(year, month, day) %>% 
  mutate(r = min_rank(desc(dep_time))) %>% 
  filter(r %in% range(r))



#> Counts: You’ve seen n(), which takes no arguments, and returns the size of the current group.
#> To count the number of non-missing values, use sum(!is.na(x)).
#> To count the number of distinct (unique) values, use n_distinct(x).

# Which destinations have the most carriers?
not_cancelled %>% 
  group_by(dest) %>% 
  summarise(carriers = n_distinct(carrier)) %>% 
  arrange(desc(carriers))


#>  Counts are so useful that dplyr provides a simple helper if all you want is a count:

not_cancelled %>% 
  count(dest)


#> You can optionally provide a weight variable. 
#> For example, you could use this to “count” (sum) the total number of miles a plane flew:

not_cancelled %>% 
  count(tailnum, wt = distance)


#> Counts and proportions of logical values: 
#> sum(x > 10), mean(y == 0). 
#> When used with numeric functions, TRUE is converted to 1 and FALSE to 0. 
#> This makes sum() and mean() very useful: sum(x) gives the number of TRUEs in x, 
#> and mean(x) gives the proportion.


# How many flights left before 5am? (these usually indicate delayed
# flights from the previous day)
not_cancelled %>% 
  group_by(year, month, day) %>% 
  summarise(n_early = sum(dep_time < 500))


# What proportion of flights are delayed by more than an hour?
not_cancelled %>% 
  group_by(year, month, day) %>% 
  summarise(hour_prop = (mean(arr_delay > 60)) * 100)
