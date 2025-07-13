---
author: rvaquerizo
categories:
- Business Intelligence
- SAS
date: '2010-01-20T17:02:57-05:00'
lastmod: '2025-07-13T16:06:15.170632'
related:
- acercamiento-a-wps-migrando-desde-sas.md
- wps-en-el-mercado-espanol.md
- truco-leer-sas7bdat-sin-sas.md
- en-breve-revision-de-wps-clonico-de-sas.md
- curso-de-lenguaje-sas-con-wps-librerias-en-wps.md
slug: sigo-migrando-de-sas-a-wps
tags:
- migración
- SAS
- WPS
title: Sigo migrando de SAS a WPS
url: /sigo-migrando-de-sas-a-wps/
---

Sigo con una hipotética migración de SAS a WPS. Fundamental, ¿qué sucede cuando leo tablas SAS? ¿Puedo leerlas, al fin y al cabo son propietarias? Ningún problema, podemos leer perfectamente tablas SAS. Si trabajamos en una librería con tablas SAS los ficheros generados serán .sas7bdat sin embargo si trabajamos en una librería sin tablas SAS los archivos generados serán .wpd; esto nos facilita trabajar conjuntamente con WPS y SAS, esto nos facilita una hipotética migración de aplicaciones. Curiosamente una tabla .wpd es ligeramente más pequeña. Por supuesto _compress=yes_ no es problema y WPS nos permite comprimir tablas.

Uno de los procedimientos más habituales con SAS es el PROC SORT. En SAS las ordenaciones requieren en espacio 2,5veces el tamaño del fichero a ordenar si no utilizamos la opción _tagsort._ Esta opción nos permite optimizar el espacio ocupado, no facilita que la ordenación sea más rápida, como piensa mi amiga Sonia, lo que nos permite es que necesitemos aproximadamente 1,5 veces el tamaño de la tabla a ordenar. Fichero aleatorio de 79 MB, PROC SORT y analizamos el crecimiento de los ficheros temporales de la librería work. WPS ha generado 2 temporales de 42 MB y uno de 45 MB. Parece que las ordenaciones ocupan menos espacio. Punto a favor de WPS. En cuanto a la velocidad, imposible comparar porque SAS es muy caro y no estoy dispuesto a pagar su licencia.

Otra cosa que se me ha ocurrido es realizar n pequeño análisis univariante con graficos y demás. Quiero generar un html vía _ods_ y no tengo prolemas. Si obtengo un error cuando no genero en mi pc la salida, si esta salida la dejo como parte de mi proyecto tengo un problema con java. Parece que el error no es importante, pero de momento no he podido solucionarlo. El reporting puede ser un punto flojo de WPS pero sed sinceros ¿quién emplea SAS como herramienta de reporting? ¿Y la realización de gráficos con SAS?