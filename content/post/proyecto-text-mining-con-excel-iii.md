---
author: rvaquerizo
categories:
- consultoría
- data mining
date: '2008-05-05'
lastmod: '2025-07-13'
related:
- proyecto-text-mining-con-excel-iv.md
- proyecto-text-mining-con-excel-ii.md
- google-mining-analisis-de-las-paginas-indexadas-i.md
- proyecto-text-mining-con-excel-pasa-a-ser-google-mining.md
- proyecto-text-mining-con-excel-i.md
tags:
- sin etiqueta
title: Proyecto. Text Mining con Excel (III)
url: /blog/proyecto-text-mining-con-excel-iii/
---
Para hacer mi proceso de Text Mining necesito un «tablón» de entrada. Sin información bien tabulada es imposible encontrar patrones sintácticos ni palabras que me ayuden a encontrar mi oportunidad de negocio dentro de la formación en Business Intelligence. Para la realización de este tablón de entrada emplearé macros de Excel que abran resultados de búsquedas en Google y generen tantas hojas en mi archivo como páginas de búsqueda obtenga. Posteriormente estas hojas las uniré en una sóla y está será mi tablón de partida para mi trabajo.

Todas las web de búsquedas de Google que abrimos con Excel contienen una sóla hoja que se llama «search» para evitar problemas creo un archivo excel (_min._ xls) que a su vez abrirá las búsquedas y genero una macro con la que abro dos búsquedas y las añado a mi fichero base _min._ Veamos el código Visual Basic que he generado tras algunos retoques:

```r
Sub cierra()

  Sheets("search").Select

  Windows("search").Activate

  ActiveWindow.Close SaveChanges:=False

End Sub
```

```r
Sub Abre()

'

  Workbooks.Open Filename:="http://www.google.es/search?hl=es&q=formacion+business+intelligence&meta="

  Sheets("search").Select

  Sheets("search").Copy After:=Workbooks("min.xls").Sheets(1)

cierra

 Workbooks.Open Filename:="http://www.google.es/search?q=formacion+business+intelligence&hl=es&start=10&sa=N"

  Sheets("search").Select

  Sheets("search").Copy After:=Workbooks("min.xls").Sheets(2)
```

cierra

End Sub

He creado una macro que cierra sin guardar cambios hojas de cálculo llamadas _search_ para evitar abrir ficheros con el mismo nombre y luego he abierto dos búsquedas de Google con «formación business intelligence» y las he añadido al archivo que me sirve de base: _min.xls_ Es evidente que este código puede recibir parámetros e íncides para funcionar de forma automática.

En un primer acercamiento puede ser interesante crear índices para las siguientes partes de mi código:

```r
Workbooks.Open Filename:="http://www.google.es/search?hl=es&q=formacion+business+intelligence&meta="

Workbooks.Open Filename:="http://www.google.es/search?q=formacion+business+intelligence&hl=es&start=10&sa=N"
```

El parámetro _start=_ ha de ir creciendo de 10 en 10 porque marca el número de entrada de la búsqueda. Podemos modificar las opiones de Google, pero de momento las mantenemos. Otra parte del código que puede ser susceptible de indizar será:

```r
After:=Workbooks("min.xls").Sheets(1)

After:=Workbooks("min.xls").Sheets(2)
```

Indicamos el punto en el que copiamos la hoja que ha abierto la búsqueda. Siempre irá creciendo en una unidad. Con todo esto creamos el siguiente bucle:

``

Sub cierra()
Sheets("search").Select
Windows("search").Activate
ActiveWindow.Close SaveChanges:=False
End Sub

Sub Abre()
'
'
Dim direccion As String

Workbooks.Open Filename:="http://www.google.es/search?hl=es&q=formacion+business+intelligence&meta="
Sheets("search").Select
Sheets("search").Copy After:=Workbooks("min.xls").Sheets(1)

cierra

For i = 2 To 10
direccion = "http://www.google.es/search?q=formacion+business+intelligence&hl=es&start=" & (i - 1) * 10 & "&sa=N"
Workbooks.Open Filename:=direccion
Sheets("search").Select
Sheets("search").Copy After:=Workbooks("min.xls").Sheets(i)

cierra

Next i

End Sub

De momento abrimos sólo algunas entradas para comprobar el correcto funcionamiento del bucle. Parece que añadimos un gran número de hojas a nuestro archivo parece importante tabular cada búsqueda que abrimos, nuestro proceso tiene que ser más «fino». Antes de leer datos hemos de tener clara la estructura de nuestro tablón de datos. El la siguiente entrega será necesario determinar el número de observaciones con las que trabajaremos y que variables hemos de preparar inicialmente.

Si no se ve correctamente esta entrada o no funciona el código remitidme el problema a rvaquerizo@analisisydecision.es