library(dplyr)
library(stringr)
library(ggplot2)
library(data.table)
library(leaflet)
library(htmltools)

old_dir <- getwd()

create_leaflet<-function(city_name,data_date){
  

  setwd(paste(old_dir,"data",sep = "/"))

  #filter the necessary values
  df <- 
    subset(as.data.frame(read.csv(paste( city_name, data_date,"listings.csv",sep = "_")))
           ,select = c("id"
                       ,"neighbourhood_cleansed"
                       ,"price"
                       ,"latitude"
                       ,"longitude"))


  markers <- subset(df,select = c("id","price","latitude","longitude"))
  

  #return to old directory
  #setwd(old_dir)
 
  
  return(
    markers%>%
      leaflet() %>% 
      #setView(mean(markers$longitude),mean(markers$latitude),zoom = 14)%>% #Very slow to react
      addTiles()%>%
      addMarkers(~longitude,~latitude,popup = ~htmlEscape(paste("ID is:", id,"Price is: $",price)),
                 clusterOptions = markerClusterOptions()))
}



############################################

find_data_dates <- function(city_name,ofset){

  setwd(paste(old_dir,"data",sep = "/"))
  
  lookup_city_date <- subset(read.csv("cities_dates_saved.csv"),
                             city==city_name,data_date)
                             
  #setwd(old_dir)
  #rm(old_dir)
  
  if(ofset=="1"){
        return(lookup_city_date$data_date[1])
  }else if(ofset=="2"){
        return(lookup_city_date$data_date[2])
  }else if(ofset=="3"){
        return(lookup_city_date$data_date[3])
  }else{
    return(lookup_city_date$data_date[1])
  }
 
  
}


##############################################


