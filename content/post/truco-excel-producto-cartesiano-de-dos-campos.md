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

Hacía tiempo que no ponía trucos en `Excel` y hoy os traigo un truco que puede ser de utilidad cuando tenéis que hacer combinaciones. Se trata de realizar el producto cartesiano mediante una macro de `Excel`; además, os pongo el enlace al propio `Excel` para que podáis rellenar los campos a cruzar. No creo que haga falta describir qué es un producto cartesiano de dos campos, pero de forma resumida se puede decir que es crear el total de pares de esos dos campos, un "todos con todos"; es útil cuando quieres hacer combinaciones (como ya he dicho).

La macro en `Visual Basic` se podrá hacer mejor, pero a mí se me ha ocurrido hacer un triple bucle; probablemente se pueda hacer con $n$ campos, pero si tenéis que realizar productos cartesianos más complejos es preferible que lo hagáis con otra herramienta. El código empleado es este:

```vba
Sub ProductoCartesiano()
    Dim L1 As Long, L2 As Long
    Dim i As Long, j As Long, k As Long

    L1 = Range(Range("A2"), Range("A2").End(xlDown)).Rows.Count
    L2 = Range(Range("B2"), Range("B2").End(xlDown)).Rows.Count

    Cells(1, 4) = Cells(1, 1)
    Cells(1, 5) = Cells(1, 2)

    i = 2
    j = 1

    While i <= (L1 * L2) + 1
        While j <= L1
            k = 1
            While k <= L2
                Cells(i, 4).Value = Cells(j + 1, 1).Value
                Cells(i, 5).Value = Cells(k + 1, 2).Value
                
                k = k + 1
                i = i + 1
            Wend
            j = j + 1
        Wend
    Wend
End Sub
```

Nada emocionante, pero tiene su "talento". Si no queréis complicaros la vida, directamente podéis descargar del siguiente enlace la hoja de cálculo que realiza este proceso:

[Producto_cartesiano_excelV0](/images/2019/04/Producto_cartesiano_excelV0.xlsm)

Saludos.