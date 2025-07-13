---
author: rvaquerizo
categories:
- Formación
- Python
date: '2020-09-17T03:24:54-05:00'
lastmod: '2025-07-13T16:00:10.526305'
related:
- manual-curso-introduccion-de-r-capitulo-3-lectura-de-datos.md
- lectura-de-archivos-csv-con-python-y-pandas.md
- analisis-de-textos-con-r.md
- leer-archivos-excel-con-python.md
- data-management-basico-con-pandas.md
slug: leer-fichero-de-texto-de-ancho-fijo-con-python-pandas
tags: []
title: Leer fichero de texto de ancho fijo con Python Pandas
url: /leer-fichero-de-texto-de-ancho-fijo-con-python-pandas/
---

Es muy habitual trabajar con archivos csv pero en ocasiones disponemos de ficheros de texto con determinado formato o con ancho fijo para las columnas. [Hace tiempo ya escribí sobre la lectura de archivos csv con Python y Pandas](https://analisisydecision.es/lectura-de-archivos-csv-con-python-y-pandas/) pero en esta ocasión vamos a leer archivos que no tienen un separador. Evidentemente tienen que darnos el formato del archivo, en este caso, para ilustrar el ejemplo, vamos a pasar un código en R a un código en Python. Necesitamos leer unos datos usados en el libro _Non-Life Insurance Pricing with GLM_ , con R teníamos el siguiente programa:

```r
varib <- c(edad = 2L, sexo = 1L, zona = 1L, clase_moto = 1L, antveh = 2L,
           bonus = 1L, exposicion = 8L, nsin = 4L, impsin = 8L)

varib.classes <- c("integer", rep("factor", 3), "integer",
                   "factor", "numeric", rep("integer", 2))
con <- url("https://staff.math.su.se/esbj/GLMbook/mccase.txt")
moto <- read.fwf(con, widths = varib, header = FALSE,
                 col.names = names(varib),
                 colClasses = varib.classes,
                 na.strings = NULL, comment.char = "")
```
 

Necesitamos crear ese data frame moto con Python. Evidentemente una lectura a las bravas no tiene sentido:

```r
import pandas as pd
data1 = pd.read_fwf("http://staff.math.su.se/esbj/GLMbook/mccase.txt")
data1.head(10)
```
 

[![](/images/2020/09/lectura_txt_python1.png)](/images/2020/09/lectura_txt_python1.png)

El programa R ya nos define el formato del fichero y es necesario "traducirlo" a Pandas:

```r
#Asignamos
columnas = [(0, 2), (2,3), (3,4), (4,5), (5,7), (7,8), (8,16), (16,20), (20,28)]
data1 = pd.read_fwf("http://staff.math.su.se/esbj/GLMbook/mccase.txt", colspecs=columnas, header=None)
data1.head(10)
```
 

Vamos a crear una lista con el ancho de los campos que denominamos columnas, como siempre, en este caso empezamos en 0 no en el 1 y el final del anterior campo será el principio del siguiente, después sumamos a ese principio la longitud del campo que nos han definido. Ahora cuando usemos read_fwf que es la función necesaria para leer files-with-format, ficheros con formato, en colspecs pondremos la lista con las longitudes de los campos y en este caso no tenemos encabezados por lo que es necesario poner header = None. Ya tenemos un data frame al que solo falta asignar los nombres con los campos:

```r
data1.columns = ['edad','sexo','zona','clase_moto', 'antveh', 'bonus', 'exposicion', 'nsin', 'impsin']
data1.head()
```
 

El ejemplo os sirve, pero se puede simplificar porque los campos son consecutivos usando widths = lista de longitudes:

```r
data2 = pd.read_fwf("http://staff.math.su.se/esbj/GLMbook/mccase.txt", widths = [2,1,1,1,2,1,8,4,8], header=None)
data2.columns = ['edad','sexo','zona','clase_moto', 'antveh', 'bonus', 'exposicion', 'nsin', 'impsin']
data2.head()
```
 

Equivale a lo que hemos visto con anterioridad pero es preferible usar el primer método porque es más rápida la lectura. Saludos.