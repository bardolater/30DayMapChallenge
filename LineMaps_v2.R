#########################
#The data set is the Delaware Public Crash 2.0 data set dowloaded
#as a CSV file on from this website:
#https://opendata.firstmap.delaware.gov/datasets/delaware-public-crash-data-2-0/
#The public crash data set supplies the data points on the map
#and the {tigris} package supplies the lines, which are the main roads
#in Delaware. Some fatalities were not on main highways, so the points
#are on smaller roads that are viewable by zooming in.

library(htmltools)
library(tigris)
library(leaflet)
library(tidyverse)
library(RColorBrewer)

de_primary <- tigris::primary_secondary_roads("DE") #Obtain the main roads in Delaware
crash <- read_csv("./Data/Delaware_Public_Crash_Data_2.0.csv")
crash$year <- as.factor(stringr::str_sub(crash$CRASH_DATE, 1, 4)) #Derive a year variable 

crash <- crash |> dplyr::filter(year=="2021") #Subset for 2021

crash <- crash |> dplyr::filter(CRASH_CLASS > '03' ) #only keep fatalities
crash <- crash |> dplyr::filter(CRASH_CLASS != '2') #remove one observation 
crash$CRASH_CLASS <- as.factor(crash$CRASH_CLASS)
#levels(crash$CRASH_CLASS)

crash$CRASH_CLASS <- factor(crash$CRASH_CLASS, labels = c("Fatality"))
#levels(crash$CRASH_CLASS)
crash_keep <- crash |> select(LATITUDE, LONGITUDE, CRASH_CLASS)
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
  tag.map.title, HTML("Crash Fatalities in Delaware (2021)")
)  
pal <- colorFactor(palette = c("orange"), domain = crash_keep$CRASH_CLASS)
##This map was exported to a PNG file by the viewer pane in RStudio
leaflet(de_primary) |> 
  addProviderTiles('CartoDB.Positron') |> 
  addPolylines(weight=.6) |> 
  addCircleMarkers(data=crash_keep, color = ~pal(CRASH_CLASS),  lng = ~LONGITUDE, lat = ~LATITUDE, group = ~CRASH_CLASS,
                   fillOpacity = 0.8, radius = 1) |> 
  addControl(title, position = "topright", className="map-title")