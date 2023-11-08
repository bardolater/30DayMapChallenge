#### Map for Day 4: Bad Map

library(sf)
library(tidyverse)
library(tigris)

usa_map <- tigris::counties()
usa_map <- usa_map |> filter(substr(NAME, 1, 1) == "V")
states <- tigris::states(cb = FALSE)
states <- states |> filter(REGION !=9)
states <- states |> filter(NAME != "Alaska" & NAME != "Hawaii")
ggplot() +
  geom_sf(data=states)+
  geom_sf(data=usa_map, aes(fill=NAME))+
  coord_sf()+  
  theme_void()+
  theme(legend.key.size = unit(1,"line"),                                       
        legend.key.height= unit(0.5,"line"),
        legend.title = element_blank(),
        plot.title = element_text(hjust=0.5))+
  labs(title="31 Counties in the USA Begin with Letter V", x="",y="",
       caption = "Map by @DataAngler@vis.social for #30DayMapChallenge")
ggsave("./Charts/04_Bad_Map.png", dpi = 300, height = 6, width = 7, units="in", bg="#eaf3ee")
