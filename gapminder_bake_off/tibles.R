
# Practices ob tibble


library(tidyverse)


# Creating tibbles

#  coerce a data frame to a tibble
as_tibble(iris)


# create a new tibble from individual vectors with tibble()

tibble(
  x = 1:5, 
  y = 1, 
  z = x ^ 2 + y
)


tb <- tibble(
  `:)` = "smile", 
  ` ` = "space",
  `2000` = "number"
)
tb


# Another way to create a tibble is with tribble(), short for transposed tibble. 

tribble(
  ~x, ~y, ~z,
  #--|--|----
  "a", 2, 3.6,
  "b", 1, 8.5
)



tibble(
  a = lubridate::now() + runif(1e3) * 86400,
  b = lubridate::today() + runif(1e3) * 30,
  c = 1:1e3,
  d = runif(1e3),
  e = sample(letters, 1e3, replace = TRUE)
)

?runif()
?today()
?now()


#>  explicitly print() the data frame and control the number of rows (n) 
#>  and the width of the display. width = Inf will display all columns:

nycflights13::flights %>% 
  print(n = 10, width = Inf)


#> You can also control the default print behavior by setting options:
#> options(tibble.print_max = n, tibble.print_min = m): if more than n rows,
#> print only m rows. Use options(tibble.print_min = Inf) to always show all rows.
#> Use options(tibble.width = Inf) to always print all columns, regardless of the 
#> width of the screen.


package?tibble



# Subsetting

df <- tibble(
  x = runif(5),
  y = rnorm(5)
)

# Extract by name
df$x

df[["x"]]


# Extract by position
df[[2]]

# To use these in a pipe, you’ll need to use the special placeholder .:

df %>% .$x

df %>% .[["x"]]



#> Some older functions don’t work with tibbles. 
#> If you encounter one of these functions, use as.data.frame() 
#> to turn a tibble back to a data.frame:

class(as.data.frame(tb))
mtcars
print(mtcars)
print(as_tibble(mtcars))



# exercices

df <- data.frame(abc = 1, xyz = "a")
df$x
df[, "xyz"]
df[, c("abc", "xyz")]

