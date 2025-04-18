
# This is practice that follows the slides from the power point presentation on week 6 of DS 350

library(tidyverse)

book_table <- tibble(
  Book = c("Moby Dick","Harry Potter, Half Blood Prince","White Fang","Old Yeller","Bartleby"),
  Author_name = c("Herman Melville","JK Rowling","Jack London","Fred Gipson","Herman Melville"),
  word_count = c(206052,169441,72071,35968,8000)
)

author_table <- tibble(
  Author = c("Jane Austen","Herman Melville","JK Rowling","Fred Gipson"),
  Birth_Yr = c("1775","1819","1965","1908"),
  gender = c("F","M","F","M")
)

left_join(book_table, author_table, by = c("Author_name" = "Author"))

right_join(book_table,author_table, by = c("Author_name" = "Author"))

inner_join(book_table,author_table, by = c("Author_name" = "Author"))

full_join(book_table, author_table, by = c("Author_name" = "Author"))



# code reusable for the future 
#which destinations have the largest average arrival delays

flights %>% 
  drop_na(arr_delay) %>%
  group_by(dest) %>%
  summarise(avg_delay = mean(arr_delay)) %>%
  arrange(desc(avg_delay))

#Which airports have the largest arrival delays?
flights %>% 
  drop_na(arr_delay) %>%
  group_by(dest) %>%
  summarise(avg_delay = mean(arr_delay)) %>%
  arrange(desc(avg_delay)) %>% 
  left_join(airports, by = c("dest" = "faa")) %>% 
  select(name, avg_delay)

#>
#left_join() - joins relevant data from the second data set to the first
#right_join() - joins relevant data from the first data set to the second
#full_join() - retains all available data
#inner_join() - retians only observations that appear in both data sets



# filter with semi_join with a created criteria ( exist also an anti_join)

criteria <- tribble(
  ~month, ~carrier,
  1,     "B6", # B6 = JetBlue
  2,     "WN"  # WN = Southwest
)

criteria

flights %>% 
  semi_join(criteria, by = c("month", "carrier"))




#semi_join() returns rows that have a match in the second data set.
#It provides a useful shortcut for complicated filtering.

#anti_join() returns rows that do not have a match in the second data set. 
#It provides a useful way to check for possible errors in a join.

#distinct() is not a join at all, but it does filter data sets in a useful way.



#When conbining data with bind_rows(), it can be useful to add a new column that shows where each row came from.

# band and band2 are two tibles, .id creates a new column in the final result with df1 or df2 depending on the name assigned as origin
bands <- list(df1 = band, 
              df2 = band2)

bands %>% bind_rows(.id = "origin")
