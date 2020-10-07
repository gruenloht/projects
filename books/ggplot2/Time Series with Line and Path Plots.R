# Line plots join the points from left to right, 
# while path plots join them in the order that they appear in the dataset
# in other words, a line plot is a path plot of the data sorted by x value

# line plots usually have time on the x-axis showing how a single variable has changed over time.
# Plath plots show how two variables have simultaneously changed over time, with time encoded 
# in the way that obervations connect

library(tidyverse)

ggplot(economics, aes(date, unemploy / pop)) + 
  geom_line()

ggplot(economics, aes(date, uempmed)) + 
  geom_line()

# To see both series in the same plot use a scatterplot
# then add geompath to see the evolution of time

ggplot(economics, aes(unemploy/pop, uempmed)) + 
  geom_point() + 
  geom_path()

# Because of the many line crossings it isnt easy to see which way time flows
# but if we add color it makes it easier to see the direction of time
ggplot(economics, aes(unemploy/pop, uempmed)) + 
  geom_path() +
  geom_point(aes(color = date), size = 3)

