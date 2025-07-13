---
author: rvaquerizo
categories:
- Consultoría
- Formación
- Monográficos
- R
date: '2017-01-25T07:08:32-05:00'
slug: ejemplo-de-web-scraping-con-r-la-formacion-de-los-diputados-del-congreso
tags:
- text mining
- web scraping
title: Ejemplo de web scraping con R. La formación de los diputados del Congreso
url: /ejemplo-de-web-scraping-con-r-la-formacion-de-los-diputados-del-congreso/
---

![](https://www.congreso.es/wc/htdocs/web/img/logo.gif)

No sabía si realizar esta entrada sobre web scraping con R o con python. He obtado por la primera opción porque en un principio era una entrada para ilustrar un ejemplo de web scraping y al final se me están ocurriendo muchas ideas sobre el análisis de [la web de Congreso de los diputados](http://www.congreso.es/portal/page/portal/Congreso/Congreso) y he preferido hacerla con R porque tengo una mayor soltura para hacer distintos análisis. Quería empezar por estudiar la formación que tienen nuestros 350 diputados, para ello se me ocurrió descargarme las líneas que tienen en su ficha de diputado y crear un data frame con los datos personales referentes a su formación. Si entráis en la ficha de cualquier diputado ([http://www.congreso.es/portal/page/portal/Congreso/Congreso/Diputados/BusqForm?_piref73_1333155_73_1333154_1333154.next_page=/wc/fichaDiputado?idDiputado=171&idLegislatura=12](http://www.congreso.es/portal/page/portal/Congreso/Congreso/Diputados/BusqForm?_piref73_1333155_73_1333154_1333154.next_page=/wc/fichaDiputado?idDiputado=171&idLegislatura=12)) veréis que les han dejado un pequeño texto donde describen su hoja de vida. La verdad es que cada uno a escrito lo que le ha parecido pero algún patrón se puede encontrar. Para ilustrar el ejemplo he preferido usar [la librería rvest](https://blog.rstudio.org/2014/11/24/rvest-easy-web-scraping-with-r/) porque me ha parecido una sintaxis más sencilla. Yo no soy un buen programador, incluso soy un poco desastre, hasta guarrete programando y con rvest creo que el código es bastante claro.

El procedimiento para el web scraping será el siguiente:

  1. Identificar en la web del Congreso como funciona el formulario para cambiar de diputado, es sencillo basta con ver el link y tenemos **fichaDiputado?idDiputado=171 &idLegislatura=12″** es evidente que vamos a crear un bucle con el idDiputado.
  2. Que parte corresponde con el curriculum de cada personaje, esta parte también es sencilla, véis el código fuente y hay un bloque de contenido identificado como  
**div id=»curriculum»** esta es la parte que nos interesa.
  3. Tenemos que limpiar con alguna función de R el HTML y el texto que estamos «escrapeando».
  4. Lo ponemos todo en un data frame por si queremos analizarlo.

Esta es la idea y se traduce en R del siguiente modo:

```r
library(rvest)

curriculos = ""
for (dip in seq(1,350,by=1)){
url = paste0("http://www.congreso.es/portal/page/portal/Congreso/Congreso/Diputados/BusqForm?_piref73_1333155_73_1333154_1333154.next_page=/wc/fichaDiputado?idDiputado=",dip,"&idLegislatura=12")

congreso <- read_html(url)
curric <- congreso %>%
html_node("#curriculum") %>%
html_text %>%
strsplit(split = "\n") %>%
unlist() %>%
.[. != ""]
#Pequeña limpieza de texto
curric <- trimws(curric)
#Elimina las líneas sin contenido
curric <- curric[which(curric!="")]
#Nos quedamos justo con la linea que hay debajo de la palabra legislaturas
linea <- curric[grep("legislatura", curric)+1]
curriculos <- rbind(curriculos,linea)}

curriculos <- data.frame(curriculos[-1])
```
 

Ya podéis ver que la elegancia programando brilla por su ausencia pero queda todo muy claro. Particularidades, para identificar la formación dentro del texto libre he seleccionado aquellas líneas que están debajo de la palabra legislaturas, no he encontrado mejor forma y soy consciente de que falla, es suceptible de mejora. La función read_html de rvest es la que lee la web, el contenido que nos interesa lo seleccionamos con html_node pero es necesario que sea un texto y por eso aparece html_text y por último particionamos el texto en función de los /n. Con el texto más o menos formateado pasamos la función TRIMWS que se cepilla los espacios en blanco, tabuladores y saltos de línea. Tenía que meter esta función con calzador porque me parece útil para limipar textos con R y este ejemplo ilustra el funcionamiento. Para finalizar eliminamos las líneas vacías del texto con Which. Acumulamos las líneas con la formación de cada diputado y creamos el data frame curriculos que contiene lo que ellos han escrito como su formación.

No he trabajado mucho con ello, pero podemos buscar la palabra que más se repite [replicando algún código ya conocido](https://analisisydecision.es/analisis-del-programa-electoral-del-partido-popular-antes-de-las-elecciones-en-espana/):

```r
palabras = strsplit(curriculos, split=" ")
palabras = as.character(unlist(palabras))
palabras = data.frame(palabras)
names(palabras) = c("V1")
palabrasV1 = sub("([[:space:]])","",palabrasV1)
palabrasV1 = sub("([[:digit:]])","",palabrasV1)
palabrasV1 = sub("([[:punct:]])","",palabrasV1)
palabraslargo = nchar(palabrasV1)
palabras = subset(palabras, largo>4)

library(plyr)
conteo = data.frame(ddply(palabras, "V1",summarise, cuenta=length(V1) ))
conteo = conteo[order(-conteo$cuenta),]
```
 

Aproximadamente el 28% de los diputados son licenciados en derecho, no veo ingenierías por ningún sitio y muchos casados y ayuntamientos… No voy a valorar lo poco que he explorado pero es evidente que nos representan personas con una experiencia profesional muy acotada en las instituciones públicas (que forma más bonita de decir personas poco productivas). Seguiré escrapeando esta web os lo prometo.