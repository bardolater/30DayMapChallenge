### Day 6 of #30DayMapChallenge: Raster Map

library(raster)

newfile <- tempfile() 
download.file("https://msc.fema.gov/portal/downloadProduct?productTypeID=FLOOD_RISK_PRODUCT&productSubTypeID=FLOOD_RISK_DB&productID=FRD_10001C_Coastal_GeoTIFFS", newfile)
localtif <- raster::raster(unzip(newfile, "10001C_Coastal_CstDpth01pct.tif"))
unlink(loadzip)

elmat <- rast(localtif)

  plot(elmat,breaks = seq(from=5, to=30, by=5), 
                col = (terrain.colors(6)),
                 main="Raster Map of Coastal Depth of Frederica, DE")
  
