---
author: rvaquerizo
categories:
  - formación
  - monográficos
  - r
date: '2010-12-18'
lastmod: '2025-07-13'
related:
  - montemos-un-sistema-de-informacion-en-nuestro-equipo-i.md
  - montemos-un-sistema-de-informacion-en-nuestro-equipo-ii.md
  - manual-curso-introduccion-de-r-capitulo-5-lectura-avanzada-de-datos.md
  - parametros-en-nuestra-consulta-sql-server-desde-r-truco-r.md
  - manual-curso-introduccion-de-r-capitulo-4-contribuciones-a-r-paquetes.md
tags:
  - pentaho
  - postgres
  - bases de datos
  - r
title: Montemos un sistema de información en nuestro equipo (III)
url: /blog/montemos-un-sistema-de-informacion-en-nuestro-equipo-iii/
---

Vamos a conectar`R` a nuestra BBDD `postgres`. Lo vamos a hacer vía `ODBC` con el paquete de ``` R``RODBC ``` [inciso] recordad que todo el trabajo lo estamos realizando bajo `Win`. Además trabajar con `ODBC` nos permitirá conectar nuestro `postgres` con `Access` o `Excel`. Aunque para este tipo de tarea recomiendo el uso del `Data Integration de Pentaho`. El primer paso será descargarnos de[ esta dirección ](http://www.postgresql.org/ftp/odbc/versions/msi/)los controladores `ODBC` para `Postgres` que se adecúen con nuestro `S.O.` y nuestra versión de `postgres`. Tras instalarlos ya podemos ir a las Herramientas Administrativas Orígenes de Datos `ODBC` e introducimos un nuevo `DSN` de sistema y de usuario:

![ODBC Configuration for PostgreSQL](/images/2010/12/sinfo_casero7.png)

Ya tenemos un origen de datos `ODBC` para nuestra BBDD de `postgres` llamado `PostgreSQL30`. Podemos crear la conexión con `R`:

```r
library(RODBC)

con =  odbcConnect("PostgreSQL30",case="postgresql")
```

Ya tenemos conectado `R` con nuestra BBDD y podemos realizar consultas sobre ella:

`datos = sqlQuery(con,"SELECT * FROM red_wine")`

Seleccionamos todos los campos de la tabla `red_wine` que cargamos en el capítulo anterior del monográfico. También estamos en disposición de subir a nuestro `postgres` los objetos de `R` que deseemos:

```r
#Creamos una muestra aleatoria de 100 registros

selec = sample(1:nrow(datos),100)

muestra = datos[selec,]

#Subimos a la BBDD postgres el data frame de R

sqlSave(con,muestra)
```

Vemos que la función `sqlSave` nos permite guardar en la BBDD aquellos objetos de `R` que consideremos necesarios. En pocos pasos estamos construyendo herramientas para que nuestro equipo tenga un pequeño sistema de información. Este sistema se sustenta en tre pilares fundamentales: `Postgres`, `Data Integration de Pentaho` y `R`. Software libre.
