


library(tidyverse)
library(RVerbalExpressions)
library(stringr)

str_c("prefix-", c("a", "b", "c"), "-suffix")
#> [1] "prefix-a-suffix" "prefix-b-suffix" "prefix-c-suffix"






name <- "Hadley"
time_of_day <- "morning"
birthday <- FALSE

str_c(
  "Good ", time_of_day, " ", name,
  if (birthday) " and HAPPY BIRTHDAY",
  "."
)
#> [1] "Good morning Hadley."



str_c(c("x", "y", "z"), collapse = ", ")
#> [1] "x, y, z"



x <- c("Apple", "Banana", "Pear")
str_sub(x, 1, 3)#> [1] "App" "Ban" "Pea"
# negative numbers count backwards from end
str_sub(x, -3, -1)
#> [1] "ple" "ana" "ear"


str_sub(x, 1, 1) <- str_to_lower(str_sub(x, 1, 1))
x
#> [1] "apple"  "banana" "pear"



#> The following function extracts the middle character.
#> If the string has an even number of characters the choice is arbitrary.
#> We choose to select ⌈n/2⌉, because that case works even if the string is only of length one.
#> A more general method would allow the user to select either the floor or ceiling for the middle character of an even string.


x <- c("a", "abc", "abcd", "abcde", "abcdef")
L <- str_length(x)
m <- ceiling(L / 2)
str_sub(x, m, m)
#> [1] "a" "b" "b" "c" "c"





#>The function str_trim() trims the whitespace from a string.

str_trim(" abc ")
#> [1] "abc"
str_trim(" abc ", side = "left")
#> [1] "abc "
str_trim(" abc ", side = "right")
#> [1] " abc"

#>The opposite of str_trim() is str_pad() which adds characters to each side.

str_pad("abc", 5, side = "both")
#> [1] " abc "
str_pad("abc", 4, side = "right")
#> [1] "abc "
str_pad("abc", 4, side = "left")
#> [1] " abc"



#> Write a function that turns (e.g.) a vector c("a", "b", "c") into the string "a, b, and c".
#>  Think carefully about what it should do if given a vector of length 0, 1, or 2.


str_commasep <- function(x, delim = ",") {
  n <- length(x)
  if (n == 0) {
    ""
  } else if (n == 1) {
    x
  } else if (n == 2) {
    # no comma before and when n == 2
    str_c(x[[1]], "and", x[[2]], sep = " ")
  } else {
    # commas after all n - 1 elements
    not_last <- str_c(x[seq_len(n - 1)], delim)
    # prepend "and" to the last element
    last <- str_c("and", x[[n]], sep = " ")
    # combine parts with spaces
    str_c(c(not_last, last), collapse = " ")
  }
}
str_commasep("")
#> [1] ""
str_commasep("a")
#> [1] "a"
str_commasep(c("a", "b"))
#> [1] "a and b"
str_commasep(c("a", "b", "c"))
#> [1] "a, b, and c"
str_commasep(c("a", "b", "c", "d"))
#> [1] "a, b, c, and d"






x <- c("apple", "banana", "pear")
str_view(x, "an")


str_view(x, ".a.")



# To create the regular expression, we need \\
dot <- "\\."

# But the expression itself only contains one:
writeLines(dot)
#> \.

# And this tells R to look for an explicit .
str_view(c("abc", "a.c", "bef"), "a\\.c")



x <- "a\\b"
writeLines(x)
#> a\b

str_view(x, "\\\\")


x <- c("apple", "banana", "pear")
str_view(x, "^a")

str_view(x, "a$") 

str_view(x, "^apple$") 



# Look for a literal character that normally has special meaning in a regex
str_view(c("abc", "a.c", "a*c", "a c"), "a[.]c")

str_view(c("abc", "a.c", "a*c", "a c"), ".[*]c")

str_view(c("abc", "a.c", "a*c", "a c"), "a[ ]") 







str_view(c("grey", "gray"), "gr(e|a)y")


str_subset(stringr::words, "[aeiou]", negate=TRUE)
#> [1] "by"  "dry" "fly" "mrs" "try" "why"

str_view(stringr::words, "[aeiou]", match=FALSE)

str_subset(stringr::words, "[^e]ed$")
#> [1] "bed"     "hundred" "red"




str_subset(c("ed", stringr::words), "(^|[^e])ed$")
#> [1] "ed"      "bed"     "hundred" "red"




str_subset(stringr::words, "i(ng|se)$")
#>  [1] "advertise" "bring"     "during"    "evening"   "exercise"  "king"     
#>  [7] "meaning"   "morning"   "otherwise" "practise"  "raise"     "realise"  
#> [13] "ring"      "rise"      "sing"      "surprise"  "thing"


x <- "1888 is the longest year in Roman numerals: MDCCCLXXXVIII"
str_view(x, "CC?")


str_view(x, "CC+") 

str_view(x, 'C[LX]+') 

str_view(x, "C{2}")

str_view(x, "C{2,}") 


str_view(x, "C{2,3}") 

str_view(x, 'C{2,3}?')






x <- c("123-456-7890", "(123)456-7890", "(123) 456-7890", "1235-2351")
str_view(x, "\\d\\d\\d-\\d\\d\\d-\\d\\d\\d\\d")

str_view(x, "[0-9][0-9][0-9]-[0-9][0-9][0-9]-[0-9][0-9][0-9][0-9]")

str_view(x, "\\(\\d\\d\\d\\)\\s*\\d\\d\\d-\\d\\d\\d\\d")

str_view(x, "\\(\\d\\d\\d\\)\\s*\\d\\d\\d-\\d\\d\\d\\d")


str_view(x, "\\d{3}-\\d{3}-\\d{4}")


str_view(x, "\\(\\d{3}\\)\\s*\\d{3}-\\d{4}")


x <- "1888 is the longest year in Roman numerals: MDCCCLXXXVIII"

str_view(x, "CC?")


str_view(x, "CC{0,1}")

str_view(x, "CC+")

str_view(x, "CC{1,}")

str_view_all(x, "C[LX]+")

str_view_all(x, "C[LX]{1,}")

str_view_all(x, "C[LX]*")

str_view_all(x, "C[LX]{0,}")








#This regex finds all words starting with three consonants.

str_view(words, "^[^aeiou]{3}", match = TRUE)

#This regex finds three or more vowels in a row:

str_view(words, "[aeiou]{3,}", match = TRUE)

#This regex finds two or more vowel-consonant pairs in a row.

str_view(words, "([aeiou][^aeiou]){2,}", match = TRUE)


#the following regular expression finds all fruits that have a repeated pair of letters.

str_view(fruit, "(..)\\1", match = TRUE)

# This regular expression matches words that start and end with the same character.

str_subset(words, "^(.)((.*\\1$)|\\1?$)")


#>This regular expression will match any pair of repeated letters, 
#>where letters is defined to be the ASCII letters A-Z.
#> First, check that it works with the example in the problem.

str_subset("church", "([A-Za-z][A-Za-z]).*\\1")
#> [1] "church"

str_subset(words, "([A-Za-z][A-Za-z]).*\\1")



#> This regex matches words that contain one letter repeated in at least three places.
#>  First, check that it works with th example given in the question.


str_subset(words, "([a-z]).*\\1.*\\1")





x <- c("apple", "banana", "pear")
str_detect(x, "e")
#> [1]  TRUE FALSE  TRUE


# How many common words start with t?
sum(str_detect(words, "^t"))
#> [1] 65
# What proportion of common words end with a vowel?
mean(str_detect(words, "[aeiou]$"))
#> [1] 0.2765306




# Find all words containing at least one vowel, and negate
no_vowels_1 <- !str_detect(words, "[aeiou]")
# Find all words consisting only of consonants (non-vowels)
no_vowels_2 <- str_detect(words, "^[^aeiou]+$")
identical(no_vowels_1, no_vowels_2)
#> [1] TRUE
#> 
#> 
#> A common use of str_detect() is to select the elements that match a pattern.
#>  You can do this with logical subsetting, or the convenient str_subset() wrapper:

words[str_detect(words, "x$")]
#> [1] "box" "sex" "six" "tax"
str_subset(words, "x$")
#> [1] "box" "sex" "six" "tax"



######################################seq_along()##################################

df <- tibble(
  word = words, 
  i = seq_along(word)
)
df %>% 
  filter(str_detect(word, "x$"))
#> # A tibble: 4 × 2
#>   word      i
#>   <chr> <int>
#> 1 box     108
#> 2 sex     747
#> 3 six     772
#> 4 tax     841


################# to find and count matches of Jesus in BOM #######################

#>A variation on str_detect() is str_count(): rather than a simple yes or no, 
#>it tells you how many matches there are in a string:

x <- c("apple", "banana", "pear")
str_count(x, "a")
#> [1] 1 3 1

x <- c("apple", "banana", "pear", "Jesus", "Jesus","Jesus", "Jesucristo")

str_count(x, "Jesus")

sum(str_count(x, "Jesus"))



# On average, how many vowels per word?
mean(str_count(words, "[aeiou]"))
#> [1] 1.991837

x1 <- c("apple", "banana", "pear", "banana", "banana")
sum(str_count(x1, "banana"))



# It’s natural to use str_count() with mutate():

df %>% 
  mutate(
    vowels = str_count(word, "[aeiou]"),
    consonants = str_count(word, "[^aeiou]")
  )
#> # A tibble: 980 × 4
#>   word         i vowels consonants
#>   <chr>    <int>  <int>      <int>
#> 1 a            1      1          0
#> 2 able         2      2          2
#> 3 about        3      3          2
#> 4 absolute     4      4          4
#> 5 accept       5      2          4
#> 6 account      6      3          4
#> # … with 974 more rows



length(sentences)
#> [1] 720
head(sentences)
#> [1] "The birch canoe slid on the smooth planks." 
#> [2] "Glue the sheet to the dark blue background."
#> [3] "It's easy to tell the depth of a well."     
#> [4] "These days a chicken leg is a rare dish."   
#> [5] "Rice is often served in round bowls."       
#> [6] "The juice of lemons makes fine punch."




#> Imagine we want to find all sentences that contain a colour. 
#> We first create a vector of colour names, and then turn it
#> into a single regular expression:


colours <- c("red", "orange", "yellow", "green", "blue", "purple")
colour_match <- str_c(colours, collapse = "|")
colour_match
#> [1] "red|orange|yellow|green|blue|purple"


#> Now we can select the sentences that contain a colour,
#>  and then extract the colour to figure out which one it is:

has_colour <- str_subset(sentences, colour_match)
matches <- str_extract(has_colour, colour_match)
head(matches)
#> [1] "blue" "blue" "red"  "red"  "red"  "blue"


#> Note that str_extract() only extracts the first match.
#> We can see that most easily by first selecting all the sentences that have more than 1 match:
#> 

more <- sentences[str_count(sentences, colour_match) > 1]
str_view_all(more, colour_match)


#> This is a common pattern for stringr functions, because working with a single 
#> match allows you to use much simpler data structures. To get all matches,
#>  use str_extract_all(). It returns a list:



str_extract_all(more, colour_match)
#> [[1]]
#> [1] "blue" "red" 
#> 
#> [[2]]
#> [1] "green" "red"  
#> 
#> [[3]]
#> [1] "orange" "red"




#> If you use simplify = TRUE,
#> str_extract_all() will return a matrix with 
#> short matches expanded to the same length as the longest:


str_extract_all(more, colour_match, simplify = TRUE)
#>      [,1]     [,2] 
#> [1,] "blue"   "red"
#> [2,] "green"  "red"
#> [3,] "orange" "red"


# A way to extract just the letters?
x <- c("a", "a b", "a b c")
str_extract_all(x, "[a-z]", simplify = TRUE)
#>      [,1] [,2] [,3]
#> [1,] "a"  ""   ""  
#> [2,] "a"  "b"  ""  
#> [3,] "a"  "b"  "c"




#> in the previous example, you might have noticed that the regular expression matched “flickered”, which is not a color. 
#> Modify the regex to fix the problem.

#This was the original color match pattern:
  
  colours <- c("red", "orange", "yellow", "green", "blue", "purple")
colour_match <- str_c(colours, collapse = "|")

#It matches “flickered” because it matches “red”. The problem is that the previous pattern will match any word
# with the name of a color inside it. We want to only match colors in which the entire word is the name of the color. 
# We can do this by adding a \b (to indicate a word boundary) before and after the pattern:
  
  colour_match2 <- str_c("\\b(", str_c(colours, collapse = "|"), ")\\b")
colour_match2
#> [1] "\\b(red|orange|yellow|green|blue|purple)\\b"

more2 <- sentences[str_count(sentences, colour_match) > 1]

str_view_all(more2, colour_match2, match = TRUE)




#> extract: The first word from each sentence.

#> Finding the first word in each sentence requires defining what a pattern constitutes a word.
#> For the purposes of this question, I’ll consider a word any contiguous set of letters. 
#> Since str_extract() will extract the first match, if it is provided a regular expression for words, 
#> it will return the first word.

str_extract(sentences, "[A-ZAa-z]+") %>% head()
#> [1] "The"   "Glue"  "It"    "These" "Rice"  "The"

#> However, the third sentence begins with “It’s”. To catch this,
#>  I’ll change the regular expression to require the string to begin with a letter,
#>   but allow for a subsequent apostrophe.

str_extract(sentences, "[A-Za-z][A-Za-z']*") %>% head()
#> [1] "The"   "Glue"  "It's"  "These" "Rice"  "The"


#> This pattern finds all words ending in ing.

pattern <- "\\b[A-Za-z]+ing\\b"
sentences_with_ing <- str_detect(sentences, pattern)
unique(unlist(str_extract_all(sentences[sentences_with_ing], pattern))) %>%
  head()
#> [1] "spring"  "evening" "morning" "winding" "living"  "king"




#> we want to extract nouns from the sentences.
#>  As a heuristic, we’ll look for any word that comes after “a” or “the”.
#> Defining a “word” in a regular expression is a little tricky, so here I use a simple approximation: 
#> a sequence of at least one character that isn’t a space.
#> 

noun <- "(a|the) ([^ ]+)"

has_noun <- sentences %>%
  str_subset(noun) %>%
  head(10)
has_noun %>% 
  str_extract(noun)
#>  [1] "the smooth" "the sheet"  "the depth"  "a chicken"  "the parked"
#>  [6] "the sun"    "the huge"   "the ball"   "the woman"  "a helps"


#> str_extract() gives us the complete match; str_match() gives each individual component.
#> Instead of a character vector, it returns a matrix, with one column for the complete
#>  match followed by one column for each group:

has_noun %>% 
  str_match(noun)
#>       [,1]         [,2]  [,3]     
#>  [1,] "the smooth" "the" "smooth" 
#>  [2,] "the sheet"  "the" "sheet"  
#>  [3,] "the depth"  "the" "depth"  
#>  [4,] "a chicken"  "a"   "chicken"
#>  [5,] "the parked" "the" "parked" 
#>  [6,] "the sun"    "the" "sun"    
#>  [7,] "the huge"   "the" "huge"   
#>  [8,] "the ball"   "the" "ball"   
#>  [9,] "the woman"  "the" "woman"  
#> [10,] "a helps"    "a"   "helps"





#> If your data is in a tibble, 
#> it’s often easier to use tidyr::extract(). It works like str_match() but requires you
#>  to name the matches, which are then placed in new columns:

tibble(sentence = sentences) %>% 
  tidyr::extract(
    sentence, c("article", "noun"), "(a|the) ([^ ]+)", 
    remove = FALSE
  )
#> # A tibble: 720 × 3
#>   sentence                                    article noun   
#>   <chr>                                       <chr>   <chr>  
#> 1 The birch canoe slid on the smooth planks.  the     smooth 
#> 2 Glue the sheet to the dark blue background. the     sheet  
#> 3 It's easy to tell the depth of a well.      the     depth  
#> 4 These days a chicken leg is a rare dish.    a       chicken
#> 5 Rice is often served in round bowls.        <NA>    <NA>   
#> 6 The juice of lemons makes fine punch.       <NA>    <NA>   
#> # … with 714 more rows






############################# REPLACING ###################

x <- c("apple", "pear", "banana")
str_replace(x, "[aeiou]", "-")
#> [1] "-pple"  "p-ar"   "b-nana"
str_replace_all(x, "[aeiou]", "-")
#> [1] "-ppl-"  "p--r"   "b-n-n-"

#> With str_replace_all() you can perform multiple replacements by supplying a named vector:

x <- c("1 house", "2 cars", "3 people")
str_replace_all(x, c("1" = "one", "2" = "two", "3" = "three"))
#> [1] "one house"    "two cars"     "three people"

#> Instead of replacing with a fixed string you can use backreferences 
#> to insert components of the match. In the following code,
#> I flip the order of the second and third words.

sentences %>% 
  str_replace("([^ ]+) ([^ ]+) ([^ ]+)", "\\1 \\3 \\2") %>% 
  head(5)
#> [1] "The canoe birch slid on the smooth planks." 
#> [2] "Glue sheet the to the dark blue background."
#> [3] "It's to easy tell the depth of a well."     
#> [4] "These a days chicken leg is a rare dish."   
#> [5] "Rice often is served in round bowls."



############################ Splitting ##################################

#> we could split sentences into words:


sentences %>%
  head(5) %>% 
  str_split(" ")
#> [[1]]
#> [1] "The"     "birch"   "canoe"   "slid"    "on"      "the"     "smooth" 
#> [8] "planks."
#> 
#> [[2]]
#> [1] "Glue"        "the"         "sheet"       "to"          "the"        
#> [6] "dark"        "blue"        "background."
#> 
#> [[3]]
#> [1] "It's"  "easy"  "to"    "tell"  "the"   "depth" "of"    "a"     "well."
#> 
#> [[4]]
#> [1] "These"   "days"    "a"       "chicken" "leg"     "is"      "a"      
#> [8] "rare"    "dish."  
#> 
#> [[5]]
#> [1] "Rice"   "is"     "often"  "served" "in"     "round"  "bowls."



#> like the other stringr functions that return a list, you can use simplify = TRUE to return a matrix:

sentences %>%
  head(5) %>% 
  str_split(" ", simplify = TRUE)
#>      [,1]    [,2]    [,3]    [,4]      [,5]  [,6]    [,7]     [,8]         
#> [1,] "The"   "birch" "canoe" "slid"    "on"  "the"   "smooth" "planks."    
#> [2,] "Glue"  "the"   "sheet" "to"      "the" "dark"  "blue"   "background."
#> [3,] "It's"  "easy"  "to"    "tell"    "the" "depth" "of"     "a"          
#> [4,] "These" "days"  "a"     "chicken" "leg" "is"    "a"      "rare"       
#> [5,] "Rice"  "is"    "often" "served"  "in"  "round" "bowls." ""           
#>      [,9]   
#> [1,] ""     
#> [2,] ""     
#> [3,] "well."
#> [4,] "dish."
#> [5,] ""



#> You can also request a maximum number of pieces:


fields <- c("Name: Hadley", "Country: NZ", "Age: 35")
fields %>% str_split(": ", n = 2, simplify = TRUE)
#>      [,1]      [,2]    
#> [1,] "Name"    "Hadley"
#> [2,] "Country" "NZ"    
#> [3,] "Age"     "35"



#>Instead of splitting up strings by patterns, you can also split up by character, 
#>line, sentence and word boundary()s:

x <- "This is a sentence.  This is another sentence."
str_view_all(x, boundary("word"))

str_split(x, " ")[[1]]
str_split(x, boundary("word"))[[1]]

################################# Also to chsange letters into numbers ###############

#> Implement a simple version of str_to_lower() using replace_all().

replacements <- c("A" = "a", "B" = "b", "C" = "c", "D" = "d", "E" = "e",
                  "F" = "f", "G" = "g", "H" = "h", "I" = "i", "J" = "j", 
                  "K" = "k", "L" = "l", "M" = "m", "N" = "n", "O" = "o", 
                  "P" = "p", "Q" = "q", "R" = "r", "S" = "s", "T" = "t", 
                  "U" = "u", "V" = "v", "W" = "w", "X" = "x", "Y" = "y", 
                  "Z" = "z")
lower_words <- str_replace_all(words, pattern = replacements)
head(lower_words)




#> Switch the first and last letters in words. Which of those strings are still words?
#>   First, make a vector of all the words with first and last letters swapped,


swapped <- str_replace_all(words, "^([A-Za-z])(.*)([A-Za-z])$", "\\3\\2\\1")

# Next, find what of “swapped” is also in the original list using the function intersect(),

intersect(swapped, words)
#>  [1] "a"          "america"    "area"       "dad"        "dead"      
#>  [6] "lead"       "read"       "depend"     "god"        "educate"   
#> [11] "else"       "encourage"  "engine"     "europe"     "evidence"  
#> [16] "example"    "excuse"     "exercise"   "expense"    "experience"
#> [21] "eye"        "dog"        "health"     "high"       "knock"     
#> [26] "deal"       "level"      "local"      "nation"     "on"        
#> [31] "non"        "no"         "rather"     "dear"       "refer"     
#> [36] "remember"   "serious"    "stairs"     "test"       "tonight"   
#> [41] "transport"  "treat"      "trust"      "window"     "yesterday"

# Alternatively, the regex can be written using the POSIX character class for letter ([[:alpha:]]):
  
  swapped2 <- str_replace_all(words, "^([[:alpha:]])(.*)([[:alpha:]])$", "\\3\\2\\1")
intersect(swapped2, words)




#> You can use the other arguments of regex() to control details of the match:
#> ignore_case = TRUE allows characters to match either their uppercase or lowercase forms.
#>  This always uses the current locale.

bananas <- c("banana", "Banana", "BANANA")
str_view(bananas, "banana")

str_view(bananas, regex("banana", ignore_case = TRUE)) 


#> multiline = TRUE allows ^ and $ to match the start
#>  and end of each line rather than the start and end of the complete string.

x <- "Line 1\nLine 2\nLine 3"
str_extract_all(x, "^Line")[[1]]
#> [1] "Line"
str_extract_all(x, regex("^Line", multiline = TRUE))[[1]]
#> [1] "Line" "Line" "Line"




phone <- regex("
  \\(?     # optional opening parens
  (\\d{3}) # area code
  [) -]?   # optional closing parens, space, or dash
  (\\d{3}) # another three numbers
  [ -]?    # optional space or dash
  (\\d{3}) # three more numbers
  ", comments = TRUE)

str_match("514-791-8141", phone)
#>      [,1]          [,2]  [,3]  [,4] 
#> [1,] "514-791-814" "514" "791" "814"

########################## Faster than regex is fixed() ###################

microbenchmark::microbenchmark(
  fixed = str_detect(sentences, fixed("the")),
  regex = str_detect(sentences, "the"),
  times = 20
)
#> Unit: microseconds
#>   expr   min     lq    mean median    uq    max neval
#>  fixed  74.8  89.20 142.755 108.25 139.9  754.8    20
#>  regex 293.6 304.85 377.650 322.60 360.3 1017.4    20



apropos("replace")
#> [1] "%+replace%"       "replace"          "replace_na"       "setReplaceMethod"
#> [5] "str_replace"      "str_replace_all"  "str_replace_na"   "theme_replace"




head(dir(pattern = "\\.Rmd$"))
#> [1] "communicate-plots.Rmd" "communicate.Rmd"       "datetimes.Rmd"        
#> [4] "EDA.Rmd"               "explore.Rmd"           "factors.Rmd"




#> What are the five most common words in sentences?
#> Using str_extract_all() with the argument boundary("word") will extract all words.
#> The rest of the code uses dplyr functions to count words and find the most common words.

tibble(word = unlist(str_extract_all(sentences, boundary("word")))) %>%
  mutate(word = str_to_lower(word)) %>%
  count(word, sort = TRUE) %>%
  head(5)



library("stringi")

#> To count the number of words use stringi::stri_count_words().
#> This code counts the words in the first five sentences of sentences.

stri_count_words(head(sentences))




library(RVerbalExpressions)

# construct an expression
x <- rx_start_of_line() %>% 
  rx_find('http') %>% 
  rx_maybe('s') %>% 
  rx_find('://') %>% 
  rx_maybe('www.') %>% 
  rx_anything_but(' ') %>% 
  rx_end_of_line()

# print the expression
x
#> [1] "^(http)(s)?(\\://)(www\\.)?([^ ]*)$"

# test for a match
grepl(x, "https://www.google.com")
#> [1] TRUE

