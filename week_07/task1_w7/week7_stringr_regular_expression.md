---
title: "Week 7 Regular Expression and stringr"
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





**Regular Expression** is a standard textual syntax for representing patterns for matching text. 

There are two ways to identify patterns:

> - Literal characters (for example, a1Ba1Ba1B)
> - Metacharacters (or special characters) used to find more abstract or complex patterns (for example, any lowercase letter, then any number, then any upper case letter)

To treat a special character as a literal character in a string you can use a back slash to “escape” it's special function. That means if you want to include a literal backslash, you’ll need to double it up: "\\\\". Beware that the printed representation of a string is not the same as string itself, because the printed representation shows the escapes. To see the raw contents of the string, use writeLines():


```r
x <- c("\"", "\\")
x
writeLines(x)
```

There are a handful of other special characters, including 


```r
"\n" #newline, 
"\t" #tab, 
```

You can see a more complete list of special characters by requesting help on ?'"', or ?"'". 

You’ll also sometimes see strings like "\\u00b5", this is a way of writing non-English characters that works on all platforms.

## Regular Express (Regex) in R

Instead of creating one complex regular expression, it’s often easier to write a series of simpler regexps. If you get stuck trying to create a single regexp that solves your problem, take a step back and think if you could break the problem down into smaller pieces, solving each challenge before moving onto the next one.

Also, don’t forget that you’re in a programming language and you have other tools at your disposal. There is R syntax and many functions written in the stringr package that may simplify the task.

### stringr Cheatsheet Tour

The [stringr cheatsheet](http://edrub.in/CheatSheets/cheatSheetStringr.pdf) should be a handy resource whenever you are dealing with text variables and regular expression.

The first page lists out some of the most commonly used shortcut functions in stringr package. Here are the ones I often find helpful: str_count, str_sub, str_subset, str_extract_all str_length, str_trim, str_replace_all.

str_c() is so useful that we will illustrate a bit here. str_c is helpful because you can use it to create a pattern of possible matches. For example, `sentences` is a character vector that comes with the stringr packages so that you can practice using regular express. It contains 720 different sentences. Say that I am interested in identifying which of those sentences has reference to a month. I can use the month.abb vector, which is a vector of month abbreviations that comes with base R, to complete this.

Run this code to see how str_c() can be useful.


```r
head(sentences)
month.abb
(months <- str_c(month.abb, collapse = "|")) #the extra set of parenthesis prints the result to the screen
str_subset(sentences, months) 
#str_subset pull out every element of the sentences vector where a match is found in the months string
#in the months string, each vertical bar | is interpreted as an "or" logic. So it is looking to match on
#Jan or Feb or Mar or ...
```

[Short video](https://www.loom.com/share/85c09fd015e74af9b3942e20882040fa) to review the highlights of the second page of the stringr cheat sheet.

## Other useful commands

Sometimes you may be surprised by the type of data a function returns. For example, it may return a list when you expected a vector, or a vector when you expected a data.frame. For this reason the `unlist()` command can be helpful. `unlist()` simplifies a list to produce a vector. This is helpful since most of dplyr commands need a vector or tibble.

`letters` a character vector where each element of the vector is a letter of the alphabet. seq() produces a vector of numbers in regular increments.

```r
letters
```

```
##  [1] "a" "b" "c" "d" "e" "f" "g" "h" "i" "j" "k" "l" "m" "n" "o" "p" "q" "r" "s"
## [20] "t" "u" "v" "w" "x" "y" "z"
```

```r
seq(1, 4, by = .5) #creates a sequence from one to four in incremenets of 0.5
```

```
## [1] 1.0 1.5 2.0 2.5 3.0 3.5 4.0
```

```r
seq(5, 25, length.out = 11) #creates a sequence of 11 evenly spaced numbers from 5 to 25
```

```
##  [1]  5  7  9 11 13 15 17 19 21 23 25
```

The `stringi` package is installed when you install the tidyverse, but has to be loaded separately. It has additional (more advanced) functions for working with text. Most of its functions start with stri_. 


## Exercises

1. Remove all the 'e' and 'a' letters and then tell me how long the string is.
2. How many times is the name 'jim' in the string? 
3. Show all the sequences with 3 of the same letter in a row. (hardest one?)
4. Tell me which character locations have three "a"'s in a row. 
5. Split the string so that instead of a string of length 70000, it is a vector of character strings that each have length 1.



```r
dat <- readr::read_lines("https://byuistats.github.io/M335/data/randomletters.txt")

#1.
dat %>% str_remove("[ea]") %>% str_length()

#2.
sum(str_count(dat, "jim"))

#3.
str_view_all(dat, "(...)", match = TRUE)

#4.

#5.
```

[exercises solution video](https://www.loom.com/share/49eeaf2ec7f144369e403fd289b60b76)

## bonus exercise

Can you find all the 3 letter palindromes (same forwards and backwards), excluding those situations where there are 3 of the same letter in a row?

[solution video](https://www.loom.com/share/1253a92126c64454b406235efa90c3f0)


```r
dat <- readr::read_lines("https://byuistats.github.io/M335/data/randomletters.txt")
```

