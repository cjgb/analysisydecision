---
author: rvaquerizo
categories:
- Formación
- R
- Trucos
date: '2010-09-08T04:41:47-05:00'
lastmod: '2025-07-13T16:09:40.455164'
related:
- stadistical-data-warehouse-del-european-central-bank-con-r-y-los-depositos-a-perdidas.md
- los-principales-problemas-de-los-espanoles-animaciones-con-r-y-gganimate.md
- trucos-simples-para-rstats.md
- analisis-de-textos-con-r.md
- leer-fichero-de-texto-de-ancho-fijo-con-python-pandas.md
slug: trucos-r-leer-archivos-xml-con-r
tags:
- Encoding
- R
- XML
- xmlToDataFrame
title: Trucos R. Leer archivos XML con R
url: /trucos-r-leer-archivos-xml-con-r/
---

Un truco de R práctico que busca la colaboración de los lectores para mejorarlo. Se trata de **leer ficheros xml con R**. Los más asiduos ya sabéis que paquete voy a emplear, el XML. En los últimos tiempos la sentencia _require(XML)_ aparece al principio de casi todos mis códigos en el **Tinn-R**. El ejemplo que ilustrará el truco lee de [la BBDD del banco mundial ](http://datos.bancomundial.org/)en español el indicador de emisiones de CO2 en toneladas por habitante y año. La sintaxis es de este modo:

```r
#Paquete necesario para leer XML

require(XML)

arch = "http://datos.bancomundial.org/sites/default/files/indicators/es/co2-emissions-metric-tons-per-capita_es.xml"

doc <- xmlTreeParse(arch,getDTD=T,addAttributeNamespaces=T)

arriba = xmlRoot(doc)

#Vemos los nombres de los campos de la tabla

names(arriba[[1]])
```

Leemos directamente de la web el documento XML. _xmlTreeParse_ crea la estructura del XML en R, de este modo podemos acceder a los datos. Lo primero que vamos a hacer es saber los nombres de las columnas que deseamos leer, para ello _xmlRoot_ obtiene los nodos raiz de la estructura que hemos leído. La función _names_ obtiene los nombres de las columnas de la tabla XML. El siguiente paso será crear un data frame con los datos de la tabla XML:

```r
#El parámetro colClasses nos facilita la lecturas

datos=xmlToDataFrame(arch,

colClasses=c("character", "character", "numeric" , "numeric"))

#Nos quedamos con datos posteriores al año 2000

datos=subset(datos,year>=2000)
```

La función del paquete XML de R que crea data frames a partir de tablas XML es _xmlToDataFrame_ , los parámetros principales que recibe son la tabla a transformar en data frame y _colClasses_ donde especificamos el tipo de dato que estamos leyendo (_numeric_ o _character_). No he sido capaz de leer los datos correctamente sin emplear _colClasses_ , por ello apelo a los lectores por si encuentran una vía más cómoda para realizar este proceso. Sobre el data frame generado ya podemos realizar las operaciones más habituales, en este caso realizo un subconjunto de observaciones quedándome con aquellos datos posteriores al año 2000. Ahora tenemos que trabajar la codificación del fichero. Desconozco que codificación emplea el paquete XML para leer tablas, pero si hacemos _head(datos)_ podemos observar que AfganistÃ¡n no es la codificación que necesitamos. La **codificación** de los ficheros del banco mundial es **UTF-8** , estoy buscando como obtener este dato con R para que no sea necesario conocerlo a priori. Para modificar la codificación de un vector hemos de emplear la función R _Encoding_. Este truco se lo tenemos que agradecer a [Carlos ](http://www.datanalytics.com/blog/)y es imprescindible para trabajar con vectores codificados. Vamos a separar el campo _country_ creando un vector de caracteres al que codificaremos como deseamos:

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

Hemos separado country en un vector de caracteres que codificamos como UTF-8 con _Encoding_. Ese vector lo unimos con nuestro data frame inicial y ya tenemos una tabla con la que podemos trabajar.

`boxplot(value~year, ylab="Toneladas per cápita", xlab="Año", data=datos)`

Espero que os sea de utilidad. Saludos.