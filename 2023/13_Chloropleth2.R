# Chloropleth Map
#

#remotes::install_github("afrimapr/afrilearndata")

library(afrilearndata)
library(tidyverse)
library(scales)
library(viridis)
library(ggtext)
library(showtext)
showtext_opts(dpi = 300)
showtext_auto(enable = TRUE)
font_add_google("Roboto Condensed")
font <- "Roboto Condensed"

data("africountries")
africountries

# Data file is COMPACT file downloaded rom https://population.un.org/wpp/Download/Standard/MostUsed/
df <- readxl::read_xlsx("./Data/WPP2022_GEN_F01_DEMOGRAPHIC_INDICATORS_COMPACT_REV1_copy.xlsx", skip = 16)

# Clean variable name and re-name countries to match name in map data
df <- df |> rename(Country = `Region, subregion, country or area *`,
                   iso_a3 = `ISO3 Alpha-code`)
df <- df |> mutate(Country = ifelse(Country=="United Republic of Tanzania", "Tanzania", Country))
df <- df |> mutate(Country = ifelse(Country=="Congo", "Republic of Congo", Country))
df <- df |> mutate(Country = ifelse(Country=="Gambia", "The Gambia", Country))

# Wrangle data to combine map information with data about median age in each country
list_africa <- as.data.frame(africountries)
list_africa <- list_africa$name_long
codes <- data.frame(Country = list_africa)
df_v2 <- inner_join(df, codes)
df_v3 <- df_v2 |> filter(Year==1950 | Year==2021)
df_v4 <- df_v3 |> dplyr::select(Country, Year, `Life Expectancy at Birth, both sexes (years)`) |> 
  rename(LifeExpectancy = `Life Expectancy at Birth, both sexes (years)`) |> 
  group_by(Country) |> 
  mutate(LifeExpectancy = as.numeric(LifeExpectancy), Percent = (LifeExpectancy - lag(LifeExpectancy)) / lag(LifeExpectancy) ) |> 
  ungroup() |> 
  rename(name_long = Country) |> 
   filter(!is.na(Percent))
map_Life <- left_join(africountries, df_v4)


ggplot()+
  geom_sf(data=map_Life, aes(fill=Percent)) +
  scale_fill_gradientn(colours=rev(magma(6)),
                       name=" ",
                       label=percent) +
  coord_sf() +
  theme_void() +
  labs(title= "Percent Change in Life Expectancy in African Nations (1950-2021)",
       caption = "Source: World Population Prospects 2022|  #30DayMapChallenge |Map by @DataAngler@vis.social") +
  theme(plot.title = element_text(family = font, hjust = 0.5),
    plot.subtitle =  element_text(family = font, hjust = 0.5),
    plot.caption = element_text(family = font, hjust = 0.5),
    legend.position = "top")
ggsave("./Charts/13_Chloropleth.png", dpi=300, height=7, width = 6, units="in", bg="beige")
                                  
        


