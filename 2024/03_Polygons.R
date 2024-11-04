#### Day 3 for #30DayMapChallenge

font_add_google("Roboto Condensed")
font <- "Roboto Condensed"
library(sysfonts)
library(tigris)
library(usmap)
library(showtext)
library(ggtext)
xx <- tigris::native_areas(year = 2022)

xx$lon <- as.numeric(xx$INTPTLON) 
xx$lat <- as.numeric(xx$INTPTLAT)

xx <- xx |> 
  select (lon, lat, everything())

areas <- usmap::usmap_transform(xx, c("lon", "lat")) |> 
  filter(as.numeric(INTPTLON) > -156) #Filter a geographic outlier that is causing a distortion
ggplot()+ 
  geom_sf(data=usmap::us_map(), fill=NA) + 
  geom_sf(data=areas, aes(fill="orchid")) +
  labs(title="Map of Statistical Areas for Native Peoples in USA",
       caption = "by DataAngler@vis.social | #30DayMapChallenge",
       subtitle  ="Areas include reservations and other types of federally and state-recognized areas.")+
  theme_void() +
  theme(legend.position = "none",
        plot.title = element_text(family=font,hjust=0.7, size=11),
        plot.subtitle = element_text(family=font, hjust=0.8, size=8),
        plot.caption = element_text(family=font, size=7)) 
ggsave("03_Polygons.png", dpi=300, height=5, width = 7, units="in", bg="white")
