---
author: rvaquerizo
categories:
  - sas
  - trucos
date: '2010-05-05'
lastmod: '2025-07-13'
related:
  - lectura-de-ficheros-sas7bdat-de-sas-directamente-con-r.md
  - sigo-migrando-de-sas-a-wps.md
  - crear-archivo-csv-desde-python.md
  - importar-a-sas-desde-otras-aplicaciones.md
  - acercamiento-a-wps-migrando-desde-sas.md
tags:
  - sas
  - trucos
title: ¿Truco? Leer sas7bdat sin SAS
url: /blog/truco-leer-sas7bdat-sin-sas/
---

Me han pasado una tabla `SAS` y no sé cómo llevármela a `SPSS`. Este problema es habitual y ha traído de cabeza a más de uno. Es lo que tienen estas herramientas tan propietarias; si en tu organización tienen `WPS` (bueno, bonito y barato), esto no pasa. En fin, me ha llegado esta cuestión y voy a plantearos una posible forma de resolverla. Podríamos usar los formatos `XPORT`; la persona que me pasa la tabla emplea el `libname xport` y me envía un fichero `.xpt`; sin embargo, esto no pasa. Casi siempre nos mandan el `.sas7bdat` y tenemos un problema.

Bueno, pues quiero plantearos una posible solución a esta contingencia. Es una solución de emergencia y que espero que funcione. Se trata de descargarnos la versión gratuita del `JMP` de `SAS` ([por ejemplo, de Softonic](http://jmp.softonic.com/)) y abrir la tabla `SAS` `.sas7bdat`; después podemos guardar como `.txt` y ya podremos leer la tabla en cuestión.

El ahora escribiente no ha probado este proceso; qué quiero decir con ello: que no me he bajado la versión de prueba del `JMP` y a lo peor no puedo hacerlo; sin embargo, no tiene por qué estar limitada en ese caso. Espero que os sirva.
