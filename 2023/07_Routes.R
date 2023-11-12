
library(sf)
library(tidyverse)
library(ggrepel)
library(tigris)
amtrak_routes <- st_read("./Book_Codes/OtherPrograms/30DayMaps/Amtrak_Routes/Amtrak_Routes.shp")
vermonter <- amtrak_routes |> filter(NAME=="Vermonter")

amtrak_states <- tigris::states()
amtrak_states <- amtrak_states |> filter(STUSPS %in% (c("DC","NH","MA", "CT","DE", "PA", "NJ", "NY", "VT", "MD")))
trenton <- data.frame(place = "Trenton",y = 40.21891, x = -74.75431)
wilmington <- data.frame(place = "Wilmington", y = 39.73721180866507, x= -75.55096371131324)

newark_nj <- data.frame(place = "Newark", y = 40.568312870528544, x= -74.32968744762886)
nyc <- data.frame(place = "NYC", y = 40.75138867268947, x = -73.9953957899489)
stops <- rbind(trenton, wilmington, newark_nj, nyc)
ggplot() +
  geom_sf(data=amtrak_states) +
  geom_sf(data=vermonter) +
  geom_point(data=stops, mapping = aes(x = x, y=y)) +
  geom_label_repel(data=stops, mapping = aes(x=x, y=y,label=place), nudge_x = 0.6)+
  coord_sf()+
  theme_void()+
  labs(title = "Route of Vermonter Amtrak Train",
       subtitle = "with labels of the 4 stations on my trip from Wilmington to NYC",
       caption = "Route map for #30DayMapChallenge | @DataAngler@vis.social") +
  theme(legend.position = "none",
        plot.title= element_text(hjust=0.5),
        plot.subtitle = element_text(hjust=0.5))
ggsave("./Charts/07_Routes.png", dpi=300, height=7, width = 6, units="in", bg="white")