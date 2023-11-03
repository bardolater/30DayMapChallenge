library(htmltools)
library(tigris)
library(sf)
library(leaflet)
library(tidyverse)
library(RColorBrewer)
library(RSocrata)
library(sysfonts)
library(showtext)
library(ggtext)
font_add_google("Roboto Condensed")
font <- "Roboto Condensed"
df <- RSocrata::read.socrata("https://data.delaware.gov//api//odata//v4//827n-m6xc")
de_primary <- tigris::primary_secondary_roads("DE")
de_borders<- counties("Delaware", cb=T)

df <- df |> mutate(Year = substr(crash_datetime, 1, 4) )
df |> filter(crash_class_desc=="Fatality Crash") |>  group_by(Year) |> count()

crash_2022 <- df |> dplyr::filter(substr(crash_datetime, 1, 4) %in% c("2022") & crash_class_desc=="Fatality Crash" ) #Subset for 2022
crash_2012 <- df |> dplyr::filter(substr(crash_datetime, 1, 4) %in% c("2012") & crash_class_desc=="Fatality Crash" ) #Subset for 2022
all_crashes <- bind_rows(crash_2012, crash_2022)

ggplot() +
  geom_sf(data=de_borders, fill="white", color="maroon") +
  geom_sf(data=de_primary, color="gray") +
  geom_point(data=all_crashes, mapping = aes(x=longitude, y = latitude,  colour=Year, alpha=0.2)) +
  scale_color_manual(values = c("orange", "blue")) +
  labs(title = "Fatality Crashes in Delaware in <span style = 'color: orange;'>2012</span>
       and in <span style = 'color: blue;'>2022</span>  ",
       caption="Crash Data from Delaware Open Data. Map by @DataAngler@vis.social for #30DayMapChallenge 2023",
       subtitle="")+
  coord_sf() +
  theme_void() +
  theme(plot.subtitle=element_text(family=font, hjust = 0.5),
        plot.title = element_markdown(family=font, hjust = 0.5, size = 12),
        plot.caption=element_text(family=font,hjust = .5, size=7),
        legend.position = "none",
        plot.title.position = "plot")
ggsave("Major_Roads_DE_Crashes.png", height=6, width=6.5, bg="#eaf3ee")


