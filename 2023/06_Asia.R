library(sf)
library(tidyverse)
#Shapefile for main boundary of China https://geodata.lib.utexas.edu/catalog/stanford-jb316kf1797
china <- read_sf("./Data/jb316kf1797.shp")
#Subnational adminiatrtive boundaries: https://data.humdata.org/dataset/cod-ab-chn?
china_boundary <- read_sf("./Data/chn_admbnda_adm2_ocha_2020.shp")
ggplot() +
  geom_sf(data=china) +
  geom_sf(data=china_boundary)+
  labs(title = "Administrative Boundaries of China and Taiwan",
       caption = "Asia Map for Day 6 of #30DayMapChallenge | @DataAngler@vis.social") +
  coord_sf() +
  theme_void() +
  theme(plot.title = element_text(hjust = 0.5))
ggsave("./Charts/06_Asia_Map.png", dpi=300, height = 5, width=6, units = "in")