## Cargamos las librerias 

library(ralger)
library(rvest)
library(stringr)
library(readr)
library(gdata)
library(openxlsx)
library(lubridate)
library(tidyr)
library(dplyr)
library(tools)
library(webshot)

remove(list=ls())
Fecha=format(Sys.Date(), "%d-%m-%Y")
Mes<-months.Date(today())
Mes<-unlist(lapply(Mes, FUN=toTitleCase))
Fotos=paste0("C:/Users/David/Desktop/FEN/Decimo Semestre/Práctica/GIT/Generados/",Mes,"/Webshot")
dir=paste0("C:/Users/David/Desktop/FEN/Decimo Semestre/Práctica/GIT/Generados/")
Principal=paste0(dir,Mes,"/",Fecha)
setwd(Principal)

link<-"https://www.gafaseclipse.cl/tienda/?per_page=36"
link2<-"https://www.gafaseclipse.cl"
links1<-unique(weblink_scrap(link))
links1<-links1[str_detect(links1,"/product/")]

tablaPreciosF<-matrix(NA,0,8)

for (i in 1:3) {
  tryCatch({
    linkProd<-paste(links1[i])
    NombreProducto<-unique(scrap(linkProd,".entry-title"))
   
    PrecioOferta<-unique(str_trim(scrap(linkProd,".woocommerce-product-details__short-description li~ li+ li")))
    PrecioNormal<-unique(str_trim(scrap(linkProd,".woocommerce-product-details__short-description li:nth-child(2)")))
    if ((length(PrecioOferta))==0) {
      PrecioOferta<-PrecioNormal
      PrecioNormal<-unique(str_trim(scrap(linkProd,".woocommerce-product-details__short-description li:nth-child(1)")))}
    PrecioPackNormal<-unique(str_trim(scrap(linkProd,".summary-inner del bdi")))
    PrecioPackOferta<-unique(str_trim(scrap(linkProd,".summary-inner ins bdi")))
    
    
    setwd(Fotos)
    webshot(linkProd,paste0("Gafaseclipse","-",NombreProducto,".pdf"))
    setwd(Principal)
   
    tablaPrecios<-cbind(linkProd,NombreProducto,PrecioNormal,PrecioOferta,PrecioPackNormal,PrecioPackOferta,Fecha,timestamp())
    tablaPreciosF<-rbind(tablaPreciosF,tablaPrecios)
    print(i)
  }, error=function(e){})
}
setwd(dir)
write.xlsx(tablaPreciosF,paste0("Nike_DR ",Fecha," ",hour(now()),"-",minute(now()),".xlsx"))
