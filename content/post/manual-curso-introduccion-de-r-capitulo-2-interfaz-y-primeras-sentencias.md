---
author: rvaquerizo
categories:
  - formación
  - r
date: '2008-02-26'
lastmod: '2025-07-13'
related:
  - manual-curso-introduccion-de-r-capitulo-3-lectura-de-datos.md
  - manual-curso-introduccion-de-r-capitulo-7-funciones-graficas-basicas-en-r.md
  - manual-curso-introduccion-de-r-capitulo-6-funciones-de-estadistica-descriptiva.md
  - truco-r-eval-parse-y-paste-para-automatizar-codigo.md
  - manual-curso-introduccion-de-r-capitulo-5-lectura-avanzada-de-datos.md
tags:
  - formación
  - r
title: 'Manual. Curso introducción de R. Capítulo 2: Interfaz y primeras sentencias'
url: /blog/manual-curso-introduccion-de-r-capitulo-2-interfaz-y-primeras-sentencias/
---

En esta nueva entrega del curso comenzamos a trabajar con `R`. Ya nos hemos descargado e instalado la herramienta y es momento de conocer a grandes rasgos como funciona `R`. Si abrimos una sesión nos encontramos con la siguiente pantalla:

![Interfaz R](/images/2008/02/interfaz_r.JPG)

El interfaz de `R` no es visual, trabajamos sobre una línea de comandos, no hay ventanas, sólo código y una gran comunidad de programadores que crean sus funciones y sus paquetes de utilidades. Para empezar a manejar `R` lo principal es conocer sus elementos principales **`objetos` y `funciones`** :

```r
> objeto <- c(2,3,4) # creamos un objeto vector

> mean(objeto) # hacemos la media del vector con la función mean

[1] 3

>
```

Sobre la línea de comandos generaremos `objetos` y `funciones`, las `funciones` llamarán `objetos`. Los `objetos` pueden ser vectores (`c`) o matrices (`matrix`) y dentro de las matrices tendremos estructuras más complejas que serán tablas (`data.frame`):

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

De este modo creamos `objetos` en `R`, el `data frame` se crea como una combinación de una `matriz` con varios `vectores`. PAra asignar los nombres a las columnas se emplea la función `names( <vector>)` Para visualizarlos sólo hemos de poner el nombre del objeto, si deseamos ver los `objetos` que hemos creado emplearemos la función `objects()` y tendremos un listado con todos los objetos de nuestra sesión.

En `R` no sólo podemos introducir manualmente los datos a través de vectores y matrices, podemos leer de un gran número de orígenes. Lo veremos en el siguiente capítulo de nuestro manual de `R`.
