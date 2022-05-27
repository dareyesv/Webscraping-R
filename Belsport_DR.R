###Belsport###
###Paso 1 ----> Cargar Librerías

library(ralger)
library(stringr)
library(readr)
library(gdata)
library(openxlsx)
library(lubridate)
library(tidyr)
library(dplyr)
library(tools)

###Paso 2 ----> Definir Directorio
remove(list = ls())
Fecha=format(Sys.Date(), "%d-%m-%Y")
Mes<-months.Date(today())
Mes<-unlist(lapply(Mes,FUN=toTitleCase))
dir=paste0("C:/Users/David/Desktop/FEN/Decimo Semestre/Práctica/GIT/Generados/","/",Mes,"/",Fecha)
dir2=paste0(dir,"/","Links")
setwd(dir2)


###Paso 3 ----> Exploración Página Web y ver sus características


###Paso 4 ----> Scrapear Página Principal 

link<-"https://belsport.cl"
link1<-unique(weblink_scrap(link,"/c/"))
link1<-sort(link1)
links2<-link1[str_detect(link1,"https")]
links3<-link1[!str_detect(link1,"https")]
links3<-paste(link,links3,sep = "")

Categorias<-c(links2,links3)

###Paso 5 ----> Scrapear por Categoría 

linksF<-matrix(NA,0,1)

for (i in 1:length(Categorias)) {
  linkscat<-Categorias[i]
  pages<-scrap(linkscat,".pagination-bar-results")
  pages<-parse_number(pages)
  pages<-ceiling(pages/20)
  pages<-c(1:pages)
  for (j in 1:length(pages)) {
    plinks<-paste0(linkscat,"?q=%3Acreationtime&page=",j-1)
    plinks2<-unique(weblink_scrap(plinks,"/p/"))
    plinks2<-as.data.frame(plinks2)
    linksF<-rbind(linksF,plinks2)
    print(paste0("pagina ",j))
  }
  print(i)
}

###Paso 6 ----> Obtener los links por Productos y Guardarlos
linksPF1<-linksF
linksPF1<-linksPF1[!duplicated(linksPF1),]
linksPF1<-as.data.frame(linksPF1)
write.xlsx(linksPF1,"belsport.xlsx")
links2.2<-read.xlsx("belsport.xlsx")


###Paso 7 ----> Scrapear cada producto a través de Ciclo For
tablaPreciosF<-matrix(NA,0,8)
for (i in 1:nrow(links2.2)) {
  tryCatch({
  url<-paste(link,links2.2$linksPF1[i],sep = "")  
  NombreProducto<-unique(scrap(url,".trimName"))
  Categoria<-unique(scrap(url,".breadcrumb , .breadcrumb li:nth-child(4) a"))[2]
  SKU<-unique(scrap(url,".code")) 
  
  PrecioOferta<-str_trim(scrap(url,".item--price-without-discount"))
  if((length(PrecioOferta))==0){
    PrecioOferta<-str_trim(scrap(url,".price-with-discount"))}
  
  PrecioNormal<-str_trim(scrap(url,".price-regular"))
  if((length(PrecioNormal))==0){
    PrecioNormal<-"0"}
  
  if((PrecioNormal)==0){
    PrecioNormal<-PrecioOferta
    PrecioOferta<-"0"}
  
  tablaPrecios<-cbind(url,NombreProducto,Categoria,SKU,PrecioNormal,PrecioOferta,Fecha,timestamp())
  tablaPreciosF<-rbind(tablaPreciosF,tablaPrecios)
  print(i)
  
  }, error=function(e){})
}
setwd(dir)
write.xlsx(tablaPreciosF,paste0("Belsport_DR ",Fecha," ",hour(now()),"-",minute(now()),".xlsx"))


