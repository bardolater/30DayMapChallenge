### 30DayMapChallenge - Retro Map

library(sf)
library(tidyverse)
library(urbnmapr)
library(here)
library(ggtext)
library(showtext)
library(cowplot)
showtext_opts(dpi = 300)
showtext_auto(enable = TRUE)

font_add_google("Karma")

font1 <- "Karma"
names_1980 <- readxl::read_excel(here("data/babynames_1980.xlsx"))
names_girls <- names_1980 |> filter(Gender=="Girl") |> rename(GirlName = Name ) |> select(-Gender)
names_boys <- names_1980 |> filter(Gender=="Boy") |> rename(BoyName = Name ) |> select(-Gender)

states_sf <- get_urbn_map("states", sf = TRUE)
states_sf <- states_sf |> rename(State = state_name)
states_sf <- inner_join(states_sf, names_boys)
states_sf <- inner_join(states_sf, names_girls)
p1 <- states_sf %>%
  ggplot(aes(fill=GirlName)) +
  geom_sf() +
  theme_void() +
  labs(title = "",
       ) +
  theme(plot.title = element_text(family = font1),
        legend.title = element_blank(),
        legend.text = element_text(family=font1, size = 7),
        plot.caption = element_text(family=font1, size=5),
        legend.)
p2<- states_sf %>%
  ggplot(aes(fill=BoyName)) +
  geom_sf() +
  theme_void() +
  labs(title = "",
       caption = "#30DayMapChallenge | Map by @DataAngler@vis.social") +
  theme(plot.title = element_text(family = font1),
        legend.title = element_blank(),
        legend.text = element_text(family=font1, size = 7),
        plot.caption = element_text(family=font1, size=5))
title <- ggdraw() +
  draw_label("Most Popular Baby Names in 1980",
             fontfamily = font1, size = 12,
             x = 0, hjust = 0)

plots <- plot_grid(p1, p2,  align='v',  ncol = 1, labels = c("Girls", "Boys"), label_size = 8, label_fontfamily = font1 )

finalplot <- plot_grid(title, plots, align='v',  ncol = 1, rel_heights = c(0.1, 0.4, .4)) +
  theme(plot.background = element_rect(fill = "grey92", colour = NA))
file1 <- tempfile("file1",tmpdir = here(), fileext = ".png")
save_plot(file1, finalplot)
