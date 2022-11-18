# 30 Day Map Challenge 04 Green Color
# Delaware boundaries are from {tigris} package
# Data about protected lands in Delaware is in the shapefile downloaded on 17 November 2022 from:
# https://opendata.firstmap.delaware.gov/datasets/delaware::outdoor-recreation-areas-1/


library(tigris)
library(sf)
library(ggtext)
library(showtext)
showtext_opts(dpi = 300)
showtext_auto(enable = TRUE)
font_add_google("Roboto Condensed")
font <- "Roboto Condensed"

counties <- tigris::counties("Delaware", cb= TRUE )
mapdata <- st_read("./Delaware_Protected_Natural_Resources_2.0.shp")
ggplot() +
  geom_sf(data=counties, fill="white")+
  geom_sf(data=mapdata, fill="darkgreen", color="darkgreen")+
  coord_sf()+
  theme_void()+
  labs(subtitle="State of Delaware", 
       title="Protected Lands", 
       caption="Map by @DataAngler@vis.social for #30DayMapChallenge")+
  theme(plot.subtitle=element_text(family=font),
        plot.title = element_text(family=font),
        plot.caption=element_text(family=font,hjust = .5, size=9)) 
  ggsave("DE_Protected_Areas.png", height=6, width=7.5, bg="#eaf3ee") 
