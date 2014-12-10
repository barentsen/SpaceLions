library(rgdal)
library(dplyr)

### convert camera utm arc 1960 to lat long coordinates
consensus <- read.csv("../CitizenScienceChapter/Data/consensus_data.csv")

SP <- SpatialPoints(cbind(consensus$LocationX, consensus$LocationY), proj4string=CRS("+init=epsg:21036"))
SP <- SpatialPointsDataFrame(SP,data=consensus)
dat <- spTransform(SP, CRS("+proj=longlat"))
str(dat@coords)

head(dat)
consensus <- mutate(consensus, Lat=dat@coords[, 1], Long=dat@coords[, 2])
imageID <- read.csv("../CitizenScienceChapter/Data/image_ids.csv")
head(imageID)
imageID$url = paste("http://static.zooniverse.org/www.snapshotserengeti.org/subjects/standard/", imageID$ImageID, "_0.JPG", sep = "")

## pull in the count at a captureevent/speciesID level
d <- select(consensus, c(CaptureEventID, DateTime, SiteID, Lat, Long, Species, Count)) %>% 
     left_join(x = ., y = imageID, by = c("CaptureEventID")) 
