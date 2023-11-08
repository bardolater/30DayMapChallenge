# This is the polygon map for the #30DayMapChallenge.
# The data for the legislative district boundaries
# were downloaded as a shapefile from this location
# on the Delaware Open Map site:
# https://de-firstmap-delaware.hub.arcgis.com/datasets/delaware::senate-districts/about?share=link

library(sf)
library(tidyverse)
library(tigris)

DE <- tigris::state_legislative_districts(state = "DE")
DE <- DE |> mutate(DISTRICT = as.numeric(SLDUST))
#This file with information about party comes from Delware Open Data
DE_political <- read.csv("./Delaware_Political_Boundaries.csv")
DE_political <- DE_political |> select(DISTRICT, PARTY)
DE_v2 <- left_join(DE, DE_political)

  summary(as.factor(DE_political$PARTY))
  
ggplot() +
  geom_sf(data=DE_v2, aes(fill=PARTY))+
  coord_sf()+  
  theme_void()+
  theme(legend.key.size = unit(1,"line"),                                       
        legend.key.height= unit(0.5,"line"))+
  scale_fill_manual(values=c("deepskyblue", "red"))+
  labs(title="21 Delaware Senate Districts (2022 Election)",
       subtitle="Democrats hold 15 - 6 Advantage",x="",y="",
       caption = "Map by @DataAngler@vis.social for #30DayMapChallenge")
ggsave("./Charts/03_30Day_Polygon.png", dpi = 300, height = 7, width = 5, units="in", bg="#eaf3ee")

