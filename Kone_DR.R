# kone

remove(list=ls())
Fecha=format(Sys.Date(), "%d-%m-%Y")
Mes<-months.Date(today())
Mes<-unlist(lapply(Mes, FUN=toTitleCase))
dir=paste0("C:/Users/David/Desktop/FEN/Decimo Semestre/Práctica/GIT/Generados/",Mes,"/",Fecha)
dir2=paste0(dir,"/Links")
setwd(dir2)

linkPage<-"https://k1.cl/"
linkPage1<-"https://k1.cl"
pages<-unique(weblink_scrap(linkPage,".K-One"))
Links1<-paste(linkPage1,pages[1:69],sep = "")
Links2<-pages[70:77]
Links<-c(Links1,Links2)


#For
linkProdF<-matrix(NA,0,1)
for (i in 1:length(Links)) {
  linkpag<-paste(Links[i],sep = "")
  linkProd<-unique(weblink_scrap(linkpag,"/p/"))
  #linkProd<-paste0(linkProd,pages[i])
  linkProd<-as.data.frame(linkProd)
  linkProdF<-rbind(linkProdF,linkProd)
  print(i)
}

linksPF1<-linkProdF
linksPF1<-linksPF1[!duplicated(linksPF1), ]

linksPF1<-as.data.frame(linksPF1)
write.xlsx(linksPF1,"kone.xlsx")
links2<-read.xlsx("kone.xlsx")


#Segunda Parte
tablaProdF<-matrix(NA,0,8)
for (i in 1:nrow(links2)) {
  tryCatch({
    url<-paste(linkPage1,links2$linksPF1[i],sep = "")
    NombreProducto<-scrap(url,".trimName")
    Categoria<-str_split_fixed(url,"/",9)[5]
    SKU<-scrap(url,".code")[1]
    PrecioOferta<-scrap(url,".price")[1]
    PrecioNormal<-str_trim(scrap(url,".item--price.item--price-without-discount"))[1]
    
    tablaP<-cbind(url,NombreProducto,Categoria,SKU,PrecioNormal,PrecioOferta,Fecha,timestamp())
    tablaProdF<-rbind(tablaProdF,tablaP)
    print(i)
  }, error=function(e){})
}
setwd(dir)
write.xlsx(tablaProdF,paste0("Kone_DR",Fecha," ",hour(now()),"-",minute(now()),".xlsx"))