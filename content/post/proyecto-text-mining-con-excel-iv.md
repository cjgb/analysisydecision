---
author: rvaquerizo
categories:
- Consultoría
- Data Mining
date: '2008-05-26T08:13:44-05:00'
slug: proyecto-text-mining-con-excel-iv
tags: []
title: Proyecto. Text Mining con Excel (IV)
url: /proyecto-text-mining-con-excel-iv/
---

[](/images/2008/05/pyt_3_entradas.JPG "pyt_3_entradas.JPG")En la anterior entrega del seguimiento de mi proyecto de minería de textos con Excel creé un proceso que leía búsquedas de Google y las almacenaba en un fichero excel que denominaba base. El problema que me encontré es que generaba un excel con una gran cantidad de hojas y posteriormente tenía que leerlas y extraer la información de cada una. Esta metodología no me parece eficiente, es mejor leer una búsqueda, extraer la información relevante de ella e introducirla en mi tablón de datos.

Para extraer la información relevante de cada búsqueda he de conocer muy bien como se almacena cada página web de Google en Excel. En un primer vistazo obtengo esto:

[![pyt_3_entradas.JPG](/images/2008/05/pyt_3_entradas.JPG)](/images/2008/05/pyt_3_entradas.JPG "pyt_3_entradas.JPG")

Parece que todas las entradas relevantes aparecen en la columna A, tienen 3 filas con datos y están separadas por dos filas. Todas las entradas que considero relevantes (no tabulo los enlaces patrocinados) finalizan con las palabras «Anotar esto»:

Los pasos a seguir en mi proceso serían:

1\. Abrir la búsqueda correspondiente  
2\. Buscar la primera entrada relevante en la columna A  
3\. Copiar las celdas con información  
4\. Trasponer y pegar las celdas copiadas para crear una tabla de datos

Para abrir las búsquedas ya creamos en su momento macros con Excel que las abrían. Buscar la primera entrada relevante requiere que diseñemos un nuevo proceso, con ayuda del asistente creamos la macro _busca1_ que nos identifica la fila con el primer registro que consideramos relevante:

```r
Sub busca1()

'

'

  Range("A1").Select

  Columns("A:A").Select
```

```r
'Buscamos la primera fila que contiene la frase que me indica

'el final del registro relevante

  fila = Selection.Find(What:=" - Anotar esto", After:=ActiveCell, LookIn:= _

  xlFormulas, LookAt:=xlPart, SearchOrder:=xlByRows, SearchDirection:= _

  xlNext, MatchCase:=False, SearchFormat:=False).Row
```
`End Sub``A partir de aquí tenemos que estudiar la estructura de la entrada:``[![pyt_4_estructura.JPG](/images/2008/05/pyt_4_estructura.JPG)](/images/2008/05/pyt_4_estructura.JPG "pyt_4_estructura.JPG")`

El primer registro a leer estará en la columna 1 fila _fila que contiene el primer "Anotar esto"_ \- 3. De las 6 filas que componen una entrada nos interesan 3: título, descripción y enlace. Estas filas las hemos de recorrer, copiar, transponer y pegar en nuestro tablón de datos. Es preciso mejorar la macro anterior para que, además de buscar, copie la primera entrada relevante y la pegue en la hoja Excel donde deseemos crear nuestro tablón de entrada:

```r
Sub busca_copia()

'

'

  Range("A1").Select

  Columns("A:A").Select
```

```r
'Buscamos la primera fila que contiene la frase que me indica

'el final del registro relevante

  fila = Selection.Find(What:=" - Anotar esto", After:=ActiveCell, LookIn:= _

  xlFormulas, LookAt:=xlPart, SearchOrder:=xlByRows, SearchDirection:= _

  xlNext, MatchCase:=False, SearchFormat:=False).Row
```

```r
'Seleccionamos la primera entrada relevante

Range(Cells(fila - 3, 1), Cells(fila, 1)).Copy
```

```r
'Nos vamos a otra hoja donde iremos creando el tablón de datos

Sheets("Hoja1").Select

Range("A2").Select
```

```r
'Pegamos transponiendo

Selection.PasteSpecial Paste:=xlPasteValues, Operation:=xlNone, SkipBlanks _

  :=False, Transpose:=True
```

End Sub

Empezamos a tener datos tabulados en la hoja "Hoja1" como producto de la copia de los datos de la hoja _search_. Ahora tenemos que diseñar un proceso que realice todos estos pasos de forma automática hasta un número de entradas determinado. Así dispondremos de nuestro tablón de datos. Pero esto queda para una posterior entrega.

Por supuesto, como siempre, si falla algo o no tenéis claro algún paso rvaquerizo@analisisydecision.es