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


############################################## Plotting Functions



analysis1<-function(city_name1, city_name2, data_date1, data_date2){
  
  setwd(paste(old_dir,"data",sep = "/"))
  
  cities_df <- rbind(
    as.data.frame(read.csv(paste(city_name1, find_data_dates(city_name1,data_date1),"listings.csv",sep = "_"))),
    as.data.frame(read.csv(paste(city_name2, find_data_dates(city_name2,data_date2),"listings.csv",sep = "_"))))
  
  #head(cities_df)
  
  return(  ggplot(cities_df,aes(x=city,y=availability_30, fill=city))+
          geom_jitter(alpha = 0.1, shape = 16)+
          theme(legend.position="none")+
           ggtitle("Availability over Cities (Average value in red)")+
          xlab("Name of the Cities")+ylab("Availability over 30 Days")+
          stat_summary(fun=mean, geom="pointrange",colour="red") + 
          stat_summary(fun=mean, colour="red", geom="text", 
                  show.legend  = FALSE, vjust=-0.7, aes(label=round(..y.., digits=4))))
}


