---
author: rvaquerizo
categories:
  - excel
  - trucos
date: '2008-07-17'
lastmod: '2025-07-13'
related:
  - trucos-excel-modificar-la-configuracion-regional-con-visual-basic.md
  - trucos-excel-pasar-de-caracter-a-numerico-con-formulas.md
  - truco-sas-sas-y-dde-aliados-de-excel.md
  - truco-sas-crear-ficheros-excel-sin-proc-export-ii.md
  - trucos-excel-y-sas-complemento-para-cambiar-la-configuracion-regional.md
tags:
  - sin etiqueta
title: Truco Excel. Obtener cambio de divisas on-line
url: /blog/truco-excel-obtener-cambio-de-divisas-on-line/
---

El siguiente truco Excel es muy sencillo. Se trata de una consulta web que nos permite obtener el cambio de divisas a Euro casi practicamente on-line. La consulta se realiza sobre la web [www.finanzas.com](http://www.finanzas.com/) sitio que además quiero recomendar, desde él sigo la imparable caida de mis valores…

La consulta es la siguiente:

```r
Sub cambio_divisas()

'

'

    With Application

        .DecimalSeparator = "."

        .ThousandsSeparator = ","

        .UseSystemSeparators = False

    End With

    With ActiveSheet.QueryTables.Add(Connection:= _

        "URL;http://www.finanzas.com/divisas", Destination:=Range("A1"))

        .Name = "divisas_1"

        .FieldNames = True

        .RowNumbers = False

        .FillAdjacentFormulas = False

        .PreserveFormatting = True

        .RefreshOnFileOpen = False

        .BackgroundQuery = True

        .RefreshStyle = xlInsertDeleteCells

        .SavePassword = False

        .SaveData = True

        .AdjustColumnWidth = True

        .RefreshPeriod = 0

        .WebSelectionType = xlSpecifiedTables

        .WebFormatting = xlWebFormattingNone

        .WebTables = "1"

        .WebPreFormattedTextToColumns = True

        .WebConsecutiveDelimitersAsOne = True

        .WebSingleBlockTextImport = False

        .WebDisableDateRecognition = False

        .WebDisableRedirections = False

        .Refresh BackgroundQuery:=False

    End With

    With Application

        .DecimalSeparator = "."

        .ThousandsSeparator = ","

        .UseSystemSeparators = True

    End With

End Sub
```

Primero cambiamos los separadores de miles y decimales, posteriormente realizamos la consulta a www.finanzas.com/divisas y ya tenemos tabulada la información. Además no sobreescribimos anteriores consultas, siempre se añadirán gracias a RefreshStyle por lo que podemos hacer un seguimiento del cambio. A mí me ha sido muy útil para seguir el efecto del precio de unos fondos de inversión.
