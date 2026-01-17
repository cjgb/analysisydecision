---
author: rvaquerizo
categories:
- SAS
- Trucos
- WPS
date: '2012-06-07T05:34:52-05:00'
lastmod: '2025-07-13T16:08:25.341820'
related:
- macros-faciles-de-sas-dias-de-un-mes-en-una-fecha.md
- trucos-sas-numero-de-dias-de-un-mes.md
- macros-sas-transformar-un-numerico-a-fecha.md
- bucle-de-fechas-con-sas-para-tablas-particionadas.md
- trucos-sas-pasar-fecha-a-caracter-en-sas.md
slug: truco-sas-macro-numero-de-dias-de-un-ano
tags: []
title: Truco SAS. Macro número de días de un año
url: /blog/truco-sas-macro-numero-de-dias-de-un-ano/
---

Macro de SAS que te dice el número de días que tiene un año.

```r
%macro dias_anio(anio);

"31DEC&anio."d-"01JAN&anio."d+1

%mend;
```

A lo mejor ya la he puesto, no me lo tengáis en cuenta.