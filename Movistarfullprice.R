library(ralger)
library(rvest)
library(stringr)
library(readr)
library(gdata)
library(openxlsx)
library(lubridate)
library(tidyr)
library(dplyr)


remove(list=ls())
Fecha=format(Sys.Date(), "%d-%m")
Fecha1=format(Sys.Date(), "%d-%m-%Y")
dir=paste0("C:/Users/David/Desktop/FEN/Decimo Semestre/Práctica/GIT/Generados/",Fecha)
dir2=paste0(dir,"/Links")
setwd(dir2)


link<-"https://ww2.movistar.cl/cyber/equipos-liberados/celulares/"
link2<-"https:"
links1<-unique(weblink_scrap(link))
linksPF1<-sort(links1)

linkProd1<-linksPF1[str_detect(linksPF1,"fullprice")]


  
tablaPreciosF<-matrix(NA,0,6)

for (i in 1:length(linkProd1)) {
  tryCatch({
    url<-linkProd1[i]
    NombreProducto<-unique(scrap(url,"#nombre-producto"))
    PrecioOferta<-unique(str_trim(scrap(url,".color_precio_normal")))
    PrecioNormal<-unique(str_trim(scrap(url,".precio_normal .price")))
   
    tablaPrecios<-cbind(url,NombreProducto,PrecioNormal,PrecioOferta,Fecha1,timestamp())
    tablaPreciosF<-rbind(tablaPreciosF,tablaPrecios)
    print(i)
  }, error=function(e){})
}
setwd(dir)
write.xlsx(tablaPreciosF,paste0("Movistar",today(),"-",hour(now()),minute(now()),".xlsx"))  
  
   
  