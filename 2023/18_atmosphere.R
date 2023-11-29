### 30DayMapChallenge - Atmosphere
# https://ourworldindata.org/outdoor-air-pollution
library(tidyverse)
library(rnaturalearth)
library(viridis)
library(scales)
library(ggtext)
library(showtext)
showtext_opts(dpi = 300)
showtext_auto(enable = TRUE)
font_add_google("Roboto Condensed")
font <- "Roboto Condensed"
viridis::
pollution <- read.csv("./Data/outdoor-pollution-death-rate.csv")
pollution_first <- pollution |> group_by(Entity) |> slice_min(order_by = Year) |> ungroup()
pollution_last <- pollution |> group_by(Entity) |> slice_max(order_by = Year) |> ungroup()
names(pollution_lag)
pollution_lag <- bind_rows(pollution_first, pollution_last) |> arrange(Entity, Year) |>
  rename(sov_a3 = Code, Pollution_Death = `Deaths.that.are.from.all.causes.attributed.to.ambient.particulate.matter.pollution.per.100.000.people..in.both.sexes.aged.age.standardized`)
pollution_lag2 <- pollution_lag |>
group_by(Entity) |>
    mutate(PercentChange = (Pollution_Death - lag(Pollution_Death)) / lag(Pollution_Death) ) |>
  ungroup() |>
  filter(!is.na(PercentChange))

world<- rnaturalearth::ne_countries(returnclass = "sf")
world <- world |>
         mutate(sov_a3 = case_when(sov_a3=="FR1" ~ "FRA",
                                   sov_a3=="US1" ~ "USA",
                                   sov_a3=="KA1" ~ "KAZ",
                                   sov_a3=="GB1" ~ "GBR",
                                   sov_a3=="DN1" ~ "DNK",
                                   sov_a3=="CU1" ~ "CUB",
                                   sov_a3=="NL1" ~  "NLD",
                                   sov_a3=="NZ1" ~ "NZL",
                                   sov_a3=="AU1" ~ "AUS",
                                   sov_a3=="CH1" ~ "CHN",
                                   sov_a3=="FI1" ~ "FIN",
                                   .default = sov_a3
                                   ) )
world2 <- left_join(world, pollution_lag2, by = "sov_a3")

ggplot()+
  geom_sf(data=world2, aes(fill=PercentChange)) +
  scale_fill_gradientn(colours=rev(inferno(6)), labels=percent,
                       name="Change in Deaths per 100K People") +
  coord_sf() +
  theme_void() +
  labs(title= "Percent Change in Deaths Attributable to Air Pollution between 1990-2019",
       subtitle = "Many of largest decreases are in Scandinavia",
       caption = "Source: Our World in Data |  #30DayMapChallenge | Map by @DataAngler@vis.social") +
  theme(plot.title = element_text(family = font, hjust = 0.5, size = 10),
        plot.subtitle =  element_text(family = font, hjust = 0.5, size=9),
        plot.caption = element_text(family = font, hjust = 0.5),
        legend.position = "right",
        legend.title  = element_text(family=font,size = 8 ))
ggsave("./Charts/18_Atmosphere.png", dpi=300, height=5, width = 7.3, units="in", bg="beige")






