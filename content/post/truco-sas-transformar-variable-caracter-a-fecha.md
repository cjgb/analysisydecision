---
author: rvaquerizo
categories:
- Formación
- SAS
- Trucos
date: '2015-07-23T04:12:35-05:00'
slug: truco-sas-transformar-variable-caracter-a-fecha
tags:
- INPUT
title: Truco SAS. Transformar variable caracter a fecha
url: /truco-sas-transformar-variable-caracter-a-fecha/
---

Pregunta de una lectora, cómo pasar una variable caracter de la forma ’23/08/2015′ a una fecha SAS. Es muy sencillo y un buen ejemplo de uso de input:

data _null_;  
y=’21/07/2014′;  
x=input(y,ddmmyy10.);  
format x ddmmyy10.;  
put x=;  
run;

Recordad, input de caracter a número y put viceversa. Saludos.