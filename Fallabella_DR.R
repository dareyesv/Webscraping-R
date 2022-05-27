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

link<-"https://www.falabella.com/falabella-cl/"
link2<-"https://www.falabella.com"
links1<-unique(weblink_scrap(link))

linksPF2<-links1
linksPF2<-linksPF2[!duplicated(linksPF2), ]
linksPF2<-linksPF2[!str_detect(linksPF2,"http")]
linksPF2<-linksPF2[!str_detect(linksPF2,"#")]
linksPF2 <- na.omit(linksPF2)
linksPF2<-paste(link2,linksPF2,sep = "")


linksPF1<-links1
linksPF1<-linksPF1[!duplicated(linksPF1), ]
linksPF1<-linksPF1[str_detect(linksPF1,"https://www.falabella.com/")]
linksPF1<-sort(linksPF1)
linksPF1<-linksPF1[1:(max(which(str_detect(linksPF1,"collection"))))]

linksfinales<-c(linksPF2,linksPF1)
write.xlsx(linksfinales,"linksfalabellacategoria.xlsx")

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

write.xlsx(finales,"linksfalabella.xlsx")
links2<-read.xlsx("linksfalabella.xlsx")


tablaPreciosF<-matrix(NA,0,10)
for (i in 1:nrow(links2)) {
  tryCatch({
    url<-paste(links2$finales[i])
    NombreProducto<-unique(scrap(url,".fa--product-name"))
    Categoria<-unique(scrap(url,"li.jsx-2781897185"))[2]
    Marca<-unique(scrap(url,".product-brand-link"))
    SKU<-str_replace(str_trim(unique(scrap(url,".fa--variant-id .jsx-3408573263"))), "Código del producto: ","")
    PrecioMP<-unique(str_trim(scrap(url,".high.normal"))[1])
    PrecioOferta<-unique(str_trim(scrap(url,".copy1")))[1]
    PrecioNormal<-unique(str_trim(scrap(url,".copy5.normal")))
    if (((length(PrecioNormal))==0) & ((length(PrecioMP))!=0)& ((length(PrecioOferta))==1)){
      PrecioNormal<-PrecioOferta
      PrecioOferta<-PrecioMP
      PrecioMP<-"0"}
    if (((length(PrecioNormal))==0) & ((length(PrecioMP))!=0)& ((length(PrecioOferta))>1)){
      PrecioNormal<-unique(str_trim(scrap(url,".price-1 .copy1")))
      if ((length(PrecioNormal))==0){
        PrecioNormal<-"0"
      }
      PrecioMP<-"0"
      PrecioOferta<-unique(str_trim(scrap(url,".high.normal")))[1]}
    if (((length(PrecioNormal))==0) & ((length(PrecioMP))!=0)& ((length(PrecioOferta))==0)){
      PrecioNormal<-PrecioMP
      PrecioOferta<-"0"
      PrecioMP<-"0"}
    
    tablaPrecios<-cbind(url,NombreProducto,Categoria,Marca,SKU,PrecioNormal,PrecioOferta,PrecioMP,Fecha,timestamp())
    tablaPreciosF<-rbind(tablaPreciosF,tablaPrecios)
    print(i)
  }, error=function(e){})}

setwd(dir)
write.xlsx(tablaPreciosF,paste0("Falabella_DR ",Fecha," ",hour(now()),"-",minute(now()),".xlsx"))