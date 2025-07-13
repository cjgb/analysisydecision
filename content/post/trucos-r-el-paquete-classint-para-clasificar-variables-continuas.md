---
author: rvaquerizo
categories:
- Formación
- Monográficos
- R
- Trucos
date: '2015-07-02T01:47:57-05:00'
lastmod: '2025-07-13T16:09:33.224315'
related:
- trucos-r-graficos-de-velocimetro-con-r.md
- truco-r-paletas-de-colores-en-r.md
- capitulo-5-representacion-basica-con-ggplot.md
- graficos-de-barras-y-lineas-en-dos-ejes-con-r.md
- informes-con-r-en-html-comienzo-con-r2html-i.md
slug: trucos-r-el-paquete-classint-para-clasificar-variables-continuas
tags:
- classInt
- RColorBrewer
title: Trucos R. El paquete classInt para clasificar variables continuas
url: /trucos-r-el-paquete-classint-para-clasificar-variables-continuas/
---

El paquete **classInt** de R últimamente está muy presente en mis programas y me gustaría dedicarle unas líneas para que podáis ver algunas de sus posibilidades a la hora de clasificar variables continuas, además estas posibilidades unidas con **RColorBrewer** nos permiten crear gráficos muy atractivos. Instalamos y clasificamos un vector de ejemplo:

```r
aleatorio <- abs(rnorm(100,50,30))
summary(aleatorio)
grupos <- 4
clases <- classIntervals(aleatorio, grupos, style="quantile")
clases

style: quantile
one of 156,849 possible partitions of this variable into 4 classes
[1.225299,29.19317) [29.19317,51.55524) [51.55524,72.06471) [72.06471,118.6466]
25                 25                 25                 25
```
 

Partimos un vector aleatorio en 4 clases en función de sus cuantiles y creamos un lista clases que contiene nuestra tabla y entre sus atributos destaca brks que indica los puntos de corte, en el caso de los cuantiles tenemos:

```r
clases$brks
quantile(aleatorio)
```
 

Coinciden el atributo brks (los cortes de nuestra clasificación) y los cuantiles de nuestro vector. Este paquete lo estoy empleando conjuntamente con RcolorBrewer para la realización de gráficos:

```r
library(RColorBrewer)
paleta <- brewer.pal(grupos,"Reds")

colores = findColours(clases, paleta)
pie(attributes(colores)$table,
main="Ejemplo de classInt",col=colores)
```
 

Hay que pararse en el objeto colores que creamos con la función findColours:

```r
>str(colores) atomic [1:100] #FCAE91 #CB181D #FCAE91 #FB6A4A ... - attr(*, "palette")= chr [1:4] "#FEE5D9" "#FCAE91" "#FB6A4A" "#CB181D" - attr(*, "table")= 'table' int [1:4(1d)] 25 25 25 25 ..- attr(*, "dimnames")=List of 1 .. ..$ : chr [1:4] "[1.225299,29.19317)" "[29.19317,51.55524)" "[51.55524,72.06471)" "[72.06471,118.6466]"
```
 

Es un objeto con los colores por elemento del vector pero además contiene los colores y los atributos necesarios para poder realizar el gráfico como es la tabla y las posibles etiquetas del gráfico. Si deseamos modificar las etiquetas o leyendas en los gráficos yo recomiendo trabajar con el atributo brks del objeto classInt, en este caso clases:

```r
colores = findColours(clases, paleta)
#Ponemos etiquetas
brks <- round(clasesbrks,2)
etiquetas = paste(brks[-(grupos+1)],'% - ', brks[-1],'%')
pie(attributes(colores)table,
main="Ejemplo de classInt",col=colores,labels=etiquetas)
```
 

El objeto etiquetas lo generamos recorriendo los elementos de brks de forma que unimos el primero con el segundo, el segundo con el tercero,… así en función del número de grupos que estemos etiquetando, también le damos un formato más elegante redondeando a 2 decimales y le añadimos un % con estas modificaciones obtenemos un gráfico más elegante.

También destacar que podemos clasificar datos con otros “estilos” trabajando con la opción style de classIntervals. Por ejemplo si deseamos fijar nosotros los intervalos empleamos style=”fixed” pero es necesario añadir fixedBreaks:

```r
clases <- classIntervals(aleatorio, grupos,
style="fixed",fixedBreaks=c(0, 50, 75, 100, 200))
clases
colores = findColours(clases, paleta)
#Ponemos etiquetas
brks <- round(clasesbrks,2)
etiquetas = paste(brks[-(grupos+1)],'% - ', brks[-1],'%')
pie(attributes(colores)table,
main="Ejemplo de classInt",col=colores,labels=etiquetas)
```
 

En fixedBreaks tendremos que poner siempre inicio-fin en este caso 4 grupos necesitan 5 elementos para realizar los cortes. Disponemos de otros estilos de particionamiento de datos entre los que me gusta personalmente el kmeans:

```r
grupos <- 4
clases <- classIntervals(aleatorio, grupos, style="pretty")
clases

grupos <- 4
clases <- classIntervals(aleatorio, grupos, style="kmeans")
clases
```
 

Espero que este monográfico sobre classInt sea de vuestro interés, en próximas entregas del blog veremos más usos. Saludos.