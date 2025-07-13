---
author: rvaquerizo
categories:
- Formación
- Monográficos
- R
date: '2020-09-01T02:56:06-05:00'
slug: tratamiento-y-procesado-de-imagenes-con-r-y-magick
tags:
- magick
title: Tratamiento y procesado de imágenes con R y magick
url: /tratamiento-y-procesado-de-imagenes-con-r-y-magick/
---

[![](/images/2020/09/sean.gif)](/images/2020/09/sean.gif)

Estoy preparando la batalla entre geometría e inteligencia artificial, batalla que está perdida porque tengo que dar de comer a mis chavales y si tengo que ir a vender un producto queda más comercial contar lo que se supone que hace la inteligencia artificial y no contar lo que hacen vectores, direcciones, puntos en el espacio,… eso lo cuentan en la educación secundaria y no es «disruptivo». Sin embargo, aprovecho para contar historia del abuelo, el único proyecto serio basado en inteligencia artificial en el que he estado involucrado se resolvió gracias a la geometría y a las mejoras que se propusieron en el reconocimiento óptico, las redes convolucionales nos provocaron un problema. Inicialmente es mejor plantear una solución sencilla. 

En esta batalla perdida que he entablado con algún modelo de Tensorflow apareció el paquete magick de R para el procesamiento de imágenes con R y es sencillo y tiene un pequeño manual en español (<https://www.datanovia.com/en/blog/easy-image-processing-in-r-using-the-magick-package/>) además recientemente fue el cumpleaños de Sean Connery y voy a aprovechar para hacerle un pequeño homenaje. 

La imagen de trabajo la saqué de este tweet: 

> Hoy cumple 90 el gigante de Sean Connery.  
> El papá de Indiana Jones!  
> El capitán del Oktubre Rojo!  
> El monje del Nombre de la Rosa!  
> El prisionero de Alcatraz!  
> El maestro de Highlander!  
> El policía de los Intocables!  
> El agente 007!
> 
> 90 años es poco para tantas vidas ❤️ [pic.twitter.com/gxr7b4Taoo](https://t.co/gxr7b4Taoo)
> 
> — Gonzalo Frasca (@frascafrasca) [August 25, 2020](https://twitter.com/frascafrasca/status/1298395116013604869?ref_src=twsrc%5Etfw)

Es una imagen grande 2048×1147 pixel que guardé en mi equipo y que se lee así:

```r
library(dplyr)
library(magick)
ub = "C:\\Users\\rvaquerizo\\Pictures\\sean_connery.jpg"
sean = image_read(ub)
image_info(sean)
plot(sean)
```
 

Tenemos 5 imágenes de Sean Connery en una así pues será necesario seleccionar y estandarizar cada una de las imágenes para que la unión sea más homogénea:

```r
sean_1 <- sean %>% image_crop( "400x620+0+100") %>% image_scale("x300") %>%
  image_border(color = "grey", geometry = "5x5")
sean_2 <- sean %>% image_crop( "380x450+430+20") %>% image_scale("x300") %>%
  image_border(color = "grey", geometry = "5x5")
sean_3 <- sean %>% image_crop( "400x750+826+0") %>% image_scale("x300") %>%
  image_border(color = "grey", geometry = "5x5")
sean_4 <- sean %>% image_crop( "400x580+1226+50") %>% image_scale("x300") %>%
  image_border(color = "grey", geometry = "5x5")
sean_5 <- sean %>% image_crop( "400x450+1635+0") %>% image_scale("x300") %>%
  image_border(color = "grey", geometry = "5x5")
plot(sean_1)
```
 

Con image_crop vamos a cortar las imágenes del siguiente modo width x height + donde empiezo por la izquierda + donde empiezo por arriba. En el momento en el que habéis cortado 3 imágenes le cogéis el aire enseguida, no cuesta. Con image_scale le damos a todas las imágenes la misma escala, para nuestro ejercicio puede ser redundante pero está bien que lo sepamos. Por último vamos a añadir un borde con image_border es una cuestión estética.

Ya tenemos 5 imágenes similares y podemos realizar una animación pasando una tras otra:

```r
image_resize(c(sean_1, sean_2, sean_3, sean_4, sean_5), '300x300!') %>%
  image_background('grey') %>%
  image_morph() %>%
  image_animate(fps=5)
```
 

image_resize ya realiza la homogeneización de las 5 imágenes de Sir Connery, por eso comentaba la redundancia. Ponemos un fondo con image_background, la combinación entre image_morph e image_animate realiza la animación donde hemos puesto la opción fps (frames por segundo) para que no pasen tan rápido. Desde mi punto de vista la forma más sencilla de realizar animaciones. Por cierto, a la hora de guardar la imagen lo hago desde el navegador.