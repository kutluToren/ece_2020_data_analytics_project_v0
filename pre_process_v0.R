library(dplyr)
library(stringr)
library(ggplot2)
library(data.table)


#This function will return the cleaned listing data
clean_listing <- function(listings_url,calender_url,city,data_date){
  listings <- read.csv(textConnection(readLines(gzcon(url(listings_url)))))
  calender <- read.csv(textConnection(readLines(gzcon(url(calender_url)))))
  
  
  listings$city <- city
  listings$data_date <- data_date
  
  columns_listings <- c("city", "data_date", "id", "neighbourhood_cleansed", 
                        "latitude", "longitude", 
                        "property_type", "room_type", "accommodates", "bedrooms", 
                        "beds", "price", "minimum_nights",  "maximum_nights")
  
  listings <- listings %>% 
    select(columns_listings) %>% 
    arrange(id)
  
  
  # Cleaning calendar dataframe
  
  ## arrange by id and date
  calender <- calender %>% 
    arrange(listing_id, date)
  
  ## add day number (starting first day)
  calender <- calender %>%
    group_by(listing_id) %>%
    mutate(day_nb = row_number()) %>%
    ungroup()
  
  ## change available column to binary
  calender <- calender %>%
    mutate(available = ifelse(available=="t", 1, 0))
  
  ## clean price column and transform to numeric
  calender <- calender %>%
    mutate(price = str_replace(price, "\\$", ""),
           adjusted_price = str_replace(adjusted_price, "\\$", ""))
  calender <- calender %>%
    mutate(price = str_replace(price, ",", ""),
           adjusted_price = str_replace(adjusted_price, ",", ""))
  calender <- calender %>%
    mutate(price = as.numeric(price),
           adjusted_price = as.numeric(adjusted_price))
  
  ## calculate estimated revenue for upcoming day
  calender <- calender %>%
    mutate(revenue = price*(1-available))
  
  ## calculate availability, price, revenue for next 30, 60 days ... for each listing_id
  calender <- calender %>%
    group_by(listing_id) %>%
    summarise(availability_30 = sum(available[day_nb<=30], na.rm = TRUE),
              #availability_60 = sum(available[day_nb<=60], na.rm = TRUE),
              #availability_90 = sum(available[day_nb<=90], na.rm = TRUE),
              #availability_365 = sum(available[day_nb<=365], na.rm = TRUE),
              price_30 = mean(price[day_nb<=30 & available==0], na.rm = TRUE),
              #price_60 = mean(price[day_nb<=60 & available==0], na.rm = TRUE),
              #price_90 = mean(price[day_nb<=90 & available==0], na.rm = TRUE),
              #price_365 = mean(price[day_nb<=365 & available==0], na.rm = TRUE),
              revenue_30 = sum(revenue[day_nb<=30], na.rm = TRUE),
              #revenue_60 = sum(revenue[day_nb<=60], na.rm = TRUE),
              #revenue_90 = sum(revenue[day_nb<=90], na.rm = TRUE),
              #revenue_365 = sum(revenue[day_nb<=365], na.rm = TRUE)           
    )
  
  listings_cleaned <- listings %>% left_join(calender, by = c("id" = "listing_id"))
  
  #dir.create(file.path("data_cleansed", city, data_date), recursive = TRUE)
  #setwd(file.path("data_cleansed", city, data_date))
  
  write.csv(listings_cleaned, paste( city, data_date,"listings.csv",sep = "_"))
  
  #print(paste("saving data into ", file.path("data_cleansd", city, data_date, "listings.csv")))
  
  #setwd(paste(old_dir,"data",sep = "/"))
  

  
  
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

selected_cities <- c("amsterdam","dublin") #Selected without any reason

#Get data of last 3 data for above 3 cities from 3 different country
for (c1 in selected_cities){
  tmp<- link_data %>% filter(city==c1) %>% slice(1:3)
  for(c2 in 1:3){
    tmp2 <- clean_listing(tmp$listings_url[c2],tmp$calendar_url[c2],c1,tmp$data_date[c2])
    print("dim(tmp2)")
  }
}

#kt <- clean_listing(tmp$listings_url[1],tmp$calendar_url[1],c1,tmp$data_date[1])


# Restoring old working directory, deleting meta variables
setwd(old_dir)
#rm(old_dir,link_data,selected_cities)



