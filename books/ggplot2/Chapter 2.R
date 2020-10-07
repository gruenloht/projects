####Chapter 2 ####

# geom_smooth

# The wiggliness of the line is controlled by the span parapmeter which ranges from 0 to 1
library(tidyverse)
mpg %>% 
  ggplot(aes(displ, hwy)) + 
  geom_point() + 
  geom_smooth()

# method allows you to choose which type of model is used to fit the smooth curve 
#method = loess (used for small n) is default

mpg %>% 
  ggplot(aes(displ, hwy)) + 
  geom_point() + 
  geom_smooth(span = .2)

#loess doesnt work well for large datasets, it is O(n^2) 
#so an alternate smoothing algorithm is used when n is greater than 1000


#You need to first load mgcv, then use a formula like 
# formula = y ~ s(x) 
# formula = y ~ s(x, bs = 'cs')
# for large data

#This is what ggplot uses when there are more than 1000 points

library(mgcv)
ggplot(mpg, aes(displ, hwy)) + 
  geom_point() + 
  geom_smooth(method = 'gam', formula = y ~ s(x))

#metgid = 'rlm' uses linear model where outliers dont affect the fit as much as 'lm'
#but its part of the MASS package so load that first



# Problem
mpg %>% 
  ggplot(aes(drv, hwy)) + 
  geom_point()

#Three solutions

ggplot(mpg, aes(drv, hwy)) + geom_jitter()
ggplot(mpg, aes(drv, hwy)) + geom_boxplot()
ggplot(mpg, aes(drv, hwy)) + geom_violin()

# Each method has its strenghs and weaknesses.  

# Boxplots summarise the bulk of the distribution with only five numbers.
# Jittered plots show every points but only work with relatively small datasets
# Violin plots give the richest display, but rely on the calculation of a density estimate, which can be 
# hard to interpret




#Exercises

#2.
# One challenge with ggplot(mpg, aes(class, hwy), hwy) + geom_boxplot() is that the odering of class is 
# alphabetical which is not terribly useful.  How could you change the factor levels to be more
# informative?  Rather than reordering the factor by hand, you can use reorder()


ggplot(mpg, aes(class, hwy)) + geom_boxplot()
?reorder

mpg %>% mutate(class = reorder(mpg$class, mpg$hwy, FUN = median)) %>% 
  ggplot(aes(class, hwy)) + 
  geom_boxplot()



#### Modifying the Axes ####

?xlab
?ylab

# xlim and ylim modify the limits of axes
ggplot(mpg, aes(drv, hwy)) +
  geom_jitter(width = 0.15)

ggplot(mpg, aes(drv, hwy)) +
  geom_jitter(width = 0.15) +
  xlim('r', 'f') +
  ylim(20, 30)

# For continuous scalses use NA to set only one limit

ggplot(mpg, aes(drv, hwy)) +
  geom_jitter(width = 0.15) + 
  ylim(NA, 30)


#### Quick plots ####
qplot(displ, hwy, data = mpg)
qplot(displ, data = mpg)

qplot(displ, hwy, data = mpg, color = 'blue') # outside the aes
qplot(displ, hwy, data = mpg, color = I('blue')) # inside the aes
