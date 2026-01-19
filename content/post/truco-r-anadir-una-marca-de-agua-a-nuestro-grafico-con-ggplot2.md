---
author: rvaquerizo
categories:
  - formación
  - monográficos
  - r
date: '2014-12-17'
lastmod: '2025-07-13'
related:
  - truco-r-insertar-imagen-en-un-grafico.md
  - incluir-subplot-en-mapa-con-ggplot.md
  - trucos-r-graficos-de-velocimetro-con-r.md
  - descubriendo-ggplot2-421.md
  - graficos-de-burbuja-con-r.md
tags:
  - ggplot2
title: Truco R. Añadir una marca de agua a nuestro gráfico con ggplot2
url: /blog/truco-r-anadir-una-marca-de-agua-a-nuestro-grafico-con-ggplot2/
---

[![](/images/2014/12/marca_agua_R.png)](/images/2014/12/marca_agua_R.png)

Un breve truco que tenía en la nevera. Añadir marcas de agua a los gráficos de R realizados con ggplot2. Quería dedicar una serie de monográficos a las marcas de agua y al final nunca acabé. Para ilustrar el ejemplo vamos a graficar la serie de visitas a esta web que nos ha dado Google Analytics:

```r
# Objeto con las visitas
visitas=c(213,376, 398, 481,416, 505, 771, 883,686, 712 ,
883,993,1234 , 1528 ,1965 ,1676 ,1037 , 1487 ,1871 ,2725 ,2455 ,2856 ,
2868,2809 ,3326 ,4284 ,4599 ,3863 ,3778 ,5090 ,5510 ,5911 ,4460 ,5495 ,5290 ,
6407,5619 ,6494 ,5854 ,4940 , 4735 ,6049 ,6839 ,8695 ,7112 ,9207 ,8991 ,
10909 , 9647 , 10943 , 9819 , 8982 ,
8597,10004,12550,12025, 9108,10664, 9563,9751 ,11402 ,11875,10395,
10078,8706,10893, 13197,12868 ,9857 ,12119 , 13421 ,14411, 12820 , 14443 , 12713 ,
13869,11740,14887,17021,16827)
serie <- ts(visitas, start=c(2008, 4), end=c(2014, 11), frequency=12)
```

Hemos creado un objeto serie temporal del tipo ts y aprovecho esta entrada para contaros como transformar un objeto ts en un data frame. Recordamos que ggplot2 no puede graficar objetos ts (por lo menos hasta donde yo sé). Para la transformación del objeto emplearemos la función index del paquete zoo y mi querida función melt de reshape2:

```r
#Pasar de objeto ts a data frame
library(reshape2)
library(zoo)
serie.nueva <- data.frame( anio = index(serie),
                           visitas = melt(serie)$value)
```

Ahora disponemos de un data frame con el que podemos pintar la serie:

```r
#Ya podemos graficar el data frame
library(ggplot2)
graf <- ggplot(data=serie.nueva,aes(anio,visitas))  + geom_line() +
  labs(list(title = "Visitas a www.analsisisydecision.es",
        x = "Mes de la visita", y = "Número de visitas"))
```

```r
graf + annotate("text", x = Inf, y = -Inf, label = "www.analisisydecision.es",
                hjust=1, vjust=-0.30, col="blue", cex=7, alpha = 0.3)
```

Para pintar la marca de agua empleamos annotate y añadimos un texto:

```r
graf + annotate("text", x = Inf, y = -Inf, label = "www.analisisydecision.es",
hjust=1, vjust=-0.30, col="blue", cex=7, alpha = 0.3)
```

Buscamos una correcta colocación y por supuesto ponemos una marca transparente (alpha). El resultado el que tenéis arriba. En el caso de que deseemos poner una imagen como marca de agua:

```r
library(grid)
library(png)
```

```r
img <- readPNG("C:\\Documents and Settings\\varaul\\Mis documentos\\Mis imágenes\\raul.PNG", FALSE)
marca <- rasterGrob(img, interpolate=F,height=unit(3, "cm"),hjust=-1.55, vjust=2.4)
graf + annotation_custom(marca,xmin=-Inf, xmax=Inf, ymin=-Inf, ymax=Inf)
```

[![](/images/2014/12/marca_agua_R2.png)](/images/2014/12/marca_agua_R2.png)

La librería png nos permite leer la imagen. La función rasterGrob es la que da el formato, una imagen de 3 cm colocada en la parte inferior derecha, con estos datos tenéis que jugar un poco para que os quede bien. Por último empleamos annotation_custom para añadir la imagen. Con todas estas premisas podemos obtener un gráfico como el anterior donde aparece un señor bastante feo, la imagen me desmerece. En este caso sería interesante poner una imagen transparente, pero hay que montar un lío bastante serio para buscar ese _alpha_. Tras varios intentos yo sería partidario de que la imagen ya tuviera la transparencia deseada. Si a algún lector se le ocurre como hacerlo en menos de 20 líneas de código incomprensible que por favor lo ponga. Espero que os sirva de ayuda. Saludos.
