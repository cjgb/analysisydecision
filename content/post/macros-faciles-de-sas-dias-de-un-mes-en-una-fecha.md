---
author: rvaquerizo
categories:
- formación
- sas
- trucos
date: '2011-05-29'
lastmod: '2025-07-13'
related:
- trucos-sas-numero-de-dias-de-un-mes.md
- macros-sas-transformar-un-numerico-a-fecha.md
- macros-sas-primer-y-ultimo-dia-del-mes-de-una-fecha-sas.md
- truco-sas-macro-numero-de-dias-de-un-ano.md
- bucle-de-fechas-con-sas-para-tablas-particionadas.md
tags:
- sin etiqueta
title: Macros (fáciles) de SAS. Días de un mes en una fecha
url: /blog/macros-faciles-de-sas-dias-de-un-mes-en-una-fecha/
---
Macro de SAS fácil y rápida que nos permite saber **el número de días que tiene el mes de una fecha de SAS**. La tenía para la automatización de un código que con una media y daba guerra cuando se trataba de un año bisiesto. 3 líneas de código:

`%macro dias(fec);`
```r
((&fec-day(&fec)+1)+31-day((&fec-day(&fec)+1)+31))-(&fec-day(&fec))

%mend;
```

El razonamiento es sencillo. Se trata de poner a día 1 la fecha que le pasamos, irnos un mes después y hacer la diferencia. Por supuesto copiáis y pegáis el ejemplo en el editor:

```r
data uno;

y="03FEB02"d; x=%dias(y); put x=;

y="01FEB04"d; x=%dias(y); put x=;

y="14MAR05"d; x=%dias(y); put x=;

y="10APR11"d; x=%dias(y); put x=;

run;
```

Creo que puede ser de utilidad y también tiene algún otro aspecto interesante sobre macros y la falta de algún signo de puntuación. Saludos.