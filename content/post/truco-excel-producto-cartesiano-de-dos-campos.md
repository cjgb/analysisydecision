---
author: rvaquerizo
categories:
  - excel
  - formación
  - trucos
date: '2019-04-14'
lastmod: '2025-07-13'
related:
  - truco-excel-repetir-celdas-en-funcion-de-los-valores-de-otra-celda.md
  - trucos-excel-multiples-campos-calculados-en-una-tabla-dinamica.md
  - truco-excel-unir-todos-los-libros-en-una-hoja.md
  - truco-excel-repetir-un-campo-a-partir-de-otro-que-define-el-numero-de-repeticiones.md
  - truco-excel-pasar-un-rango-de-varias-columnas-a-una.md
tags:
  - excel
  - formación
  - trucos
title: Truco Excel. Producto cartesiano de dos campos
url: /blog/truco-excel-producto-cartesiano-de-dos-campos/
---

Hacía tiempo que no ponía trucos en Excel y hoy os traigo un truco que puede ser de utilidad cuando tienes que hacer combinaciones. Se trata de realizar el producto cartesiano mediante una macro de Excel, además os pongo el enlace al propio Excel para que podáis rellenar los campos a cruzar. No creo que haga falta describir que es un producto cartesiano de dos campospero de forma resumida se puede decir que es crear el total de pares de esos dos campos, un todos con todos, es útil cuando quieres hacer combinaciones (como ya he dicho). La macro en Visual Basic se podrá hacer mejor, pero a mi se me ha ocurrido hacer un triple bucle, probablemente se pueda hacer con n campos pero si tenéis que realizar productos cartesianos más complejos es preferible que lo hagáis con otra herramienta. El código empleado es este:

```vba
Sub ProductoCartesiano()

L1 = Range(Range("A2"), Range("A2").End(xlDown)).Rows.Count
L2 = Range(Range("B2"), Range("B2").End(xlDown)).Rows.Count

Cells(1, 4) = Cells(1, 1)
Cells(1, 5) = Cells(1, 2)

i = 2
j = 1

While i <= L1 * L2
While j <= L1
k = 1
While k <= L2

Cells(i, 4) = Cells(j + 1, 1)
Cells(i, 5) = Cells(k + 1, 2)

k = k + 1
If k > L2 Then j = j + 1
i = i + 1

Wend
Wend
Wend
End Sub
```

Nada emocionante pero tiene su «talento». Si no queréis complicaros la vida directamente podéis descargar del siguiente enlace la hoja del cálculo que realiza este proceso:

[Producto_cartesiano_excelV0](/images/2019/04/Producto_cartesiano_excelV0.xlsm)

Saludos.
