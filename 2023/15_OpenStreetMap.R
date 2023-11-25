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


