---
author: rvaquerizo
categories:
- Business Intelligence
- Excel
- Formación
- Monográficos
- Trucos
date: '2012-04-07T13:53:22-05:00'
slug: trucos-excel-mapa-de-mexico-por-estados
tags:
- macros de Excel
- mapas
- mexico
title: Trucos Excel. Mapa de México por Estados
url: /trucos-excel-mapa-de-mexico-por-estados/
---

![mapa_excel_mexico1.png](/images/2012/04/mapa_excel_mexico1.png)

Hoy os presento la versión inicial del**mapa de México por Estados Federales** para que le podáis usar en Excel, Powerpoint, Word o alguna de las herramientas habituales de ofimática. Se trata de un archivo Excel con macros que os [podéis descargar en este enlace](/images/2012/04/mapa-mexico.xlsm "mapa-mexico.xlsm"). La hoja Mapa contiene una serie de _shapes_ que están nombrados para poder cambiar de color en función de una variable tramo. Este Excel inicial está preparado para poder pintar hasta 5 tramos, si deseáis más tramos tenéis que meteros en el código Excel que modifica el color de cada uno de los 32 _shapes_ que componen el mapa, posteriormente lo repasamos de forma rápida. Por otro lado tenemos la división de los estados, el nombre de los _shapes_ y los tramos que previamente habremos preparado. Este ejemplo no pinta nada concreto. La hoja Mapa además dispone de dos botones asociados a las dos macros que contiene el Excel. Por un lado tenemos una macro que nos deja los Estados en blanco y por otro tenemos la macro que nos pinta de cada color elegido el mapa.Un vistazo sobre estos elementos de la hoja Excel:

![mapa_excel_mexico2.png](/images/2012/04/mapa_excel_mexico2.png)

El nombre de la columna Estado se puede modificar. Los nombres están sacados de Wikipedia, entiendo que no deberían de plantear ningún problema. Lo que no se puede modificar es la columna **name** que contiene el nombre asociado a la imagen de windows. Cada uno de los elementos del mapa se asocian a la variable tramo a través de la columna name. La variable tramo es la que nos realiza el mapa de colores, recordamos que sólo tenemos 5 tramos. Los botones son los que ejecutan las macros.

Las macros que lleva el Excel son:

```r
'Esta macro pone el color de todos los estados en blanco

Sub ColorOriginalFormas()
```

```r
Dim K As Integer

Dim Hoja As Worksheet
```

`Set Hoja = Worksheets("Mapa")`

` `````
```r
For K = 1 To Hoja.Shapes.Count

Hoja.Shapes(K).Fill.ForeColor.RGB = RGB(256, 256, 256)

Next K

End Sub
```

Esta macro recorre todos los shapes de la hoja Mapa y los pone en blanco. La otra macro es:

```r
'Macro para colorear cada Estado en función de una variable tramo.

'Los datos de tramo han de ser hechos.

Sub Tramos()

Dim Poblaciones() As Variant

Dim K As Long

Dim Hoja As Worksheet
```

```r
Poblaciones = Worksheets("Mapa").Range("Q1").CurrentRegion.Value

Set Hoja = Worksheets("Mapa")
```

` ```
```r
If Hoja.Shapes(1).Type = msoGroup Then Hoja.Shapes(1).Ungroup

For K = 2 To UBound(Poblaciones, 1)

With Hoja.Shapes(Poblaciones(K, 2)).Fill.ForeColor

If Poblaciones(K, 3) = 1 Then .RGB = RGB(0, 0, 256)

If Poblaciones(K, 3) = 2 Then .RGB = RGB(256, 256, 128)

If Poblaciones(K, 3) = 3 Then .RGB = RGB(128, 256, 256)

If Poblaciones(K, 3) = 4 Then .RGB = RGB(128, 128, 256)

If Poblaciones(K, 3) = 5 Then .RGB = RGB(256, 128, 0)

End With

Next K

End Sub
```

Esta macro, al igual que la anterior, son conocidas por los seguidores del blog porque ya aparecieron en una [entrada anterior](https://analisisydecision.es/trucos-excel-mapa-de-espana-por-provincias-mejores-versiones/). Para el rango poblaciones vamos recorriendo el elemento que contiene el nombre y en función de él modificamos el color del objeto seleccionado. Lo hacemos mediante código RGB, si deseamos tener un nuevo tramo podemos añadir una nueva condición, por otro lado si deseamos eliminar un tramo sólo eliminamos la condición. Siempre tendremos en cuenta que si añadimos o eliminamos tramos tenemos que modificar la leyenda.

El mapa tiene algunas limitaciones:

  * Es muy feo
  * No pinta las islas, pero esta labor es sencilla
  * Sólo está preparado para 5 tramos, se debe preparar para más
  * No se actualiza la leyenda
  * Habría que incluir el mar, países limítrofes,…

En fin, si alguien lo mejora o detecta algún error que se ponga en contacto conmigo y solventaremos los posibles problemas. Saludos.