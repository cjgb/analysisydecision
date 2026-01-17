---
author: rvaquerizo
categories:
- Formación
- R
- SAS
- Trucos
date: '2016-06-22T08:34:58-05:00'
lastmod: '2025-07-13T16:08:02.107563'
related:
- macros-sas-dataset-a-data-frame-r.md
- truco-sas-crear-ficheros-excel-sin-proc-export-ii.md
- curso-de-lenguaje-sas-con-wps-lectura-de-ficheros-de-texto.md
- comunicar-sas-con-r-creando-ejecutables-windows.md
- truco-sas-macro-buscar-y-reemplazar-en-texto.md
slug: truco-sas-como-leer-pc-axis-con-sas
tags:
- PC Axis
title: Truco SAS. Como leer PC Axis con SAS
url: /blog/truco-sas-como-leer-pc-axis-con-sas/
---

Estoy leyendo [información del INE](http://www.ine.es/prodyser/micro_censopv.htm) que tiene que terminar cargándose en SAS y estos datos están en [formato PC Axis](http://www.ine.es/ss/Satellite?c=Page&p=1254735116596&pagename=ProductosYServicios%2FPYSLayout&cid=1254735116596&L=1). Existen [macros en SAS para generar datasets a partir de PC Axis](http://tilastokeskus.fi/tup/pcaxis/lataus_tyokalut_en.html) pero la verdad es que no he llegado a entender muy bien como funcionan y tras varios errores la mejor opción que he encontrado es emplear R y el [paquete pxR](https://cran.r-project.org/web/packages/pxR/index.html) que han creado algunos miembros de la [Comunidad de R-Hispano](http://r-es.org/). Como realizo esta tarea es más que sencillo:

**En R realizamos la importación del archivo *.px:**

```r
nacionalidad = read.px("ubicacion\\seccion_censal_nacionalidad.px")
nacionalidad = data.frame(nacionalidad)
write.csv( nacionalidad, file = "ubicacion\\nacionalidad.csv" )
```


**Hemos generado un csv que importamos desde SAS:**

```r
proc import datafile="ubicacion\nacionalidad.csv"
     out=nacionalidades
     dbms=csv
     replace;
     getnames=yes;
run;
```


También quería aprovechar esta entrada para comentaros que es preferible usar los viejos csv para mover archivos entre R y SAS que usar librerías como [SASxport ](https://cran.r-project.org/web/packages/SASxport/index.html)que generan ficheros «portables» de SAS, aunque los ficheros «portables» garantizan que se puedan leer con distintas versiones de SAS este paquete tarda mucho (demasiado) tiempo en crear los archivos. Y si alguien tiene una versión más sencilla de la macro de SAS que mande el link. Saludos.