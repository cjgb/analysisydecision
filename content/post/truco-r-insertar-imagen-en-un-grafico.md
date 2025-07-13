---
author: rvaquerizo
categories:
- Formación
- R
- Trucos
date: '2010-06-22T11:07:19-05:00'
lastmod: '2025-07-13T16:07:56.239262'
related:
- truco-r-anadir-una-marca-de-agua-a-nuestro-grafico-con-ggplot2.md
- mapa-de-argentina-con-r.md
- mapas-con-spatial-data-de-r.md
- trucos-r-graficos-de-velocimetro-con-r.md
- truco-r-paletas-de-colores-en-r.md
slug: truco-r-insertar-imagen-en-un-grafico
tags:
- rimage
- TeachingDemos
title: Truco R. Insertar imagen en un gráfico
url: /truco-r-insertar-imagen-en-un-grafico/
---

Quería pintaros mi estimación sobre el mundial de Sudáfrica con R. La he hecho con el corazón más que con la cabeza. Es evidente que no será así. Esta estimación la pinto utilizando dos paquetes de R más que interesantes. El rimage no está en CRAN, es una cosa muy rara, un paquete «propietario» pero que tiene la función read.jpeg que permite crear objetos de imagen en R. El otro paquete interesante es el TeachingDemos que nos permite añadir imágenes a los gráficos de R, me acerqué a él cuando esta web tenía un logo, ahora ya no lo tiene. También me parece que puede ser de utilidad la función download.file

El caso es que a continuación os planteo un código de R que puede añadir mucha vistosidad a vuestros gráficos:

```r
#Nos descargamos una imagen de la bandera de España
imagen = "http://www.google.es/images?q=tbn:6ZQixmSQWTr3-M::ohmycat.files.wordpress.com/2008/07/20071012130705-bandera-espana.jpg&h=94&w=141&usg=__CMSfd8xxAbtQrzMnRV7lFfDSdFY="
destino <- paste(tempfile(),'.jpg', sep='')
download.file(imagen, destino, mode="wb")
#Leemos jpeg con rimage
library(rimage)
esp <- read.jpeg(destino)
#Nos descargamos una imagen de la bandera de Argentina
imagen = "http://www.google.es/images?q=tbn:aBXCKunAyiSI2M::www.manuelbelgrano.gov.ar/img/bandera_bandera.jpg&h=94&w=150&usg=__pOnmgvNd7D0HU906KNiYGV59GW8="
destino <- paste(tempfile(),'.jpg', sep='')
download.file(imagen, destino, mode="wb")
#Leemos jpeg con rimage
arg <- read.jpeg(destino)
#Nos descargamos una imagen de la bandera de Mexico
imagen = "http://t1.gstatic.com/images?q=tbn:de-Fks--KqYUZM:http://cocn.tarifainfo.com/blogs/media/blogs/photo/bandera-mexico.jpg"
destino <- paste(tempfile(),'.jpg', sep='')
download.file(imagen, destino, mode="wb")
#Leemos jpeg con rimage
mexico <- read.jpeg(destino)
```
 

Nos hemos descargado 3 banderas y las hemos guardado como objetos de R. Ahora hemos de pintar un podium:

```r
#Pintamos el podium
plot(c(1,1),c(1,2),type="l",xlim=c(0,5),ylim=c(0,5),
lwd=2,col="red",axes="F",xlab=" ",ylab=" ")
points(c(1,2),c(2,2),type="l",lwd=3,col="red")
points(c(2,2),c(2,3),type="l",lwd=3,col="red")
points(c(2,3),c(3,3),type="l",lwd=3,col="red")
points(c(3,3),c(2,3),type="l",lwd=3,col="red")
points(c(2,3),c(3,3),type="l",lwd=3,col="red")
points(c(3,4),c(2,2),type="l",lwd=3,col="red")
points(c(4,4),c(2,1),type="l",lwd=3,col="red")
```
 

Y ahora ponemos mi estimación:

```r
#Le añadimos mi estimación...
library(TeachingDemos)
subplot(plot(esp),2.5,3.5)
subplot(plot(mexico),1.3,2.5)
subplot(plot(arg),3.7,2.5)
```
 

¿Imposible? Seguramente, pero todavía hay esperanza.

Saludos.