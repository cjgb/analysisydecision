---
author: rvaquerizo
categories:
  - formación
  - r
  - trucos
date: '2010-09-08'
lastmod: '2025-07-13'
related:
  - stadistical-data-warehouse-del-european-central-bank-con-r-y-los-depositos-a-perdidas.md
  - los-principales-problemas-de-los-espanoles-animaciones-con-r-y-gganimate.md
  - trucos-simples-para-rstats.md
  - analisis-de-textos-con-r.md
  - leer-fichero-de-texto-de-ancho-fijo-con-python-pandas.md
tags:
  - encoding
  - r
  - xml
  - xmltodataframe
title: Trucos R. Leer archivos XML con R
url: /blog/trucos-r-leer-archivos-xml-con-r/
---

Un truco de R práctico que busca la colaboración de los lectores para mejorarlo. Se trata de **leer ficheros xml con R**. Los más asiduos ya sabéis que paquete voy a emplear, el XML. En los últimos tiempos la sentencia `require(XML)` aparece al principio de casi todos mis códigos en el **Tinn-R**. El ejemplo que ilustrará el truco lee de [la BBDD del banco mundial ](http://datos.bancomundial.org/)en español el indicador de emisiones de CO2 en toneladas por habitante y año. La sintaxis es de este modo:

```r
#Paquete necesario para leer XML

require(XML)

arch = "http://datos.bancomundial.org/sites/default/files/indicators/es/co2-emissions-metric-tons-per-capita_es.xml"

doc <- xmlTreeParse(arch,getDTD=T,addAttributeNamespaces=T)

arriba = xmlRoot(doc)

#Vemos los nombres de los campos de la tabla

names(arriba[[1]])
```

Leemos directamente de la web el documento XML. `xmlTreeParse` crea la estructura del XML en R, de este modo podemos acceder a los datos. Lo primero que vamos a hacer es saber los nombres de las columnas que deseamos leer, para ello `xmlRoot` obtiene los nodos raiz de la estructura que hemos leído. La función `names` obtiene los nombres de las columnas de la tabla XML. El siguiente paso será crear un data frame con los datos de la tabla XML:

```r
#El parámetro colClasses nos facilita la lecturas

datos=xmlToDataFrame(arch,

colClasses=c("character", "character", "numeric" , "numeric"))

#Nos quedamos con datos posteriores al año 2000

datos=subset(datos,year>=2000)
```

La función del paquete XML de R que crea data frames a partir de tablas XML es `xmlToDataFrame`, los parámetros principales que recibe son la tabla a transformar en data frame y `colClasses` donde especificamos el tipo de dato que estamos leyendo (`numeric` o `character`). No he sido capaz de leer los datos correctamente sin emplear `colClasses`, por ello apelo a los lectores por si encuentran una vía más cómoda para realizar este proceso. Sobre el data frame generado ya podemos realizar las operaciones más habituales, en este caso realizo un subconjunto de observaciones quedándome con aquellos datos posteriores al año 2000. Ahora tenemos que trabajar la codificación del fichero. Desconozco que codificación emplea el paquete XML para leer tablas, pero si hacemos `head(datos)` podemos observar que AfganistÃ¡n no es la codificación que necesitamos. La **codificación** de los ficheros del banco mundial es **UTF-8**, estoy buscando como obtener este dato con R para que no sea necesario conocerlo a priori. Para modificar la codificación de un vector hemos de emplear la función R `Encoding`. Este truco se lo tenemos que agradecer a [Carlos ](http://www.datanalytics.com/blog/)y es imprescindible para trabajar con vectores codificados. Vamos a separar el campo `country` creando un vector de caracteres al que codificaremos como deseamos:

```r
#Modificamos la codificación

#Encoding sólo trabaja con vectores

aux1=as.vector(datos$country)

Encoding(aux1)="UTF-8"

aux1=as.data.frame(aux1); names(aux1)=c("country")

head(aux1)

#Damos al data frame la estructura más sencilla

datos=cbind(aux1,subset(datos,select=c("year","value")))

remove(aux1); summary(datos)
```

Hemos separado country en un vector de caracteres que codificamos como UTF-8 con `Encoding`. Ese vector lo unimos con nuestro data frame inicial y ya tenemos una tabla con la que podemos trabajar.

`boxplot(value~year, ylab="Toneladas per cápita", xlab="Año", data=datos)`

Espero que os sea de utilidad. Saludos.
