# Open Street Map
install.packages("osmdata")
library(tigris)
library(osmdata)
library(tidyverse)
library(sf)
library(ggtext)
library(showtext)
showtext_opts(dpi = 300)
showtext_auto(enable = TRUE)
font_add_google("Roboto Condensed")
font <- "Roboto Condensed"
####Using Open Street Data to Make Map of primary and secondary roads in Newark, Delaware
###Code adapted from from https://github.com/BlakeRMills OpenStreetMap Challenge

border <- opq(bbox="Newark, Delaware") %>%
  add_osm_feature(key="admin_level", value=8) %>%
  osmdata_sf() %>%
  .$osm_multipolygons %>%
  select(osm_id, name, geometry) %>%
  filter(name=="Newark")

lines <- opq(bbox="Newark, Delaware") |> 
  add_osm_feature(key="highway", value = c("primary", "secondary", "residential", "road")) |> 
  osmdata_sf() %>%
  .$osm_lines |> 
  select(osm_id, name, geometry)

intersection <- st_intersection(border, lines)

list <- list(border, intersection)

plot <- ggplot() +
  geom_sf(data=list[[2]], size=0.25, color="darkgreen") +
  theme_void() +
  labs(title="Roads in Newark, Delaware", 
       caption = "Map by @DataAngler@vis.social | Code adapted from entry at github.com/BlakeRMills") 
ggsave("Roads_NewarkDE.png", height=6, width=7.5, bg="#eaf3ee") 

available_features()

tags <- available_tags("agricultural")


border<- getbb("Hawaii", display_name_contains="United States") |> 
  opq() |> 
  add_osm_feature("natural", "volcano")
osmdata_sf(border)

?opq
border <- opq(bbox="Iceland") %>%
  add_osm_feature(key="admin_level", value=2) %>%
  osmdata_sf() %>%
  .$osm_multipolygons %>%
  select(osm_id, name, geometry) %>%
  filter(name=="Iceland")

volcanoes <- opq(bbox="Iceland") |> 
  add_osm_feature(key="natural", value = c("volcano")) |> 
  osmdata_sf() %>%
  .$osm_points |> 
  select(osm_id, name, geometry)

plot <- ggplot() +
  geom_sf(data=list[[2]], size=0.25, color="darkgreen") +
  theme_void()


library(sf)
library(dplyr)
library(osmdata)

city_coords_from_op_str_map <- function(city_name){
  city_coordinates <- osmdata::getbb(city_name) %>% # Obtain the bounding box corners fro open street map
    t() %>% # Transpond the returned matrix so that you get x and y coordinates in different columns
    data.frame() %>% # The next function takes a data frame as input
    sf::st_as_sf(coords = c("x", "y")) %>%  # Convert to simple feature
    sf::st_bbox() %>% # get the bounding box of the corners
    sf::st_as_sfc() %>% # convert bounding box to polygon
    sf::st_centroid() %>% # get the centroid of the polygon
    sf::st_as_sf() %>% # store as simple feature
    sf::`st_crs<-`(4326)  # set the coordinate system to WGS84 (GPS etc.)
}
ithaca <- city_coords_from_op_str_map("Ithaca")


Iceland_bb <- getbb("Iceland")
boundaries <- opq(bbox = 'Iceland') %>%
  add_osm_feature(key = 'admin_level', value = '7') %>% 
  osmdata_sf() %>% 
  unique_osmdata()

ggplot() +
  geom_sf(data=volcanoes$osm_multipolygons) +
  coord_sf() +
  theme_void()

bb <- getbb("Iceland", featuretype = "country", format_out = "sf_polygon")

volcanoes2 <- getbb("Iceland", featuretype = "country") %>% 
  opq() %>% 
  add_osm_feature(key = "natural", value = "volcano") %>% 
  osmdata_sf() %>% 
  trim_osmdata(bb)


border <- opq(bbox="Iowa City, Iowa") %>%
  add_osm_feature(key="admin_level", value=8) %>%
  osmdata_sf() %>%
  .$osm_multipolygons %>%
  select(osm_id, name, geometry) %>%
  filter(name=="Iowa City")
available_tags("highway")
lines <- opq(bbox="Iowa City, Iowa") |> 
  add_osm_feature(key="highway") |> 
  osmdata_sf() %>%
  .$osm_lines |> 
  select(osm_id, name, geometry)


intersection <- st_intersection(border, lines)

list <- list(border, intersection)

plot <- ggplot() +
  geom_sf(data=list[[2]], size=0.25, color="darkgreen") +
  theme_void() +
  labs(title="Roads in Iowa City, Iowa", 
       subtitle="All roads with the Highway feature",
       caption = "Map by @DataAngler@vis.social | Code adapted from entry at github.com/BlakeRMills") +
  theme(plot.title = element_text(family = font, hjust = 0.5, size=11),
        plot.subtitle =  element_text(family = font, hjust = 0.5),
        plot.caption = element_text(family = font, hjust = 0.5),
        legend.position = "top")
ggsave("15_OpenStreetMap.png", height=6, width=7.5, bg="#eaf3ee")


