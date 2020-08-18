# script used to produce figures included in 2018 iessns-post-cruise-report
# repeated in August 2020 for the 2020-report, after some experimenting
library(raster)
library(tidyverse)
# devtools::install_github("einarhjorleifsson/gisland", dependencies = FALSE)

years <- 2010:2020

# the average for the reference period 1990-2009

raster("macArea/ave_m07.nc", varname = "sst") %>%
  aggregate(fac = 2) %>%
  as("SpatialPixelsDataFrame") %>% 
  as.data.frame() %>%
  as_tibble() %>%
  rename(average = Daily.sea.surface.temperature) -> reference

# seeding
res <- list()

# stack the hay
for(i in seq(along = years)) {
  res[[i]] <- 
    raster(paste("macArea", years[i], 
                 "m07.nc", sep = "/"), varname = "sst") %>% 
    # User can change spatial resolution of temperature grid in the next step.
    #  Higher values mean faster plot rendering.
    aggregate(fac = 2) %>% 
    as("SpatialPixelsDataFrame") %>% 
    as.data.frame() %>% 
    as_tibble() %>% 
    rename(sst = Daily.sea.surface.temperature) %>% 
    mutate(year = years[i])
}

# bind the hay and add reference period average to monthly july averages
d <-
  res %>% 
  bind_rows() %>%
  left_join(reference) -> d

# Get a background map of terrestrial reference areas
m <- map_data("world", xlim = c(-50, 50), ylim = c(30, 85))

# Find plot range
xlim <- range(d$x)
ylim <- range(d$y)

# The number of "steps" in the rainbow:
nlev <- d$sst %>% floor() %>% unique() %>% length()

# palette to use from help(grDevices::colorRampPalette) 'as in Matlab'
jet.colors <-   
  colorRampPalette(c("#00007F", "blue", "#007FFF", "cyan",
                     "#7FFF7F", "yellow", "#FF7F00", "red", "#7F0000"))

pdf(file = "sst_jul_2010-2020.pdf")
print(
d %>% 
  ggplot() +
  theme_bw() +
  geom_tile(aes(x=x, y=y, fill=sst), alpha=0.8) +
  scale_fill_gradientn(colours = jet.colors(nlev)) +
  geom_polygon(data = m, aes(long, lat, group = group), fill = "grey") +
  coord_map(projection = "azequalarea",
            xlim = xlim, ylim = ylim) + 
  scale_x_continuous(name = NULL, breaks = NULL) +
  scale_y_continuous(name = NULL, breaks = NULL) +
  labs(title = "July - average SST",
       fill = "Celcius") +
  facet_wrap(~ year)
)
dev.off()
system("convert -density 250x250 sst_jul_2010-2020.pdf sst_jul_2010-2020.png")

# Calculate annual anomalies by "square":

d <- 
  d %>% 
  group_by(x, y) %>% 
  mutate(anomaly = sst - average) %>% 
  ungroup()



amin <- -3
amax <- 3
d <-
  d %>% 
  # "Trim" the exremes, used in the plotting
  mutate(a.plot = case_when(anomaly < amin ~ amin,
                       anomaly > amax ~ amax,
                       TRUE ~ anomaly),
         a.plot = gisland::grade(a.plot, 0.5))


# And the anomaly plot (again, be patient, takes some time to render):

pdf(file="sst_jul_2010-2020_anomaly_ref_1990-2009.pdf")
print(
d %>%
  ggplot() +
  # lets keep the default theme, shows the extent of the data
  #theme_bw() +
  geom_tile(aes(x=x, y=y, fill= round(anomaly)), alpha=0.8) +
  scale_fill_gradient2(low = "blue", mid = "white", high = "red",
                       midpoint = 0, limits = c(-3, 3),
                       breaks = seq(-3, 3, by = 0.5),
                       guide = "legend") +
  geom_polygon(data = m, aes(long, lat, group = group), fill = "grey") +
  coord_map(projection = "azequalarea", xlim = xlim, ylim = ylim) + 
  scale_x_continuous(name = NULL, breaks = NULL) +
  scale_y_continuous(name = NULL, breaks = NULL) +
  labs(title = "July SST anomaly",
       fill = "Anomaly +/- 0.25") +
  facet_wrap(~ year)
)
dev.off()
system("convert -density 250x250 sst_jul_2010-2020_anomaly_ref_1990-2009.pdf sst_jul_2010-2020_anomaly_ref_1990-2009.png")
