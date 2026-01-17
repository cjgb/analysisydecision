---
author: rvaquerizo
categories:
- Formación
- SAS
- Trucos
date: '2009-06-03T01:46:25-05:00'
lastmod: '2025-07-13T16:10:28.693292'
related:
- truco-sas-transformar-variable-caracter-a-fecha.md
- trabajo-con-fechas-sas-formatos-de-fecha-sas-mas-utilizados.md
- transformar-variables-en-sas-caracter-a-numerico.md
- trucos-sas-pasar-fecha-a-caracter-en-sas.md
- macros-sas-transformar-un-numerico-a-fecha.md
slug: trucos-sas-pasar-de-caracter-a-numerico-y-viceversa
tags: []
title: Trucos SAS. Pasar de caracter a numérico y viceversa
url: /blog/trucos-sas-pasar-de-caracter-a-numerico-y-viceversa/
---

Llega un gran número de visitas a AyD buscando como transformar en SAS variables caracter a numéricas y viceversa. Pero estas visitas están muy poco tiempo y me he planteado que los mensajes que hay dedicados al uso de PUT e INPUT no son claros. Por este motivo planteo un truco SAS de transformación de variables muy corto y concreto. Como es habitual lo vemos con ejemplos:

**Transformar de caracter a numérico:**

```r
data uno;

char="2009";

num1=char*1;

num2=input(char,best16.);

run;
```
`proc contents; quit;`

Dos formas de hacerlo, multiplicando por 1 o bien con INPUT(variable,formato). Una transformación muy habitual, de caracter a fecha SAS:

```r
data uno;

char="10/09/2009";

fecha=input(char,ddmmyy10.);

run;
```
`proc contents; quit;``Transformar de numérico a caracter:`
```r
data dos;

num=2009;

char=put(num,4.);

run;

proc contents; quit;
```
`Transformamos con PUT(variable,formato). Creo que he dejado clara la metodología de todos modos si tenéis alguna duda o sugerencia... rvaquerizo@analisisydecision.es`