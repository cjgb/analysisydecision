---
author: rvaquerizo
categories:
  - formación
  - sas
  - trucos
date: '2010-10-27'
lastmod: '2025-07-13'
related:
  - macro-facil-de-sas-longitud-de-la-parte-decimal-de-un-numero.md
  - macros-sas-calular-la-longitud-de-un-numero.md
  - macros-sas-pasar-de-texto-a-numerico.md
  - transformar-variables-en-sas-caracter-a-numerico.md
  - truco-sas-macro-buscar-y-reemplazar-en-texto.md
tags:
  - length
  - put
  - scan
title: Duda de SAS. Longitud de la parte decimal de un número
url: /blog/duda-de-sas-longitud-de-la-parte-decimal-de-un-numero/
---

Una búsqueda que me ha llegado. Longitud de la parte decimal de un número con SAS. Nos sirve para recordar (me gusta insistir en el tema) como transformamos números en caracteres con SAS. La función PUT es la que realiza esta tarea:

````r
```sas
data _null_;

y=67.34123432;

x=length(scan(put(y,best32.),2,"."));

put x=;

run;
````

Transformamos un número a texto. Con SCAN buscamos la parte decimal puesto que el separador será el . Y con LENGTH tenemos la longitud resultante del texto obtenido. No sé para que puede servir esto pero ahí os planteo como se resuelve.
