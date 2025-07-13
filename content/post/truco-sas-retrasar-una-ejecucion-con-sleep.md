---
author: rvaquerizo
categories:
- Modelos
- SAS
- Trucos
date: '2013-10-03T03:09:40-05:00'
slug: truco-sas-retrasar-una-ejecucion-con-sleep
tags: []
title: Truco SAS. Retrasar una ejecución con SLEEP
url: /truco-sas-retrasar-una-ejecucion-con-sleep/
---

El método más sencillo para ejecutar SAS a una hora determinada es el empleo de la función SLEEP:

```r
data _null_;
    momento = "03OCT2013:10:07"dt;
    duerme_hasta = sleep(momento - datetime(), 1);
run;
```
 

Un truco muy sencillo que da respuesta a una duda planteada en el blog. Pensé que ya existía esta entrada. Saludos.