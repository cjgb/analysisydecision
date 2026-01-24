---
author: rvaquerizo
categories:
  - formación
  - monográficos
  - r
  - trucos
date: '2011-02-10'
lastmod: '2025-07-13'
related:
  - curso-de-lenguaje-sas-con-wps-funciones-en-wps.md
  - analisis-de-textos-con-r.md
  - truco-r-valores-perdidos-a-0-ejemplo-de-uso-de-sapply.md
  - introduccion-a-la-estadistica-para-cientificos-de-datos-capitulo-3-manejo-de-datos-con-r.md
  - truco-r-eval-parse-y-paste-para-automatizar-codigo.md
tags:
  - eval
  - parse
  - rpanel
  - svwidgets
title: Nuestras funciones de R en menús con rpanel y svWidgets
url: /blog/nuestras-funciones-de-r-en-menus-con-rpanel-y-svwidgets/
---

Hoy quería acercarme a los paquetes `rpanel` y `svWidgets` para crear ventanas y menús respectivamente. La idea es sencilla, tenemos funciones en `R` que empleamos habitualmente y con ellas vamos a**realizar un menú**. Partimos de una función muy sencilla en `R` para eliminar datos con valores `missing`. [Por cierto, que cansado estoy de escribir palabras en inglés para facilitar las búsquedas, un valor missing es un valor perdido. Tras el lapso continúo]. Mi función:

```r
#Data frame con NAs

tmp <- as.data.frame(matrix(log(rnorm(10000,25,10)),ncol=10))

#Función que elimina missing

nomiss <- function(x) {

d1 = nrow(x)

x <- na.omit(x)

d2 = nrow(x)

cat("Se han eliminado ",d1-d2," de un total de ",d1," observaciones")

}

#Llamamos a la función

nomiss(tmp)
```

La idea es crear un menú para ejecutar mi función a través de **ventanas**. También es muy importante crear un código que me implique pocas líneas y que pueda aprobechar para otras funciones. Para la creación de ventanas vamos a emplear `rpanel` y para la creación de menús en nuestra sesión de `R` `svWidgets`. Lo primero es crear la función con las ventanas:

```r
library(rpanel)

#Creación de la ventana

elim <- function(){

elim.panel = `rp.control`(title = "Seleccionar DF",

size = c(100, 100), panelname = `Elim`)

`rp.textentry`(elim.panel, `var=zzdf`, title="DF a eliminar missing: ",`initval`="")

`rp.button`(elim.panel, title = "Ejecutar", action = `ej` , quitbutton = TRUE)

}

#Creamos la acción de la ventana

ej <- function(`panel`) {

`nomiss`(`eval`(`parse`(text=`panel`$`zzdf`)))

`panel`

}

elim()
```

Tenemos la siguiente ventana:

![menu_rpanel.png](/images/2011/02/menu_rpanel.png)

Con `rp.control` hemos creado el panel `Elim` que tiene el título Seleccionar DF y el tamaño es 100×100. Creamos un cuadro de entrada de texto con `rp.textentry` sobre el panel antes definido. Tenemos el parámetro `var=zzdf` que será la variable que pasemos en el menú, podemos asignar el valor inicial con `initval`. Incluimos un botón con `rp.button` al que asignamos la acción `ej` , será un botón que cerrará el menú tras la ejecución. La acción `ej` será la función que se ejecute tras pulsar el botón aceptar. Estas funciones de ejecución de los paneles recibirán siempre el parámetro `panel` y **para facilitar nuestro código** sólo ponemos la función que deseamos ejecutar en menús. Dos cosas muy importantes en esta función `ej`: 1) el parámetro `zzdf` es un texto por ello hemos de emplear **`eval + parse`** como ya [conté en otra ocasión](https://analisisydecision.es/truco-r-eval-parse-y-paste-para-automatizar-codigo/) para que un texto sea un código ejecutable 2) todas las funciones de ejecución de paneles creadas con `rpanel` han de finalizar con la instrucción `panel` , de este modo indicamos que recibe parámetros. Estos dos puntos es lo único relevante que tiene esta entrada.

Ahora creamos menús en nuestra barra de herramientas con `svWidgets`:

```r
library(svWidgets)

`MenuAdd`("`ConsoleMain/Utilidades`")

`MenuAddItem`("`ConsoleMain/Utilidades`", "`Elimina Perdidos`", "`elim()`")
```

`MenuAdd` nos permite crear menús en nuestra barra de herramientas. `MenuAddItem` crea un elemento en un menú, en este ejemplo creamos `Utilidades` y al pulsar utilidades tenemos el elemento `Elimina Perdidos` , al pulsar este elemento se ejecutará la función `elim()` que, como hemos visto antes, genera la ventana que llama a nuestra función `nomiss`.

Espero que estas ideas os sirvan en vuestro trabajo. Saludos.
