---
author: rvaquerizo
categories:
- formación
date: '2008-02-27'
lastmod: '2025-07-13'
related:
- manual-curso-introduccion-de-r-capitulo-5-lectura-avanzada-de-datos.md
- leer-fichero-de-texto-de-ancho-fijo-con-python-pandas.md
- manual-curso-introduccion-de-r-capitulo-2-interfaz-y-primeras-sentencias.md
- curso-de-lenguaje-sas-con-wps-lectura-de-ficheros-de-texto.md
- curso-de-lenguaje-sas-con-wps-que-hace-el-paso-data.md
tags:
- sin etiqueta
title: 'Manual. Curso introducción de R. Capítulo 3: Lectura básica de datos'
url: /blog/manual-curso-introduccion-de-r-capitulo-3-lectura-de-datos/
---
En el anterior capítulo creábamos vectores y matrices con las funciones _c_ y _matrix_ pero en R disponemos de otros medios para leer o introducir datos. Empezamos con la entrada manual de datos:


`> # Entrada manual de datos`
```r
> ej.3.1 <- scan()

1: 1 2

3: 4 5

5: 6 7

7:

Read 6 items

> ej.3.1

[1] 1 2 4 5 6 7

>
```

Para introducir manualmente datos en R disponemos de la función _scan_ e introduciremos los datos manualmente separando las entradas con un espacio, para finalizar empleamos intro en una línea sin datos, R nos indicará los registros leídos. La función _scan_ también puede leer ficheros de texto planos si le pasamos el fichero como **parámetro** :

```r
> > ej.3.2 <- scan("c:\\windows\\temp\\fichero_texto1.txt")

Read 8 items

> ej.3.2

[1] 123 456 765 345 23 567 78 900

>
```

Como vemos es necesario separar los directorios con \\\ en vez de \\. El proceso ha leído 8 registros de un fichero plano _fichero_texto1.txt_ que tiene la siguiente estructura:

```r
123 456 765 345

23 567 78 900
```

Es un fichero con 2 registros y 4 columnas, sin embargo _scan_ interpreta que es un fichero sin saltos de línea. Por ello para leer ficheros de texto es más recomendable emplear la función _read.table_ :

```r
> ej.3.3 <- read.table("c:\\windows\\temp\\fichero_texto1.txt")

Warning message:

In read.table("c:\\windows\\temp\\fichero_texto1.txt") :

  linea final incompleta encontrada por readTableHeader en 'c:\windows\temp\fichero_texto1.txt'

> ej.3.3

  V1 V2 V3 V4

1 123 456 765 345

2 23 567 78 900

>
```

Ahora hemos leído 2 registros y 4 variables y hemos creado una tabla con la estructura del fichero de texto. Si el fichero de texto tuviera los nombres de los campos que leemos habríamos de trabajar con los **parámetros opcionales** de la función _scan_ :

```r
> ej.3.3 <- read.table("c:\\windows\\temp\\fichero_texto1.txt",header=TRUE)

Warning message:

In read.table("c:\\windows\\temp\\fichero_texto1.txt", header = TRUE) :

  linea final incompleta encontrada por readTableHeader en 'c:\windows\temp\fichero_texto1.txt'

> ej.3.3

  Puntuacion1 Puntuacion2 Puntuacion3 Puntuacion4

1 123 456 765 345

2 23 567 78 900

>
```

En este caso disponíamos de un fichero de texto con cabeceras, por ello ha sido necesario modificar a verdadero (TRUE) el parámetro _header_ de la función _read.table_. Para saber que parámetros tienen las distintas funciones de R y obtener ayuda sobre ellas en la línea de comandos debemos introducir _? <función>_:

```r
> ?read.table

>
```

En función de la configuración de la ayuda que hayamos hecho en el momento de la instalación obtendremos un pop-up o bien la información sobre la función en la misma pantalla de R.

Con estas herramientas ya estamos en disposición de crear estructuras de datos más complejas. En sucesivas entregas leeremos datos de otros orígenes (SAS, ODBC,…)