#### Day 4 Hexagon Map by DataAngler@vis.social

library(tidyverse)
library(tigris)
library(tidycensus)
library(sf)
library(scales)

# Read in a shapefile found on the web at
# https://vizpainter.com/hex-map-spatial-file/
hex <- st_read("Hex States Shapefile/HexStates.shp")

# Create a crosswalk to merge shapefile with Census data
cwalk <- data.frame(State_Abbr = state.abb, NAME = state.name)

# OPTIONAL - look at the list of variables for the American Community Survey
variable_list  <- tidycensus::load_variables(2022, "acs1", cache = TRUE)

# Obtain median household income at the state level and merge with shapefile
income <- tidycensus::get_acs(geography = "state", variables = c(medianincome="B19013_001"),
                  year=2022)
hex <- hex |> inner_join(cwalk) |> inner_join(income)

ggplot() +
  geom_sf(data=hex, aes(fill=estimate)) +
  geom_sf_text(data = hex, aes(label=State_Abbr)) +
  scale_fill_gradientn(colours = rev(terrain.colors(10)),name="", guide = "colourbar", labels=scales::dollar) +
  labs(title="Hex Map of Median Household Income by State",
       subtitle = "from 2022 American Community Survey",
       caption = "Map by DataAngler@vis.social | #30DayMapChallenge")+
  theme_void() +
  theme(
    legend.position = "bottom",
    legend.key.size = unit(.8,"line"),
    legend.key.width = unit(1.5, 'cm'),
    legend.box.spacing = unit(0.5, 'cm'),
    legend.spacing.x = unit(0.02, 'cm')
  )
ggsave("04_Hex.png", dpi=300, height=5, width=7, units = "in")

