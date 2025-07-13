---
author: rvaquerizo
categories:
- Formación
- SAS
date: '2016-08-02T07:22:47-05:00'
lastmod: '2025-07-13T16:06:32.303221'
related:
- test-de-levene-con-sas.md
- numeros-aleatorios-con-sas.md
- truco-sas-grafico-de-correlaciones.md
- minimo-de-una-matriz-de-datos-en-sas.md
- determinar-el-mimino-tamano-muestral-para-detectar-un-cambio-en-la-fraccion-no-conforme.md
slug: test-de-bondad-de-ajuste-con-sas
tags:
- proc univariate
title: Test de bondad de ajuste con SAS
url: /test-de-bondad-de-ajuste-con-sas/
---

Pregunta que me han hecho hoy. Cómo hacer un test de bondad de ajuste con SAS y la respuesta que he dado:

```r
data datos_aleatorios;
do i=1 to 200000;
*GENERAMOS UNAS VARIABLES ALEATORIAS;
variable_gamma = rangam(89,450);
variable_exponencial = ranexp(23)*100+0.17045;
output;
end;
run;

*ods select ParameterEstimates GoodnessOfFit ;
proc univariate data=datos_aleatorios;
   var var:;
   histogram /   gamma;
run;
```
 

Mucho cuidado con estos test de hipótesis. Yo suelo conformarme con ver la tabla de cuantiles. Saludos.