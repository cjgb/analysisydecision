---
author: rvaquerizo
categories:
- Excel
- Formación
- Trucos
date: '2018-09-30T14:44:21-05:00'
slug: truco-excel-transponer-una-fila-en-varias-columnas-con-desref
tags:
- DESREF
title: Truco Excel. Transponer una fila en varias columnas con DESREF
url: /truco-excel-transponer-una-fila-en-varias-columnas-con-desref/
---

Creo que alguna vez me lo han preguntado. Se trata de tranponer en Excel el contenido de una fila en varias columnas, como es habitual (sobre todo si escribo yo) una imagen vale más que mil palabras:

[![Transponer varias columnas](/images/2018/09/Transponer-varias-columnas.jpg)](/images/2018/09/Transponer-varias-columnas.jpg)

En este caso se trata de pasar de una fila a 3 columnas por lo que se trata de que la [función DESREF](https://analisisydecision.es/trucos-excel-transponer-con-la-funcion-desref/) tiene que moverse en función del elemento que va a transpone. En este caso empezando desde A1 tenemos que generar un autonumérico para las columnas que se ha de mover de 3 en 3 por lo que multiplicaremos por 3 y sumaremos la columna:

Para el primer elemento: =DESREF(A1;0;(FILA(A1)-FILA(A1))*3)  
Para el segundo elemento: =DESREF(A1;0;(FILA(B1)-FILA(A1))*3+1)  
Para el tercer elemento: =DESREF(A1;0;(FILA(C1)-FILA(A1))*3+2)

Ya lo veis, se mueve de 3 en 3 la columna 0 el primer elemento la 1 el segundo y el 2 el tercero.