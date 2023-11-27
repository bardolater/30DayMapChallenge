# Map of Oceania
library(tidyverse)
library(sf)
library(ggtext)
library(showtext)
library(viridis)
library(readxl)
library(scales)
showtext_opts(dpi = 300)
showtext_auto(enable = TRUE)
font_add_google("Roboto Condensed")
font <- "Roboto Condensed"

# These data files are from the Australian Bureau of Statistics
az <- st_read("./Data/STE_2021_AUST_SHP_GDA2020/STE_2021_AUST_GDA2020.shp")
pop <- readxl::read_xlsx("./Data/Australian Bureau of Statistics.xlsx")
pop <- pop |> mutate(Population = 1000*`Population at 31 March 2023 ('000)`)
az_v2 <- left_join(az, pop)

ggplot() +
  geom_sf(data=az_v2, aes(fill=Population)) +
  scale_fill_gradientn(colours=rev(magma(6)),
                       name="Population",
                       labels = scales::unit_format(unit = "M", scale = 1e-6)) +
  geom_sf_label(fill = "white") + 
  coord_sf() +
  theme_void() +
  labs(title= "Population of Regions in Australia in 2023",
       subtitle = "Greatest population gain (as a percentage) from previous year was in 
                  Western Australia (2.8%)",
       caption = "Source: Australian Bureau of Statistics | #30DayMapChallenge | Map by @DataAngler@vis.social") +
  theme(plot.title = element_text(family = font, hjust = 0.5),
        plot.subtitle =  element_text(family = font, hjust = 0.5),
        plot.caption = element_text(family = font, hjust = 0.5),
        legend.title = element_text(family = font),
        legend.position = "top")
ggsave("./Charts/16_Oceania.png", height=6, width=7.5, bg="#eaf3ee", dpi=300)

