library(tidyverse)
p <- ggplot(mpg, aes(displ, hwy))
p

#### Adding Layers ####

p + geom_point()

p + layer(
  mapping = NULL,
  data = NULL,
  geom = 'point',
  stat = 'identity',
  position = 'identity'
)


#### Inside geom_smooth() ####

# This is what geom_smooth() does behind the scenes
mod <- loess(hwy ~ displ, data = mpg)
grid <- data.frame(displ = seq(min(mpg$displ), max(mpg$displ), length.out = 50))
grid$hwy <- predict(mod, newdata = grid)

grid

# Next I'll isolate observations that are particularly far away from their predicted values

std_resid <- resid(mod)/ mod$s
outlier <- filter(mpg, abs(std_resid) > 2)
outlier

# With these new datasets I can improve our intial scatterplot by overlaying a smoothed line, 
# And labelling the outlying points

ggplot(mpg, aes(displ, hwy)) + 
  geom_point() + 
  geom_line(data = grid, color = 'blue', size = 1.5) + 
  geom_text(data = outlier, aes(label = model))

# The style in this example is not that good because it makes it elss clear what the primary dataset is
# and because of the way that the argumetns to ggplot() are ordered, it actually requires more keystrokes

# However you may prefer it in cases where there isnt a clear primary dataset, or where the aesthetics
# also vary from layer to layer


# Exercise
class <- mpg %>% 
  group_by(class) %>% 
  summarise(n = n(), hwy = mean(hwy))

mpg %>% 
  ggplot(aes(x = class, y = hwy)) + 
  geom_jitter(width = 0.1) + 
  geom_point(data = class, size = 5, color = 'red') + 
  geom_text(data = class, aes(y = 10, label = paste('n =', n, sep = ' '))) + 
  ylim(10, NA)


#### aes() ####

# If youre american you can use color, and behind the scenes ggplot2 will corect your spelling!

# can do calculations in aes like aes(log(price), y), but keep it simple or just create a new column

# Never refer to a variable with $ (eg. diamonds$carat) in aes().  This breaks containment so that the plot 
# no longer contains everything it needs, and causes problems if ggplot2 changes the order of rows, 
# as it does when facetting

ggplot(mpg, aes(cty, hwy)) +
  geom_point(color = 'darkblue')

ggplot(mpg, aes(cty, hwy)) +
  geom_point(aes(color = 'darkblue'))

ggplot(mpg, aes(cty, hwy)) +
  geom_point(aes(color = 'darkblue')) + 
  scale_color_identity()


# This is most useful if you always have a column that already contains colors.

# It's sometimes useful to map aesthetics to constants.  For example if you want to display multiple
# layers with varying parameters you can 'name' each layer: 

ggplot(mpg, aes(displ, hwy)) + 
  geom_point() + 
  geom_smooth(aes(color = 'loess'), method = 'loess', se = F) + 
  geom_smooth(aes(color = 'lm'), method = 'lm', se = F) + 
  labs(color = 'Method')


#### Geoms ####

## Graphical primitives

# geom_blan(): display nothing.  Most useful for  adjusting axes limits using data
# geom_point(): points
# geom_path(): paths
# geom_ribbon(): ribbons, a path with verticle thickness
# geom_segment(): a line segment, specified by start and end position
# geom_rect(): rectangles
# geom_polygon(): filled polygons
# geom_text(): text

## One Variable

## Discrete
# geom_bar(): display distribution of discrete variable

## Continuous
# geom_histogram(): bin and count continuous variable, display with bars
# geom_density(): smoothed density estimate
# geom_dotplot(): stack individual points into a dot plot
# geom_freqpoly(): bin and count continuous variable, display with lines


## Two Variable

## Both continuous
# geom_point(): scatterplot
# geom_quantile(): smoothed quantile regression
# geom_rug(): marginal rug plots
# geom_smooth(): smoothed line of best fit
# geom_text(): textt labels

## Show Distribution
# geom_bin2d(): bin into rectangles and count
# geom_density2d(): smoothed 2d density estimate
# gemo_hex(): bin into hexagons and count


## At Least One Discrete
# geom_count(): count number of point at distinct locations
# geomjitter(): randomly gitter overlapping points


## One Discrete, One Continuous
# geom_bar(stat = 'identity'): a bar chart of precomputed summaries
# geom_col(): same as above
# geom_boxplot(): boxplots
# geom_violin(): show density of values in each group


## One Time, One Continuous
# geom_area(): area plot
# geom_line(): line plot
# geom_step(): step plot


## Display Uncertainty
# geom_crossbar(): vertical bar with center
# geom_errorbar(): error bars
# geom_linerange(): vertical line
# geom_pointrange(): vertical line with center


## Three Variables
# geom_contour(): contours
# geom_tile(): tile the plane with rectangles
# geom_raster(): fast version of geom_tile() for equal sized tiles




#### Stats ####

# stat_ecdf(): compute an empirical cumulative distribution plot
# stat_function(): compute y values from a function of x values
# stat_summary(): summarise y values at distinct x values
# stat_summary2d(): like hex
# stat_qq(): perform calculations for a quantile-quantile plot
# stat_poke(): convert angle and radius to position
# stat_unique(): remove duplicated rows

# There are two ways to use these functions.  You can either add a stat_() function and 
# override the dfault geom.  Or add geom_() function and override the default stat

ggplot(mpg, aes(trans, cty)) + 
  geom_point()+ 
  stat_summary(geom = 'point', fun.y = mean, color = 'red', size = 4)

ggplot(mpg, aes(trans, cty)) + 
  geom_point() + 
  geom_point(stat = 'summary', fun.y = mean, color = 'red', size = 4)



#### Generated Variables ####

# Internally a stat stakes a data frame as input and returns a data frame as ouput.  
# This means that a stat can add new variables to the original dataset.  
# It is possible to map aesthetics to these new variables.  
# For example, stat_bin, the statistic used to make histograms, produces the following variables: 

# count: the number of obsercations in each bin 
# density: the density of observations in each bin (percentage of total/bar width) 
# x: the centre of the bin


# These generated variables can be used instead of the variables present in the original dataset.  
# For example, the default histogram geom assigns the height of the bars to the number of observations (count),
# but if you'd prefer a more traditional histogram, you can use the density (density). 
# To refer to a generated variable, like density, ".." must surround the name.  
# This prevents confusion in case the original dataset includes a variable with the same name 
# as a generated variable, and makes it clear to any later reader of the code that this is a generated variable 
# from the stat.  Each statistic lists the variables that it creates in its documentation.  


diamonds %>% 
  ggplot(aes(price)) + 
  geom_histogram(binwidth = 500)

diamonds %>% 
  ggplot(aes(price)) + 
  geom_histogram(aes(y = ..density..), binwidth = 500)

# This technique is particularly useful when you want to compute the distribution of multiple groups 
# that have very different sizes.  For example its hard to compare the distribution of price within cut 
# becuase  some groups are quite small
diamonds %>% 
  mutate(cut = as.character(cut)) %>% 
  ggplot(aes(price, color = cut)) + 
  geom_freqpoly(binwidth = 500) + 
  theme(legend.position = 'none')

diamonds %>% 
  mutate(cut = as.character(cut)) %>% 
  ggplot(aes(price, color = cut)) + 
  geom_freqpoly(aes(y = ..density..), bindwidth = 500) + 
  theme(legend.position = 'none')


# Exercise
mpg %>% 
  group_by(displ) %>% 
  summarise(n = n()) %>% 
  arrange(displ) %>% 
  mutate(csum = cumsum(n), 
         sum = sum(n)) %>% 
  ggplot(aes(x = displ, y = csum/sum)) + 
  geom_step()

mpg %>% 
  ggplot(aes(x = displ)) + 
  geom_step(stat = 'ecdf')

mpg %>% 
  ggplot(aes(x = displ)) + 
  stat_ecdf(geom = 'step')

#### Link to ggplot2 documentation ####
# https://ggplot2.tidyverse.org/reference/


#### Position Adjustments ####
dplot <- ggplot(diamonds, aes(color, fill = cut)) + 
  xlab(NULL) + ylab(NULL) + theme(legend.position = 'none')

dplot + geom_bar()
dplot + geom_bar(position = 'fill')
dplot + geom_bar(position = 'dodge')
dplot + geom_bar(position = 'identity', alpha = 0.5, color = 'grey50')

