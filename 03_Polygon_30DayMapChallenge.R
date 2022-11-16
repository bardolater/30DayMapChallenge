# This is the polygon map for the #30DayMapChallenge.
# The data for the legislative district boundaries
# were downloaded as a shapefile from this location
# on the Delaware Open Map site:
# https://opendata.firstmap.delaware.gov/datasets/delaware::enacted-house-of-representatives/

library(sf)
library(tidyverse)
House <- st_read("./BND_LegEnacted_House.shp")
png("./DE_House_2022_Election.png", height=6, width=5, units="in", res=300)
ggplot() +
  geom_sf(data=House,aes(fill=PARTY))+
  coord_sf(datum = NA)+  
  theme_void()+
  theme(legend.key.size = unit(1,"line"),                                       
        legend.key.height= unit(0.5,"line"))+
  scale_fill_manual(values=c("deepskyblue", "red"))+
  labs(title="41 Delaware House Districts (2022 Election)",
       subtitle="Democrats hold 11 more seats",x="",y="",
       caption = "Map by @DataAngler@vis.social for #30DayMapChallenge")
dev.off()

