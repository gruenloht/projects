library(tidyverse)

ggplot(mpg, aes(manufacturer)) + 
  geom_bar()

# This expects you to have unsummarised data, and each observation contributes one unit to the 
# height of the bar.  The other form of bar chart is used for presummaarised data.

# For example, you might have three drugs with their average effect
drugs <- data.frame(
  drug = c('a', 'b', 'c'),
  effect = c(4.2, 9.7, 6.1)
)

# To display this sort of data you need to tell geom_bar() to not run the default stat which bins 
# and counts the data

# However, Hadley things it's even better to use geom_point() because points tak up less space than bars,
# and don't require that the y axis includes 0