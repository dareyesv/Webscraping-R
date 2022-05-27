###Paris###
###Paso 1 ----> Cargar Librerías

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

###Paso 2 ----> Definir Directorio
remove(list=ls())
Fecha=format(Sys.Date(), "%d-%m-%Y")
Mes<-months.Date(today())
Mes<-unlist(lapply(Mes, FUN=toTitleCase))
dir=paste0("C:/Users/David/Desktop/FEN/Decimo Semestre/Práctica/GIT/Generados/",Mes,"/",Fecha)
dir2=paste0(dir,"/Links")
setwd(dir2)


###Paso 3 ----> Exploración Página Web y ver sus características


###Paso 4 ----> Scrapear Página Principal 

link<-"https://www.paris.cl/"
link2<-"https://www.paris.cl"
links1<-unique(weblink_scrap(link))
links1<-unique(weblink_scrap(link))[c(6:length(links1))]

#Paginas siguientes por categoria
Paginas_linkcategoria=matrix(NA,0,1)
for (i in 1:length(links1)) {
  tryCatch({
    linkPag<-paste0(links1[i])
    cambiopagina<-unique(weblink_scrap(linkPag,"start="))
    cambiopagina<-as.data.frame(cambiopagina)
    Paginas_linkcategoria<-rbind(Paginas_linkcategoria,cambiopagina)
    print(i)
  }, error=function(e){})
} 
names(Paginas_linkcategoria)<-c("links1")
links1.1<-as.data.frame(links1)
linksfinalesfinalesxcategoria<-rbind(Paginas_linkcategoria,links1.1)


write.xlsx(linksfinalesfinalesxcategoria,"linkspariscategoria.xlsx")
links2.2<-read.xlsx("linkspariscategoria.xlsx")
links2.2<-links2.2[!duplicated(links2.2), ]


#For Productos
linkProdF<-matrix(NA,0,1)
for (i in 1:length(links2.2)) {
  tryCatch({
  linkPag<-paste0(links2.2[i])
  linkProd<-unique(weblink_scrap(linkPag,".html"))
  linkProd<-as.data.frame(linkProd)
  linkProdF<-rbind(linkProdF,linkProd)
  print(i)
  }, error=function(e){})
}

#Tratamiento links: Duplicados
linksPF1<-linkProdF
linksPF1<-linksPF1[!duplicated(linksPF1), ]
linksPF1<-linksPF1[str_detect(linksPF1,".html")]
linksPF1<-linksPF1[str_detect(linksPF1,"cgid")]
linksPF1<-sort(linksPF1)

#Tratamiento links: Sin base
linkProd1<-linksPF1[str_detect(linksPF1,"https")]
linkProd1<-as.data.frame(linkProd1)
names(linkProd1)=c("linkProd")

linkProd2<-linksPF1[1:(min(which(str_detect(linksPF1,"https")))-1)]
linkProd<-paste(link2,linkProd2,sep = "")  
linkProd<-as.data.frame(linkProd)

#Links Finales
linklistos<-rbind(linkProd,linkProd1)
prueba<-linklistos$linkProd


#Tratamiento links: Links de mismo producto pero con distinta base, se deben eliminar
linkscortados<-str_split_fixed(prueba,"cgid",n=2)
linkscortados<-as.data.frame(linkscortados)
names(linkscortados)=c("base","extensión")

#Links Finales Finales
linkscortados1<-as.data.frame(linkscortados)
linkscortados1<-linkscortados1[!duplicated(linkscortados1[c("base")]), ]
linkscortados2<-unite(linkscortados1, linksfinales,c(1:2),  sep = "cgid", remove = TRUE)

write.xlsx(linkscortados2,"paris2.xlsx")
links2<-read.xlsx("paris2.xlsx")

#muestreo1 <- sample_n(links2, size= 100)
#nrow(muestreo1)


tablaPreciosF<-matrix(NA,0,10)

for (i in 1:nrow(links2)) {
  tryCatch({
    linkProd<-paste(links2$linksfinales[i])
    NombreProducto<-unique(scrap(linkProd,".js-product-name"))
    Categoria<-unique(scrap(linkProd,".breadcrumb-element:nth-child(3) span"))
    Marca<-unique(scrap(linkProd,"#GTM_pdp_brand"))
    SKU<-unique(scrap(linkProd,"#pdpMain .pull-right"))[1]
    precioOferta1<-unique(str_trim(scrap(linkProd,".price")))[1]
    PrecioMP<-str_split_fixed(precioOferta1,"-",n=2)[1]
    PrecioOferta<-unique(str_trim(scrap(linkProd,".noPad .price-internet span")))
    if ((length(PrecioOferta))==0) {
      PrecioOferta<-"0"}
    PrecioNormal<-unique(str_trim(scrap(linkProd,".noPad s")))
    if ((length(PrecioNormal))==0) {
      PrecioNormal<-"0"}
    
    tablaPrecios<-cbind(linkProd,NombreProducto,Categoria,Marca,SKU,PrecioNormal,PrecioOferta,PrecioMP,Fecha,timestamp())
    tablaPreciosF<-rbind(tablaPreciosF,tablaPrecios)
    print(i)
  }, error=function(e){})
}
setwd(dir)
write.xlsx(tablaPreciosF,paste0("Paris_DR",today(),"-",hour(now()),minute(now()),".xlsx"))