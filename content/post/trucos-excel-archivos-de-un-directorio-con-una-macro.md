---
author: rvaquerizo
categories:
  - excel
  - formación
  - trucos
date: '2010-11-02'
lastmod: '2025-07-13'
related:
  - truco-excel-application-getopenfilename-el-explorador-de-archivos-sencillo-en-macro.md
  - truco-sas-dataset-con-los-ficheros-y-carpetas-de-un-directorio.md
  - trucos-excel-unir-varios-excel-en-uno.md
  - truco-excel-abrir-multiples-libros-de-excel-en-distintas-hojas-de-un-nuevo-libro.md
  - trucos-sas-mas-usos-de-infile-y-pipe-directorios-en-tablas-sas.md
tags:
  - excel
  - formación
  - trucos
title: Trucos Excel. Archivos de un directorio con una macro
url: /blog/trucos-excel-archivos-de-un-directorio-con-una-macro/
---

Puede resultarnos útil tener todos los archivos de un directorio en una tabla de excel. Si estamos documentando un proceso, si nos dan un gran número de ficheros y tenemos que realizar procesos repetitivos sobre ellos, si queremos tener inventariados nuestros programas,… Para esto os planteo una macro bien sencilla que recorre un directorio y nos escribe los elementos que encuentra en él. El código visual basic para la macro en Excel no puede ser más sencillo:

```vba
Sub explora()

'Macro para poner los archivos de un directorio en una hoja Excel

Dim directorio, nombre_completo, tipo_fichero As String

Dim tam As Long

directorio = "C:\temp"

'Si deseamos especificar el tipo de fichero

tipo_fichero = "*"

'ChDir directorio

directorio = directorio & "\*." & tipo_fichero

'Recorre el directorio hasta que no hay elementos

fichero = Dir(directorio, vb)

i = 1

Do While fichero <> ""

'Pone en un excel vacío los elementos que encuentra

Cells(i, 1) = fichero

i = i + 1

fichero = Dir

Loop

'

End Sub
```

El «talento» está en el uso de `Dir` y en la realización del bucle. Como añadido tenemos una variable `tipo_fichero` que nos permite acotar la extensión de los ficheros a listar. Un truco sencillo y que puede ayudarnos a automatizar mucho código. Yo la cree porque un proceso de SQL SERVER me devolvía un gran número de ficheros de texto distintos cada vez y necesitaba automatizar su lectura. Espero que os sea de utilidad. Saludos.
