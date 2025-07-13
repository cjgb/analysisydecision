---
author: rvaquerizo
categories:
- Excel
- Formación
- Trucos
date: '2019-04-14T14:01:16-05:00'
slug: truco-excel-producto-cartesiano-de-dos-campos
tags: []
title: Truco Excel. Producto cartesiano de dos campos
url: /truco-excel-producto-cartesiano-de-dos-campos/
---

Hacía tiempo que no ponía trucos en Excel y hoy os traigo un truco que puede ser de utilidad cuando tienes que hacer combinaciones. Se trata de realizar el producto cartesiano mediante una macro de Excel, además os pongo el enlace al propio Excel para que podáis rellenar los campos a cruzar. No creo que haga falta describir que es un producto cartesiano de dos campospero de forma resumida se puede decir que es crear el total de pares de esos dos campos, un todos con todos, es útil cuando quieres hacer combinaciones (como ya he dicho). La macro en Visual Basic se podrá hacer mejor, pero a mi se me ha ocurrido hacer un triple bucle, probablemente se pueda hacer con n campos pero si tenéis que realizar productos cartesianos más complejos es preferible que lo hagáis con otra herramienta. El código empleado es este:

```r
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