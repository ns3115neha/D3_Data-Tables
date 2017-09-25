library(shiny)
library(DT)
library(dplyr)
library(lubridate)
library(gridExtra)

###############################          Feed Data & Data Manipulation   ########################
#################################################################################################

setwd("C:/Users/neha.sharma/Desktop/Digital_Path/data")
data1 <- read.csv("panelist_forshiny.csv",stringsAsFactors = FALSE)



##Filter out needed coloumns removing the Taxonomies by Hub 
#data1 <- data1[,c("Panelist","Start_DateTime","Capped_Milliseconds","Device_Type","Web_UsageURI")]


## Process the data to remove rows of data containing survey /panel /research /consumer keywords /ktrmr /ipsos

survey1 <- data1 %>% filter(grepl("survey", Web_UsageURI))
survey2 <- data1 %>% filter(grepl("research", Web_UsageURI))
survey3 <- data1 %>% filter(grepl("panel", Web_UsageURI))
survey4 <- data1 %>% filter(grepl("consumer", Web_UsageURI))
survey7 <- data1 %>% filter(grepl("notifications", Web_UsageURI))
survey8 <- data1 %>% filter(grepl("porn", Web_UsageURI))
survey9 <- data1 %>% filter(grepl("outlook.live", Web_UsageURI))
survey10 <- data1 %>% filter(grepl("go.insites", Web_UsageURI))
survey12 <- data1 %>% filter(grepl("^[[:space:]]*$", Web_UsageURI))  ##Removing blank lines
survey13 <- data1 %>% filter(grepl("cint", Web_UsageURI))
survey14 <- data1 %>% filter(grepl("rewards", Web_UsageURI))
survey15 <- data1 %>% filter(grepl("samplicio", Web_UsageURI))

tobedeleted <- rbind(survey1,survey2,survey3,survey4,survey5,survey6,survey7,survey8,survey9,survey10,survey11,survey12,survey13,survey14,survey15)
cleandata <- data1 %>% anti_join(tobedeleted)


#Adding addtional date and time columns
cleandata$datetime <- lubridate::ymd_hms(cleandata$Start_DateTime)
cleandata$Local_Date <- as.Date(cleandata$datetime)
cleandata$Local_Time <- format(cleandata$datetime,"%H:%M:%S")

cleandata  <- cleandata[,c("Panelist","Local_Date","Local_Time","Capped_Milliseconds","Device_Type","Web_UsageURI")]

#Converting capped duration  into seconds 
cleandata$Capped_Duration_Seconds <- cleandata$Capped_Milliseconds/1000

cleandata  <- cleandata[,c("Panelist","Local_Date","Local_Time","Capped_Duration_Seconds","Device_Type","Web_UsageURI")]

##ordering the data to represent click stream 

cleandata <- cleandata[ order(cleandata$Panelist, cleandata$Local_Date,cleandata$Local_Time) , ]

##Getting rid of duplicates row-wise

cleandata <- cleandata[!duplicated(cleandata[,c('Panelist','Local_Date','Capped_Duration_Seconds','Web_UsageURI')]),]

#using only first 5000 rows for testing 
cleandata <- cleandata[1:5000,]

## Add a new comment section to check edit filter function 

cleandata[,"comments"] <- NA


