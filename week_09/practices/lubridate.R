

library(lubridate)
library(tidyverse)
library(readr)

#> 5 operations.
#> 
#> 
#> 
#> Parse Text and Convert to Date / Time 
#> Extract Values (e.g. Day of Week) from Date / Time
#> Calculate duration between two different times
#> Filter Data based on Date / Time Values
#> Round Date / Time Values
#> 
#> 
#> 
#> 

political <- read_csv("C:\\Users\\Emilia\\Desktop\\12_BYU_spring_2023\\store\\political.csv")

head(political)

#> Parse Text and Convert to Date and Time

political %>% mutate(start_time = ymd_hms(start_time), end_time = ymd_hms(end_time))

# If date are separated in different columns :
# mutate(ARR_DATE_TIME_text = ymd_hm(str_c(year, month, day,hour,minute, sep=”-”)))




# See the start and end in local time zone:


test <- political %>% mutate(start_time = ymd_hms(start_time), 
       start_time_in_local_tz = with_tz(start_time), 
       end_time = ymd_hms(end_time), 
       end_time_in_local_tz = with_tz(end_time))
view(test)





# Extract month

political %>% mutate(month_name = month(start_time, label = TRUE)) %>% view()


#> Filter based on Date and Time
#> 

#> Sometimes we want to filter the data in a certain date and/or time period. Let’s say we are interested in the data for the last 5 weeks.
#> To do this, first, you can get the current date and time with today() or now() function, 
#> which will return the current date or date/time. 
#> Second, you can calculate the date/time of x weeks ago by subtracting x number of weeks from the current date/time.
#> Last, you can filter only the date and times that are greater than the x weeks ago. So it will look something like this.



test2 <- political %>% filter(start_time > now() - years(8))
test2

# Calculate the length between two date and times

political <-  political %>% mutate(start_time = ymd_hms(start_time), end_time = ymd_hms(end_time))

test3 <- political %>% mutate(air_time = end_time - start_time)
print(test3, n = 5)
view(test3)
test3$air_time %>%  class()


# get the values in minutes

test3 <- test3 %>% mutate(air_time2 = as.numeric(end_time - start_time, units="mins"))

test3$air_time2 %>% class()






# Round Date and Time


#> Sometimes, you want to round date to a certain level like month, week, day, etc, 
#> so that you can group data or aggregate at that level. For example, when you have
#>  sales data or user activity data you might want to aggregate the sales amounts or
#>   the numbers of the activities by week, month, or quarter, to see the trend or growth.


test4 <- political %>% mutate(date_by_week = floor_date(start_time, unit = "week")) %>% 
                                group_by(date_by_week) %>% 
                                mutate(count = n())
view(test4)
