---
author: rvaquerizo
categories:
  - business intelligence
  - sas
date: '2010-01-20'
lastmod: '2025-07-13'
related:
  - acercamiento-a-wps-migrando-desde-sas.md
  - wps-en-el-mercado-espanol.md
  - truco-leer-sas7bdat-sin-sas.md
  - en-breve-revision-de-wps-clonico-de-sas.md
  - curso-de-lenguaje-sas-con-wps-librerias-en-wps.md
tags:
  - migración
  - sas
  - wps
title: Sigo migrando de SAS a WPS
url: /blog/sigo-migrando-de-sas-a-wps/
---

Sigo con una hipotética migración de SAS a `WPS`. Fundamental: ¿qué sucede cuando leo tablas SAS? ¿Puedo leerlas? Al fin y al cabo, son propietarias. Pues ningún problema: podemos leer perfectamente tablas SAS. 

Si trabajamos en una librería con tablas SAS, los ficheros generados serán `.sas7bdat`; sin embargo, si trabajamos en una librería sin tablas SAS, los archivos generados serán `.wpd`. Esto nos facilita trabajar conjuntamente con `WPS` y SAS, y facilita una hipotética migración de aplicaciones. Curiosamente, una tabla `.wpd` es ligeramente más pequeña. Por supuesto, `COMPRESS=YES` no es problema y `WPS` nos permite comprimir tablas.

Uno de los procedimientos más habituales con SAS es el `PROC SORT`. En SAS, las ordenaciones requieren en espacio unas 2,5 veces el tamaño del fichero a ordenar si no utilizamos la opción `TAGSORT`. Esta opción nos permite optimizar el espacio ocupado; no facilita que la ordenación sea más rápida, como piensa mi amiga Sonia, sino que nos permite necesitar aproximadamente 1,5 veces el tamaño de la tabla a ordenar. 

Con un fichero aleatorio de 79 MB, ejecuto el `PROC SORT` y analizamos el crecimiento de los ficheros temporales de la librería `WORK`. `WPS` ha generado dos temporales de 42 MB y uno de 45 MB. Parece que las ordenaciones ocupan menos espacio. Punto a favor de `WPS`. En cuanto a la velocidad, es imposible comparar porque SAS es muy caro y no estoy dispuesto a pagar su licencia.

Otra cosa que se me ha ocurrido es realizar un pequeño análisis univariante con gráficos y demás. Quiero generar un `HTML` vía `ODS` y no tengo problemas. Sí obtengo un error cuando no genero en mi PC la salida; si esta salida la dejo como parte de mi proyecto, tengo un problema con `Java`. Parece que el error no es importante, pero de momento no he podido solucionarlo. El *reporting* puede ser un punto flojo de `WPS`, pero sed sinceros: ¿quién emplea SAS como herramienta de *reporting*? ¿Y la realización de gráficos con SAS? Saludos.