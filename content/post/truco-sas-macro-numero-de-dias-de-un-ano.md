---
author: rvaquerizo
categories:
- SAS
- Trucos
- WPS
date: '2012-06-07T05:34:52-05:00'
slug: truco-sas-macro-numero-de-dias-de-un-ano
tags: []
title: Truco SAS. Macro número de días de un año
url: /truco-sas-macro-numero-de-dias-de-un-ano/
---

Macro de SAS que te dice el número de días que tiene un año. 

```r
%macro dias_anio(anio);

"31DEC&anio."d-"01JAN&anio."d+1

%mend;
```

A lo mejor ya la he puesto, no me lo tengáis en cuenta.