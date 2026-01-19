---
author: rvaquerizo
categories:
- excel
- formación
- trucos
date: '2016-12-17'
lastmod: '2025-07-13'
related:
- truco-excel-repetir-celdas-en-funcion-de-los-valores-de-otra-celda.md
- truco-excel-pasar-un-rango-de-varias-columnas-a-una.md
- trucos-excel-repetir-filas-con-desref.md
- trucos-excel-repetir-filas-o-columnas-con-la-funcion-desref.md
- trucos-excel-transponer-con-la-funcion-desref.md
tags:
- sin etiqueta
title: Truco Excel. Repetir un campo a partir de otro que define el número de repeticiones
url: /blog/truco-excel-repetir-un-campo-a-partir-de-otro-que-define-el-numero-de-repeticiones/
---
En realidad necesitamos repetir filas, pero el número de repeticiones está parametrizado por otro campo. Partimos de un rango donde la primera columna es un valor que necesita ser repetido el número de filas que nos indica la segunda columna. Es una duda que planteaba un lector del blog:

_Hola, a ver si me podeis ayudar,_
_quiero repetir cada fila el número de veces que hay en cada celda que le corresponde._
_Es decir tengo una variable Nombre (Columna A) y otra Frecuencia (Columna B)_
_Nombre Frecuencia_
_A 5_
_B 8_
_C 25_
_D 12_
_… …._

_La idea es repetir la la Fila A, 5 veces, la fila B, 8 veces y así sucesivamente._
_En realidad es lo inverso a crear una tabla de frecuencias desde una matriz de datos._

Tenía en la nevera un truco de Excel que puede hacer esta tarea y que también subiré al blog en los próximos días, en realidad esta entrada y la siguiente son modificaciones de un [anterior truco Excel que subí al blog](https://analisisydecision.es/truco-excel-pasar-un-rango-de-varias-columnas-a-una/). En esta imagen podéis ver lo que hace:

[![excel_repite_filas](/images/2016/12/Excel_repite_filas.png)](/images/2016/12/Excel_repite_filas.png)

La macro que lo realiza es esta:

```r
Sub rango_columnas2()

Dim rango, celda As Variant
Dim i As Long, j As Long, k As Long
Dim col As Long

rango = Application.InputBox(Prompt:="Seleccione el rango a repetir sin cabeceras", Type:=8)
Set celda = Application.InputBox(Prompt:="Seleccione donde quiere poner los datos", Type:=8)

'Esta es la parte que permite ubicar la salida
celda.Select
k = 0

'Esto recorre el rango
For i = 1 To UBound(rango, 1)
    For j = 1 To rango(i, 2)
        ActiveCell.Offset(k, 0).Value = rango(i, 1)
        k = k + 1
    Next
Next

End Sub
```


Se ejecutan 2 cuadros con el método Application.InputBox, en el primero seleccionamos el rango de datos **sin cabeceras** y en el segundo indicamos donde queremos que salgan los datos. Se trata de recorrer el rango y pararse a repetir las primera columna del rango tantas veces como lo indica la segunda columna. Un proceso sencillo con Visual Basic pero que sería interesante replicar con funciones de Excel, en este caso creo que INDIRECTO sería la más adecuada. En el siguiente enlace podéis descargar el ejemplo:

[repite_filas](/images/2016/12/repite_filas.xlsm)

En siguientes fechas daré más vueltas a este bucle para realizar transposiciones de datos. Saludos.