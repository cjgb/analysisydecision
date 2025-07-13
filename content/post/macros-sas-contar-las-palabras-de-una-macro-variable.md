---
author: rvaquerizo
categories:
- Formación
- SAS
- Trucos
date: '2012-12-11T07:42:37-05:00'
slug: macros-sas-contar-las-palabras-de-una-macro-variable
tags: []
title: Macros SAS. Contar las palabras de una macro variable
url: /macros-sas-contar-las-palabras-de-una-macro-variable/
---

Una macro de SAS interesante que nos permite ahorrar código. Dada una macro variable necesitamos **contar el número de palabras** que tiene esta macro variable. Para ello vamos a crear una función con código macro:

```r
%let texto = uno dos tres;

%macro cuenta(mv);
%eval(%sysfunc(length(%cmpres(&mv.),%str( ))) - %length(&mv.) + 1)
%mend;

%put La Macrovariable Texto tiene %cuenta(&texto.) palabras;
```
 

Vemos que la macro variable texto tiene tres palabras y necesitamos contabilizarlas para automatizar un código. La propuesta que se plantea es el cálculo de la longitud de la macro sin espacios frente a la longitud de la macro variable con espacios. La diferencia más uno será el número de palabras de nuestro texto. Como aspectos interesantes tenéis el uso de _%str( )_ , _%cmpres_ y como se juega con _%sysfunc_ para evitar algún que otro problema. Esta macro tiene sus problemas, no pongáis más de dos espacios que la volvéis loca. Pero puede resultar muy útil para determinadas cosas. Saludos.