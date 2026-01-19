---
author: rvaquerizo
categories:
- excel
- formación
- trucos
date: '2009-02-27'
lastmod: '2025-07-13'
related:
- trucos-excel-transponer-con-la-funcion-desref.md
- desref-para-trasponer-en-excel-varias-columnas.md
- truco-excel-transponer-una-fila-en-varias-columnas-con-desref.md
- truco-excel-pasar-un-rango-de-varias-columnas-a-una.md
- truco-excel-repetir-un-campo-a-partir-de-otro-que-define-el-numero-de-repeticiones.md
tags:
- funciones excel
- indirecto
- trasponer
- excel
title: Trucos Excel. Trasponer con la función indirecto
url: /blog/trucos-excel-trasponer-con-la-funcion-indirecto/
---
Una de las tareas más comunes en Excel es la de transponer filas. En ocasiones hemos de transformar columnas en filas o viceversa:

![indirecto.JPG](/images/2009/02/indirecto.JPG)

Es muy habitual copiar y pegar transponiendo pero esta labor es muy manual cuando manejamos hojas con gran cantidad de fórmulas y que pueden generar informes automáticos. Para transponer contamos con la ayuda de la función INDIRECTO de exce. En la ayuda se define como:

« _Devuelve la referencia especificada por una cadena de texto. Las referencias se evalúan de inmediato para presentar su contenido. Use INDIRECTO cuando desee cambiar la referencia a una celda en una fórmula sin cambiar la propia formula_ »

A mi particularmente me gusta esta función porque se evalúa con bastante rapidez y nos permite referenciar otra celda con un texto. Tenemos algunas funciones desarrolladas con código que hacen cosas similares ([función PULL](http://groups.google.com/group/microsoft.public.excel.worksheet.functions/msg/e249f6c074a3adfd)) pero al final es mejor emplear INDIRECTO por si se comparten documentos.

Para comenzar a conocer esta función partimos del ejemplo más sencillo, hacer referencia a la celda (1,1) o A1. Si por ejemplo escribimos INDIRECTO(«A1») nos referenciará la primera celda de la hoja. Del mismo modo INDIRECTO(«F1C1»;FALSO) nos referencia la primera celda de la hoja pero en forma «Fila Columna» para ello necesitamos el segundo parámetro de la función a FALSO. Estos son los dos modos de referenciar con INDIRECTO. Vemos que los parámetros son un texto y una variable booleana que por defecto toma el valor VERDADERO para referencias tipo A1. Con estas directrices el siguiente ejemplo realizará una trasposición de las celdas como indica la figura de arriba. LA referencia tipo F1C1 parece la más acecuada. La columna se mantendrá fija en C1 pero a la fila necesitaremos agregarle un índice. De forma que recorrer las filas sería INDIRECTO(«F1C1»;FALSO) – INDIRECTO(«F2C1»;FALSO) … – INDIRECTO(«FnC1»;FALSO) El índice tendría que ir de 1 a n y sería interesante crearlo de forma que podamos arrastrar la fórmula. ¿Cómo creamos ese índice? Recorriendo la propia columna y restando las unidades necesarias para hacer el índice. En este ejemplo sencillo sería: COLUNMA()-1 ya que empezamos en la segunda columna. Con ello la fórmula sería un texto del modo «FiC1»: **INDIRECTO(«F» &COLUMNA()-1&»C1»;FALSO)** la podemos arrastrar y nos realiza una trasposición perfecta.

Tened en cuenta para trasponer:

  * El rango que debemos recorrer para saber donde ubicar el índice
  * El comienzo de la trasposición para que el índice comience perfectamente

Espero que os sea de utilidad. Si tenéis dudas o sugerencias… [rvaquerizo@analisisydecision.es](mailto:rvaquerizo@analisisydecision.es)