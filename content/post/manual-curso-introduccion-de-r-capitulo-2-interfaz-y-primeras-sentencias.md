---
author: rvaquerizo
categories:
- Formación
- R
date: '2008-02-26T09:14:33-05:00'
slug: manual-curso-introduccion-de-r-capitulo-2-interfaz-y-primeras-sentencias
tags: []
title: 'Manual. Curso introducción de R. Capítulo 2: Interfaz y primeras sentencias'
url: /manual-curso-introduccion-de-r-capitulo-2-interfaz-y-primeras-sentencias/
---

En esta nueva entrega del curso comenzamos a trabajar con R. Ya nos hemos descargado e instalado la herramienta y es momento de conocer a grandes rasgos como funciona R. Si abrimos una sesión nos encontramos con la siguiente pantalla:

![](/images/2008/02/interfaz_r.JPG)

El interfaz de R no es visual, trabajamos sobre una línea de comandos, no hay ventanas, sólo código y una gran comunidad de programadores que crean sus funciones y sus paquetes de utilidades. Para empezar a manejar R lo principal es conocer sus elementos principales **objetos y funciones** :  

```r
> objeto <- c(2,3,4) # creamos un objeto vector

> mean(objeto) # hacemos la media del vector con la función mean

[1] 3

>
```

Sobre la línea de comandos generaremos objetos y funciones, las funciones llamarán objetos. Los objetos pueden ser vectores (_c_) o matrices (_matrix)_ y dentro de las matrices tendremos estructuras más complejas que serán tablas _(data.frame_)_:_

```r
> objeto <- c(2,3,4) # creamos un objeto vector

> matriz <- matrix(c(2,3,4,5,6,7),ncol=2) #objeto matriz

> filas<-c("Fila 1","Fila 2","Fila 3") # vector de filas

> columnas<-c("Fila","Columna 1","Columna 2")

> tabla<-data.frame(filas,matriz) #objeto tabla (data frame)

> names(tabla)<-columnas #el vector columnas asigna el nobre de las columnas

> tabla #visualizamos el objeto

  Fila Columna 1 Columna 2

1 Fila 1 2 5

2 Fila 2 3 6

3 Fila 3 4 7

>
```

De este modo creamos objetos en R, el data frame se crea como una combinación de una matriz con varios vectores. PAra asignar los nombres a las columnas se emplea la función _names( <vector>)_ Para visualizarlos sólo hemos de poner el nombre del objeto, si deseamos ver los objetos que hemos creado emplearemos la función _objects()_ y tendremos un listado con todos los objetos de nuestra sesión.

En R no sólo podemos introducir manualmente los datos a través de vectores y matrices, podemos leer de un gran número de orígenes. Lo veremos en el siguiente capítulo de nuestro manual de R.