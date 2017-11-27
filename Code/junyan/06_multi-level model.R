library(readxl)
library(data.table)
library(lubridate) #Date Time Object
library(ggplot2)
library(stringr) #Regular expression string splitting
library(rio)
library(MASS)
library(tigris)
library(sp)
library(broom)
library(dplyr)
library(rgdal)
library(stargazer)
library(stats) #Principal Component Package
library(lme4)
library(lmerTest)

T21External <- import("~/Documents/NYU/Fall 2017/Stats Consulting/master.csv")
View(T21External)

T21ExtSub <- T21External[T21External$Event != 2, ]
T21ExtSub <- T21ExtSub[-1]
T21ExtSub <- subset(T21ExtSub, Year > 2010)
T21ExtSub <- subset(T21ExtSub, Year < 2018)
View(T21ExtSub)

write.csv(T21ExtSub, "~/Documents/NYU/Fall 2017/Stats Consulting/T21ExtSub.csv")
View(T21ExtSub)


AllT21ContigencyRatios <- rio::import("~/Documents/PolicyDiffusion/Data/borderratios_updated.csv")
#View(AllT21ContingencyRatios)
#nrow(AllT21ContingencyRatios)
AllT21ContigencyRatios <- AllT21ContigencyRatios[-1]
AllT21ContigencyRatios$ratio <- as.numeric(AllT21ContigencyRatios$ratio)





nrow(master)
nrow(AllT21ContigencyRatios)
#names(AllT21ContingencyRatios)

master$Name.x <- tolower(master$Name.x)
#master$Name.x
#match(unique(master$Name.x), unique(AllT21ContingencyRatios$TownName))
#match(unique(master$Year), unique(AllT21ContingencyRatios$year))

T21_Contigency_Master <- master %>% left_join(AllT21ContigencyRatios, by = c("Name.x" = "TownName", "Year" = "year")) 
#View(T21_Contingency_Master)



T21_Contigency_Master <- T21_Contigency_Master[T21_Contigency_Master$Event !=2,]
T21_Contigency_Master$Population <- as.numeric(T21_Contigency_Master$Population)
#sort(names(T21_Contingency_Master))
#T21_Contingency_Master$ratio
T21_Contigency_Master$ratio <- as.numeric(T21_Contigency_Master$ratio)


#unconditional mean model
m0<-glmer(Event~(1|Year/County), family= binomial, data = T21_Contigency_Master)
summ0<- summary(m0)
#report ICC
print("ICC of Year")
print(summ0$varcor$Year[1]/(summ0$varcor$Year[1]+ summ0$varcor$`County:Year`[1]+(summ0$sigma)^2))

print("ICC of county")
print(summ0$varcor$`County:Year`[1]/(summ0$varcor$Year[1]+summ0$varcor$`County:Year`[1]+(summ0$sigma)^2))

M1<- glmer(Event~ratio+PercentSmokers+(PercentSmokers|County)+(1|Year),family= binomial, data = T21_Contigency_Master)
summ1<-summary(M1)
#report ICC
print("ICC of Year")
print(summ1$varcor$Year[1]/(summ1$varcor$Year[1]+ summ1$varcor$County[1]+(summ1$sigma)^2))

print("ICC of county")
print(summ1$varcor$County[1]/(summ1$varcor$Year[1]+summ1$varcor$County[1]+(summ1$sigma)^2))




