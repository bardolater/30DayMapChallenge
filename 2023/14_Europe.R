# This map uses tips from https://felixanalytix.medium.com/how-to-map-any-region-of-the-world-using-r-programming-bb3c4146f97f

library(tidyverse)
library(sf)
install.packages("rnaturalearthdata")
library(rnaturalearthdata)
library(viridis)
library(ggtext)
library(showtext)
showtext_opts(dpi = 300)
showtext_auto(enable = TRUE)
font_add_google("Roboto Condensed")
font <- "Roboto Condensed"
Europe <- ne_countries(scale = 'medium', type = 'map_units', returnclass = 'sf', continent="Europe")
Europe2 <- Europe |> filter(geounit != "Russia") |> rename(Code = sov_a3)

bounding_box <- st_sfc(
  st_point(c(-18, 32.5)),
  st_point(c(40.4, 72.3)),
  crs=4326
)
window_coord_sf <- bounding_box |> 
  st_transform(crs=4326) |> 
  st_coordinates()



vaccines_europe <- read.csv("./Data/covid-people-vaccinated-marimekko.csv")
vaccines <- vaccines_europe |> arrange(Code, Day) |>  group_by(Code) |> 
  slice_max(order_by = Day) |> ungroup() |> filter(Continent=="Europe")
vaccines2 <- vaccines |> mutate(Code = ifelse(Code == "GBR", "GB1", Code))
vaccines2 <- vaccines2 |> mutate(Code = ifelse(Code == "FIN", "FI1", Code))
vaccines2 <- vaccines2 |> mutate(Code = ifelse(Code == "FRA", "FR1", Code))
vaccines2 <- vaccines2 |> mutate(Code = ifelse(Code == "NLD", "NL1", Code))
vaccines2 <- vaccines2 |> mutate(Code = ifelse(Code == "DNK", "DN1", Code))
vaccines2 <- vaccines2 |> mutate(Code = ifelse(Code == "OWID_KOS", "KOS", Code))

Europe3 <- left_join(Europe2, vaccines2, by = "Code")
ggplot(Europe3) + geom_sf(aes(fill = people_vaccinated_per_hundred)) +
  scale_size_area() +
  coord_sf(
    xlim = window_coord_sf[,"X"],
    ylim = window_coord_sf[, "Y"],
    expand = F)+
  scale_fill_gradientn(colours=rev(magma(6)),
                       name=" ")+
  labs(title = "Number of People with >= 1 Dose of a COVID-19 Vaccine (per 100 Citizens)",
       caption = "#30DayMapChallenge | Data from Our World in Data | Map by @DataAngler@vis.social 
       https://ourworldindata.org/grapher/covid-people-vaccinated-marimekko") +
  theme_void()+
    theme(plot.title = element_text(family = font, hjust = 0.5, size=11),
          plot.subtitle =  element_text(family = font, hjust = 0.5),
          plot.caption = element_text(family = font, hjust = 0.5),
          legend.position = "top")
  ggsave("./Charts/14_Europe.png", dpi=300, height=7, width = 6, units="in", bg="beige")
  