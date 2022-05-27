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

remove(list=ls())
Fecha=format(Sys.Date(), "%d-%m-%Y")
Mes<-months.Date(today())
Mes<-unlist(lapply(Mes, FUN=toTitleCase))
dir=paste0("C:/Users/David/Desktop/FEN/Decimo Semestre/Práctica/GIT/Generados/",Mes,"/",Fecha)
dir2=paste0(dir,"/Links")
setwd(dir2)

link<-"https://www.nike.com/cl/"
link2<-"https://www.nike.com/cl"
links1<-unique(weblink_scrap(link))
links1<-links1[str_detect(links1,"/w/")]

#For
linkProdF<-matrix(NA,0,1)
for (i in 1:length(links1)) {
  tryCatch({
    linkPag<-paste0(links1[i])
    linkProd<-unique(weblink_scrap(linkPag,"/t/"))
    linkProd<-as.data.frame(linkProd)
    linkProdF<-rbind(linkProdF,linkProd)
    print(i)
  }, error=function(e){})
}

linksPF1<-linkProdF
linksPF1<-linksPF1[!duplicated(linksPF1), ]

#For
linkProdF1<-matrix(NA,0,1)
for (i in 1:length(links1)) {
  tryCatch({
    linkPag<-paste0(links1[i])
    linkProd<-unique(weblink_scrap(linkPag,"/u/"))
    linkProd<-as.data.frame(linkProd)
    linkProdF1<-rbind(linkProdF1,linkProd)
    print(i)
  }, error=function(e){})
}

linksPF2<-linkProdF1
linksPF2<-linksPF2[!duplicated(linksPF2), ]

finales<-c(linksPF1,linksPF2)
finales<-as.data.frame(finales)

write.xlsx(finales,"nike.xlsx")

links2<-read.xlsx("nike.xlsx")
tablaPreciosF<-matrix(NA,0,9)

for (i in 1:nrow(links2)) {
  tryCatch({
    linkProd<-paste(links2$finales[i])
    NombreProducto<-unique(scrap(linkProd,"#pdp_product_title"))
    Categoria<-unique(scrap(linkProd,".css-1ppcdci"))
    Marca<-"nike"
    SKU<-unique(scrap(linkProd,".description-preview__style-color"))[1]
    precioOferta<-unique(str_trim(scrap(linkProd,".css-s56yt7")))[1]
    precioNormal<-unique(str_trim(scrap(linkProd,".is--current-price")))
   
    tablaPrecios<-cbind(linkProd,NombreProducto,Categoria,Marca,SKU,precioOferta,precioNormal,Fecha,timestamp())
    tablaPreciosF<-rbind(tablaPreciosF,tablaPrecios)
    print(i)
  }, error=function(e){})
}
setwd(dir)
write.xlsx(tablaPreciosF,paste0("Nike_DR ",Fecha," ",hour(now()),"-",minute(now()),".xlsx"))
