### Scales, Axes and Legends ###
library(tidyverse)
#### Modifying Scales ####

# A scale is required for every aesthetic used on the plot, so when you write:
ggplot(mpg, aes(displ, hwy)) + 
  geom_point(aes(color = class))

# What actually happens is this:
ggplot(mpg, aes(displ, hwy)) + 
  geom_point(aes(color = class)) + 
  scale_x_continuous() + 
  scale_y_continuous() + 
  scale_color_discrete()

# They are the same thing

# So to change a scale you just need add one of those and it will overrite the previous/default scale
ggplot(mpg, aes(displ, hwy)) + 
  geom_point(aes(color = class)) + 
  scale_x_continuous('A really awesome x axis') + 
  scale_y_continuous('An amazingly great y axis')

# Another example:
ggplot(mpg, aes(displ, hwy)) + 
  geom_point(aes(color = class)) + 
  scale_x_continuous('Label 1') + 
  scale_x_continuous('Label 2')

# Is the same as 
ggplot(mpg, aes(displ, hwy)) + 
  geom_point(aes(color = class)) + 
  scale_x_continuous('Label 2')

# We even got a warning when we added two of the same scales:
# Scale for 'x' is already present. Adding another scale for 'x', which will replace the existing scale.

# Or you can use a different scale all together:
ggplot(mpg, aes(displ, hwy)) + 
  geom_point(aes(color = class)) + 
  scale_x_sqrt() + 
  scale_color_brewer()

# Important to note that for all the scales they are made up of the same three pieces separated by an underscore:
# scale
# The name of the aesthetic (e.g., color, shape or x)
# The name of the scale (e.g., continuous, discrete, brewer)


#### Guides: Legends and Axes ####

# There are three main things you can adjust in the scales:
# name
# breaks
# labels

## Scale Title

# The first argument to the scale function is name, which is the axes/legend title

# you can us text strings (\n for line break)
# or mathematical expressions in quote()
# This is descirbed in ?plotmath
?plotmath

df <- data.frame(x = 1:2, y = 1, z = 'a')
p <- ggplot(df, aes(x, y)) + geom_point()
p + scale_x_continuous('X axis')
p + scale_x_continuous(quote(a + mathemactical ^ expression))

# However since tweeking labels is so common there are three helpers that will save tying time
# xlab()
# ylab()
# labs()

p <- ggplot(df, aes(x,y)) + geom_point(aes(color = z))
p + 
  xlab('X axis') + 
  ylab('Y axis')
p + labs(x = 'X axis', y = 'Y axis', color = 'Color\nlegend')

## There are two ways you can remove the axis label
# Setting it to '' omits the label, but still alloates space
# Setting it to NULL removes the label and its space

# Here is an outline to see it better:
p <- ggplot(df, aes(x,y)) + 
  geom_point() + 
  theme(plot.background = element_rect(color = 'grey50'))

p + labs(x = '', y = '')
p + labs(x = NULL, y = NULL)


## Breaks and Labels

# The breaks argument controls which values appear as tick marks on axes and keys on legends.
# Each break has an associated label, controlled by the labels argument.

# If you set labels, you must also set breaks; otherwise if data changes 
# the breaks will no longer align with the labels

df <- data.frame(x = c(1, 3, 5) * 10000, y = 1)
axs <- ggplot(df, aes(x,y)) + 
  geom_point() + 
  labs(x = NULL, y = NULL)
axs
axs + scale_x_continuous(breaks = c(20000, 40000))
axs + scale_x_continuous(breaks = c(20000, 40000), labels = c('20k', '40k'))


leg <- ggplot(df, aes(y, x, fill = x)) + 
  geom_tile() + 
  labs(x = NULL, y = NULL)
leg
leg + scale_fill_continuous(breaks = c(20000, 40000))
leg + scale_fill_continuous(breaks = c(20000, 40000), labels = c('20k', '40k'))


# If you want to relabel the breaks in a categorical scale, you can use a named labels vector
df2 <- data.frame(x = 1:3, y = c('a', 'b', 'c'))
ggplot(df2, aes(x, y)) + 
  geom_point()
ggplot(df2, aes(x, y)) + 
  geom_point() + 
  scale_y_discrete(labels = c(a = 'apple', b = 'banana', c = 'carrot')) + 
  ylab(NULL)


# To supress breaks (and for axes, grid lines) or labels, set them to NULL:
axs + scale_x_continuous(breaks = NULL)
axs + scale_x_continuous(labels = NULL)

leg + scale_fill_continuous(b = NULL)
leg + scale_fill_continuous(l = NULL)

# Additionally you can supply a function to breaks or labels.
# The breaks function should have one argument, the limits function (a numerci cevtor of length 2),
# and should return a numeric vector of breaks 

# The labels function should accept a numeric vector of breaks and return a character vector of labels 
# (the same length as the input).

# The scales package provides a number of useful labelling functions

# scales::comma_format() adds commas to make it easier to read large numbers
# scales::unit_format(unit, scale) adds a unit suffix, optionally scaling
# scales::dollar_format(prefix, suffix) displays currency values rounding to two decimal places 
#                                       and adding a prefix or suffix
# scales::wrap_format() wraps long labels into multiple lines

# See documentation for more details
axs + scale_y_continuous(labels = scales::percent_format())
axs + scale_y_continuous(labels = scales::dollar_format(prefix = '$'))
leg + scale_fill_continuous(labels = scales::unit_format(unit = 'k', scale = 1e-3))

# Minor Breaks:

# you can adjust minor breaks (the faint grid lines that appear between the major grid lines)
# by supplying a numeric vector of positions to the minor_breaks argument

# This is particularly useful for log scales

df <- data.frame(x = c(2, 3, 5, 10, 200, 300), y = 1)


ggplot(df, aes(x, y)) + 
  geom_point() + 
  scale_x_log10()

mb <- as.numeric(1:10 %o% 10^(0:4))
ggplot(df, aes(x, y)) + 
  geom_point() + 
  scale_x_log10(minor_breaks = log10(mb))


#### Legends ####

## By default, a layer will only appear if the corresponding aesthetic is mapped to a variables with aes().
# You can override whether or not a layer appears in the legend with show.legend
# FALSE prevents the layer from ever appearing
# TRUE forces it to appear when it otherwise wouldn't

df <- data.frame(x = 1:3, y = 1:3, z = c('a', 'b', 'c'))
ggplot(df, aes(x, y)) + 
  geom_point(size = 4, color = 'grey20') + 
  geom_point(aes(color = z), size = 2)

ggplot(df, aes(x,y)) + 
  geom_point(size = 4, color = 'grey20', show.legend = T) + 
  geom_point(aes(color = z), size =2)


## Sometimes you want the geoms in the legend to display differently to the geoms in the plot
# This is particularly useful when you've used transparency or size to deal with moderate overplotting 
# and also used color in the plot.

# You can do this using the override.aes parameter of guide_legend()

norm <- data.frame(x = rnorm(1000), y = rnorm(1000))
norm$z <- cut(norm$x, 3, c('a', 'b', 'c'))
ggplot(norm, aes(x,y)) + 
  geom_point(aes(color = z), alpha = 0.1)
ggplot(norm, aes(x,y)) + 
  geom_point(aes(color = z), alpha = 0.1) + 
  guides(color = guide_legend(override.aes = list(alpha = 1)))

# ggplot will combind legends to have the fewest number of legends possible

df <- data.frame(x = 0, y = c(1, 2, 3), z = c('a', 'b', 'c'))
ggplot(df, aes(x, y)) + geom_point(aes(color = z))
ggplot(df, aes(x, y)) + geom_point(aes(shape = z))
ggplot(df, aes(x, y)) + geom_point(aes(shape = z, color = z))


## In order for legends to be merged, they must have the same name.  
# So if you change the name of one of the scales, youll need to change the name for all of them


### Legend Layout

# The position and justification of legends are controlled by the theme setting legend.position
# This takes the values:

# 'right', 'left', 'top', 'bottom', or 'none'

base <- ggplot(df, aes(x, y)) + 
  geom_point(aes(color = z), size = 3) + 
  xlab(NULL) + 
  ylab(NULL)

base + theme(legend.position = 'right')
base + theme(legend.position = 'bottom')
base + theme(legend.position = 'none')
base + theme(legend.position = 'top')

# Switching between left/right and top/bottom modifies how the keys 
# in each legend are laid out (horizontally or vertically)
# And how multiple legends are stacked.

# If needed you can adjust those options independently:

# legend.direction: layout of items in legends ('horizontal', or 'vertical')
# legend.box: arrangement of multiple legends ('horizontal' or 'vertical')
# legend.box.just: justification of each legend withing the overall boudnign box,
#                  when there are multiple legends ('top', 'bottom', 'left', or 'right')

# If there is alot of black space, you can even put the legends on the graph

# Use by setting legend.position to a numeric vector of length two
# The numbers represent a relative location in the panel area: c(0, 1) is top-left
# and c(1, 0) is bottom-right

# You can control which corner of the legend the legend.position refers to with legend.justification
# which takes similar parameters

base <- ggplot(df, aes(x, y)) + 
  geom_point(aes(color = z), size = 3)

base + theme(legend.position = c(0,1), legend.justification = c(0, 1))

base + theme(legend.position = c(0.5, 0.5), legend.justification = c(0.5, 0.5))
base + theme(legend.position = c(0.5, 0.5), legend.justification = c(0, 1))

base + theme(legend.position = c(1, 0), legend.justification = c(1, 0))

## There is also a margin around the legends which you can suppres with 
# legend.margin = unit(0, 'mm')


#### Guide Functions ####

# The functions guide_colourbar() and guide_legend() provide control over the fine details of the legend
# Legend guides can be used for any aesthetic (discrete or continuous)
# colour bar guid can only be used with continuous colour scales

# You can override the default guide using the guide argument of the corresponding scale function
# Or more easily the guides() helper function

df <- data.frame(x = 1, y = 1:3, z = 1:3)
base <- ggplot(df, aes(x, y)) + geom_raster(aes(fill = z))
base
base + scale_fill_continuous(guide = guide_legend())
base + guides(fill = guide_legend())

# Both functions have numerous examples in their documentations help pages that illustrate all their arguments

## guide_legend() ##

# The legend guid displas individual keys in a table.  The most useful operations are:
# nrow or ncol: which specify the dimensions of the table
# byrow: controls how the table is filled

df <- data.frame(x = 1, y = 1:4, z = letters[1:4])

p <- ggplot(df, aes(x, y)) + geom_raster(aes(fill = z))
p
p + guides(fill = guide_legend(ncol = 2))
p + guides(fill = guide_legend(ncol = 2, byrow = TRUE))

# reverse: reverses the order of the keys.
# This is useful when you want to have the same heirarcial display:

p
p + guides(fill = guide_legend(reverse = T))

# There are also:
# override.aes: override some of the aesthetic settings derived from each layer
# keywidth and keyheight: (along with default.unit) allow you to specify the size of the keys
# These are grid units, e.g., unit(1, 'cm')


## guide_colorbar ##

# The color bar guide is designed for continuous ranges of color - as its name implies, it ouputs
# a rectangle over which the color gradient varies.  The most important arguments are:

# barwidth and barheight: (along with default.unit) allow you to specify the size of the bar
# These are gird units, e.g., unit(1, 'cm')

# nbin: controls the number of slices.  You may want to increase this from the default value of 20
# If you draw a very long bar

# reverse: flips the color bar to put the lowest valeus at the top

df <- data.frame(x = 1, y = 1:4, z = 4:1)
p <- ggplot(df, aes(x, y)) + geom_tile(aes(fill = z))

p
p + guides(fill = guide_colorbar(reverse = T))
p + guides(fill = guide_colorbar(barheight = unit(4, 'cm')))


ggplot(mpg, aes(displ, hwy)) + 
  geom_point(aes(color = drv, shape = drv)) + 
  scale_color_discrete('Drive train') + 
  scale_shape_discrete('Drive train')



#### Limits ####

# Limits applyt to ranges of the axes, but alos apply to the claes hat have legends, like color, size and shape

# When you specify limits of continuous variables:
# give a numeric vector of length two, if you want to set only an upper limit, set the other value to NA

# For discrete scales, give a vecto which enumerates all possible values

df <- data.frame(x = 1:3, y = 1:3)
base <- ggplot(df, aes(x,y)) + 
  geom_point()

base
base + scale_x_continuous(limits = c(1.5, 2.5))
#Warning message:
#Removed 2 rows containing missing values (geom_point). 

base + scale_x_continuous(limits = c(0, 4))


# Use xlim, ylim, and lims as a shortcut 

# Here are some examples:
# xlim(10, 20) : a continuous scale from 10 to 20
# ylim(20, 10) : a reversed continuous scale from 20 to 10
# xlim(as.Date(c('2020-06-12', '2020-07-12))) : a date scale from June 12 - July 12 2020

base + xlim(0, 4)
base + xlim(4, 0)
base + lims(x = c(0,4))

# There are some spaces after the limits are specified.  This is so we can still see poitns on the 
# Specified limits.  To eliminate this space set expand = c(0,0)
# This is useful with geom_raster

ggplot(faithfuld, aes(waiting, eruptions)) + 
  geom_raster(aes(fill = density)) + 
  theme(legend.position = 'none')
ggplot(faithfuld, aes(waiting, eruptions)) + 
  geom_raster(aes(fill = density)) + 
  theme(legend.position = 'none') + 
  scale_x_continuous(expand = c(0,0)) + 
  scale_y_continuous(expand = c(0,0))


## By default the data outside the limits is converted to na.  This means that setting limits
# is not the same as zooming in

### To do that, you need to use xlim and ylim arguments to coord_cartesian()
# That is purly zooming in and out

# You can override this with the oob (out of bounds) arguments to the scale.
# The default is scales::censor() whcih replaces any value outside the limits with NA, 
# Another option is scales::squish() which squishes all values into the range

df <- data.frame(x = 1:5)
p <- 
  ggplot(df, aes(x, 1)) + 
  geom_tile(aes(fill = x), color = 'white')

p
p + scale_fill_gradient(limits = c(2, 4))
p + scale_fill_gradient(limits = c(2, 4), oob = scales::squish)

# Obliterating data
p + xlim(c(2,4))
# Zooming in
p + coord_cartesian(xlim = c(2,4))


#### Continuous Position Scales ####

# Every continuous scale takes a trans argument allowing a use of a variety of transformations

ggplot(mpg, aes(displ, hwy)) + 
  geom_point() +
  scale_y_continuous(trans = 'reciprocal')

ggplot(diamonds, aes(price, carat)) + 
  geom_bin2d() + 
  scale_x_continuous(trans = 'log10') + 
  scale_y_continuous(trans = 'log10')

## Here is a list of the most common transformations:

# asn, exp, identity, log, log10, log2, logit, pow10, probit, reciprocal, reverse, sqrt

# There are shortcuts for the most common: scale_x_log10(), scale_x_sqrt()
# and scale_x_reverse() (and similarly for y.)
# Of course, you can also perform the transformation yourself. For example,
# instead of using scale x log10(), you could plot log10(x). 

# The appearance of
# the geom will be the same, but the tick labels will be different. If you use a
# transformed scale, the axes will be labelled in the original data space; if you
# transform the data, the axes will be labelled in the transformed space.
# In either case, the transformation occurs before any statistical summaries.
# To transform, after statistical computation, use coord trans()
ggplot(diamonds, aes(log10(price),log10(carat))) + 
  geom_bin2d()



# Date and date/time data are continuous variables with special labels. 
# ggplot2 works with Date (for dates) and POSIXct (for date/times) classes: if your
# dates are in a different format you will need to convert them with as.Date()
# or as.POSIXct(). scale_x_date() and scale_x_datetime() work similarly to
# scale_x_continuous() but have special date_breaks and date_labels arguments
# that work in date-friendly units:
# 
# • date_breaks and date_minor_breaks() allows you to position breaks by date
# units (years, months, weeks, days, hours, minutes, and seconds). 
# For example, 
# date breaks = "2 weeks" will place a major tick mark every two weeks.
#
# • date_labels controls the display of the labels using the same formatting
# strings as in strptime() and format():




#### String Meaning ####

# %S Second (00–59)
# %M Minute (00–59)
# %l Hour, in 12-hour clock (1–12)
# %I Hour, in 12-hour clock (01–12)
# %p am/pm
# %H Hour, in 24-hour clock (00–23)
# %a Day of week, abbreviated (Mon–Sun)
# %A Day of week, full (Monday–Sunday)
# %e Day of month (1–31)
# %d Day of month (01–31)
# %m Month, numeric (01–12)
# %b Month, abbreviated (Jan–Dec)
# %B Month, full (January–December)
# %y Year, without century (00–99)
# %Y Year, with century (0000–9999)


# For example, if you wanted to display dates like 14/10/1979, you would
# use the string "%d/%m/%Y"

head(economics)
base <- ggplot(economics, aes(date, psavert)) + 
  geom_line(na.rm = T) + 
  labs(x = NULL, y = NULL)

base
base + scale_x_date(date_labels = '%y', date_breaks = '5 years')
base + scale_x_date(date_labels = '%y', date_breaks = '5 years', date_minor_breaks = '5 years')
base + scale_x_date(date_labels = '%b %Y', date_breaks = '10 years')


base + scale_x_date(
  limits = as.Date(c('2004-01-01', '2005-01-01')),
  date_labels = '%b %y',
  date_minor_breaks = '1 month'
)
base + scale_x_date(
  limits = as.Date(c('2004-01-01', '2004-06-01')),
  date_labels = '%m/%d',
  date_minor_breaks = '2 weeks'
)


#### Color Theory ####

# An excellent and more
# detailed exposition is available online at http://tinyurl.com/clrdtls

# We’ll use a modern attempt called the HCL
# colour space, which has three components of hue, chroma and luminance:

# • Hue is a number between 0 and 360 (an angle) which gives the “colour”
#   of the colour: like blue, red, orange, etc.

# • Chroma is the purity of a colour. A chroma of 0 is grey, and the maximum
#   value of chroma varies with luminance.

# • Luminance is the lightness of the colour. A luminance of 0 produces black,
#   and a luminance of 1 produces white.


# An additional complication is that many people (˜10 % of men) do not
# possess the normal complement of colour receptors and so can distinguish
# fewer colours than usual. In brief, it’s best to avoid red-green contrasts, and
# to check your plots with systems that simulate colour blindness. Visicheck is
# one online solution. 

# Another alternative is the dichromat package 
# which provides tools for simulating colour blindness, and a set of colour
# schemes known to work well for colour-blind people


#### Continuous Color ####
erupt <- ggplot(faithfuld, aes(waiting, eruptions, fill = density)) +
  geom_raster() + 
  scale_x_continuous(NULL, expand = c(0, 0)) + 
  scale_y_continuous(NULL, expand = c(0, 0)) + 
  theme(legend.position = 'none')

erupt


# There are four continuous colour scales:
# • scale_colour_gradient() and scale_fill_gradient(): a two-colour gradient,
#   low-high (light blue-dark blue). This is the default scale for continuous
#   colour, and is the same as scale_colour_continuous(). Arguments low and
#   high control the colours at either end of the gradient.

# Generally, for continuous colour scales you want to keep hue constant, and
# vary chroma and luminance. The munsell colour system is useful for this
# as it provides an easy way of specifying colours based on their hue, chroma
# and luminance. Use munsell::hue_slice("5Y") to see the valid chroma and
# luminance values for a given hue.

munsell::hue_slice("5Y") # Y: Yellow
munsell::hue_slice("5G") # G: Green

erupt

erupt + scale_fill_gradient(low = "white", high = "black")

erupt + scale_fill_gradient(
  low = munsell::mnsl("5G 9/2"),
  high = munsell::mnsl("5G 6/8")
)


# • scale-colour_gradient2() and scale_fill_gradient2(): a three-colour gradient, 
#   low-med-high (red-white-blue). As well as low and high colours, these
#   scales also have a mid colour for the colour of the midpoint. The midpoint
#   defaults to 0, but can be set to any value with the midpoint argument.
#   It’s artificial to use this colour scale with this dataset, but we can force it
#   by using the median of the density as the midpoint. Note that the blues
#   are much more intense than the reds (which you only see as a very pale pink)

mid <- median(faithfuld$density)
erupt + scale_fill_gradient2(midpoint = mid)


# • scale colour gradientn() and scale fill gradientn(): a custom n-colour
#   gradient. This is useful if you have colours that are meaningful for your
#   data (e.g., black body colours or standard terrain colours), or you’d like
#   to use a palette produced by another package. The following code includes
#   palettes generated from routines in the colorspace package.  
#   describes the philosophy behind these palettes and provides a good
#   introduction to some of the complexities of creating good colour scales


erupt + scale_fill_gradientn(colours = terrain.colors(7))
erupt + scale_fill_gradientn(colours = colorspace::heat_hcl(7))
erupt + scale_fill_gradientn(colours = colorspace::diverge_hcl(7))


# By default, colours will be evenly spaced along the range of the data. To
# make them unevenly spaced, use the values argument, which should be a
# vector of values between 0 and 1.

# • scale_color_distiller() and scale_fill_gradient() apply the ColorBrewer 
#   colour scales to continuous data. You use it the same way as
#   scale_fill_brewer(), described below:

# Use this to get a list of available pallets
?scale_fill_brewer

erupt
erupt + scale_fill_distiller()
erupt + scale_fill_distiller(palette = "RdPu")
erupt + scale_fill_distiller(palette = "YlOrBr")

# All continuous colour scales have an na.value parameter that controls what
# colour is used for missing values (including values outside the range of the
# scale limits). By default it is set to grey, which will stand out when you use
# a colourful scale. If you use a black and white scale, you might want to set it
# to something else to make it more obvious

df <- data.frame(x = 1, y = 1:5, z = c(1, 3, 2, NA, 5))
p <- ggplot(df, aes(x, y)) + geom_tile(aes(fill = z), size = 5)
p

# Make missing colours invisible
p + scale_fill_gradient(na.value = NA)

# Customise on a black and white scale
p + scale_fill_gradient(low = "black", high = "white", na.value = "red")



#### Discrete Colors ####

# There are four colour scales for discrete data

df <- data.frame(x = c("a", "b", "c", "d"), y = c(3, 4, 1, 2))
bars <- ggplot(df, aes(x, y, fill = x)) +
  geom_bar(stat = "identity") +
  labs(x = NULL, y = NULL) +
  theme(legend.position = "none")
bars


# • The default colour scheme, scale_colour_hue(), picks evenly spaced hues
#   around the HCL colour wheel. This works well for up to about eight
#   colours, but after that it becomes hard to tell the different colours apart.
#   You can control the default chroma and luminance, and the range of hues,
#   with the h, c and l arguments:

bars
bars + scale_fill_hue(c = 40) 
bars + scale_fill_hue(h = c(180, 300))

# One disadvantage of the default colour scheme is that because the colours
# all have the same luminance and chroma, when you print them in black
# and white, they all appear as an identical shade of grey


# • scale_colour_brewer() uses handpicked “ColorBrewer” colours, http://
#   colorbrewer2.org/. These colours have been designed to work well
#   in a wide variety of situations, although the focus is on maps and so
#   the colours tend to work better when displayed in large areas. For
#   categorical data, the palettes most of interest are ‘Set1’ and ‘Dark2’
#   for points and ‘Set2’, ‘Pastel1’, ‘Pastel2’ and ‘Accent’ for areas. Use
#   RColorBrewer::display.brewer.all() to list all palettes
RColorBrewer::display.brewer.all()

bars
bars + scale_fill_brewer(palette = "Set1")
bars + scale_fill_brewer(palette = "Set2")
bars + scale_fill_brewer(palette = "Accent")

# • scale_colour_grey() maps discrete data to grays, from light to dark.

bars + scale_fill_grey()
bars + scale_fill_grey(start = 0.5, end = 1)
bars + scale_fill_grey(start = 0, end = 0.5)


# • scale_colour_manual() is useful if you have your own discrete colour palette.
#   The following examples show colour palettes inspired by Wes Anderson
#   movies, as provided by the wesanderson package, https://github.com/
#   karthik/wesanderson. These are not designed for perceptual uniformity,
#   but are fun!

library(wesanderson)
?wes_palette
wes_palette("Rushmore")

bars
bars + scale_fill_manual(values = wes_palette("GrandBudapest1"))
bars + scale_fill_manual(values = wes_palette("Zissou1"))
bars + scale_fill_manual(values = wes_palette("Rushmore"))


# Note that one set of colours is not uniformly good for all purposes: 
# bright colours work well for points, but are overwhelming on bars. 
# Subtle colours work well for bars, but are hard to see on points:

# Bright colours work best with points
df <- data.frame(x = 1:3 + runif(30), y = runif(30), z = c("a", "b", "c"))
point <- ggplot(df, aes(x, y)) +
  geom_point(aes(colour = z)) +
  theme(legend.position = "none") +
  labs(x = NULL, y = NULL)

point + scale_colour_brewer(palette = "Set1")
point + scale_colour_brewer(palette = "Set2")
point + scale_colour_brewer(palette = "Pastel1")
  

# Subtler colours work better with areas
df <- data.frame(x = 1:3, y = 3:1, z = c("a", "b", "c"))
area <- ggplot(df, aes(x, y)) +
  geom_bar(aes(fill = z), stat = "identity") +
  theme(legend.position = "none") +
  labs(x = NULL, y = NULL)

area + scale_fill_brewer(palette = "Set1")
area + scale_fill_brewer(palette = "Set2")
area + scale_fill_brewer(palette = "Pastel1")


#### The Manual Discrete Scale ####


# The discrete scales, scale linetype(), scale shape(), and scale size discrete()
# basically have no options. These scales are just a list of valid values that are
# mapped to the unique discrete values.
# If you want to customise these scales, you need to create your own new
# scale with the manual scale: scale shape manual(), scale linetype manual(),
# scale colour manual(). The manual scale has one important argument, values,
# where you specify the values that the scale should produce. If this vector is
# named, it will match the values of the output to the values of the input;
# otherwise it will match in order of the levels of the discrete variable. You
# will need some knowledge of the valid aesthetic values, which are described
# in vignette("ggplot2-specs").

vignette("ggplot2-specs")
colors()
colors()[str_detect(colors(), 'green')]



plot <- ggplot(msleep, aes(brainwt, bodywt)) +
  scale_x_log10() +
  scale_y_log10()
plot

plot +
  geom_point(aes(colour = vore)) +
  scale_colour_manual(
    values = c("red", "orange", "green", "blue"),
    na.value = "grey50"
  )
#> Warning: Removed 27 rows containing missing values (geom_point).

colours <- c(
  carni = "red",
  insecti = "orange",
  herbi = "green",
  omni = "blue"
)

plot +
  geom_point(aes(colour = vore)) +
  scale_colour_manual(values = colours, na.value = 'grey50')
#> Warning: Removed 27 rows containing missing values (geom_point)


# The following example shows a creative use of scale colour manual() to
# display multiple variables on the same plot and show a useful legend. In most
# other plotting systems, you’d colour the lines and then add a legend:
  
huron <- data.frame(year = 1875:1972, level = as.numeric(LakeHuron))
ggplot(huron, aes(year)) +
  geom_line(aes(y = level + 5), colour = "red") +
  geom_line(aes(y = level - 5), colour = "blue")

# That doesn’t work in ggplot because there’s no way to add a legend manually. 
# Instead, give the lines informative labels:
  
ggplot(huron, aes(year)) +
  geom_line(aes(y = level + 5, colour = "above")) +
  geom_line(aes(y = level - 5, colour = "below"))

ggplot(huron, aes(year)) +
  geom_line(aes(y = level + 5, colour = "above")) +
  geom_line(aes(y = level - 5, colour = "below")) +
  scale_colour_manual("Direction",
                      values = c("above" = "red", "below" = "blue")
  )


# The identity scale is used when your data is already scaled, when the data and
# aesthetic spaces are the same. The code below shows an example where the
# identity scale is useful. luv colours contains the locations of all R’s built-in
# colours in the LUV colour space (the space that HCL is based on). A legend is
# unnecessary, because the point colour represents itself: the data and aesthetic
# spaces are the same.


head(luv_colours)

ggplot(luv_colours, aes(u, v)) +
  geom_point(aes(colour = col), size = 3) +
  scale_color_identity() +
  coord_equal()
ggplotly()
