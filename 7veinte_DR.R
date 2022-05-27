# 7veinte
remove(list=ls())
Fecha=format(Sys.Date(), "%d-%m-%Y")
Mes<-months.Date(today())
Mes<-unlist(lapply(Mes, FUN=toTitleCase))
dir=paste0("C:/Users/David/Desktop/FEN/Decimo Semestre/Práctica/GIT/Generados/",Mes,"/",Fecha)
dir2=paste0(dir,"/Links")
setwd(dir2)

linkPage<-"https://www.7veinte.cl/"
linkPage1<-"https://www.7veinte.cl"

pages<-unique(weblink_scrap(linkPage))
pages1<-unique(weblink_scrap(linkPage,"hombre"))
pages2<-unique(weblink_scrap(linkPage,"mujer"))

Categorias<-c(pages1,pages2)
Categorias1<-paste(linkPage1,Categorias,sep = "")

#Metodo For
linkProdF<-matrix(NA,0,1)
for (i in 1:length(Categorias1)){ 
  linkscat<-unique(weblink_scrap(Categorias1[i],"/p"))
  linkProd<-as.data.frame(linkscat)
  linkProdF<-rbind(linkProdF,linkProd)
  print(i)
  
}
linksPF1<-linkProdF
linksPF1<-linksPF1[!duplicated(linksPF1), ]
linksPF1<-as.data.frame(linksPF1)
write.xlsx(linksPF1,"7veinte.xlsx")
links2<-read.xlsx("7veinte.xlsx")

#Segunda Parte
tablaPF<-matrix(NA,0,8)
for (i in 1:nrow(links2)) {
  tryCatch({
    
    url<-paste(linkPage1,links2$linksPF1[i],sep = "")
    NombreProducto<-scrap(url,".vtex-store-components-3-x-productBrand")[1]
    Marca<-unique(scrap(url,".vtex-store-components-3-x-productBrandName"))[1]
    SKU<-scrap(url,".vtex-product-identifier-0-x-product-identifier__value")[1]
    PrecioOferta<-scrap(url,".vtex-store-components-3-x-price_sellingPrice")
    PrecioNormal<-scrap(url,".vtex-store-components-3-x-price_listPrice")
    
    tablaP<-cbind(url,NombreProducto,Marca,SKU,PrecioNormal,PrecioOferta,Fecha,timestamp())
    tablaPF<-rbind(tablaPF,tablaP)
    print(i)
  }, error=function(e){})
}
setwd(dir)
write.xlsx(tablaPF,paste0("7veinte_DR",Fecha," ",hour(now()),"-",minute(now()),".xlsx"))
