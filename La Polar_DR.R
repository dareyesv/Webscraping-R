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

link<-"https://www.lapolar.cl/"
link2<-"https://www.lapolar.cl"
links<-unique(weblink_scrap(link))
links<-sort(links)
links1<-links[c(1:(min(which(str_detect(links,"http")))-1))]
links3<-links[str_detect(links,"http")]
link1<-paste(link2,links1,sep = "")

linktotales<-c(link1,links3)
#For
linkProdF<-matrix(NA,0,1)
for (i in 1:length(linktotales)) {
  tryCatch({
  linkPag<-paste(linktotales[i])
  linkProd<-unique(weblink_scrap(linkPag,".html"))
  linkProd<-as.data.frame(linkProd)
  linkProdF<-rbind(linkProdF,linkProd)
  print(i)
  }, error=function(e){})
}

linksPF1<-linkProdF
linksPF1<-linksPF1[!duplicated(linksPF1), ]
linksPF1<-linksPF1[!str_detect(linksPF1,"https")]



linksPF1<-sort(linksPF1)
linksPF1<-as.data.frame(linksPF1)

write.xlsx(linksPF1,"lapolar.xlsx")

links2<-read.xlsx("lapolar.xlsx")

tablaPreciosF<-matrix(NA,0,10)
for (i in 9816:nrow(links2)) {
  tryCatch({
    linkProd<-paste(link2,links2$linksPF1[i],sep = "")
    NombreProducto<-unique(scrap(linkProd,".product-name"))
    Categoria<-unique(scrap(linkProd,".lp-font--barlow+ .lp-font--barlow span"))
    Marca<-unique(scrap(linkProd,".lp-font--uppercase.lp-font--barlow-medium span"))
    SKU<-str_trim(unique(scrap(linkProd,".sku-code-value")))
    PrecioMP<-unique(str_trim(scrap(linkProd,".prices-actions .ms-flex .price-value")))
    PrecioOferta<-unique(str_trim(scrap(linkProd,".prices-actions .js-internet-price .price-value")))
    if ((length(PrecioMP))!=0) {
      PrecioOferta<-"0"}
    PrecioNormal<-unique(str_trim(scrap(linkProd,".prices-actions .js-normal-price .price-value")))
    if ((length(PrecioNormal))==0) {
      PrecioNormal<-"0"}
    
    tablaPrecios<-cbind(linkProd,NombreProducto,Categoria,Marca,SKU,PrecioNormal,PrecioOferta,PrecioMP,Fecha,timestamp())
    tablaPreciosF<-rbind(tablaPreciosF,tablaPrecios)
    print(i)
  }, error=function(e){})
}
setwd(dir)
write.xlsx(tablaPreciosF,paste0("La Polar_DR ",Fecha," ",hour(now()),"-",minute(now()),".xlsx"))