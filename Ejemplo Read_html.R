remove(list=ls())                 #Con remove se elimina todo lo que puede haber en el ambiente, esto con la finalidad de que no se confundan con las nuevas variables 
Fecha=format(Sys.Date(), "%d-%m-%Y") #Crea la fecha del dia de hoy con dia, mes y año, seagregara a la tabla de la columna final 
Mes<-months.Date(today())
Mes<-unlist(lapply(Mes,FUN=toTitleCase))
dir=paste0("C:/Users/David/Desktop/FEN/Decimo Semestre/Práctica/GIT/Generados/","/",Mes,"/",Fecha)
dir2=paste0(dir,"/","Links")
setwd(dir2) #Definimos el directorio donde se guardaran los archivos, se escoje dir2 porque primero se generan los liks de los productos y posterior a esto se webscrapearan esos links

### Se cargan las librerias ###

#Paso previo
#Si no tienen instaladas las librerias deben hacerlo ahora con el siguiente codigo:
#install.packages(c("ralger","rvest","stringr","readr","gdata","openxlsx","lubridate","tidyr","dplyr"))
#Se demorara un poco pero es normal, una vez instladas las librerias hay pproceder a cargalas coomo se muestra a continuación

library(ralger) #Esta libreria nos ayudará con el webscraping, ocuparemos funciones como scrap o weblink_scrap
library(rvest) #Esta libreria nos ayudará con el webscraping tambien, ocuparemos funciones como read_html
library(stringr)
library(readr)
library(gdata)
library(openxlsx)
library(lubridate)
library(tidyr)
library(dplyr)
timestamp()
#####Konstruyendo(listo)#####
K_url<-"https://www.konstruyendo.com" #url sobre el que se trabaja
K_page<-read_html(K_url) #lectura y almacenamiento de la página
vector_subpage<-K_page%>% # Se crea la variable, se define el elemento HTML
  html_nodes("li.k_heading")%>% #Se accede al primer grupo de nodos
  html_nodes("a")%>% #Se accede a los sub-nodos
  html_attr("href") #Se extrae el atributo href
vector_tipo<-K_page%>% # Se crea la variable, se define el elemento HTML
  html_nodes("li.k_heading")%>% #Se accede al primer grupo de nodos
  html_nodes("a")%>% #Se accede a los sub-nodos
  html_text() %>% #Se extrae el texto
  str_trim() #Se aplica limpieza de espacios
Base_K<-matrix(NA,0,6) #Creación de la matriz vacía
for(i in 1:length(vector_subpage)){ #Se define variable de control y vector
  K_subpage<-read_html(vector_subpage[i]) #Lectura de la subpágina
  Tipo<-vector_tipo[i] #Almacenar el Tipo de producto
  paginas<-K_subpage%>% #Extracción del texto de páginas
    html_nodes("p.woocommerce-result-count")%>%
    html_text() %>%
    str_split(" ") %>% unlist() #aplicación de split y unlist
  paginas<-as.integer(paginas[4]) #Convertir valor a número
  paginas<-ceiling(paginas/12) #Calcular páginas de productos
  for(j in 1:paginas){ #Se define variable de control y vector
    #Lectura y almacenamiento de la nueva página
    K_subpage_n<-read_html(paste0(vector_subpage[i],"?pagination=",(j-1)*12))
    Tiempo<-as.character(now()) #Creación de la marca temporal
    Nombre <- K_subpage_n %>% #Extracción de Nombre
      html_nodes("div.col-xs-12") %>%
      html_nodes("a") %>%
      html_nodes("h3") %>%
      html_text() %>% str_trim()
    Marca<-K_subpage_n %>% #Extracción de Marca
      html_nodes("div.col-xs-12") %>%
      html_nodes("span.loop-product-categories") %>%
      html_text() %>% str_trim()
    SKU <- gsub("SKU: ","",K_subpage_n %>% #Extracción de SKU
                  html_nodes("div.col-xs-12") %>%
                  html_nodes("small") %>%
                  html_text()) %>% str_trim()
    Precio<-gsub("\\.","",gsub("\\$","",K_subpage_n %>% #Extracción de Precio
                                 html_nodes("div.col-xs-12") %>%
                                 html_nodes("span.amount") %>%
                                 html_text())) %>% str_trim()
    Precio<-Precio[!duplicated(Precio)] #Sacar duplicados de Precio
    df<-cbind(Tiempo,SKU,Tipo,Marca,Nombre,Precio) #Creación de matriz auxiliar
    Base_K<-rbind(Base_K,df) #Autocompletado de la matriz base
  }
}
Base_K<-as.data.frame(Base_K) #Transformación a data frame
names(Base_K)<-c("Marca Temporal","SKU","Tipo", #Aplicación de nombres
                 "Marca","Nombre","Precio")
write.xlsx(Base_K,"Konstruyendo.xlsx") #Exportación de la base
now