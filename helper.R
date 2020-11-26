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


############################################## Plotting Functions for analysis 1

analysis1<-function(city_name1, city_name2, data_date1, data_date2,feature_select,plot_select_a1){
  
  setwd(paste(old_dir,"data",sep = "/"))
  
  cities_df <- rbind(
    as.data.frame(read.csv(paste(city_name1, find_data_dates(city_name1,data_date1),"listings.csv",sep = "_"))),
    as.data.frame(read.csv(paste(city_name2, find_data_dates(city_name2,data_date2),"listings.csv",sep = "_"))))
  
  #head(cities_df)
  
  if(plot_select_a1=="box"){
    return(
      ggplot(cities_df,aes_string(x="city",y=feature_select, fill="city"))+
        geom_boxplot() +
        ggtitle(paste(feature_select,"over Cities (Average value in red)",sep = " " ))+
        xlab("Name of the Cities")+ylab(paste(feature_select))+
        stat_summary(fun=mean, geom="crossbar",colour="red") + 
        stat_summary(fun=mean, colour="red", geom="text", show.legend  = FALSE, vjust=-0.7,      
                     aes( label=round(..y.., digits=4)))+
        #theme(axis.text.x=element_text(angle = -90, hjust =1,size = 7))+
        scale_fill_brewer(palette="BuPu")
    )
  }else if(plot_select_a1=="jitter"){
    return(  
              ggplot(cities_df,aes_string(x="city",y=feature_select, fill="city"))+
               geom_jitter(alpha = 0.1, shape = 16)+
               theme(legend.position="none")+
               ggtitle(paste(feature_select,"over Cities (Average value in red)",sep = " " ))+
               xlab("Name of the Cities")+ylab(paste(feature_select))+
               #theme(axis.text.x=element_text(angle = -90, hjust =1,size = 7))+
               stat_summary(fun=mean, geom="pointrange",colour="red") + 
               stat_summary(fun=mean, colour="red", geom="text", 
                            show.legend  = FALSE, vjust=-0.7, aes(label=round(..y.., digits=4))))
    
  }else{
    ggplot(subset(cities_df,estimated_revenue_30<3000,c(city,estimated_revenue_30,room_type)), 
           aes(x=room_type , y=estimated_revenue_30 , fill=as.factor(room_type)))+ 
      geom_bar(stat="identity")+facet_grid(.~city)+
      ggtitle("Revenue estimation over # of Rooms for  cities")+
      xlab("Room Type")+ylab("Revenue over 30 Days")+ labs(fill="Room Type")+
      theme(axis.text.x=element_text(angle = -90, hjust =1,size = 7))
    
  }
}


############################################## Plotting Functions for analysis 2 deep

analysis2<-function(city_name, data_date, feature_select){
  
  setwd(paste(old_dir,"data",sep = "/"))
  
  city_df <- as.data.frame(read.csv(
                          paste(city_name, 
                          find_data_dates(city_name,data_date),"listings.csv",sep = "_")))
  
  if(feature_select=="room_type"){
    return(ggplot(subset(city_df,city==city_name,room_type))+
            geom_bar(mapping = aes(x=room_type,fill=as.factor(room_type)))+
            ggtitle( paste("Distribution of room types for",city_name))+
             xlab("Room Type")+ labs(fill="Room Type"))
    
  }else if(feature_select=="price"){
    ggplot(subset(city_df,city==city_name ,c(room_type,price)), 
           aes(x=room_type , y=price , fill=as.factor(room_type)))+ 
      geom_bar(stat="identity")+
      ggtitle(paste("Price over Room type for ",city_name))+
      xlab("Room Type")+ylab("Price")+ labs(fill="Room Type")+
      theme(axis.text.x=element_text(angle = -90, hjust =1,size = 7))
    
  }else if(feature_select=="bedrooms"){
    ggplot(subset(city_df,city==city_name ,c(price,bedrooms)), 
           aes(x=bedrooms , y=price , fill=as.factor(bedrooms)))+ 
      geom_bar(stat="identity")+
      ggtitle(paste("Price over # of Room type for ",city_name))+
      xlab("Room number")+ylab("Price")+ labs(fill="Room Type")+
      theme(axis.text.x=element_text(angle = -90, hjust =1,size = 7))
    
  }else if(feature_select=="availability_30"){
    ggplot(subset(city_df,city==city_name,c(room_type,availability_30)), 
           aes(x=room_type , y=availability_30 , fill=as.factor(room_type)))+ 
      geom_boxplot()+
      ggtitle(paste("Availability over Room Types ",city_name))+
      xlab("Room Type")+ylab("Availability over 30 Days")+ labs(fill="Room Type")+
      stat_summary(fun=mean, geom="crossbar",colour="red") + 
      stat_summary(fun=mean, colour="red", geom="text", show.legend  = FALSE, vjust=-0.7,      aes( label=round(..y.., digits=4)))+
      scale_fill_brewer(palette="BuPu")
    
  }else{
    
  }
  
  

}



