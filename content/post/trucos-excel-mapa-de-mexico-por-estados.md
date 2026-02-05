---
author: rvaquerizo
categories:
  - business intelligence
  - excel
  - formación
  - monográficos
  - trucos
date: '2012-04-07'
lastmod: '2025-07-13'
related:
  - mapa-excel-de-europa.md
  - trucos-excel-mapa-de-espana-por-provincias.md
  - trucos-excel-mapa-de-espana-por-comunidades-autonomas.md
  - nuevo-y-muy-mejorado-mapa-de-espana-por-provincias-con-excel.md
  - trucos-excel-mapa-de-colombia-por-departamentos.md
tags:
  - macros de excel
  - mapas
  - mexico
title: Trucos Excel. Mapa de México por Estados
url: /blog/trucos-excel-mapa-de-mexico-por-estados/
---

![mapa_excel_mexico1.png](/images/2012/04/mapa_excel_mexico1.png)

Hoy os presento la versión inicial del **mapa de México por Estados Federales** para que lo podáis usar en `Excel`, `PowerPoint`, `Word` o alguna de las herramientas habituales de ofimática. Se trata de un archivo `Excel` con macros que os [podéis descargar en este enlace](/images/2012/04/mapa-mexico.xlsm "mapa-mexico.xlsm").

La hoja `Mapa` contiene una serie de *shapes* que están nombrados para poder cambiar de color en función de una variable `tramo`. Este `Excel` inicial está preparado para poder pintar hasta cinco tramos; si deseáis más tramos, tenéis que meteros en el código de `Visual Basic` que modifica el color de cada uno de los 32 *shapes* que componen el mapa; posteriormente lo repasamos de forma rápida. Por otro lado, tenemos la división de los estados, el nombre de los *shapes* y los tramos que previamente habremos preparado. Este ejemplo no pinta nada concreto.

La hoja `Mapa` además dispone de dos botones asociados a las dos macros que contiene el `Excel`. Por un lado, tenemos una macro que nos deja los estados en blanco y, por otro, tenemos la macro que nos pinta de cada color elegido el mapa. Un vistazo sobre estos elementos de la hoja `Excel`:

![mapa_excel_mexico2.png](/images/2012/04/mapa_excel_mexico2.png)

El nombre de la columna `Estado` se puede modificar. Los nombres están sacados de la `Wikipedia`; entiendo que no deberían plantear ningún problema. Lo que no se puede modificar es la columna `name`, que contiene el nombre asociado a la imagen. Cada uno de los elementos del mapa se asocian a la variable `tramo` a través de la columna `name`. La variable `tramo` es la que nos realiza el mapa de colores; recordamos que sólo tenemos cinco tramos. Los botones son los que ejecutan las macros.

Las macros que lleva el `Excel` son:

```vba
' Esta macro pone el color de todos los estados en blanco
Sub ColorOriginalFormas()
    Dim K As Integer
    Dim Hoja As Worksheet
    
    Set Hoja = Worksheets("Mapa")
    
    For K = 1 To Hoja.Shapes.Count
        Hoja.Shapes(K).Fill.ForeColor.RGB = RGB(255, 255, 255)
    Next K
End Sub
```

Esta macro recorre todos los *shapes* de la hoja `Mapa` y los pone en blanco. La otra macro es:

```vba
' Macro para colorear cada Estado en función de una variable tramo.
' Los datos de tramo han de ser numéricos.
Sub Tramos()
    Dim Poblaciones() As Variant
    Dim K As Long
    Dim Hoja As Worksheet

    Poblaciones = Worksheets("Mapa").Range("Q1").CurrentRegion.Value
    Set Hoja = Worksheets("Mapa")

    If Hoja.Shapes(1).Type = msoGroup Then Hoja.Shapes(1).Ungroup

    For K = 2 To UBound(Poblaciones, 1)
        With Hoja.Shapes(Poblaciones(K, 2)).Fill.ForeColor
            Select Case Poblaciones(K, 3)
                Case 1
                    .RGB = RGB(0, 0, 255)
                Case 2
                    .RGB = RGB(255, 255, 128)
                Case 3
                    .RGB = RGB(128, 255, 255)
                Case 4
                    .RGB = RGB(128, 128, 255)
                Case 5
                    .RGB = RGB(255, 128, 0)
            End Select
        End With
    Next K
End Sub
```

Esta macro, al igual que la anterior, es conocida por los seguidores del blog porque ya apareció en una [entrada anterior](https://analisisydecision.es/trucos-excel-mapa-de-espana-por-provincias-mejores-versiones/). Para el rango `Poblaciones` vamos recorriendo el elemento que contiene el nombre y, en función de él, modificamos el color del objeto seleccionado. Lo hacemos mediante código `RGB`; si deseamos tener un nuevo tramo, podemos añadir una nueva condición; por otro lado, si deseamos eliminar un tramo, sólo eliminamos la condición. Siempre tendremos en cuenta que, si añadimos o eliminamos tramos, tenemos que modificar la leyenda.

El mapa tiene algunas limitaciones:

- Es algo básico estéticamente.
- No pinta las islas, pero esta labor es sencilla.
- Sólo está preparado para cinco tramos; se debe preparar para más.
- No se actualiza la leyenda automáticamente.
- Habría que incluir el mar, países limítrofes…

En fin, si alguien lo mejora o detecta algún error, que se ponga en contacto conmigo y solventaremos los posibles problemas. Saludos.