# Day 10  of 30DayMapChallenge: North America
library(tigris)
library(tidyverse)
library(sf)
library(scales)
library(viridis)
library(ggtext)
library(showtext)
showtext_opts(dpi = 300)
showtext_auto(enable = TRUE)
font_add_google("Roboto Condensed")
font <- "Roboto Condensed"

# Data come from https://ourworldindata.org/us-states-vaccinations
vaccine <- read.csv("./Data/us-state-covid-vaccines-per-100.csv")
vaccine_rates <- vaccine |> group_by(Entity) |>  slice_max(Day) |> ungroup()
vaccine_rates <- vaccine_rates |> rename(NAME = Entity)
vaccine_rates <- vaccine_rates |> mutate(NAME = ifelse(NAME=="New York State", "New York", NAME))
usamap <- tigris::states()
usamap <- usamap |> filter(DIVISION >0)
usamap <- usamap |> filter(!(STUSPS %in% c("HI", "AK")))
usamap2 <- left_join(usamap, vaccine_rates, by = "NAME")

ggplot() +
geom_sf(data=usamap2, aes(fill=total_vaccinations_per_hundred)) +
  scale_fill_gradientn(colours=rev(magma(6)),
                       name=" ",) +
  coord_sf() +
  theme_void() +
  labs(title= "Total Vaccination Doses Administered per 100 People, by May 10, 2023",
       subtitle = "All doses, including boosters",
       caption = "Source: Our World in Data|  #30DayMapChallenge |Map by @DataAngler@vis.social") +
  theme(plot.title = element_text(family = font, hjust = 0.5),
        plot.subtitle =  element_text(family = font, hjust = 0.5),
        plot.caption = element_text(family = font, hjust = 0.5),
        legend.position = "top")
ggsave("./Charts/10_NorthAmerica.png", dpi=300, height=7, width = 6, units="in", bg="beige")

