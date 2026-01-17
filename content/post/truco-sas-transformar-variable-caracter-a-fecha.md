---
author: rvaquerizo
categories:
- Formación
- SAS
- Trucos
date: '2015-07-23T04:12:35-05:00'
lastmod: '2025-07-13T16:08:40.532222'
related:
- trucos-sas-pasar-de-caracter-a-numerico-y-viceversa.md
- trabajo-con-fechas-sas-formatos-de-fecha-sas-mas-utilizados.md
- trucos-sas-pasar-fecha-a-caracter-en-sas.md
- macros-sas-transformar-un-numerico-a-fecha.md
- transformar-variables-en-sas-caracter-a-numerico.md
slug: truco-sas-transformar-variable-caracter-a-fecha
tags:
- INPUT
title: Truco SAS. Transformar variable caracter a fecha
url: /blog/truco-sas-transformar-variable-caracter-a-fecha/
---

Pregunta de una lectora, cómo pasar una variable caracter de la forma ’23/08/2015′ a una fecha SAS. Es muy sencillo y un buen ejemplo de uso de input:

data _null_;
y=’21/07/2014′;
x=input(y,ddmmyy10.);
format x ddmmyy10.;
put x=;
run;

Recordad, input de caracter a número y put viceversa. Saludos.