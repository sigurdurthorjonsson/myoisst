library(ggplot2)
library(raster)

ave <- raster("macArea/ave_m07.nc", varname = "sst")

ave <- aggregate(ave, fac = 2)

proj4string(ave) <- 
  CRS("+proj=longlat +datum=WGS84 +no_defs +ellps=WGS84 +towgs84=0,0,0")

jet.colors <-   # function from grDevices package
  colorRampPalette(c("#00007F", "blue", "#007FFF", "cyan",
                     "#7FFF7F", "yellow", "#FF7F00", "red", "#7F0000"))
blue_white_red_anomaly.colors <- colorRampPalette(c("blue", "white", "red"))

## ggplot with azimuthal equal area projection

a <- as(ave, "SpatialPixelsDataFrame")
a <- as.data.frame(a)

names(a)[1] <- 'temperature'

b <- bbox(ave)
m <- map_data("world", xlim = b[1,], ylim = b[2,])

pdf(file = "figs_out.pdf")

mylev <- seq(-2, 23, by = 1)
nlev <- length(mylev) - 1

print(
  ggplot() +
    geom_tile(data=a, aes(x=x, y=y, fill=temperature), alpha=0.8) +
    scale_fill_gradientn(colours = jet.colors(nlev), limits = c(-2,23)) +
    geom_polygon(data = m, aes(long, lat, group = group), fill = "grey") +
    theme(legend.position="bottom") +
    theme(legend.key.width=unit(2, "cm")) +
    coord_map(projection = "azequalarea", xlim = b[1,], ylim = b[2,]) + 
    theme_bw() +
    labs(x = NULL, y = NULL,
       title = paste("July 1990-2009 average SST"))
)

years <- 2010:2018

for(i in seq(along = years)) {
  jul <- raster(paste("macArea/", years[i], 
    "m07.nc", sep = "/"), varname = "sst")
  jul <- aggregate(jul, fac = 2)
  diff <- jul - ave

  j <- as(jul, "SpatialPixelsDataFrame")
  j <- as.data.frame(j)
  names(j)[1] <- 'temperature'

  d <- as(diff, "SpatialPixelsDataFrame")
  d <- as.data.frame(d)
  names(d)[1] <- 'anomaly'

  mylev <- seq(-2, 23, by = 1)
  nlev <- length(mylev) - 1
  
print(
  ggplot() +
    geom_tile(data=j, aes(x=x, y=y, fill=temperature), alpha=0.8) +
    scale_fill_gradientn(colours = jet.colors(nlev), limits = c(-2,23)) +
    geom_polygon(data = m, aes(long, lat, group = group), fill = "grey") +
    theme(legend.position="bottom") +
    theme(legend.key.width=unit(2, "cm")) +
    coord_map(projection = "azequalarea", xlim = b[1,], ylim = b[2,]) + 
    theme_bw() +
    labs(x = NULL, y = NULL,
       title = paste("July", years[i], "average SST"))
)

  mylev <- seq(-5, 5, by = 2)
  nlev <- length(mylev) - 1
  
print(
  ggplot() +
    geom_tile(data=d, aes(x=x, y=y, fill=anomaly), alpha=0.8) +
    scale_fill_gradientn(
      colours = blue_white_red_anomaly.colors(nlev), limits = c(-5,5)) +
    geom_polygon(data = m, aes(long, lat, group = group), fill = "grey") +
    theme(legend.position="bottom") +
    theme(legend.key.width=unit(2, "cm")) +
    coord_map(projection = "azequalarea", xlim = b[1,], ylim = b[2,]) + 
    theme_bw() +
    labs(x = NULL, y = NULL,
       title = paste("July", years[i], "average SST anomaly"))
)
}

dev.off()
