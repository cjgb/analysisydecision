---
author: rvaquerizo
categories:
  - consultoría
  - formación
  - opinión
  - r
date: '2019-08-26'
lastmod: '2025-07-13'
related:
  - stadistical-data-warehouse-del-european-central-bank-con-r-y-los-depositos-a-perdidas.md
  - leer-y-representar-datos-de-google-trends-con-r.md
  - evita-problemas-con-excel-desde-r-de-tocar-el-dato-a-un-proceso.md
  - analisis-de-textos-con-r.md
  - beatifulsoup-web-scraping-con-python-o-como-las-redes-sociales-estan-cambiando-mi-forma-de-escribir.md
tags:
  - gganimate
  - ggplot2
  - xml
title: Los principales problemas de los españoles. Animaciones con R y gganimate
url: /blog/los-principales-problemas-de-los-espanoles-animaciones-con-r-y-gganimate/
---

![Problemas_españoles.gif](/images/2019/08/Problemas_espa%C3%B1oles.gif)

La realización de gráficos animados con `R`, `gganimate` y `ggplot2` es algo que quiero empezar a trabajar en mis visualizaciones de datos, una buena forma de llamar la atención sobre nuestros gráficos. Para ilustrar el ejemplo he recogido los datos que publica mensualmente el CIS con las 3 principales preocupaciones de los españoles que podéis encontrar en [este enlace](http://www.cis.es/cis/export/sites/default/-Archivos/Indicadores/documentos_html/TresProblemas.html), por cierto, este enlace tiene toda la pinta de ser una salida en SAS, no me parece muy apropiado pero no diré nada porque imagino que serán lectores del blog (ya podíais hacer una salida más acorde con los tiempos). El caso es que la primera parte de nuestro trabajo será el «scrapeado» de la web. Scrapear verbo regular de la primera conjugación:

```r
library(XML)
library(dplyr)
library(lubridate)

#Lectura de los datos del CIS
url <- "http://www.cis.es/cis/export/sites/default/-Archivos/Indicadores/documentos_html/TresProblemas.html"
doc = htmlParse(url,  encoding = "UTF-8")
tableNodes = getNodeSet(doc, "//table")

#Leemos la tabla que tiene un formato un tanto peculiar
problemas <- readHTMLTable(tableNodes[[2]], skip.rows=1)
problemas <- problemas %>% filter(!is.na(V1))

#Transformamos los puntos en 0, parece que estuviera hecho con SAS
haz.cero.na=function(x){ifelse(x==".",0,as.numeric(as.character(x)))}

problemas <- cbind.data.frame(as.character(problemas$V1),sapply(problemas,haz.cero.na),stringsAsFactors=FALSE)
problemas <- problemas %>% select(-V1)

#El primer elemento de la tabla contiene los nombres que vamos a emplear
nombres <- readHTMLTable(tableNodes[[2]])[1,]
nombres$V1="Problema"
nombres <- as.vector(t(nombres))

names(problemas) <- nombres

#Hay un registro en la tabla que tiene el número de encuestas, no es necesario
problemas <- filter(problemas,Problema != "(N)")
```

Cosas interesantes en el código. Hacemos `HTMLParse` de la web y nos quedamos con las `tablas`, en este caso la segunda, en ese sentido la salida de SAS es sencilla de manipular. No entiendo muy bien por qué aparecen filas con todos los valores nulos, por eso se han eliminado. Como la salida es SAS los valores perdidos aparecen como un punto `.` y es necesario transformarlos a `0`, además aprovechamos para pasar de carácter a número y eliminar los factores. Para los nombres de las columnas seleccionamos el primer registro de la tabla que contiene las fechas de la obtención de las encuestas, ese único registro que está en un data frame lo transformamos a vector con la instrucción `as.vector(t())` una de las mejores formas de pasar de data frame a vector en R. Por último eliminamos del data frame aquellos registros cuyo problema es `(N)` ya que se trata del número de encuestados.

Tenemos un data frame con tantas columnas como meses con encuestas, ahora es necesario crear un data frame con los problemas mes a mes, además vamos a aprovechar para quedarnos sólo con los 10 principales problemas:

```r
#Leemos mes a mes y creamos un data frame por mes que vamos uniendo horizontalmente
for (i in 2:length(nombres)){
  mes = nombres[i]
  instruccion <- paste0('df <- problemas %>% arrange(desc(', mes,
                        ')) %>%  mutate(Problema = ifelse(row_number()>=11,"RESTO",Problema)) %>%
                          select(Problema,', mes, ') %>% group_by(Problema) %>% summarise(porcentaje=sum(',mes,')) %>%
                        mutate(mes = "',mes,'")%>% arrange(desc(porcentaje)) %>% mutate(rank=row_number())')
  eval(parse(text=instruccion))
  if (i == 2) {resultado <- df}
  else {resultado <- rbind.data.frame(df,resultado)}
}

#A la hora de realizar la animación es mejor disponer de fechas por lo que tenemos que transformar
resultado$mes <- parse_date_time2(resultado$mes, orders = "my")
```

Es una función que lee mes a mes nuestros datos y va generando un data frame acumulado con el tratamiento deseado para los meses. Como programador SAS que he sido durante muchos años me parece muy sencillo el uso de macros y por eso suelo abusar del `eval(parse(text=instrucción))` sólo hay que poner talento en la creación de esa instrucción y en la realización de un bucle que recorra los elementos. Para hacer estos procesos siempre es lo mismo, haces el de un mes aislado y después donde pones el mes pones un parámetro. Bajo mi prisma es muy sencillo, es probable que algún compañero diga que no es eficiente y otros que opinen que es un poco complicado pero los programas son como los resultados electorales nos gustan si sale lo que nosotros queremos y como nosotros queremos.

Ya estamos en disposición de realizar la animación con `ggplot2` y `gganimate`:

```r
#Ya estamos en disposición de realizar el gráfico
library(ggplot2)
library(gganimate)

#El primer y más importante paso es realizar el gráfico estático
estatico <- ggplot(resultado, aes(x=-rank, group=Problema, y=porcentaje,fill=Problema, color=Problema)) +
  geom_text(aes(y = 0, label = paste(Problema, " ")), vjust = 0.2, hjust = 1, size=4) +
  geom_bar(stat='identity')  + theme_minimal() + theme(legend.position = "none") +
  coord_flip(clip = "off", expand = TRUE) +
  scale_y_continuous(limits = c(0, 100)) +
  theme(plot.title = element_text(size = 14),plot.margin = margin(1,1,1,9, "cm"),
        axis.title.y=element_blank(), axis.text.y=element_blank(),  axis.ticks.y=element_blank())

# Especificamos la transición
p <- estatico + transition_manual(mes) + labs(title = "Mes de encuesta: {month(current_frame)}/{year(current_frame)}")

#Realizamos la animación
animate(p, fps = 0.7, width = 800, height = 600)
```

Para realizar animaciones con `gganimate` lo más importante es el gráfico estático, comprobad que tiene el formato que queréis. En este caso se representa un ranking ordenado de mayor a menor, sin embargo en el eje ponemos la descripción del problema (que es muy larga y susceptible de ser acortada), con `coord_flip` hacemos que sea un gráfico de barras horizontal, fijamos la escala del eje `y`, jugamos con los colores para que cada problema tenga siempre su color y eliminamos todos los elementos del eje `y` para que se vea la descripción del problema de la forma más clara posible. Con estos elementos hemos configurado el gráfico estático y ahora creamos la animación como una `transition_manual` (no funcionaba `transition_state`) y vemos como podemos jugar con el título y funciones de R. Por último creamos la animación donde el parámetro `fps` es el que nos permite regular la velocidad de transición. Todo este código estará colgado en el `github` de la web [https://github.com/analisisydecision](https://github.com/analisisydecision) para que me ayudéis a que quede mejor porque es cierto que quiero mejorar mis visualizaciones, pero no son bonitas, yo no tengo gusto para esas cosas. Además estaría bien jugar con las transiciones entre frames del gif.

En cuanto a lo que sale me gustaría no decir nada porque luego me llaman liberal pero vamos, que lo del paro es un tema recurrente porque el problema es la subvención de ese paro para obtener rédito político y nadie tiene valor a afrontar ese problema.
