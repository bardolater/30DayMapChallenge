### #030DayMapChallenge Vintage Map

library(sysfonts)
library(showtext)
library(scales)
showtext_auto(enable = TRUE)
font_add_google("Eagle Lake")
font <- "Eagle Lake"
data <- readxl::read_xlsx("2024/Data/OldCensus.xlsx")

basemap <- usmap::us_map()

mymap <- left_join(basemap, data)

ggplot()+
  geom_sf(data=mymap, aes(fill=Population_2010))+
  theme_void()+
  scale_fill_gradientn(colours=rev(magma(8)),
                       name=" ",
                       labels = scales::unit_format(unit = "M", scale = 1e-6)) +
  labs(title = "Population from 2010 Census",
       caption= "Map by @DataAngler@vis.social | #30DayMapChallenge") +
  theme(legend.position = "top",
        legend.text = element_text(family=font, size=6, margin = margin(r = 40, unit = "pt")),
        legend.box.spacing = margin(5,-10,-10,-10),
        legend.margin = margin(0, 0, 0, 0),
        legend.spacing.x = unit(.1, 'cm'),
        legend.key.size = unit(0.7, "cm"),
        plot.caption =   element_text(family=font),
        plot.title = element_text(size=rel(1.1), family = font))
ggsave("07_Vintage.png", height = 4, width = 6, bg="gray", dpi = 300)
