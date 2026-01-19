---
author: rvaquerizo
categories:
  - formación
  - r
date: '2008-03-10'
lastmod: '2025-07-13'
related:
  - manual-curso-introduccion-de-r-capitulo-3-lectura-de-datos.md
  - manual-curso-introduccion-de-r-capitulo-4-contribuciones-a-r-paquetes.md
  - montemos-un-sistema-de-informacion-en-nuestro-equipo-iii.md
  - parametros-en-nuestra-consulta-sql-server-desde-r-truco-r.md
  - tres-fracasos-y-medio-con-r.md
tags:
  - sin etiqueta
title: 'Manual. Curso introducción de R. Capítulo 5: Lectura avanzada de datos'
url: /blog/manual-curso-introduccion-de-r-capitulo-5-lectura-avanzada-de-datos/
---

En esta nueva entrega aprenderemos a importar datos a R desde otras fuentes. Habitualmente no introduciremos manualmente los datos, emplearemos las posibilidades de lectura que nos ofrece R. En este capítulo leeremos ficheros de texto y ficheros Access, para ello necesitaremos el paquete de R [RODBC](http://cran.cict.fr/bin/windows/contrib/2.3/RODBC_1.1-7.zip).

Para leer fichero de texto emplearemos un fichero de ejemplo GRADES.TXT que es un fichero de texto delimitado por espacios y sin cabeceras, tiene los siguientes campos:

```r
Variable

ID del estudiante

genero

clase

puntuación de test

puntuación del examen 1

puntuación del examen 2

puntuación de laboratorio

puntuación del examen final
```

Descargateló [aquí](/images/2008/03/grades.TXT) y guardaló en C:\\WINDOWS\\temp para seguir el ejemplo. La función que se emplea en R para leer tablas desde ficheros de texto es _read.table:_

```r
> archivo <- read.table (file= "c:\\WINDOWS\\temp\\GRADES.TXT", header=FALSE) #leemos el archivo

> archivo

V1 V2 V3 V4 V5 V6 V7 V8

1 air f 4 50 93 93 98 162

2 aln m 4 49 95 98 97 175

3 bam m 4 39 63 84 95 95 ...
```

Vemos que la sintaxis de la función _read.table_ es bastante sencilla. Recomiendo estudiar la documentación que tiene R al respecto de esta función. El argumento principal de esta función será _file= \<ubicación y nombre del fichero>_, además con _header_ indicamos si es necesario leer cabeceras, por defecto _read.table_ tiene lo tiene a FALSE. Para introducir las cabeceras al fichero empleamos vectores:

```r
> archivo <- read.table (file="c:\\WINDOWS\\temp\\GRADES.TXT") #leemos el archivo

> nombres<-c("ID","sexo","clase","test","exam1","exam2","labo","final") #creamos un vector de nombres

> names(archivo)<-nombres #nombramos las variables

> archivo

  ID sexo clase test exam1 exam2 labo final

1 air f 4 50 93 93 98 162

2 aln m 4 49 95 98 97 175

3 bam m 4 39 63 84 95 95

4 bag f 3 46 92 96 88 150...
```

Empleamos la función names para dar nombres a las variables del _data.frame_ archivo a partir de un vector que contiene dichos nombres.

Otra fuente de datos muy habitual puede ser Access. Para leer bases de datos necesitaremos tener instalado el paquete [RODBC](http://cran.cict.fr/bin/windows/contrib/2.3/RODBC_1.1-7.zip). En el capítulo anterior se indicó como descargar e intalar este módulo de R. Para este ejemplo partimos de una BBDD Access _bd1_ almacenada en C:/WINDOWS/temp que contiene la siguiente tabla:

**POBLACION** | **RECLAM** | **TAM_COCHE**\*\*\*\* | **GRUPO_EDAD**\*\*\*\*
---|---|---|---
500 | 42 | small | 1
1200 | 37 | medium | 1
100 | 1 | large | 1
400 | 101 | small | 2
500 | 73 | medium | 2
300 | 14 | large | 2

Podéis crear la BBDD en la ubicación C:/WINDOWS/temp copiar y pegar el ejemplo para estudiar como funciona el código. Comencemos a analizar las sentencias en R:

```r
> setwd("c:/windows/temp") #Especificamos el directorio de trabajo.

> library(RODBC)    #Cargamos los paquetes.

> bd<-odbcConnectAccess("bd1.mdb")

> bd #Analizamos la conexión ODBC

RODB Connection 1

Details:

  case=nochange

  DBQ=c:\windows\temp\bd1.mdb

  Driver={Microsoft Access Driver (*.mdb)}

  DriverId=25

  FIL=MS Access

  MaxBufferSize=2048

  PageTimeout=5

  UID=admin
```

Primero necesitamos especificar el directorio de trabajo con la función _setwd_. Después cargamos el módulo RODBC con la función _library_ , recordemos que podemos cargarlo vía menú. Por último creamos la conexión con la función específica de RODBC _odbcConnectAccess_ y comprobamos que la conexión funciona correctamente. Ahora estamos en disposición de realizar consultas sobre las tablas de la BBDD conectada:

```r
> datos<-sqlQuery(bd,"SELECT * FROM tabla2") #Realizamos una consulta sobre la tabla2

> datos

  POBLACION RECLAM TAM_COCHE GRUPO_EDAD

1 500 42 small 1

2 1200 37 medium 1

3 100 1 large 1

4 400 101 small 2

5 500 73 medium 2

6 300 14 large 2
```

Las consultas se realizan con la función específica sqlQuery donde introduciremos la BBDD conectada y la consulta en SQL estándar entre comillas. Con esta sentencia hemos creado un objeto de R que contiene una tabla de Access. Ya tenemos conectado R con dos de los orígenes de datos más habituales. En sucesivas entregas leeremos datos con R de SAS y SPSS.
