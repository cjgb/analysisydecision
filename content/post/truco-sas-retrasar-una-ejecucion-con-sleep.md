---
author: rvaquerizo
categories:
  - modelos
  - sas
  - trucos
date: '2013-10-03'
lastmod: '2025-07-13'
related:
  - truco-excel-y-sas-ejecutar-sas-desde-macro-en-excel.md
  - macros-faciles-de-sas-dias-de-un-mes-en-una-fecha.md
  - trucos-sas-macrovariable-a-dataset.md
  - truco-sas-sysecho-para-controlar-las-ejecuciones-en-enterprise-guide.md
  - trucos-sas-ejecutar-un-codigo-si-existe-una-tabla-o-un-fichero.md
tags:
  - sin etiqueta
title: Truco SAS. Retrasar una ejecución con SLEEP
url: /blog/truco-sas-retrasar-una-ejecucion-con-sleep/
---

El método más sencillo para ejecutar SAS a una hora determinada es el empleo de la función SLEEP:

```r
data _null_;
    momento = "03OCT2013:10:07"dt;
    duerme_hasta = sleep(momento - datetime(), 1);
run;
```

Un truco muy sencillo que da respuesta a una duda planteada en el blog. Pensé que ya existía esta entrada. Saludos.
