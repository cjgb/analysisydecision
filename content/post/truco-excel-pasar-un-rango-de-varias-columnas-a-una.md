---
author: rvaquerizo
categories:
- excel
- formación
- trucos
date: '2016-10-05'
lastmod: '2025-07-13'
related:
- truco-excel-repetir-un-campo-a-partir-de-otro-que-define-el-numero-de-repeticiones.md
- truco-excel-transponer-una-fila-en-varias-columnas-con-desref.md
- truco-excel-unir-todos-los-libros-en-una-hoja.md
- desref-para-trasponer-en-excel-varias-columnas.md
- trucos-excel-transponer-con-la-funcion-desref.md
tags:
- sin etiqueta
title: Truco Excel. Pasar un rango de varias columnas a una
url: /blog/truco-excel-pasar-un-rango-de-varias-columnas-a-una/
---
Macro de Excel que nos permite pasar de varias columnas a una sola. De momento no es una función, es un código que sorprende por su sencillez:

```r
Sub rango_columnas()

Dim rango As Variant
Dim i As Long, j As Long, k As Long
Dim col As Long

rango = Selection.Value

'Esta es la parte que permite ubicar la salida
col = Selection.Column
k = Selection.Row

'Esto recorre el rango y realiza la trasposición
For i = 1 To UBound(rango, 1)
    For j = 1 To UBound(rango, 2)
        Cells(k, col + UBound(rango, 2)).Value = rango(i, j)
        k = k + 1
    Next
Next

End Sub
```


Este código lo ponéis tal cual en vuestro Excel y os ilustro a continuación sobre su funcionamiento. Lo primero es seleccionar el rango de columnas que deseamos transponer:

[![varias_columnas_a_una_excel1](/images/2016/10/varias_columnas_a_una_excel1.png)](/images/2016/10/varias_columnas_a_una_excel1.png)

Ahora sólo ejecutamos la macro rango_columnas:

[![varias_columnas_a_una_excel2](/images/2016/10/varias_columnas_a_una_excel2.png)](/images/2016/10/varias_columnas_a_una_excel2.png)

Y aparece justo al lado del rango que deseamos transponer a una sola columna:

[![varias_columnas_a_una_excel3](/images/2016/10/varias_columnas_a_una_excel3.png)](/images/2016/10/varias_columnas_a_una_excel3.png)

En este caso el resultado lo obtenemos en la columna F. Jugando con los índices i y j de nuestra macro podremos modificar la forma de la transposición. Me parece una macro útil y por eso lo comparto con vosotros. Saludos.