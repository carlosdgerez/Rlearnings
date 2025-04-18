


library(tidyverse)
library(stringi)



# Name : Carlos Gerez
# Course DS 350

# Week 7 


#############################################################################################

#> Task 1. 




#> 
#> With the randomletters.txt file, pull out every 1700 letter (for example, 1, 1700, 3400, 5100, …)
#>  and find the quote that is hidden—the quote ends with a period.

dat <- readr::read_lines("https://byuistats.github.io/M335/data/randomletters.txt")


# Build a sequence of the positions to search
pos <- str_c(seq(from = 1, to = 70000, by = 1700))

# Put the first position
newt <- str_sub(dat,1,1)

# Loop for each position paste the letters into the string
for (i in as.numeric(pos)){
  newt <-  paste(newt,(str_sub(dat,i - 1, i - 1)))
  
}

# Result

# extract the message that ends in the .
quote <- str_split(newt, "\\.")[[1]][1]
quote

############################################################################################


#> Task 2


#> With the randomletters_wnumbers.txt file, find all the numbers hidden,
#>  and convert those numbers to letters using the letters order in the alphabet to decipher the message.
#>  (Hint: the message starts with “experts”).


dat2 <- readr::read_lines("https://byuistats.github.io/M335/data/randomletters_wnumbers.txt") 




# get all the numbers from the set

numbers <- dat2 %>% str_match_all("[0-9]+") %>% unlist()

# Create a pattern for replacements


replacements <- c( "1" = "a", "2" = "b", "3" = "c", "4" = "d", "5" = "e",
                  "6" = "f", "7" = "g", "8" = "h", "9" = "i", "10" = "j", 
                  "11" = "k", "12" = "l", "13" = "m", "14" = "n", "15" = "o", 
                  "16" = "p", "17" = "q", "18" = "r", "19" = "s", "20" = "t", 
                  "21" = "u", "22" = "v", "23" = "w", "24" = "x", "25" = "y", 
                  "26" = "z")

# invert the order to get the right translation for double digits numbers (must be processed first)
replacements <- sort(replacements, decreasing = TRUE)


msg <- str_replace_all(numbers, pattern = replacements)

# consolidate the mesage in one string
msg <- stri_paste(msg, collapse = '')

# result


final_msg <- paste(
    stri_sub(str = msg , from = 1, to = 7),
    stri_sub(str = msg, from = 8, to = 12),
    stri_sub(str = msg, from = 13, to = 19),
    stri_sub(str = msg, from = 20, to = 23),
    stri_sub(str = msg, from = 24, to = 27),
    stri_sub(str = msg, from = 28, to = 31),
    stri_sub(str = msg, from = 32, to = 39),
    sep = " "
)


final_msg

############################################################################################################


# Task 3

#> With the randomletters.txt file, remove all the spaces and periods from the string
#> then find the longest sequence of vowels.

# Remove spaces and periods
clean <- dat %>% str_remove_all("[\\s\\.]") 

# extract vowels, set them in a tibble, measure they lenght in a new column and order by this column 

result <- tibble(vowel = unlist(str_extract_all(clean,"[aeiou]+"))) %>% 
                 mutate(longest =str_length(vowel)) %>% 
                 arrange(desc(longest)) %>% head(1)
result






