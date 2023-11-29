
# Flow Map for 30DayMapChallenge

library(tidycensus)
library(mapdeck)
library(tidyverse)
library(htmltools)
library(leaflet)

# Obtain the migration numbers for the Philadelphia Statistical Area ---------

phl_flows <- get_flows(
  geography = "metropolitan statistical area",
  msa = 37980,
  year = 2019,
  geometry = TRUE
)

# Only keep the top 10 sources of migration into the Philadelphia Area --------

most_moved_in <- phl_flows |> 
  filter(!is.na(GEOID2), variable=="MOVEDIN") |> 
  slice_max(n=10, order_by = estimate) |> 
  mutate(
    width = estimate / 500,
    tooltip = paste0(
      scales::comma(estimate * 5, 1),
      " people moved from", str_remove(FULL2_NAME, "Metro Area"),
      " to ", str_remove(FULL1_NAME, "Metro Area"), " between 2015 and 2019"
    )
  )

# To make the lines connecting the source to the Philadelphia area,
# we need to make new columns with latitude and longitude

most_moved_in <- most_moved_in %>%
  dplyr::mutate(lon_dest = sf::st_coordinates(.)[,1],
                lat_dest = sf::st_coordinates(.)[,2])
most_moved_in<- most_moved_in %>%
  mutate(lon_origin = unlist(map(most_moved_in$centroid2,1)),
         lat_origin = unlist(map(most_moved_in$centroid2,2)))

# Get a map of the region--------------------------------------------
states_flow <- tigris::states()
states_flow<- states_flow |> filter(STUSPS %in% (c("VA", "DC","NH","MA", "CT","DE", "PA", "NJ", "NY", "VT", "MD")))


# To map the polylines in {leaflet}, we need a long form data set of coordinates

most_moved_in_long <- most_moved_in |> 
  select(FULL2_NAME, lat_dest, lon_dest, lat_origin, lon_origin) |> 
  pivot_longer(c(lat_dest, lat_origin)) |> 
  rename(lat = value)
most_moved_in_long2 <- most_moved_in |> 
  select(FULL2_NAME, lat_dest, lon_dest, lat_origin, lon_origin) |> 
  pivot_longer(c(lon_dest, lon_origin)) |> 
  rename(lon = value) |> 
  select(lon)
most_moved_in_long <- cbind(most_moved_in_long, most_moved_in_long2[,1])
width <- most_moved_in |> select(FULL2_NAME, width, tooltip)
width <- as.data.frame(width)
most_moved_in_long <- left_join(most_moved_in_long, width, by = "FULL2_NAME")
most_moved_in_long <- most_moved_in_long |> mutate(tooltip= ifelse(name=="lat_dest", NA, tooltip))
tag.map.title <- tags$style(HTML("
  .leaflet-control.map-title { 
    transform: translate(-50%,20%);
    position: fixed !important;
    left: 70%;
    text-align: right;
    padding-left: 10px; 
    padding-right: 10px; 
    background: rgba(255,255,255,0.75);
    font-weight: bold;
    font-size: 18px;
  }
"))

title <- tags$div(
  tag.map.title, HTML("Top 10 Sources of Migration into the Philadelphia Statistical Area (from 2019 ACS)")
) 
leaflet(states_flow) |> 
  addProviderTiles('CartoDB.Positron') |> 
  addPolylines(weight=.6) |> 
  addCircleMarkers(data=most_moved_in, lng = ~lon_origin, lat = ~lat_origin,
                   fillOpacity = 0.8, radius = 1) |> 
  addCircleMarkers(data=most_moved_in, lng = ~lon_dest, lat = ~lat_dest,
                   fillOpacity = 0.8, radius = 1, fill="red") |> 
  addPolylines(data = most_moved_in_long, lng = ~lon, lat = ~lat,
               group = ~FULL2_NAME) |> 
  addMarkers(data =most_moved_in_long, lng = ~lon, lat = ~lat, popup = ~htmlEscape(tooltip) ) |> 
  addControl(title, position = "topright", className="map-title")
  