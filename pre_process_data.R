library(dplyr)
library(stringr)
library(ggplot2)
library(data.table)



#City selection to download last 3 available data
selected_cities <- c("madrid","munich","berlin","amsterdam") #Selected without any reason



#This function will return the cleaned listing data
clean_listing <- function(listings_url,calender_url,city,data_date){
  listings <- read.csv(textConnection(readLines(gzcon(url(listings_url)))))
  #calender <- read.csv(textConnection(readLines(gzcon(url(calender_url)))))
  
  
  #add the date and city as a column to merge
  listings$city <- city
  listings$data_date <- data_date
  
  #list of columns to use in analysis
  columns_listings <- c("city", "data_date", "id", "neighbourhood_cleansed", 
                        "latitude", "longitude", 
                        "property_type", "room_type", "accommodates", "bedrooms", 
                        "beds", "price", "availability_30", "minimum_nights",  "maximum_nights")
  
  #drop the not necessary columns
  listings <- listings %>% 
    select(columns_listings) %>% 
    arrange(id)
  
  
  #Check latitude and longitude numeric, convert if not
  
  if(!is.numeric(listings$latitude)){
    listings <- listings %>% mutate(latitude = as.numeric(latitude))
  }
  if(!is.numeric(listings$longitude)){
    listings <- listings %>% mutate(longitude = as.numeric(longitude))
  }
  
  #convert price in dollars in non numerical values
  listings <- listings %>% mutate(listings , price = as.numeric(str_replace(price,"\\$","")))
  #convert availability_30 into numerical values
  listings <- listings %>% mutate(availability_30 = as.numeric(availability_30))
  
  # embed 0 into na values in price and availability_30
  listings$price[is.na(listings$price)] <- 0
  listings$availability_30[is.na(listings$availability_30)] <- 0
  
  #mutate the estimated revenue by average price and availability
  listings_cleaned <-listings %>% mutate(estimated_revenue_30 = (availability_30*price))
  
  #write listings for each data into a csv file
  write.csv(listings_cleaned, paste( city, data_date,"listings.csv",sep = "_"))
  
  print(paste("saving data into ",city,"_",data_date,"_","listings.csv"))
  
  
  return("success")
}


# Check if there is a data folder to store the cleaned data, create if does not exist
# Check if "all_data.csv" available for download links
old_dir <- getwd()
if(file.exists(paste(old_dir,"data","all_data.csv",sep = "/"))){
  
  setwd(paste(old_dir,"data",sep = "/"))
  print("data folder already exists, setting working dir in ~/data")
  
  link_data <- read.csv(file.path("all_data.csv"))
  print("links successfully loaded")
  
}else if(file.exists(paste(old_dir,"all_data.csv",sep = "/"))){
  
  link_data <- read.csv(file.path("all_data.csv"))
  print("links successfully loaded")
  
  if(dir.exists(paste(old_dir,"data",sep = "/"))){
    setwd(paste(old_dir,"data",sep = "/"))
    print("setting working dir in ~/data")
  }else{
    dir.create(paste(old_dir,"data",sep = "/"))
    print("creating ~/data in your folder")
    
    setwd(paste(old_dir,"data",sep = "/"))
    print("setting working dir in ~/data")
  }
}else{
  print(paste("Your Working Directiory is: ",old_dir))
  print("Cannot find /data/all_data.csv, please provide all_data.csv in your wd")
}


# Main Part of the Code

#data to hold city and date for csv files created
cities_dates_saved<-{}

#Get data of last 3 data for above 3 cities from 3 different country

for (c1 in selected_cities){
  tmp<- link_data %>% filter(city==c1) %>% slice(1:3)
  cities_dates_saved<-cities_dates_saved %>% rbind(select(tmp,c("city","data_date")))
  
  for(c2 in 1:3){
    clean_listing(tmp$listings_url[c2],tmp$calendar_url[c2],c1,tmp$data_date[c2])
  }
}

#save map variable into data folder
write.csv(cities_dates_saved, "cities_dates_saved.csv")


# Restoring old working directory, deleting meta variables
setwd(old_dir)
rm(old_dir,link_data,selected_cities,listings,c1,c2,clean_listing,tmps)



