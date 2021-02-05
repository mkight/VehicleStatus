
# Load in Required Libraries
library(tidyverse)
library(RODBC)
library(lubridate)

# Call data from Microsoft Access file, verify working directory
getwd()
Vehicle_DB <- odbcConnectAccess2007('VehicleFleetStatus.accdb')

# Identify availabel tables in Access file and extract desired table using sqlFetch
tbl <- sqlTables(Vehicle_DB, tableType = 'TABLE' )
tbl <- tbl$TABLE_NAME
Fleet_Status <- sqlFetch(Vehicle_DB, tbl)

#identify data type for each column 
sapply(Fleet_Status, class)

#Vehicle and Status are characters and must be converted to factors
Fleet_Status$Vehicle <- as.factor(Fleet_Status$Vehicle)
Fleet_Status$Status <- as.factor(Fleet_Status$Status)

#Arrange data table by color in alphabetical order
Fleet_Status_sort <- Fleet_Status %>% arrange(Status)


#Convert start and end dates to date variable formats using lubridate package
Fleet_Status_sort$`Start Date` <- as.Date(Fleet_Status_sort$`Start Date`)
Fleet_Status_sort$`End Date` <- as.Date(Fleet_Status_sort$`End Date`)


#Identify how many of each vehicle type/factor
table(Fleet_Status_sort$Vehicle)
Fleet_Status_sort %>% count(Vehicle)

y = as.numeric(row.names(Fleet_Status_sort))
  
#Create plot template for functionally plotting each Vehicle Type
plot_template <- function(dataset, var){
  ggplot(dataset) +
  geom_rect(aes(NULL, NULL, xmin = `Start Date`, 
                xmax = `End Date`, 
                ymin = y-0.25,
                ymax = y+0.25,
                fill = "Status",
                colour = "black")) +
  scale_fill_manual(values=c("Green" = "dark green", "Yellow" = "yellow", "Red"="red")) +
  labs(title = paste0("Vehicle: ", var))
}

test_plot <- Fleet_Status_sort %>%
  filter(Vehicle == "Dodge")

plot_template(test_plot, "Dodge")

Fleet_Status_AutoPlot <- Fleet_Status_sort %>%
  group_by(Vehicle) %>%
  nest() %>%
  mutate(plots = map2(.x = Vehicle,
                      .y = data,
                      ~make_plot(dataset = .y, var = .x)))

  



