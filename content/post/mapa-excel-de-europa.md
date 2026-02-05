---
author: rvaquerizo
categories:
  - consultoría
  - excel
  - formación
  - monográficos
date: '2015-04-24'
lastmod: '2025-07-13'
related:
  - trucos-excel-mapa-de-mexico-por-estados.md
  - trucos-excel-mapa-de-espana-por-provincias.md
  - nuevo-y-muy-mejorado-mapa-de-espana-por-provincias-con-excel.md
  - trucos-excel-mapa-de-espana-por-comunidades-autonomas.md
  - mapas-de-municipales-de-espana-en-r-con-la-ayuda-de-excel.md
tags:
  - mapas
  - excel
title: Mapa Excel de Europa
url: /blog/mapa-excel-de-europa/
---

![mapa_excel_europa1](/images/2015/04/mapa_excel_europa1.png)

Un lector me había pedido disponer en `Excel` de un mapa de Europa y dicho y hecho. Además, en este `Excel` os muestro cómo hacer paletas de colores más o menos atractivas y cómo poder usarlas indistintamente con el mapa. Este `Excel` además contiene algunas líneas de `Visual Basic` que considero interesantes y que veremos después. [Los *shapes* están sacados de este enlace](http://www.clearlyandsimply.com/clearly_and_simply/2009/06/choropleth-maps-with-excel.html), pero se retoca completamente el código `Visual Basic` para hacerlo (a mi entender) más sencillo. El mapa se controla desde esta zona del `Excel`:

![mapa_excel_europa2](/images/2015/04/mapa_excel_europa2-169x300.png)

El "Dato" es lo que vamos a pintar. Evidentemente, tenéis que cruzar los datos con los nombres de los 37 países que se pintan en el mapa. Disponéis del nombre en inglés y del código de país para poder hacer este cruce previo. Pero quedaos con lo siguiente: lo único que podéis modificar es el nombre en inglés, por si preferís hacer vuestro `VLOOKUP` o `BUSCARV` por nombre en español. Lo que vais a pintar está en la columna `Dato`, pero en este caso se añade la selección de la paleta de colores que podéis emplear de las cuatro que propongo. Si sois lectores del blog y un poco espabilados, podréis crear vuestras propias paletas de colores; tampoco os lo puedo poner tan fácil.

Las paletas que pongo a vuestra disposición son:
![mapa_excel_europa3](/images/2015/04/mapa_excel_europa3.png)

Estas cuatro paletas pintan rangos de 5, 10 y los 37 países. La seleccionáis en la celda `P2` y automáticamente se dividen en el número necesario de rangos y, si pulsáis el botón "Colores", podéis ver cómo quedarían esos colores. No podéis cambiar los colores directamente en la paleta; no saldrá, necesitáis crearla.

En cuanto al `Visual Basic` empleado, es el mismo de todos los mapas `Excel` que tenéis en el blog, pero poco a poco se va haciendo más simple:

```vba
Sub colorpais()
    Dim pais As String
    Dim i As Integer
    Dim rngPais As Range

    Set rngPais = Range(ThisWorkbook.Names("pais").RefersTo)

    actualiza_colores

    Sheets("mapa").Select

    ' ESTA PARTE PONE LOS COLORES DE LAS FORMAS
    For i = 1 To rngPais.Rows.Count
        pais = "S_" & rngPais.Cells(i, 2)

        ActiveSheet.Shapes(pais).Fill.ForeColor.RGB = rngPais.Cells(i, 3).Interior.Color
        ActiveSheet.Shapes(pais).Line.ForeColor.RGB = rngPais.Cells(i, 3).Interior.Color
        ' ActiveSheet.Shapes(pais).Line.Weight = 0.25
    Next i

    Cells(1, 1).Select
End Sub

Sub actualiza_colores()
    Dim rngColor As Range
    Dim i As Integer
    Dim colorin As Long

    Sheets("mapa").Select
    Set rngColor = Range(ThisWorkbook.Names("pintar").RefersTo)

    For i = 1 To rngColor.Rows.Count
        colorin = rngColor.Cells(i, 3).Value
        rngColor.Cells(i, 1).Interior.Color = colorin
        rngColor.Cells(i, 2).Interior.Color = colorin
    Next i
End Sub
```

Dos partes diferenciadas: la parte que `actualiza_colores` y la parte que aplica esos colores a los *shapes* del mapa. He preferido hacerlo así para que podáis ver si los colores se adaptan a lo que queréis pintar. En ocasiones mi código `VB` puede parecer engorroso, pero lo hago para poner puntos de control. Un detalle: si deseáis marcar la línea de separación de los países, debéis modificar la línea `ActiveSheet.Shapes(pais).Line.ForeColor.RGB = 0` (os pinta una línea en negro). Creo que es un mapa sencillo y vistoso; espero que os sea de utilidad; me consta que, por lo menos para un lector, sí.

El archivo `Excel` que contiene el mapa os lo podéis descargar en este enlace:

[Mapa_Europa_Excel (XLSM)](/images/2015/04/Mapa_Europa_Excel.xlsm)

Saludos.