---
author: rvaquerizo
categories:
- Consultoría
- Data Mining
date: '2008-06-12T08:36:19-05:00'
lastmod: '2025-07-13T15:58:02.693262'
related:
- proyecto-text-mining-con-excel-iii.md
- proyecto-text-mining-con-excel-iv.md
- proyecto-text-mining-con-excel-ii.md
- proyecto-text-mining-con-excel-pasa-a-ser-google-mining.md
- proyecto-text-mining-con-excel-i.md
slug: google-mining-analisis-de-las-paginas-indexadas-i
tags: []
title: Google Mining. Análisis de las páginas indexadas (I)
url: /google-mining-analisis-de-las-paginas-indexadas-i/
---

El proyecto de minería de textos con Excel ha generado el Google Mining. Veamos como puede ayudar la minería de páginas de búsqueda con Google a gestionar una web. Si en el buscador de Google escribimos site:<nombre del sitio web> obtenemos todas las páginas indexadas de nuestro sitio. En el caso de AyD ponemos site:analisisydecision.es y tenemos 49 resultados correspondientes a las 49 páginas indexadas. La herramienta que hemos construido con macros de Excel nos tabula la información y el resultado se puede ver en [Analisis titulos y metas](/images/2008/06/min.htm).

Con información tabulada podemos empezar a analizar si los títulos del sitio son los correctos y si las «metas» son frases que puedan atraer entradas.

Lo primero que se considera relevante es estudiar las palabras de los títulos. El primer paso será realizar una limpieza de las palabras que no vamos a tener en cuenta. No habríamos de estudiar:

  * preposiciones
  * conjunciones
  * artículos (sólo en algunos casos)
  * fechas
  * signos de puntuación
  * otros irrelevantes

Para realizar esta limpieza creamos un proceso en visual basic que, para un rango seleccionado, elimine los elementos que no participan en el análisis. En este punto se empieza a crear el diccionario para la realización de la minería de textos. Este diccionario irá creciendo y nos servirá para el total de análisis que deseemos realizar.

La metodología para buscar y eliminar las palabras irrelevantes será muy sencilla, utilizamos el método replace:

`Selection.Replace What:=" y ", Replacement:=""`

Pero habremos de introducirlo en un bucle que se recorra nuestro diccionario de palabras irrelevantes. Es decir, hemos de limpiar la tabla de datos palabra por palabra. Las palabras estarán en otra hoja de Excel que denominaremos diccionario. Con todo esto nuestro proceso queda:

```r
Sub Limpieza()

'

' Rutina que reemplaza por vacío

'

Dim pal As String
```

```
'Palabras en diccionario  
Sheets("diccionario").Select  
para = 0  
i = 2  
While (para = 0)  
If Cells(i, 2) = "" Then  
para = 1  
Else: i = i + 1  
End If  
Wend

For j = 2 To i  
Sheets("diccionario").Select  
pal = " " & Cells(j, 2) & " "Sheets("Hoja2").SelectColumns("A:A").Select  
Selection.Replace What:=pal, Replacement:=" "  
Next j  
End Sub
```

En la segunda columna de una hoja Excel que denominamos diccionario colocamos todas las palabras que vamos a eliminar y nuestro bucle primero encuentra cuantas son para posteriormente eliminarlas de la Hoja2, hoja en la que se ha ubicado la tabla de datos. Todo el proceso está en desarrollo. Evidentemente se puede mejorar el código (se aceptan sugerencias y colaboraciones) de todos modos si encontráis problemas, tenéis dudas o incluso queréis desarrollar esta herramienta dentro de vuestra organizacion: [rvaquerizo@analisisydecision.es](mailto:rvaquerizo@analisisydecision.es) En la siguiente entrega comenzaremos a hacer informes de palabras.
