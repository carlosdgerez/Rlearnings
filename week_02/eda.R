
# This is the practice from chapter 7 Exploratory Data Analysis

library(tidyverse)

ggplot(data = diamonds) +
  geom_bar(mapping = aes(x = cut))


diamonds %>% 
  count(cut)

diamonds


#To examine the distribution of a continuous variable, use a histogram:

ggplot(data = diamonds) +
  geom_histogram(mapping = aes(x = carat), binwidth = 0.5)


# Compute this by hand by combining dplyr::count() and ggplot2::cut_width():

diamonds %>% 
  count(cut_width(carat, 0.5))


# You can set the width of the intervals in a histogram with 
# the binwidth argument, which is measured in the units of the x variable

smaller <- diamonds %>% 
  filter(carat < 3)

ggplot(data = smaller, mapping = aes(x = carat)) +
  geom_histogram(binwidth = 0.1)

smaller

#  It’s much easier to understand overlapping lines than bars, here with geom_freqpoly

ggplot(data = smaller, mapping = aes(x = carat, colour = cut)) +
  geom_freqpoly(binwidth = 0.1)


# Start with questions about unexpected values and patterns

ggplot(data = smaller, mapping = aes(x = carat)) +
  geom_histogram(binwidth = 0.01)

# Clusters of data

ggplot(data = faithful, mapping = aes(x = eruptions)) + 
  geom_histogram(binwidth = 0.25)


# Unusual values: the only evidence of outliers is the unusually wide limits on the x-axis.

ggplot(diamonds) + 
  geom_histogram(mapping = aes(x = y), binwidth = 0.5)

# To make it easy to see the unusual values, we need to zoom 
# to small values of the y-axis with coord_cartesian():


ggplot(diamonds) + 
  geom_histogram(mapping = aes(x = y), binwidth = 0.5) +
  coord_cartesian(ylim = c(0, 50))


# This allows us to see that there are three unusual values:
# 0, ~30, and ~60. We pluck them out with dplyr:

unusual <- diamonds %>% 
  filter(y < 3 | y > 20) %>% 
  select(price, x, y, z) %>%
  arrange(y)
unusual



# Missing values.

# Drop the entire row with the strange values:
# Not recomended

diamonds2 <- diamonds %>% 
  filter(between(y, 3, 20))

#  replacing the unusual values with missing values. 

diamonds2 <- diamonds %>% 
  mutate(y = ifelse(y < 3 | y > 20, NA, y))

diamonds2

?mutate


# It’s not obvious where you should plot missing 
# values, so ggplot2 doesn’t include them in the plot, 
# but it does warn that they’ve been removed:


ggplot(data = diamonds2, mapping = aes(x = x, y = y)) + 
  geom_point()

# To suppress that warning, set na.rm = TRUE:


ggplot(data = diamonds2, mapping = aes(x = x, y = y)) + 
  geom_point(na.rm = TRUE)

# you might want to compare the scheduled departure times
# for cancelled and non-cancelled times. You can do this by 
# making a new variable with is.na().

nycflights13::flights %>% 
  mutate(
    cancelled = is.na(dep_time),
    sched_hour = sched_dep_time %/% 100,
    sched_min = sched_dep_time %% 100,
    sched_dep_time = sched_hour + sched_min / 60
  ) %>% 
  ggplot(mapping = aes(sched_dep_time)) + 
  geom_freqpoly(mapping = aes(colour = cancelled), binwidth = 1/4)


# COVARIATION

# Covariation is the tendency for the values of two or more variables 
# to vary together in a related way.


# Example 1
# Not that useful for that sort of comparison because the height 
# is given by the count. That means if one of the groups is much 
# smaller than the others, it’s hard to see the differences in 
# shape.

ggplot(data = diamonds, mapping = aes(x = price)) + 
  geom_freqpoly(mapping = aes(colour = cut), binwidth = 500)

ggplot(diamonds) + 
  geom_bar(mapping = aes(x = cut))

# Density

ggplot(data = diamonds, mapping = aes(x = price, y = ..density..)) + 
  geom_freqpoly(mapping = aes(colour = cut), binwidth = 500)

# Boxplot


ggplot(data = diamonds, mapping = aes(x = cut, y = price)) +
  geom_boxplot()


# Ordered boxplots

ggplot(data = mpg, mapping = aes(x = class, y = hwy)) +
  geom_boxplot()


ggplot(data = mpg) +
  geom_boxplot(mapping = aes(x = reorder(class, hwy, FUN = median), y = hwy))

# If you have long variable names, geom_boxplot() will work better
# if you flip it 90°. You can do that with coord_flip().

ggplot(data = mpg) +
  geom_boxplot(mapping = aes(x = reorder(class, hwy, FUN = median), y = hwy)) +
  coord_flip()


# Exercices

install.packages("lvplot")
library("lvplot")
ggplot(data = diamonds, mapping = aes(x = cut, y = price)) +
  geom_lv()



ggplot(data = diamonds, mapping = aes(x = cut, y = price)) +
  geom_violin()


install.packages("ggbeeswarm")
??ggbeeswarm


# Two categorical variables covariation

ggplot(data = diamonds) +
  geom_count(mapping = aes(x = cut, y = color))

# compute the count with dyplr

p <- diamonds %>% 
  count(color, cut)
p


# Then visualise with geom_tile() and the fill aesthetic:

diamonds %>% 
  count(color, cut) %>%  
  ggplot(mapping = aes(x = color, y = cut)) +
  geom_tile(mapping = aes(fill = n))


install.packages("d3heatmap")


# Two continuous variables


ggplot(data = diamonds) +
  geom_point(mapping = aes(x = carat, y = price))

# The previous graph was overploated, 
# the next uses alpha to manage that

ggplot(data = diamonds) + 
  geom_point(mapping = aes(x = carat, y = price), alpha = 1 / 100)


# how to use geom_bin2d() and geom_hex() to bin in two dimensions.



ggplot(data = smaller) +
  geom_bin2d(mapping = aes(x = carat, y = price))

install.packages("hexbin")


ggplot(data = smaller) +
  geom_hex(mapping = aes(x = carat, y = price))

# Another option is to bin one continuous variable so it acts
# like a categorical variable. Then you can use one of the
# techniques for visualising the combination of a categorical
# and a continuous variable that you learned about.

ggplot(data = smaller, mapping = aes(x = carat, y = price)) + 
  geom_boxplot(mapping = aes(group = cut_width(carat, 0.1))) 


# cut_width(x, width), as used above, divides x into bins 
# of width width.



# Another approach is to display approximately the same number
# of points in each bin. That’s the job of cut_number()


ggplot(data = smaller, mapping = aes(x = carat, y = price)) + 
  geom_boxplot(mapping = aes(group = cut_number(carat, 20)))








