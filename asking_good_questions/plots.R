


library(tidyverse)

ggplot2::mpg
?mpg
ggplot(data = mpg) + 
  geom_point(mapping = aes(x = displ, y = hwy))


# Template for plots into ggplot
#ggplot(data = <DATA>) + 
#   <GEOM_FUNCTION>(mapping = aes(<MAPPINGS>))

ggplot(data = mpg)

ggplot(data = mpg) + 
    geom_point(mapping = aes(x = hwy, y = cyl))

ggplot(data = mpg) + 
  geom_point(mapping = aes(x = class, y = drv))


# Mapping color and size to one variable

ggplot(data = mpg) + 
  geom_point(mapping = aes(x = displ, y = hwy, color = class))

ggplot(data = mpg) + 
  geom_point(mapping = aes(x = displ, y = hwy, size = class))


# mapping shape and alpha side by side (one way)
require(gridExtra)

# Left

plot1 <- ggplot(data = mpg) + 
  geom_point(mapping = aes(x = displ, y = hwy, alpha = class))

# Right
plot2 <- ggplot(data = mpg) + 
  geom_point(mapping = aes(x = displ, y = hwy, shape = class))

grid.arrange(plot1, plot2, ncol = 2)

#Mapping color, shape and size  to all the graph
ggplot(data = mpg) + 
  geom_point(mapping = aes(x = displ, y = hwy), color = "blue")

ggplot(data = mpg) + 
  geom_point(mapping = aes(x = displ, y = hwy), shape = 22, size = 2, color = "blue")


ggplot(data = mpg) + 
  geom_point(mapping = aes(x = displ, y = hwy, color = cyl))


# not possible to map a shape to a continuous variable
ggplot(data = mpg) + 
  geom_point(mapping = aes(x = displ, y = hwy, shape = cyl))

ggplot(data = mpg) + 
  geom_point(mapping = aes(x = displ, y = hwy, size = cyl))

# Facets to display several graphs with facet_wrap
ggplot(data = mpg) + 
  geom_point(mapping = aes(x = displ, y = hwy)) + 
  facet_wrap(~ class, nrow = 2)

# Facets to display several graphs with facet_grid

ggplot(data = mpg) + 
  geom_point(mapping = aes(x = displ, y = hwy)) + 
  facet_grid(drv ~ cyl)


ggplot(data = mpg) + 
  geom_point(mapping = aes(x = displ, y = hwy)) + 
  facet_grid(. ~ cyl)


ggplot(data = mpg) + 
  geom_point(mapping = aes(x = displ, y = hwy)) + 
  facet_grid(. ~ cty)


#exercises and tests

ggplot(data = mpg) + 
  geom_point(mapping = aes(x = displ, y = hwy)) +
  facet_grid(drv ~ .)

ggplot(data = mpg) + 
  geom_point(mapping = aes(x = displ, y = hwy)) +
  facet_grid(. ~ cyl)


?facet_wrap

# Different uses of geometries,smooth and point
# left
plot3 <- ggplot(data = mpg) + 
  geom_point(mapping = aes(x = displ, y = hwy))

# right
plot4 <- ggplot(data = mpg) + 
  geom_smooth(mapping = aes(x = displ, y = hwy))

grid.arrange(plot3, plot4, ncol = 2)

# mapping geom_smoth with a third variable as  linetype
ggplot(data = mpg) + 
  geom_smooth(mapping = aes(x = displ, y = hwy, linetype = drv))


# Using group and color as aes mappings  in smooth geom

plot5 <- ggplot(data = mpg) +
  geom_smooth(mapping = aes(x = displ, y = hwy))

plot6 <- ggplot(data = mpg) +
  geom_smooth(mapping = aes(x = displ, y = hwy, group = drv))

plot7 <- ggplot(data = mpg) +
  geom_smooth(
    mapping = aes(x = displ, y = hwy, color = drv),
    show.legend = FALSE
  )

grid.arrange(plot5, plot6, plot7)
grid.arrange(plot5, plot6, plot7, ncol = 3)



# To display multiple geoms in the same plot, add multiple geom functions to ggplot():

ggplot(data = mpg) + 
  geom_point(mapping = aes(x = displ, y = hwy)) +
  geom_smooth(mapping = aes(x = displ, y = hwy))

# An easier way passing the mappings aes  to ggplot to resolve

ggplot(data = mpg, mapping = aes(x = displ, y = hwy)) + 
  geom_point() + 
  geom_smooth()


# different aesthetics in different layers

ggplot(data = mpg, mapping = aes(x = displ, y = hwy)) + 
  geom_point(mapping = aes(color = class)) + 
  geom_smooth()


# Filtering data by layer to display selected data (overriding the previous data)

ggplot(data = mpg, mapping = aes(x = displ, y = hwy)) + 
  geom_point(mapping = aes(color = class)) + 
  geom_smooth(data = filter(mpg, class == "subcompact"), se = FALSE)

# Smooth without se = FALSE 

ggplot(data = mpg, mapping = aes(x = displ, y = hwy)) + 
  geom_point(mapping = aes(color = class)) + 
  geom_smooth(data = filter(mpg, class == "subcompact"))



#  Exercises

ggplot(data = mpg, mapping = aes(x = displ, y = hwy)) + 
  geom_point() + 
  geom_smooth()

ggplot() + 
  geom_point(data = mpg, mapping = aes(x = displ, y = hwy)) + 
  geom_smooth(data = mpg, mapping = aes(x = displ, y = hwy))
