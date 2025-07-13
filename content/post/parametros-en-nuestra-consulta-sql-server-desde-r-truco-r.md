---
author: rvaquerizo
categories:
- Formación
- R
date: '2019-10-14T11:19:56-05:00'
slug: parametros-en-nuestra-consulta-sql-server-desde-r-truco-r
tags:
- SQL SERVER
title: Parámetros en nuestra consulta SQL Server desde R. Truco R
url: /parametros-en-nuestra-consulta-sql-server-desde-r-truco-r/
---

Me han preguntado hoy como parametrizar una consulta de Sql Server desde R y la verdad es que es algo que me parecía muy sencillo y no me había planteado compartirlo. En mi caso suelo emplear la librería RODBC para acceder a Sql Server porque realizo las consultas vía ODBC, por este motivo lo primero debéis tener es configurado el origen de datos ODBC e instalada la librería RODBC en R. Para acceder vía R a los datos de Sql Server lo primero es crear la conexión a la BBDD:

```r
conexion <- odbcConnect("ORIGEN_ODBC")
```
 

Ya estamos en disposición de realizar nuestras consultas sobre la BBDD de SQL Server, en R debemos ejecutar siempre:

```r
objeto_r <- sqlQuery(conexion,"")
```
 

Con sqlQuery realizamos la consulta tal cual la realizaríamos en Sql Server y obtendremos el objeto en R o directamente puede salirnos en la consola. Recomiendo siempre cerrar las conexiones ODBC, R nos lo irá recordando de todas formas:

```r
odbcCloseAll()
```
 

Con odbccloseAll cerramos todas las conexiones ODBC. Y si deseamos añadir parámetros a nuestra consulta desde R sólo tenemos que recordar que en sqlQuery metemos un texto por ello podremos hacer:

```r
fecha <- '2019-08-01'
conexion <- odbcConnect("ORIGEN_ODBC")
objeto_r <- sqlQuery(conexion,paste0("SELECT * FROM TABLA WHERE FECHA>", fecha ,"AND ESTADO='1'"))
odbcCloseAll()
```
 

En ocasiones realizamos consultas más complejas, yo suelo "jugar con frases" y directamente pasar a sqlQuery la frase. Truco sencillo.