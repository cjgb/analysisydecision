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
  - consultoría
  - data mining
title: Proyecto. `Text Mining` con Excel (III)
url: /blog/proyecto-text-mining-con-excel-iii/
---

![pyt_3_entradas.JPG](/images/2008/05/pyt_3_entradas.JPG "pyt_3_entradas.JPG")En la anterior entrega del seguimiento de mi proyecto de minería de textos con Excel creé un proceso que leía búsquedas de `Google` y las almacenaba en un fichero Excel que denominaba `base`. El problema que me encontré es que generaba un Excel con una gran cantidad de hojas y posteriormente tenía que leerlas y extraer la información de cada una. Esta metodología no me parece eficiente, es mejor leer una búsqueda, extraer la información relevante de ella e introducirla en mi tablón de datos.

Para extraer la información relevante de cada búsqueda he de conocer muy bien como se almacena cada página web de `Google` en Excel. En un primer vistazo obtengo esto:

![pyt_3_entradas.JPG](/images/2008/05/pyt_3_entradas.JPG "pyt_3_entradas.JPG")

Parece que todas las entradas relevantes aparecen en la columna `A`, tienen 3 filas con datos y están separadas por dos filas. Todas las entradas que considero relevantes (no tabulo los enlaces patrocinados) finalizan con las palabras «`Anotar esto`»:

Los pasos a seguir en mi proceso serían:

1\. Abrir la búsqueda correspondiente
2\. Buscar la primera entrada relevante en la columna `A`
3\. Copiar las celdas con información
4\. Trasponer y pegar las celdas copiadas para crear una tabla de datos

Para abrir las búsquedas ya creamos en su momento macros con Excel que las abrían. Buscar la primera entrada relevante requiere que diseñemos un nuevo proceso, con ayuda del asistente creamos la macro `busca1` que nos identifica la fila con el primer registro que consideramos relevante:

```vb.net
Sub cierra()

  Sheets("search").Select

  Windows("search").Activate

  ActiveWindow.Close SaveChanges:=False

End Sub
```

```vb.net
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

He creado una macro que `cierra` sin guardar `SaveChanges` hojas de cálculo llamadas `search` para evitar abrir ficheros con el mismo nombre y luego he abierto dos búsquedas de `Google` con «`formacion business intelligence`» y las he añadido al archivo que me sirve de `base`: `min.xls` Es evidente que este código puede recibir parámetros e íncides para funcionar de forma automática.

En un primer acercamiento puede ser interesante crear `indices` para las siguientes partes de mi código:

`Workbooks.Open Filename:="http://www.google.es/search?hl=es&q=formacion+business+intelligence&meta="`

`Workbooks.Open Filename:="http://www.google.es/search?q=formacion+business+intelligence&hl=es&start=10&sa=N"`

El parámetro `start=` ha de ir creciendo de `10` en `10` porque marca el número de entrada de la búsqueda. Podemos modificar las opiones de `Google`, pero de momento las mantenemos. Otra parte del código que puede ser susceptible de indizar será:

`After:=Workbooks("min.xls").Sheets(1)`

`After:=Workbooks("min.xls").Sheets(2)`

Indicamos el punto en el que `Copy` la hoja que ha abierto la búsqueda. Siempre irá creciendo en una unidad. Con todo esto creamos el siguiente bucle:

```vb.net
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
```

De momento abrimos sólo algunas entradas para comprobar el correcto funcionamiento del bucle. Parece que añadimos un gran número de hojas a nuestro archivo parece importante tabular cada búsqueda que abrimos, nuestro proceso tiene que ser más «fino». Antes de leer datos hemos de tener clara la estructura de nuestro tablón de datos. El la siguiente entrega será necesario determinar el número de observaciones con las que trabajaremos y que variables hemos de preparar inicialmente.

Si no se ve correctamente esta entrada o no funciona el código remitidme el problema a `rvaquerizo@analisisydecision.es`
