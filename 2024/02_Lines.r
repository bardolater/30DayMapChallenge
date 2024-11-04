#### #30DayMapChallenge Day 2: Lines
# There is an open data source that provides the shapefiles for 
# rail lines by province. From this link, you can get to the files:
# https://open.canada.ca/data/en/dataset/ac26807e-a1e8-49fa-87bf-451175a859b8/resource/e9aabb53-6145-4a98-b0f5-c10270e9aa58
library(tidyverse)
library(sf)
library(canadianmaps)
CN <- canadianmaps::PROV

AB_shape <- st_read("nrwn_rfn_ab_shp_en/NRWN_AB_2_0_TRACK.shp")
BC_shape <- st_read("nrwn_rfn_bc_shp_en/NRWN_BC_2_0_TRACK.shp")
MB_shape <- st_read("nrwn_rfn_mb_shp_en/NRWN_MB_2_0_TRACK.shp")
NB_shape <- st_read("nrwn_rfn_nb_shp_en/NRWN_NB_2_0_TRACK.shp")
NL_shape <- st_read("nrwn_rfn_nl_shp_en/NRWN_NL_1_0_TRACK.shp")
NS_shape <- st_read("nrwn_rfn_ns_shp_en/NRWN_NS_2_0_TRACK.shp")
NT_shape <- st_read("nrwn_rfn_nt_shp_en/NRWN_NT_1_0_TRACK.shp")
ON_shape <- st_read("nrwn_rfn_on_shp_en/NRWN_ON_2_0_TRACK.shp")
SK_shape <- st_read("nrwn_rfn_sk_shp_en/NRWN_SK_2_0_TRACK.shp")
YT_shape <- st_read("nrwn_rfn_yt_shp_en/NRWN_YT_1_0_TRACK.shp")
QC_shape <- st_read("nrwn_rfn_qc_shp_en/NRWN_QC_2_0_TRACK.shp")

  ggplot() +
    geom_sf(data=CN) +
    geom_sf(data=AB_shape, color="red") +
    geom_sf(data=BC_shape, color="red") +
    geom_sf(data=BC_shape, color="red") +
    geom_sf(data=MB_shape, color="red") +
    geom_sf(data=NB_shape, color="red") +
    geom_sf(data=NL_shape, color="red") +
    geom_sf(data=NS_shape, color="red") +
    geom_sf(data=NT_shape, color="red") +
    geom_sf(data=SK_shape, color="red") +
    geom_sf(data=ON_shape, color="red") +
    geom_sf(data=YT_shape, color="red") +
    geom_sf(data=QC_shape, color="red") +
    labs(title="Rail Lines in Canadian Provinces", caption = "Map by DataAngler@vis.social | #30DayMapChallenge 2024")+
    theme_wallis()
  ggsave("/Volumes/disk2s3/02_Lines.png", height=5, width=7, dpi=300, bg="beige")
