---
author: rvaquerizo
categories:
- excel
- formación
- trucos
date: '2011-04-21'
lastmod: '2025-07-13'
related:
- trucos-excel-repetir-filas-con-desref.md
- trucos-excel-transponer-con-la-funcion-desref.md
- truco-excel-transponer-una-fila-en-varias-columnas-con-desref.md
- desref-para-trasponer-en-excel-varias-columnas.md
- truco-excel-repetir-un-campo-a-partir-de-otro-que-define-el-numero-de-repeticiones.md
tags:
- desref
- funciones excel
title: Trucos Excel. Repetir filas o columnas con la función DESREF
url: /blog/trucos-excel-repetir-filas-o-columnas-con-la-funcion-desref/
---
La **función DESREF** va a ser la protagonista de 2 trucos de Excel. Vamos a **repetir filas o columnas** con esta función. En nuestro caso la función va a devolver el valor de una celda referenciada del modo _DESREF( <Celda inicial anclada>;<Filas por debajo de la referenciada>;<Columnas a la derecha de la fila referenciada>)_. Para nuestro caso el funcionamiento de la función DESREF será:

![ejemplo-de-uso-desref-2.png](/images/2011/04/ejemplo-de-uso-desref-2.png)

Repito, en este caso la función **DESREF** lo que hace es referenciar celdas en función de una celda inicial, de modo que el primer parámetro que le pasamos a la función es la referencia, el segundo parámetro es el número de celdas que nos movemos hacia abajo y el tercer parámetro el número de celdas que nos movemos a la derecha. En nuestro caso fijamos la celda B3 como referencia y si deseamos repetir columnas (menos habitual) sólo hacemos _DESREF(B3;0;0)_. Si lo que queremos es repetir filas lo primero que tenemos que hacer es crear el valor incremental sobre nuestra referencia. En el ejemplo deseamos repetir el número en 3 ocasiones y que después cambie, bien el autonumérico irá del 0 al 11, del 0 al 4×3 – 1. Hacemos una función _REDONDEAR.MENOS_ donde dividimos nuestro autonumérico entre el número de veces que queremos repetir, en este caso 3. Y esa será la forma en la que se incrementará nuestra referencia.

Creo que he sido bastante claro con la exposición, pero si alguien tiene alguna duda en [este link](/images/2011/04/ejemplo-de-uso-desref-1.xlsx "ejemplo-de-uso-desref-1.xlsx") tiene el ejemplo utilizado para entenderlo mejor. En breve vuelvo con esta función.