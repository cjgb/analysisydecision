---
author: rvaquerizo
categories:
- SAS
- Trucos
date: '2010-05-05T09:26:04-05:00'
slug: '%c2%bftruco-leer-sas7bdat-sin-sas'
tags: []
title: ¿Truco? Leer .sas7bdat sin SAS
url: /c2bftruco-leer-sas7bdat-sin-sas/
---

Me han pasado una tabla SAS y no sé como llevármela a SPSS. Este problema es habitual y ha traído de cabeza a más de uno. Es lo que tienen estas herramientas tan propietarias, si en tu organización tienen WPS (bueno bonito y barato) esto no pasa. En fin, me ha llegado esta cuestión y voy a plantearos una posible forma de resolverla. Podríamos usar los formatos XPORT, la persona que me pasa la tabla emplea el libname xport y me envía un fichero .xpt, sin embargo esto no pasa. Casi siempre nos mandan el .sas7bdat y tenemos un problema.

Bueno, pues quiero plantearos una posible solución a esta contingencia. Es una solución de emergencia y que espero funcione. Se trata de descargarnos la versión gratuita del JMP de SAS ([por ejemplo de softonic](http://jmp.softonic.com/)) y abrir la tabla SAS .sas7bdat, después podemos guardar como .txt y ya podremos leer la tabla en cuestión.

El ahora escribiente no ha probado este proceso, que quiero decir con ello, que no me he bajado la versión de prueba del JMP y a lo peor no puedo hacerlo, sin embargo no tiene porque estar limitada en ese caso. Espero que os sirva.