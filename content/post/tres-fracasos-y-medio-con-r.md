---
author: cgbellosta
categories:
  - data mining
  - r
date: '2009-12-15'
lastmod: '2025-07-13'
related:
  - conectar-r-a-una-base-de-datos.md
  - manual-curso-introduccion-de-r-capitulo-5-lectura-avanzada-de-datos.md
  - monografico-paquete-sqldf-si-sabes-sql-sabes-r.md
  - analisis-de-textos-con-r.md
  - lectura-de-archivos-csv-con-python-y-pandas.md
tags:
  - ficheros grandes
  - memoria
  - r
title: Tres fracasos y medio con R
url: /blog/tres-fracasos-y-medio-con-r/
---

Hoy, mientras Raúl departía en el cuarto de al lado —él os dirá por qué y para qué— y hacía tiempo para saludarlo, me he entretenido fracasando tres veces y media en lo que abajo desarrollo. No pensaba publicarlo hasta que, reflexionando, he considerado que, a veces, más útil es una buena pregunta que algunas certezas. Inconcluso —o fracasado— puede no significar inútil o imperfecto.

Veamos en qué han consistido mis fraccionarios fracasos.

He intentado algo imposible: leer un fichero de texto de dos gigas en un ordenador de otras cuantas de RAM. Como no tenía un fichero de tal magnitud a mano, me lo he fabricado a partir de otro de cuatro meguillas:

```r
asdf <- read.table( "fichero_de_4_megas.txt", header = T, sep = "\t" )

write.table( asdf, file = "test_data.txt", row.names = F, sep = "\t" )

for( i in 1:500 ) write.table( asdf, file = "test_data.txt", row.names = F, col.names = F, append = T, sep = "\t" )
```

Dos gigas, pues, de columnas de texto separadas por tabuladores en `test_data.txt`. Raúl seguía ocupado y he probado la opción más básica (primer fracaso):

`bigdata <- read.table( "test_data.txt", header = T, sep = "\t" )`

Al cabo de un rato he obtenido un error. He olvidado, por primerizo, usar `system.time` para ver cuánto se ha demorado el castañetazo. En la siguiente sería.

El segundo fracaso lo he cosechado con una versión más sofisticada de `read.table` (es decir, read.table con guirnaldas y abalorios para, como dicen los que hacen llorar a Cervantes, _eficientar_ la lectura de datos:

`bigdata <- read.table( "test_data.txt", header = T, sep = "\t", comment.char = "", colClasses = c( "numeric", "factor", "numeric", "factor", "numeric", "factor", "factor", "factor", "factor", "factor", "numeric", "numeric", "numeric", "factor", "factor" ) )`

Eliminar el caracter de comentario y predefinir el tipo de columnas sólo ha servido para acelerar el momento en el que `malloc` se ha pegado un cabezazo contra el techo de la RAM. Fracaso dos.

A la tercera he tenido un medio éxito —¿de qué estaría hablando Raúl tanto rato?— utilizando [un paquete que publicó en CRAN un personaje de mala calaña](http://cran.r-project.org/web/packages/colbycol/index.html "colbycol") al que no hay que creer nada de cuanto dice o escribe:

```r
library( colbycol )

system.time( bigdata <- cbc.read.table( "test_data.txt", header = T, sep = "\t" ) )
```

La función `cbc.read.table` de este malhadado paquete rasca el disco duro durante 1.092,80 segundos y termina felizmente. Quien lea la documentación que la acompaña descubrirá que ni ha cargado datos ni ha hecho mucho más de provecho: sólo los ha almacenado en disco de otra manera. No obstante, se pueden cargar columnas individuales y _hacer cosas_ con ellas con comandos del tipo:

`col.1 <- cbc.get.col( bigdata, 1 )`

No obstante, si uno trata de recomponer el conjunto de datos íntegro en memoria mediante algo parecido a

`mis.datos <- sapply( 1:ncol( bigdata), function( x ) cbc.get.col( bigdata, x ) )`

el ordenador inicia un encomiable pero fútil esfuerzo hacia un fracaso ineluctable. Es decir, falla. No obstante, como ha sido posible todavía hacer algo con los datos, consideraré que el fracaso, en este caso, ha sido parcial.

El cuarto ensayo ha sido un [remedo de algo que leí](http://www.cerebralmastication.com/?p=416 "sqlite"). Tenía ganas de probar [sqldf](http://cran.r-project.org/web/packages/sqldf/index.html "sqldf") (y también SQLite, claro). ¿Que qué es [SQLite](http://www.sqlite.org/ "SQLite")? Pues es [una base de datos que algunos lleváis en el bolsillo](http://forums.macrumors.com/showthread.php?t=453043 "SQLite en el iPhone"). De hecho, la llevaba un tipo que alegaba que, en bases de datos, Oracle y nada más…

Pero, retomando el hilo de nuestro tema, haciendo:

```r
library(sqldf)

tmp <- file( "test_data.txt" )

system.time( bigdata <- sqldf( "select * from tmp", dbname = tempfile(), file.format = list(header = T, row.names = F, sep = "\t")) )
```

uno vuelve a toparse con el consabido error. Efectivamente, los datos se cargan en SQLite pero luego, al tratar de importarlos a R… catástrofe. Eso sí, en tan sólo 688,20 segundos.

El problema de la lectura de conjuntos grandes de datos en R es acuciante y está —manifiesta y reiteradamente— sobre la mesa. Las buenas noticias son que problemas como el que cuento, hace ocho años, se tenían con ficheros de 10 megas. Dentro de nada, esto que escribo hoy será una reliquia que se leerá con un punto de nostalgia.
