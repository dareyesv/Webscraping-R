###Sodimac

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

link<-"https://www.sodimac.cl/sodimac-cl/"
link2<-"https://www.sodimac.cl"
links1<-unique(weblink_scrap(link))

linksPF1<-links1
linksPF1<-linksPF1[!duplicated(linksPF1), ]
linksPF1<-linksPF1[str_detect(linksPF1,"https://www.sodimac.cl/sodimac-cl/")]
linksPF1 <- na.omit(linksPF1)


linksPF3<-links1
linksPF3<-linksPF3[!duplicated(linksPF3), ]
linksPF3<-linksPF3[str_detect(linksPF3,"landing")]
linksPF3<-linksPF3[!str_detect(linksPF3,"https")]
linksPF3 <- na.omit(linksPF3)
linksPF3<-paste(link2,linksPF3,sep = "")
names(linksPF3)=c("linkProd")


linksPF2<-links1
linksPF2<-linksPF2[!duplicated(linksPF2), ]
linksPF2<-linksPF2[str_detect(linksPF2,"category")]
linksPF2<-linksPF2[!str_detect(linksPF2,"https")]
linksPF2 <- na.omit(linksPF2)
linksPF2<-paste(link2,linksPF2,sep = "")


linksfinales<-c(linksPF2,linksPF1,linksPF3)
write.xlsx(linksfinales,"linkssodimaccategoria.xlsx")

#For
linkProdF<-matrix(NA,0,1)
for (i in 1:length(linksfinales)) {
  tryCatch({
    linkPag<-paste0(linksfinales[i])
    linkProd<-unique(weblink_scrap(linkPag,"product/"))
    linkProd<-as.data.frame(linkProd)
    linkProdF<-rbind(linkProdF,linkProd)
    print(i)
  }, error=function(e){})
}

finales<-linkProdF
finales<-finales[!duplicated(finales), ]
finales<-as.data.frame(finales)
write.xlsx(finales,"linkssodimac.xlsx")
links2<-read.xlsx("linkssodimac.xlsx")



tablaPreciosF<-matrix(NA,0,9)
for (i in 1:nrow(links2)) {
  tryCatch({
    url<-paste(link2,links2$finales[i],sep = "")
    NombreProducto<-unique(scrap(url,".jsx-4129468047.product-title"))
    Categoria<-unique(scrap(url,".bread-crumb+ .bread-crumb-wrapper .link-disabled .jsx-3306415055"))
    Marca<-unique(scrap(url,".jsx-4129468047.product-brand"))
    SKU<-str_replace(str_trim(unique(scrap(url,".product-cod"))), "Código","")
    PrecioNormal<-unique(str_trim(scrap(url,".jsx-3972598687+ .jsx-3655512908")[2]))
    PrecioOferta<-unique(str_trim(scrap(url,".jsx-1373953156 .level-0 .jsx-3972598687 .jsx-3655512908:nth-child(1)")[1]))
    
    
    tablaPrecios<-cbind(url,NombreProducto,Categoria,Marca,SKU,PrecioNormal,PrecioOferta,Fecha,timestamp())
    tablaPreciosF<-rbind(tablaPreciosF,tablaPrecios)
    print(i)
  }, error=function(e){})
}
setwd(dir)
write.xlsx(tablaPreciosF,paste0("Sodimac_DR ",Fecha," ",hour(now()),"-",minute(now()),".xlsx"))