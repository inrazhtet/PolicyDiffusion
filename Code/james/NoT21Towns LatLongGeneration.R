require(dplyr)
library(ggmap)
library(rio)

#To get a list of the nonT21 towns, we antijoin the full list of towns to the T21 towns.
MA_Lon_Lat <- import("../../Data/MA21_lonlat.csv")
ALLMA = read.csv("./Data/CountyTownMA.csv")
ALLMA$CityTown = paste(ALLMA$Name, "Massachusetts", sep=" , ")

NoT21Towns = anti_join(ALLMA, MA_Lon_Lat)[,"CityTown"]

#Using Zarni's code to append the latitudes and longitudes
NoT21Towns = data.frame(NoT21Towns)
NoT21Towns_tmp<- apply(NoT21Towns,2, geocode)
NoT21Towns_tmp <- data.frame(NoT21Towns_tmp)
colnames(NoT21Towns_tmp) <- c("lon", "lat")
View(NoT21Towns_tmp)
View(NoT21Towns)

NoT21Towns_lonlat <- cbind(NoT21Towns, NoT21Towns_tmp$lon, NoT21Towns_tmp$lat)
colnames(NoT21Towns_lonlat) <- c("CityTown","lon", "lat")
View(NoT21Towns_lonlat)
write.csv(NoT21Towns_lonlat,"./Data/NoT21Towns_lonlat.csv")