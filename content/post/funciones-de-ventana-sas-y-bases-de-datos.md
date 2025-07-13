---
author: cgbellosta
categories:
- Formación
- SAS
date: '2009-11-22T09:19:29-05:00'
slug: funciones-de-ventana-sas-y-bases-de-datos
tags:
- funciones de ventana
- lag
- SAS
- SQL
title: Funciones de ventana, SAS y bases de datos
url: /funciones-de-ventana-sas-y-bases-de-datos/
---

Hace unos meses padecí (eso sí, brevemente) un proyecto que consistía en la migración de cierto código en SAS (¡nos lo pasaron como un documento de 20 hojas de Word!) a otro lenguaje de programación.

Esencialmente, desde la nueva plataforma habrían de lanzarse consultas a cierta base de datos (cuando el código SAS permitiese resolver los cálculos como una consulta de SQL) y procesarse los resultados procedimentalmente desde el nuevo lenguaje de programación cuando SQL ,declarativo, no fuese suficiente. Surgió el problema de que el lenguaje procedimental era incapaz de procesar bloques tan grandes de información. Pero ésa es otra historia.

En esencia, lo que SQL era incapaz (¿lo era realmente? sigamos leyendo…) de procesar eran pasos data muy simples pero que contenían llamadas a la función [lag](http://support.sas.com/documentation/cdl/en/lrdict/62618/HTML/default/a000212547.htm "Documentación de la función lag"). Esta función, en esencia, ordena a SAS en un paso data recordar el valor de cierta variable en la línea anterior para compararlo con el de la presente. Se usa principalmente para calcular incrementos cuando los datos están ordenados temporalmente.

Las nuevas especificaciones de SQL (la [2003](http://es.wikipedia.org/wiki/SQL:2003) y la [2008](http://en.wikipedia.org/wiki/SQL:2008)) introdujeron y detallaron el uso de [funciones de ventana](http://www.postgresql-es.org/node/376). Las funciones de ventana son extensiones de las clásicas consultas con «group by». Éstas últimas sólo permiten devolver una fila por cada nivel de agrupamiento. Las funciones de ventana permiten operar sobre el bloque completo que define un nivel y:

  * Devolver tantas filas como contiene el bloque
  * Devolver valores basados en la totalidad de las filas del bloque
  * Si los bloques, además, se ordenan, tener acceso al primer valor (o último, o enésimo) de cada bloque; o a la fila anterior (mediante lag).

Puede leerse más al respecto [aquí](http://www.pgcon.org/2009/schedule/attachments/98_Windowing%20Functions.pdf "Presentación sobre funciones de ventana") y [aquí](http://www.postgresql.org/docs/current/static/functions-window.html "Documentación de Postgres sobre funciones de ventana").

Estoy seguro de que el uso de este tipo de extensiones ahorrará a muchos desarrolladores kilómetros de líneas de código y eones de tiempo de depuración.