---
author: rvaquerizo
categories:
- formación
- sas
- trucos
date: '2012-04-19'
lastmod: '2025-07-13'
related:
- truco-sas-ver-el-contenido-de-un-formato.md
- trucos-sas-eliminar-etiquetas-en-los-conjunto-de-datos-sas.md
- truco-sas-limpieza-de-tabuladores-con-expresiones-regulares.md
- truco-sas-limpiar-un-fichero-de-texto-con-sas.md
- truco-sas-elminar-retornos-de-carro-o-saltos-de-linea-engorrosos.md
tags:
- datasets
- fmterr
- formatos
title: Trucos SAS. Errores y formatos
url: /blog/trucos-sas-errores-y-formatos/
---
Un truco SAS que puede ayudar a todos aquellos que estén empezando a programar en SAS. Hay ocasiones que trabajamos con datasets que tienen formatos y nos encontramos con el error: « _formato FMT no se ha encontrado o no se ha podido cargar»._ ¿Qué hacer? Lo primero es jugar con la opción FMTERR:

`options nofmterr;`

Esta opción de SAS nos permite trabajar con conjuntos de datos SAS con formatos aunque no estén cargados porque no se tienen en cuenta los errores. Por otro lado podemos emplear PROC DATASETS para eliminar todos los formatos (entrada y/o salida) de un conjunto de datos SAS, el código es el siguiente:

```r
proc datasets lib=librer;

modify conjunto_datos;

format _all_;

informat _all_;

quit;
```

Eliminamos todos los formatos de un conjunto de datos SAS de forma instantánea. También podemos eliminar sólo los numéricos con _NUM_ o los alfanuméricos con _CHAR_. Espero que estas líneas os ayuden. Saludos.