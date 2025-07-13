---
author: rvaquerizo
categories:
- Excel
- Formación
- Trucos
date: '2015-02-23T10:17:19-05:00'
slug: trucos-excel-repetir-filas-con-desref
tags:
- DESREF
title: Trucos Excel. Repetir filas con DESREF
url: /trucos-excel-repetir-filas-con-desref/
---

[![desref repetir filas excel](/images/2015/02/desref-repetir-filas-excel-300x115.png)](/images/2015/02/desref-repetir-filas-excel.png)

En respuesta a una [cuestión planteada por una lectora ](https://analisisydecision.es/trucos-excel-repetir-filas-o-columnas-con-la-funcion-desref/#comment-73872)en una entrada muy parecida a esta podemos usar la función de Excel DESREF para repetir registros el número de veces que deseemos. Como sabemos DESREF parte desde una celda referenciada y nos movemos FILAS y COLUMNAS en función de los parámetros. La sintaxis es DESREF(CELDA DE REFERENCIA; FILA; COLUMNA) de modo que si ponemos DESREF(A1;0;1) haremos referencia a la celda B1 o bien si ponemos DESREF(A1;1;0) hará refrencia a la celda A2. Para repetir lo que haremos será algo de este estilo:

=DESREF(A$2;REDONDEAR.MENOS((FILA(A3)-2)/4;0);0)

Fijada la celda de referencia nos movemos por las filas y dividimos por el número de veces que deseamos repetir (ene el ejemplo 4), hacemos un redondear menos para que tengamos valores enteros de la fila y de este modo repetirá 4 veces cada fila. De todos modos tenéis en este enlace el ejemplo utilizado para que os sirva de referencia: [ejemplo-de-uso-desref-2](/images/2015/02/ejemplo-de-uso-desref-2.xlsx)