#Linio

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

link<-"https://www.linio.cl/"
link2<-"https://www.linio.cl"
links1<-unique(weblink_scrap(link))

linksPF1<-links1
linksPF1<-linksPF1[!duplicated(linksPF1), ]
linksPF1<-linksPF1[str_detect(linksPF1,"/c/")]
linksPF1<-linksPF1[!str_detect(linksPF1,"https")]
linksPF1 <- na.omit(linksPF1)
linksPF11<-paste(link2,linksPF1,sep = "")

linksPF2<-linksPF1
linksPF2<-linksPF2[!duplicated(linksPF2), ]
linksPF2<-linksPF2[str_detect(linksPF2,"https")]

linksPF3<-links1
linksPF3<-linksPF3[!duplicated(linksPF3), ]
linksPF3<-linksPF3[str_detect(linksPF3,"/cm/")]
linksPF3 <- na.omit(linksPF3)
linksPF3<-paste(link2,linksPF3,sep = "")

linksfinales<-c(linksPF2,linksPF11,linksPF3)
linksfinales1<-as.data.frame(linksfinales)

#Paginas siguientes por categoria
Paginas_linkcategoria=matrix(NA,0,1)
for (i in 1:length(linksfinales)) {
  tryCatch({
    linkPag<-paste0(linksfinales[i])
    cambiopagina<-unique(weblink_scrap(linkPag,"page="))
    cambiopagina1<-paste("https://www.linio.cl",cambiopagina,sep = "")
    cambiopagina1<-as.data.frame(cambiopagina1)
    Paginas_linkcategoria<-rbind(Paginas_linkcategoria,cambiopagina1)
    print(i)
  }, error=function(e){})
} 
names(Paginas_linkcategoria)<-c("linksfinales")

linksfinalesfinalesxcategoria<-rbind(Paginas_linkcategoria,linksfinales1)
write.xlsx(linksfinalesfinalesxcategoria,"linksliniocategoria.xlsx")

links22<-read.xlsx("linksliniocategoria.xlsx")
links22<-links22[!duplicated(links22), ]

#For
linkProdF<-matrix(NA,0,1)
for (i in 1:length(links22)) {
  tryCatch({
    linkPag<-paste0(links22[i])
    linkProd<-unique(weblink_scrap(linkPag,"/p/"))
    linkProd<-as.data.frame(linkProd)
    linkProdF<-rbind(linkProdF,linkProd)
    print(i)
  }, error=function(e){})
}

finales<-linkProdF
finales<-finales[!duplicated(finales), ]


linkscortados<-str_split_fixed(finales,"\\?.*qid",n=2)
linkscortados<-as.data.frame(linkscortados)
names(linkscortados)=c("base","extensión")

linkscortados1<-as.data.frame(linkscortados)
linkscortados1<-linkscortados1[!duplicated(linkscortados1[c("base")]), ]
linkscortados2<-unite(linkscortados1, linksfinales,c(1:2),  sep = "?cgid", remove = TRUE)


write.xlsx(linkscortados2,"linkslinio.xlsx")
links2<-read.xlsx("linkslinio.xlsx")

tablaPreciosF<-matrix(NA,0,9)
for (i in 1:nrow(links2)) {
  tryCatch({
    url<-paste(link2,links2$linksfinales[i],sep = "")
    NombreProducto<-unique(scrap(url,".product-name"))
    Categoria<-unique(scrap(url,".breadcrumb li:nth-child(2) span"))
    Marca<-unique(scrap(url,".link-low-sm"))
    PrecioMP<-unique(str_trim(scrap(url,".price-promotional")))
    if ((length(PrecioMP))==0) {
      PrecioMP<-"0"}
    PrecioOferta<-unique(str_trim(scrap(url,".price-main-md")[1]))
    if ((length(PrecioOferta))==0) {
      PrecioOferta<-"0"}
    PrecioNormal<-unique(str_trim(scrap(url,".original-price")[1]))
    if ((length(PrecioNormal))==0) {
      PrecioNormal<-"0"}
    
    tablaPrecios<-cbind(url,NombreProducto,Categoria,Marca,PrecioNormal,PrecioOferta,PrecioMP,Fecha,timestamp())
    tablaPreciosF<-rbind(tablaPreciosF,tablaPrecios)
    print(i)
  }, error=function(e){})
}
setwd(dir)
write.xlsx(tablaPreciosF,paste0("Linio_DR ",Fecha," ",hour(now()),"-",minute(now()),".xlsx"))
