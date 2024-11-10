# Day 5 (Route) for #30DayMapChallenge 
library(tidyverse)
library(sf)
library(ggtext)
app <- st_read("./appa_area/appa_area.shp")
basemap2 <- usmap::us_map(include = c("GA", "ME", "VT", "NH", "MA", "NY", "NJ",
                              "PA", "MD", "VA", "WV","TN", "NC", "CT"))
rayshader::plot_map(app)

ggplot()+
  geom_sf(data=basemap2) +
  geom_sf(data=app, aes(color="magenta", size=3)) +
  theme(legend.position = "none") +
  coord_sf()+
  labs(title="The Appalachian Trail")+
  theme_wallis() +
  theme(legend.position = "none")
ggsave("05_Route.png", height=5, width = 6, dpi=300, bg="white")
