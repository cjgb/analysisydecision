---
author: rvaquerizo
categories:
  - consultoría
  - data mining
date: '2008-05-26'
lastmod: '2025-07-13'
related:
  - proyecto-text-mining-con-excel-iii.md
  - proyecto-text-mining-con-excel-ii.md
  - google-mining-analisis-de-las-paginas-indexadas-i.md
  - proyecto-text-mining-con-excel-i.md
  - truco-excel-unir-todos-los-libros-en-una-hoja.md
tags:
  - consultoría
  - data mining
title: Proyecto. Text Mining con Excel (IV)
url: /blog/proyecto-text-mining-con-excel-iv/
---

![pyt_3_entradas.JPG](/images/2008/05/pyt_3_entradas.JPG "pyt_3_entradas.JPG")

En la anterior entrega del seguimiento de mi proyecto de minería de textos con `Excel`, creé un proceso que leía búsquedas de `Google` y las almacenaba en un fichero `Excel` que denominaba `base`. El problema que me encontré es que generaba un `Excel` con una gran cantidad de hojas y posteriormente tenía que leerlas y extraer la información de cada una. Esta metodología no me parece eficiente: es mejor leer una búsqueda, extraer la información relevante de ella e introducirla en mi tablón de datos.

Para extraer la información relevante de cada búsqueda, he de conocer muy bien cómo se almacena cada página web de `Google` en `Excel`. En un primer vistazo, obtengo ésto:

![pyt_3_entradas.JPG](/images/2008/05/pyt_3_entradas.JPG "pyt_3_entradas.JPG")

Parece que todas las entradas relevantes aparecen en la columna `A`, tienen tres filas con datos y están separadas por dos filas. Todas las entradas que considero relevantes (no tabulo los enlaces patrocinados) finalizaban con las palabras "Anotar esto".

Los pasos a seguir en mi proceso serían:

1. Abrir la búsqueda correspondiente.
2. Buscar la primera entrada relevante en la columna `A`.
3. Copiar las celdas con información.
4. Transponer y pegar las celdas copiadas para crear una tabla de datos.

Para abrir las búsquedas, ya creamos en su momento macros con `Excel` que las abrían. Buscar la primera entrada relevante requiere que diseñemos un nuevo proceso; con ayuda del asistente creamos la macro `busca1` que nos identifica la fila con el primer registro relevante:

```vba
Sub busca1()
    ' Buscamos la primera fila que contiene la frase que indica
    ' el final del registro relevante
    Dim fila As Long
    
    Range("A1").Select
    Columns("A:A").Select
    
    fila = Selection.Find(What:=" - Anotar esto", After:=ActiveCell, LookIn:= _
        xlFormulas, LookAt:=xlPart, SearchOrder:=xlByRows, SearchDirection:= _
        xlNext, MatchCase:=False, SearchFormat:=False).Row
End Sub
```

A partir de aquí, tenemos que estudiar la estructura de la entrada:
![pyt_4_estructura.JPG](/images/2008/05/pyt_4_estructura.JPG "pyt_4_estructura.JPG")

El primer registro a leer estará en la columna 1, fila (*fila que contiene el primer "Anotar esto"*) - 3. De las seis filas que componen una entrada nos interesan tres: título, descripción y enlace. Éstas filas las hemos de recorrer, copiar, transponer y pegar en nuestro tablón de datos. 

Es preciso mejorar la macro anterior para que, además de buscar, copie la primera entrada relevante y la pegue en la hoja `Excel` donde deseemos crear nuestro tablón:

```vba
Sub busca_copia()
    Dim fila As Long
    
    Range("A1").Select
    Columns("A:A").Select
    
    ' Buscamos la primera fila relevante
    fila = Selection.Find(What:=" - Anotar esto", After:=ActiveCell, LookIn:= _
        xlFormulas, LookAt:=xlPart, SearchOrder:=xlByRows, SearchDirection:= _
        xlNext, MatchCase:=False, SearchFormat:=False).Row
    
    ' Seleccionamos la primera entrada relevante (3 filas anteriores)
    Range(Cells(fila - 3, 1), Cells(fila, 1)).Copy
    
    ' Nos vamos a otra hoja donde iremos creando el tablón de datos
    Sheets("Hoja1").Select
    Range("A2").Select
    
    ' Pegamos transponiendo
    Selection.PasteSpecial Paste:=xlPasteValues, Operation:=xlNone, SkipBlanks:=False, Transpose:=True
End Sub
```

Empezamos a tener datos tabulados en la hoja `Hoja1` como producto de la copia de los datos de la hoja `search`. Ahora tenemos que diseñar un proceso que realice todos estos pasos de forma automática hasta un número de entradas determinado. Pero ésto queda para una posterior entrega.

Por supuesto, como siempre, si falla algo o no tenéis claro algún paso: `rvaquerizo@analisisydecision.es`. Saludos.