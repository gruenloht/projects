library(tidyverse)
ggplot(mpg, aes(hwy)) + geom_histogram()
ggplot(mpg, aes(hwy)) + geom_freqpoly()

# Hadley is not a fan of geom_density() because they are harder to interpret since the 
# underlying computations are more complex and they also make assumptioins that are not true
# for all data, the distribution is continuous, unbounded, and smooth

ggplot(mpg, aes(displ, color = drv)) + 
  geom_freqpoly(binwidth = 0.5)

ggplot(mpg, aes(displ, fill = drv)) + 
  geom_histogram(binwidth = 0.5) +
  facet_wrap(~drv, ncol = 1)
