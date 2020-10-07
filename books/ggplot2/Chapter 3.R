library(tidyverse)
df <- data.frame(
  x = c(3, 1, 5),
  y = c(2, 4, 6), 
  label = c('a', 'b', 'c')
)

p <- ggplot(df, aes(x,y, label = label)) + 
  labs(x = NULL, y = NULL) + 
  theme(plot.title = element_text(size = 12)) #Shrink the plot title

p + geom_point() + ggtitle('point')
p + geom_text() + ggtitle('text')
p + geom_bar(stat = 'identity') + ggtitle('bar')
p + geom_tile() + ggtitle('tile')

p + geom_line() + ggtitle('line')
p + geom_area() + ggtitle('area')
p + geom_path() + ggtitle('path')
p + geom_polygon() + ggtitle('polygon')


#### Text ####
df <- data.frame(x = 1, y = 3:1, family = c('sans', 'serif', 'mono'))
ggplot(df, aes(x,y)) + 
  geom_text(aes(label = family, family = family), size = 15) +
  ylim(0.5,3.5)


df <- data.frame(x = 1, y = 3:1, face = c('plain', 'bold', 'italic'))
ggplot(df, aes(x,y)) + 
  geom_text(aes(label = face, fontface = face), size = 15) +
  ylim(0.5,3.5)

# You can adjust the alignment of the text with the hjust ('left', 'center', 'right', 'inward', 'outward')
# And vjust ('bottom', 'middle', 'top', 'inward', 'outward')

df <- data.frame(
  x = c(1, 1, 2, 2, 1.5),
  y = c(1, 2, 1, 2, 1.5), 
  text = c(
    'bottom-left', 'bottom-right', 
    'top-left', 'top-right', 'center'
    )
)

ggplot(df, aes(x,y)) + 
  geom_text(aes(label = text))


ggplot(df, aes(x,y)) + 
  geom_text(aes(label = text), vjust = 'inward', hjust = 'inward')

#can also use angle (in degrees)

ggplot(df, aes(x,y)) + 
  geom_text(aes(label = text), vjust = 'inward', hjust = 'inward', angle = 10)


#can use nudge to make your labels not all on points or bars in your plot

df <- data.frame(trt = c('a', 'b', 'c'), resp = c(1.2, 3.4, 2.5))
ggplot(df, aes(resp, trt)) + 
  geom_point() + 
  geom_text(aes(label = resp))


ggplot(df, aes(resp, trt)) + 
  geom_point() + 
  geom_text(aes(label = paste0("(", resp, ")")), nudge_y = -0.25) + 
  xlim(1,3.6)


#check_overlap
# labels are plotted in the order they appear in the data frame; if a label 
# would overlap with an existing point, it is omitted.  This is not incredibly useful

ggplot(mpg, aes(displ, hwy)) + 
  geom_text(aes(label = model)) + 
  xlim(1,8)

ggplot(mpg, aes(displ, hwy)) + 
  geom_text(aes(label = model), check_overlap = T) + 
  xlim(1,8)


# A variation on geom_text is geom_label.  It draws a rounded rectangle behind the text.
# This makes it useful for adding labels to plots with busy backgrounds

faithfuld
label <- data.frame(
  waiting = c(55,80),
  eruptions = c(2,4.2),
  label = c('Peak One', 'Peak Two')
)

ggplot(faithfuld, aes(waiting, eruptions)) + 
  geom_tile(aes(fill = density)) + 
  geom_label(data = label, aes(label = label))





ggplot(mpg, aes(displ, hwy, color = class)) + 
  geom_point()


ggplot(mpg, aes(displ, hwy, color = class)) + 
  geom_point() + 
  directlabels::geom_dl(aes(label = class), method = 'smart.grid')

#Acts as a second legend and puts the labels near where the points are

#smart.grid is good place to start for scatter plots, but other useful ones
#go to http://directlabels.r-forge.r-project.org


#### Annotations ####

ggplot(economics, aes(date, unemploy)) + 
  geom_line()

#we can annotate this plot with which president was in  power at the time
# -Inf and Inf refer to the top and bottom or left and right of the plot

presidential <- subset(presidential, start > economics$date[1])
ggplot(economics) +
  geom_rect(
    aes(xmin = start, xmax = end, fill = party),
    ymin = -Inf, ymax = Inf, alpha = 0.2, 
    data = presidential
  ) +
  geom_vline(
    aes(xintercept = start), 
    data = presidential, 
    color = 'grey50', alpha = 0.5
  ) +
  geom_text(
    aes(x = start, y = 2500, label = name), 
    data = presidential, 
    size = 3, vjust = 0, hjust = 0, nudge_x = 50
  ) +
  geom_line(aes(date, unemploy)) + 
  scale_fill_manual(values = c('blue', 'red'))


# You can use the same technique to add a single annotation to a plot, but its a bit
# fiddly because you have to create a one row dataframe

yrng <- range(economics$unemploy)
xrng <- range(economics$date)
caption <- str_wrap('Unemployment rates in the US have varied a lot over the years', width = 40)
ggplot(economics, aes(date, unemploy)) + 
  geom_line() + 
  geom_text(
    aes(x, y, label = caption),
    data = data.frame(x = xrng[1], y = yrng[2], caption = caption), 
                      hjust = 0, vjust = 1, size = 4
  )

#It is easier to use annotate helper function wich creates the dataframe for you
ggplot(economics, aes(date, unemploy)) + 
  geom_line() + 
  annotate('text', x = xrng[1], y = yrng[2], label = caption,
           hjust = 0, vjust = 'inward', size = 4)


# Anotations, particularly refference lines, are also useful when comparing groups across facets.
# In the following plot, it's much easier to see the subtle differences if we add a reference line

ggplot(diamonds, aes(log10(carat), log10(price))) + 
  geom_bin2d() + 
  facet_wrap(~cut, nrow = 1)


mod_coef <- coef(lm(log10(price) ~ log10(carat), data = diamonds))
ggplot(diamonds, aes(log10(carat), log10(price))) + 
  geom_bin2d() + 
  geom_abline(intercept = mod_coef[1], slope = mod_coef[2], 
              color = 'white', size = 1) + 
  facet_wrap(~cut, nrow = 1)


#### Group ####

### Note on grouping 
## if a group isn't defined by a single variable, but instead by a combination of multiple variables
## use interaction() to combine them,
## eg. aes(group = interaction(school_id, student_id))

ggplot(mpg, aes(class)) + 
  geom_bar()
ggplot(mpg, aes(class, fill = drv)) + 
  geom_bar()

# If you try to map fill to a continuous variable in the same way, it doesn't work.  The default
# grouping will only be based on class, so each bar will be given multiple colors.  
# Since a bar can only display one color, it will use the default grey.  To show multiple colors
# we need multiple bars for each class, which we can get by overriding the grouping

ggplot(mpg, aes(class, fill = hwy)) + 
  geom_bar()

ggplot(mpg, aes(class, fill = hwy)) + 
  geom_bar(aes(group = hwy))




#### Surface Plots ####

# ggplot2 does not support true 3d surfaces, however it does support many common ools for representing 
# 3d surfaces in 2d: contours, colored tiles and bubble plots.  These all work similarly differing only
# in the aesthetic used for the third dimension

ggplot(faithfuld, aes(eruptions, waiting)) + 
  geom_contour(aes(z = density, color = ..level..))

ggplot(faithfuld, aes(eruptions, waiting)) + 
  geom_raster(aes(fill = density))


#Bubble plots work better for fewer observations
small <- faithfuld[seq(1, nrow(faithfuld), by = 10), ]
ggplot(small, aes(eruptions, waiting)) + 
  geom_point(aes(size = density), alpha = 1/3) + 
  scale_size_area()



#### Graphing Maps ####

# There are four types of map data you might want to visualize: 
# Vector Boundaries
# Point Metadata
# Area Metadata
# Raster Images


#### Vector Boundaries ####
mi_counties <- map_data('county', 'michigan') %>% 
  select(lon = long, lat, group, id = subregion)

head(mi_counties)

ggplot(mi_counties, aes(lon, lat)) + 
  geom_polygon(aes(group = group)) +
  coord_quickmap()

ggplot(mi_counties, aes(lon, lat)) + 
  geom_polygon(aes(group = group), fill = NA, color = 'grey50') +
  coord_quickmap()

# coord_quickmap()
# this is a quick and dirty adjustment that ensures that the aspect ratio of the plot is set correctly
# Other useful sources are


#### Useful Packages for Maps ####

# USAboundaries
# https://github.com/ropensci/USAboundaries
# contains state, county and zip code data for the US.
# As well as current boundaries, it also has state and county boundaries going back to the 1600's

# tigris
# https://github.com/walkerke/tigris
# Makes it easy to access the US Census TIGRIS shapefiles.  It contains state, county, zip, and census 
# tract boundaries, as well as many other useful datasets

# rnaturalearth
# http://naturalearthdata.com/
# Contains country borders and borders for the top-level region within a country
# eg states in the USA, regions in France, counties in the UK

# osmar
# https://cran.r-project.org/package=osmar
# Wraps up the OpenStreetMap API so you can access a wide range of vector data 
# including indiviual streets and buildings

# You may have your own shape files (.shp) that you can load them into R with 
# maptools::readShapeSpatial()



# install.packages("USAboundaries")  This didnt work it told me to load the bottom one
# install.packages("USAboundariesData", repos = "http://packages.ropensci.org", type = "source")
library(USAboundaries)
c18 <- us_boundaries(as.Date('1820-01-01'))

# all the sources generate spatial data frames defined by the sp package
# You can convert them into a data frame with fortify()

# Rather than using this function, I now recommend using the broom package,
# which implements a much wider range of methods. fortify may be deprecated in the future.

library(broom)
c18df <- fix_data_frame(c18)

## All this stuff is getting a feel for the data
View(c18df)
rbind(c18df$geometry)

bind_rows(c18df$geometry[[1]][[6]][[1]], .id = 'group')


typeof(c18df$geometry[[1]][[6]][[1]])

length(c18df$geometry)

View(c18df$geometry)

for (i in 1:length(c18df$geometry)) {
  print(length(c18df$geometry[[i]]))
}

temp <- data.frame(c18$geometry[[1]][[6]][[1]])
names(temp) <- c('lon', 'lat')

ggplot(temp, aes(lon, lat)) + 
  geom_polygon()

ctest <- c18df$geometry

for (i in 1:length(ctest[[1]])) {
  ctest[[1]][[i]] <- data.frame(ctest[[1]][[i]][[1]])
}

ctest[[1]]
bind_rows(ctest[[1]], .id = 'group') %>% 
  ggplot(aes(X1, X2, group = group)) + 
  geom_polygon(fill = NA, color = 'grey50')

## Start of cleaning
for (i in 1:length(ctest)) {
  for (j in 1:length(ctest[[i]])) {
    ctest[[i]][[j]] <- data.frame(ctest[[i]][[j]][[1]])
  }
}


for (i in 1:length(ctest)) {
  ctest[[i]] <- bind_rows(ctest[[i]], .id = 'group')
}

test <- bind_rows(ctest, .id = 'state')


#final product
ggplot(test, aes(X1, X2)) + 
  geom_polygon(aes(group = interaction(state, group)), fill = NA, color = 'grey50')

c18dftemp <- c18df %>% 
  select(-geometry)

c18df %>% 
  mutate(state = as.character(1:28)) %>% 
  left_join(test, by = c('state')) %>% 
  ggplot(aes(X1, X2)) + 
  geom_polygon(aes(group = interaction(state, group), fill = terr_type), color = 'grey25') + 
  coord_quickmap()



#### Point Metadata ####
mi_cities <- maps::us.cities %>% 
  as_tibble() %>% 
  filter(country.etc == 'MI') %>% 
  select(-country.etc, lon = long) %>% 
  arrange(desc(pop))

mi_cities


ggplot(mi_cities, aes(lon, lat)) + 
  geom_polygon(aes(group = group), mi_counties, fill = NA, color = 'grey25') + 
  geom_point(aes(size = pop), color = 'red') + 
  scale_size_area() +
  coord_quickmap()


#### Raster Images ####

# Instead of displaying context with vector boundaries you might want to draw a traditional map underneath.  
# This is called a raster image.  The easiest way to get a raster map of a given area is to use the ggmap 
# package, which allows you to get data from a variety of online mapping sources including OpenStreetMap and 
# Google Maps. Downloading the raster data is oftem time consuming so its a good idea to cache it in a rds file

#if you have raster data from the raster package you can convert it to the form 
# needed by ggplot2 with the following code

# df <- as.data.frame(raster::rasterToPoints(x))
# names(df) <- c('lon', 'lat', 'x')
# ggplot(df, aes(lon, lat)) + 
#   geom_raster(aes(fill = x))



#### Area Metadata ####
mi_census <- midwest %>% 
  as_tibble() %>% 
  filter(state == 'MI') %>% 
  mutate(county = tolower(county)) %>% 
  select(county, area, poptotal, percwhite, percblack)
mi_census


census_counties <- left_join(mi_census, mi_counties, by = c('county' = 'id'))
census_counties
ggplot(census_counties, aes(lon, lat, group = county)) + 
  geom_polygon(aes(fill = poptotal)) + 
  coord_quickmap()


ggplot(census_counties, aes(lon, lat, group = county)) + 
  geom_polygon(aes(fill = percwhite)) + 
  coord_quickmap()




#### Graphing Error ####
y <- c(18, 11, 16)
df <- data.frame(x = 1:3, y, se = c(1.2, 0.5, 1))

base <- ggplot(df, aes(x, y, ymin = y - se, ymax = y + se))

base + geom_crossbar()
base + geom_pointrange()
base + geom_smooth(stat = 'identity')

base + geom_errorbar()
base + geom_linerange()
base + geom_ribbon()



#### Displaying Distributions ####
diamonds %>% 
  mutate(cut = as.character(cut)) %>% 
  ggplot(aes(depth)) + 
  geom_freqpoly(aes(color = cut), binwidth = 0.1, na.rm = T) + 
  xlim(58, 68) + 
  theme(legend.position = 'none')



diamonds %>% 
  mutate(cut = as.character(cut)) %>% 
  ggplot(aes(depth)) + 
  geom_histogram(aes(fill = cut), binwidth = 0.1, position = 'fill', na.rm = T) + 
  xlim(58, 68) + 
  theme(legend.position = 'none')


# Use a density plot when you know that the underlying density is smooth, continuous and unbounded.  
# you can use the adjust parameter to make the density more or less smooth

ggplot(diamonds, aes(depth)) + 
  geom_density(na.rm = T) + 
  xlim(58,68) + 
  theme(legend.position = 'none')


ggplot(diamonds, aes(depth, fill = cut, color = cut)) + 
  geom_density(alpha = 0.2, na.rm = T) + 
  xlim(58,68) + 
  theme(legend.position = 'none')



ggplot(diamonds, aes(clarity, depth)) + 
  geom_boxplot()

ggplot(diamonds, aes(carat, depth)) + 
  geom_boxplot(aes(group = cut_width(carat, 0.1))) +
  xlim(NA, 2.05)


#### Dealing with overplotting ####
# Very small amounts of overplotting can sometimes be alleviated by making the points smaller 
# or using hollow glyphs.  The following code shows some options for 2000 points sampled from 
# a bivariate normal distribution

df <- data.frame(x = rnorm(2000), y = rnorm(2000))
norm <- ggplot(df, aes(x,y)) + xlab(NULL) + ylab(NULL)
norm + geom_point()
norm + geom_point(shape = 1)
norm + geom_point(shape = '.')


# For larger datasets with more overplotting you can use alpha belnding to make the poitns transparent.

norm + geom_point(alpha = 1/3)
norm + geom_point(alpha = 1/5)
norm + geom_point(alpha = 1/10)


#if there is some discreteness in the data you can use jitter: geom_jitter()
# width and height argument, also use 

norm + geom_bin2d()
norm + geom_bin2d(bins = 10)
norm + geom_hex()
norm + geom_hex(bins = 10)



#### Statistical Summaries ####

#Count
ggplot(diamonds, aes(color)) + 
  geom_bar()


#Mean
ggplot(diamonds, aes(color, price)) + 
  geom_bar(stat = 'summary_bin', fun.y = mean)



ggplot(diamonds, aes(table, depth)) + 
  geom_bin2d(binwidth = 1, na.rm = T) + 
  xlim(50,70) +
  ylim(50,70)

ggplot(diamonds, aes(table, depth, z = price)) + 
  geom_raster(binwidth = 1, stat = 'summary_2d', fun = mean, na.rm = T) + 
  xlim(50,70) +
  ylim(50,70)

?stat_summary_bin
?stat_summary_2d













