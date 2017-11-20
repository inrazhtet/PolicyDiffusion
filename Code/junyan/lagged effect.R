dat<- read.csv("~/Documents/NYU/Fall 2017/Stats Consulting/MACTownHealth21_v6.csv")
View(dat)

#drop year 2005-2009
dat2<- dat[which(dat$Year>=2010 & dat$Year !=2018),]


#DUMMY COVARAIATES
dat2$year_dummy<- dat2$Year

dat3<- slide(dat2, Var="year_dummy", GroupVar="Name", slideBy=-2)


View(dat3)
write.csv(dat3, "~/Documents/NYU/Fall 2017/Stats Consulting/lagged.csv")

elec_data<- read_dta("~/Documents/NYU/Fall 2017/Stats Consulting/county_electoral_soceconom_data (2).dta")

ma<- elec_data[which(elec_data$state_abb=="MA"),]
#only 14 counties



View(ma)

#drop unnecessary columns
ma2<- ma[,c("fips_code","county_state_abb","county_name","state_abb","pop16","pop16_labor_civil_empl","pop16_labor_civil_unempl","pop16_labor_civil","median_household_income","mean_household_income","pop_total_2015", "male_2015","female_2015","white_male_2015","white_female_2015","black_male_2015","black_female_2015","hispanic_male_2015","hispanic_female_2015","educ_no_high_school_2000","votes_total_2012","votes_r_2012","votes_d_2012","prct_d_2012","prct_r_2012","votes_total_2016","prct_d_2016","prct_r_2016","votes_d_2016","votes_r_2016")]

#merge it with health dataset. These are time-invariant data
names(ma2)[3]<-"Name"
names(ma2)[1]<-"FIPS"
dat4<- left_join(dat3,ma2, by="FIPS")

dat4$tax<- 2.51
dat4$tax[dat4$Year>2013]<-3.51

#remove the NA due to lagged effect
master<- dat4[!is.na(dat4$`year_dummy-2`),]

write.csv(master,"~/Documents/NYU/Fall 2017/Stats Consulting/master.csv")



#load youth data
#youth <-import("~/Documents/NYU/Fall 2017/Stats Consulting/sadc_2015_state_a_m.dat", fill = TRUE)
#dat.names <- readLines("~/Documents/NYU/Fall 2017/Stats Consulting/sadc_2015_state_a_m.dat", n = 1)


#this is the one

#Current_C_use <- read_csv("~/Documents/NYU/Fall 2017/Stats Consulting/Current C_use.csv")

#names(Current_C_use)<- c("Grade","1993","1995","1997","1999","2001","2003","2005","2007","2009","2011","2013","2015")

#new<-reshape(Current_C_use, varying = NULL, timevar = c("1993","1995","1997","1999","2001","2003","2005","2007","2009","2011","2013","2015),idvar = "Grade", direction = "long")

