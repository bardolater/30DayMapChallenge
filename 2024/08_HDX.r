### #30DayMapChallenge: Humanitarian Data Exchange
# Data about civilian fatalities are from https://data.humdata.org/dataset/ukraine-acled-conflict-data

library(scales)
library(tidyverse)
library(viridis)
library(sysfonts)
library(showtext)

showtext_opts(dpi = 300)
showtext_auto(enable = TRUE)
options(scipen = 100)
font_add_google("Roboto Condensed")
font <- "Roboto Condensed"

ukr <- sf::st_read("ukr_admbnda_adm1_sspe_20240416.shp")
conflict <- readxl::read_xlsx("\\Downloads\\ukraine_hrp_civilian_targeting_events_and_fatalities_by_month-year_as-of-21nov2024.xlsx", sheet = "Data")
kyiv <- data.frame(city="Kyiv", lat=50.26, lon= 30.31) #Coordinates taken from https://www.worldatlas.com/maps/ukraine

total_fatalities <- conflict |> 
  group_by(`Admin1 Pcode`) |> 
  summarise(Total = sum(Fatalities)) |> 
  rename(ADM1_PCODE = `Admin1 Pcode`)

ukr <- ukr |> 
  left_join(total_fatalities)

ggplot() +
  geom_sf(data=ukr, aes(fill=Total)) +
  geom_text(data=kyiv, aes(x=lon, y=lat, label=city), size=2, alpha=0.75) +
  theme_void()+
  scale_fill_gradientn(colours=rev(magma(6)),
                       name=" ",
                       labels=comma) +
  labs(title = "Number of Civilian Fatalities in the War in Ukraine (2018-2024)",
       caption= "Map by @DataAngler@vis.social | Data from HDX") +
  theme(legend.position = "top",
        plot.title = element_text(family=font, size=10),
        plot.caption = element_text(family=font, size=6),
        legend.key.size = unit(4,"line"),
        legend.key.height = unit(1, "line"),
        legend.text=element_text(family=font, size=7),
        legend.margin = margin(0.3, 0,0,0, unit="cm")
        )
ggsave("05_Ukraine.png", height = 4, width = 6, bg="#eaf3ee", dpi = 300)
