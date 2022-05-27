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


link<-"https://salcobrand.cl/"
link2<-"https://salcobrand.cl"
links1<-unique(weblink_scrap(link))
linksPF1<-sort(links1)
linkProd1<-linksPF1[str_detect(linksPF1,"/t/")]
linkProd1<-paste(link2,linkProd1,sep = "")
linkProd2<-c(linkProd1,"https://salcobrand.cl/products/sales")


linkProd2<-c("https://salcobrand.cl/t/belleza","https://salcobrand.cl/t/bienestar-sexual","https://salcobrand.cl/t/medicamentos","https://salcobrand.cl/t/cuidado-personal","https://salcobrand.cl/t/dermocoaching","https://salcobrand.cl/t/infantil-y-mama","https://salcobrand.cl/t/mundo-mascotas","https://salcobrand.cl/t/wellness","https://salcobrand.cl/products/sales")



#Construcción por categorias
belleza<-unique(weblink_scrap(linkProd2[1],"page="))
belleza<-sort(belleza)
numero<-str_split_fixed(belleza[1],"page=",2)[2]
pages<-c(1:numero)
plinksF<-matrix(NA,0,1)
for (j in 1:length(pages)) {
  plinks<-paste0(linkProd2[1],"?current_store_id=1&page=",j)
  plinks2<-unique(weblink_scrap(plinks,"products/"))
  plinks2<-as.data.frame(plinks2)
  plinksF<-rbind(plinksF,plinks2)
  print(j)
}

bienestar<-unique(weblink_scrap(linkProd2[2],"page="))
bienestar<-sort(bienestar)
numero<-str_split_fixed(bienestar[3],"page=",2)[2]
pages<-c(1:numero)
plinksF1<-matrix(NA,0,1)
for (j in 1:length(pages)) {
  plinks<-paste0(linkProd2[2],"?current_store_id=1&page=",j)
  plinks2<-unique(weblink_scrap(plinks,"products/"))
  plinks2<-as.data.frame(plinks2)
  plinksF1<-rbind(plinksF1,plinks2)
  print(j)
}

medicamentos<-unique(weblink_scrap(linkProd2[3],"page="))
medicamentos<-sort(medicamentos)
numero<-str_split_fixed(medicamentos[1],"page=",2)[2]
pages<-c(1:numero)
plinksF2<-matrix(NA,0,1)
for (j in 1:length(pages)) {
  plinks<-paste0(linkProd2[3],"?current_store_id=1&page=",j)
  plinks2<-unique(weblink_scrap(plinks,"products/"))
  plinks2<-as.data.frame(plinks2)
  plinksF2<-rbind(plinksF2,plinks2)
  print(j)
}

cuidado<-unique(weblink_scrap(linkProd2[4],"page="))
cuidado<-sort(cuidado)
numero<-str_split_fixed(cuidado[5],"page=",2)[2]
pages<-c(1:numero)
plinksF3<-matrix(NA,0,1)
for (j in 1:length(pages)) {
  plinks<-paste0(linkProd2[4],"?current_store_id=1&page=",j)
  plinks2<-unique(weblink_scrap(plinks,"products/"))
  plinks2<-as.data.frame(plinks2)
  plinksF3<-rbind(plinksF3,plinks2)
  print(j)
}

dermocoaching<-unique(weblink_scrap(linkProd2[5],"page="))
dermocoaching<-sort(dermocoaching)
numero<-str_split_fixed(dermocoaching[4],"page=",2)[2]
pages<-c(1:numero)
plinksF4<-matrix(NA,0,1)
for (j in 1:length(pages)) {
  plinks<-paste0(linkProd2[5],"?current_store_id=1&page=",j)
  plinks2<-unique(weblink_scrap(plinks,"products/"))
  plinks2<-as.data.frame(plinks2)
  plinksF4<-rbind(plinksF4,plinks2)
  print(j)
}

infantil<-unique(weblink_scrap(linkProd2[6],"page="))
infantil<-sort(infantil)
numero<-str_split_fixed(infantil[3],"page=",2)[2]
pages<-c(1:numero)
plinksF5<-matrix(NA,0,1)
for (j in 1:length(pages)) {
  plinks<-paste0(linkProd2[6],"?current_store_id=1&page=",j)
  plinks2<-unique(weblink_scrap(plinks,"products/"))
  plinks2<-as.data.frame(plinks2)
  plinksF5<-rbind(plinksF5,plinks2)
  print(j)
}

mundo<-unique(weblink_scrap(linkProd2[7],"page="))
mundo<-sort(mundo)
numero<-str_split_fixed(mundo[3],"page=",2)[2]
pages<-c(1:numero)
plinksF6<-matrix(NA,0,1)
for (j in 1:length(pages)) {
  plinks<-paste0(linkProd2[7],"?current_store_id=1&page=",j)
  plinks2<-unique(weblink_scrap(plinks,"products/"))
  plinks2<-as.data.frame(plinks2)
  plinksF6<-rbind(plinksF6,plinks2)
  print(j)
}

wellness<-unique(weblink_scrap(linkProd2[8],"page="))
wellness<-sort(wellness)
numero<-str_split_fixed(wellness[4],"page=",2)[2]
pages<-c(1:numero)
plinksF7<-matrix(NA,0,1)
for (j in 1:length(pages)) {
  plinks<-paste0(linkProd2[8],"?current_store_id=1&page=",j)
  plinks2<-unique(weblink_scrap(plinks,"products/"))
  plinks2<-as.data.frame(plinks2)
  plinksF7<-rbind(plinksF7,plinks2)
print(j)
}

sales<-unique(weblink_scrap(linkProd2[9],"page="))
sales<-sort(sales)
numero<-str_split_fixed(sales[1],"page=",2)[2]
pages<-c(1:numero)
plinksF8<-matrix(NA,0,1)
for (j in 1:length(pages)) {
  plinks<-paste0(linkProd2[9],"?current_store_id=1&page=",j)
  plinks2<-unique(weblink_scrap(plinks,"products/"))
  plinks2<-as.data.frame(plinks2)
  plinksF8<-rbind(plinksF8,plinks2)
  print(j)
}



finales<-rbind(plinksF,plinksF1,plinksF2,plinksF3,plinksF4,plinksF5,plinksF6,plinksF7,plinksF8)


finales1<-finales[!duplicated(finales), ]
finales1<-as.data.frame(finales1)
prueba<-finales1$finales1

linkscortados<-str_split_fixed(prueba,"\\?",n=2)
linkscortados<-as.data.frame(linkscortados)
names(linkscortados)=c("base","extensión")

linkscortados1<-as.data.frame(linkscortados)
linkscortados1<-linkscortados1[!duplicated(linkscortados1[c("base")]), ]
linkscortados2<-unite(linkscortados1, linksfinales,c(1:2),  sep = "?", remove = TRUE)
linkscortados3<-linkscortados2[!duplicated(linkscortados2), ]
linkscortados3<-linkscortados3[!str_detect(linkscortados3,"preview")]

linkscortados3<-as.data.frame(linkscortados3)
write.xlsx(linkscortados3,"salcobrand.xlsx")
links2<-read.xlsx("salcobrand.xlsx")

tablaPreciosF<-matrix(NA,0,7)
for (i in 1:nrow(links2)) {
  tryCatch({
    url<-paste(link2,links2$linkscortados3[i],sep = "")
    NombreProducto<-unique(scrap(url,".product-name"))[1]
    PrincipioActivo<-unique(scrap(url,".product-info"))[1]
    Categoria<-unique(scrap(url,"#breadcrumbs span a"))
    PrecioNormal<-unique(str_replace((str_trim(scrap(url,".full p"))[1]),"Ahora:","-"))
    
    tablaPrecios<-cbind(url,NombreProducto,Categoria,PrincipioActivo,PrecioNormal,Fecha,timestamp())
    tablaPreciosF<-rbind(tablaPreciosF,tablaPrecios)
    print(i)
  }, error=function(e){})
}
setwd(dir)
write.xlsx(tablaPreciosF,paste0("Salcobrand_DR1 ",Fecha," ",hour(now()),"-",minute(now()),".xlsx"))  










#Paginas siguientes por categoria
Paginas_linkcategoria=matrix(NA,0,1)
for (i in 1:length(linkProd2)) {
  tryCatch({
    linkPag<-paste(link2,linkProd2[i],sep = "")
    cambiopagina<-unique(weblink_scrap(linkPag,"page="))
    for (i in 1:length(cambiopagina)) {
      tryCatch({
        linkPag<-paste(link2,cambiopagina[i],sep = "")
        cambiopagina2<-unique(weblink_scrap(linkPag,"page="))
        cambiopagina2<-as.data.frame(cambiopagina2)
        Paginas_linkcategoria<-rbind(Paginas_linkcategoria,cambiopagina2)
        print(i)
      }, error=function(e){})
    } 
    Paginas_linkcategoria<-as.data.frame(Paginas_linkcategoria)
    Paginas_linkcategoria1<-rbind(Paginas_linkcategoria,cambiopagina)
    print(i)
  }, error=function(e){})
} 
Paginas_linkcategoria1<-Paginas_linkcategoria1[str_detect(Paginas_linkcategoria1,"&taxon")]



