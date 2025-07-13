---
author: rvaquerizo
categories:
- Formación
- Monográficos
- R
date: '2011-05-22T10:49:46-05:00'
slug: un-repaso-a-los-paquetes-de-r-solar-chron-directlabels-y-graficos-de-densidades-con-lattice
tags:
- as.yearmon
- chron
- densityplot
- directlabels
- is.weekend
- lattice
- solaR
- weekday
title: Un repaso a los paquetes de R solaR, chron, directlabels y gráficos de densidades
  con lattice
url: /un-repaso-a-los-paquetes-de-r-solar-chron-directlabels-y-graficos-de-densidades-con-lattice/
---

Y además vamos a analizar si de verdad llueve más los fines de semana en Madrid. Hace tiempo que me gustaría estudiar la influencia de la contaminación en algunos fenómenos atmosféricos. Por supuesto no tengo tiempo para elaborar un estudio de ese tipo. La base de este estudio iba a ser el [paquete solaR](http://procomun.wordpress.com/software/solar/). Por otro lado quería elaborar un monográfico sobre el [paquete chron](http://cran.r-project.org/web/packages/chron/chron.pdf) que contiene funciones muy interesantes para el manejo de fechas. Sin tiempo es imposible, por ello nos vamos a acercar a estos dos paquetes con un ejemplo y de propina os presento [directlabels ](http://directlabels.r-forge.r-project.org/docs/index.html)otro paquete muy interesante para añadir etiquetas a nuestros gráficos.

Nuestro trabajo va a comenzar con la descarga de datos agroclimáticos con **solaR**. Este paquete nos permite conectarnos con el SIAR ([descripción](http://www.mappinginteractivo.com/plantilla-ante.asp?id_articulo=177)) Sistema de Información Agroclimática para el Regadío:

```r
library(solaR)

siar = readMAPA(prov=19, est=9, start='01/01/2000', end='22/05/2011')

#str(siar)

datos = data.frame(siar@data$Precipitacion)

names(datos)="lluvias"
```

La función _readMAPA_ como Dora la Exploradora se conecta a [MAPA ](http://www.mapa.es/siar/Informacion.asp) y nos permite descargarnos una gran cantidad de datos. Por cierto, para ver MAPA usad IE. Esta función requiere la provincia (_prov_), la estación (_est_), fecha inicial y fecha final de la extracción. La estación más cercana a mi hogar está en Marchamalo Guadalajara. Para saber las estaciones usad los datos de la consulta que lanzáis en la web. Para el ejemplo sólo nos quedamos con las precipitaciones y creamos un _data.frame_ con lluvias y fechas como nombres de filas. Ahora hemos de trabajar con las fechas y para ello empleamos **chron** :

```r
library(chron)

datosdia = factor(weekdays(as.Date(row.names(datos),"%Y-%m-%d")))

datosmes = factor(as.yearmon(row.names(datos)))

datos$finde = factor(ifelse(is.weekend(as.Date(row.names(datos),"%Y-%m-%d")),"FINDE","RESTO"))

summary(datos)
```

Los nombres de fila de nuestro _data.frame_ los transformamos en 3 factores. Con **weekday**(es una función del paquete Base) obtenemos el día de la semana a partir de una fecha. La función **as.yearmon** nos crea una variable MES-AAAA y la función **is.weekend** toma valores 1 y 0 si se trata de fin de semana. Ahora tenemos que estudiar si se produce una diferencia entre las precipitaciones los fines de semana y entre semana. Esto se hace con un análisis de la varianza, pero nosotros vamos a emplear **lattice** para crear un gráfico de densidades por meses con R:

```r
library(lattice)

densityplot( ~ lluvias | mes , data = datos, groups=finde  ,

layout = c(3, 4), xlab = "Estevita", bw = 2, plot.points = FALSE)
```

El resultado:

[![lluvias-1.png](/images/2011/05/lluvias-1.thumbnail.png)](/images/2011/05/lluvias-1.png "lluvias-1.png")

Echamos de menos un etiquetado para el gráfico de densidades que hemos creado con _densityplot_ , para ello vamos a emplear **directlabels** :

```r
#install.packages("directlabels")

library(directlabels)

densidades = densityplot( ~ lluvias | mes , data = datos, groups=finde  ,

layout = c(3, 4), xlab = "Estevita", bw = 2, plot.points = FALSE)

direct.label(densidades)
```

El resultado es:

[![lluvias-2.png](/images/2011/05/lluvias-2.thumbnail.png)](/images/2011/05/lluvias-2.png "lluvias-2.png")

Este gráfico es claramente mejorable, además incluye un error pero mi hijo acaba de entrar por la puerta lleno de tierra con una espátula y… En fin, los resultados obtenidos son interesantes. Como ejercicio os dejo lo siguiente: réplica del gráfico con ggplot2 y análisis de la varianza.