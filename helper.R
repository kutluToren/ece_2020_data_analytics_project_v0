library(dplyr)
library(stringr)
library(ggplot2)
library(data.table)
library(leaflet)


create_leaflet<-function(city_name,data_date){
  
  old_dir <- getwd()
  setwd(paste(old_dir,"data",sep = "/"))

  #filter the necessary values
  df <- 
    subset(as.data.frame(read.csv(paste( city_name, data_date,"listings.csv",sep = "_")))
           ,select = c("neighbourhood_cleansed"
                       ,"price"
                       ,"latitude"
                       ,"longitude"))


  markers <- subset(df,select = c("latitude","longitude"))

  #return to old directory
  setwd(old_dir)
  rm(old_dir)
  
  return(
    markers%>%
      leaflet() %>%
      addTiles()%>%
      addMarkers(clusterOptions = markerClusterOptions()))
}



############################################

