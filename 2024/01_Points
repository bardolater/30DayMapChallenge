#########################
#30DayMapChallenge Day 1: Points
# The data are from the Feederwatch program (2021-2024 checklists) and are downloadable at
# https://feederwatch.org/explore/raw-dataset-requests/

library(tigris)
library(tidyverse)
library(janitor)
library(sf)
library(usmap)
feederwatch <- readr::read_csv("PFW_all_2021_2024_May2024_Public.csv")
d <- feederwatch
d <- d |> clean_names()

basemap <- usmap::us_map(exclude = c("HI", "AK"))
birdcounts <- d |> 
  select(longitude, latitude,year, species_code, subnational1_code, how_many, valid ) |> 
  filter(substr(subnational1_code, 1,2) != 'CA' ) |> 
  filter(substr(subnational1_code, 1,2) != 'PM' ) |> 
  filter(species_code=="osprey" & valid==1) |> 
  group_by(latitude, longitude) |> 
  mutate(Total = sum(how_many)) |> 
  ungroup() |> 
  select(-c(year, how_many)) |> 
  distinct() |> 
  rename(lon=longitude, lat=latitude)
counts <- usmap::usmap_transform(birdcounts)

titletext <- "Total Sightings of Ospreys at Different Coordinates in the U.S."
subtext <- "Data from Feederwatch Checklists for 2021-2024"
captiontext <- "Map by DataAngler@vis.social | #30DayMapChallenge"
ggplot(basemap) +
  geom_sf() +
  geom_sf(data=counts, pch=21, aes(size=Total), fill = alpha("purple", 0.7)) +
  labs(title=titletext, subtitle = subtext, caption=captiontext) +
  theme_void()+
  theme(plot.margin=unit(c(1,1,1.5,1.2),"cm"))
ggsave("01_Points_2024.png", dpi = 300, width = 7, height=5, units="in", bg="beige")

