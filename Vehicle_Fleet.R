# Load in Packages

library(RODBC)
library(tidyverse)
library(lubridate)

Vehicle_DB <- odbcConnectAccess2007('VehicleFleetStatus.accdb')

tbl <- sqlTables(Vehicle_DB, tableType = 'TABLE' )
tbl <- tbl$TABLE_NAME
Fleet_Status <- sqlFetch(Vehicle_DB, tbl)

#identify data type for each column 
sapply(Fleet_Status, class)

#Vehicle and Status are characters and must be converted to factors
Fleet_Status$Vehicle <- as.factor(Fleet_Status$Vehicle)
Fleet_Status$Status <- as.factor(Fleet_Status$Status)
Fleet_Status$`Start Date` <- as.Date(Fleet_Status$`Start Date`)
Fleet_Status$`End Date` <- as.Date(Fleet_Status$`End Date`)

#Identify how many of each vehicle type/factor
table(Fleet_Status$Vehicle)

#Create data table for dodge
dodge_tbl <- filter(Fleet_Status, Vehicle == 'Dodge')

#Arrange by color and sort by Start Date
dodge_tbl <- dodge_tbl %>%
  arrange(Status, `Start Date`)

#Create data table for each ticket status color
dodge_tbl_green <- filter(dodge_tbl, Status == 'Green')
dodge_tbl_red <- filter(dodge_tbl, Status == 'Red')
dodge_tbl_yel <- filter(dodge_tbl, Status == 'Yellow')





#Plot 
ggplot(data = dodge_tbl) +
  geom_tile(aes())









