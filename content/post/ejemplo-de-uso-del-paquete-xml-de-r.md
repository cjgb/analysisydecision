---
author: rvaquerizo
categories:
  - formación
  - r
  - trucos
date: '2010-06-08'
lastmod: '2025-07-13'
related:
  - resultados-de-la-liga-con-rstats-estudiando-graficamente-rachas.md
  - alineaciones-de-equipos-de-futbol-con-worldfootballr-de-rstats.md
  - truco-r-insertar-imagen-en-un-grafico.md
  - trucos-r-leer-archivos-xml-con-r.md
  - los-principales-problemas-de-los-espanoles-animaciones-con-r-y-gganimate.md
tags:
  - plotrix
  - xml
title: Ejemplo de uso del paquete XML de R
url: /blog/ejemplo-de-uso-del-paquete-xml-de-r/
---

Quería poneros unos apuntes sobre el paquete `XML` de `R`. El caso es que, entre todos los fregados en los que ando metido, he retomado el tema de leer páginas web con `R`. Y con esto he llegado a la sentencia `install.packages("XML")` y, con la fiebre mundialista, estoy en lo siguiente:

```r
library(XML)
pag <- "http://es.wikipedia.org/wiki/Anexo:Finales_de_la_Copa_Mundial_de_F%C3%BAtbol"
# readHTMLTable devuelve una lista de tablas
tablas <- readHTMLTable(pag)
pagina <- data.frame(tablas[[1]])

ganador <- data.frame(substr(pagina$Ganador, 3, nchar(as.character(pagina$Ganador))))
names(ganador) <- "primero"

segundo <- data.frame(substr(pagina$Segundo.puesto, 3, nchar(as.character(pagina$Segundo.puesto))))
names(segundo) <- "segundo"
```

Muy sencillo: leemos la Wikipedia y nos creamos un objeto con las finales de todos los mundiales. Me voy a centrar en los finalistas. Parece que tengo algún problema con las tildes y con nulos. Grafiquemos un poco:

```r
ganador <- subset(ganador, nchar(as.character(primero)) > 0)
segundo <- subset(segundo, nchar(as.character(segundo)) > 0)

library(plyr)
tabla <- ddply(ganador, "primero", summarise, veces = length(primero))

library(plotrix)
pie3D(tabla$veces, labels = tabla$primero, main = "Campeones históricos")
```

Vemos que, al final, esto siempre lo ganan los mismos. Nos facilita una predicción. Veamos los finalistas:

```r
finalistas <- data.frame(rbind(
  as.matrix(ganador, dimnames = list("finalista")),
  as.matrix(segundo, dimnames = list("finalista"))
))

# Suponiendo que queremos contar finalistas totales
tabla_finalistas <- ddply(finalistas, "primero", summarise, veces = length(primero))
pie3D(tabla_finalistas$veces, labels = tabla_finalistas$primero, main = "Finalistas")
```

Un poco vago con el nombre de las variables. A la vista de los datos, la final será Brasil – Argentina. Lo que no tengo tan claro es cuál ganará… Seguiremos trabajando con `XML` y con `plotrix`.
