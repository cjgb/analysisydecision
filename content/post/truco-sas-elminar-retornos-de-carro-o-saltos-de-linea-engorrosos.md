---
author: rvaquerizo
categories:
- SAS
- Trucos
date: '2013-09-30T08:46:04-05:00'
lastmod: '2025-07-13T16:08:11.083705'
related:
- truco-sas-limpiar-un-fichero-de-texto-con-sas.md
- macros-sas-limpiar-una-cadena-de-caracteres.md
- truco-sas-limpieza-de-tabuladores-con-expresiones-regulares.md
- macros-faciles-de-sas-normaliza-un-texto-rapido.md
- truco-sas-macro-buscar-y-reemplazar-en-texto.md
slug: truco-sas-elminar-retornos-de-carro-o-saltos-de-linea-engorrosos
tags: []
title: Truco SAS. Elminar retornos de carro o saltos de línea engorrosos
url: /blog/truco-sas-elminar-retornos-de-carro-o-saltos-de-linea-engorrosos/
---

Cuando tenemos saltos de línea o retornos de carro que nos dificultan las lecturas de ficheros de texto podemos leer caracter a caracter con SAS y elminar esos caracteres incómodos.

```r
data _null_;
length char 1.;
infile 'C:\fichero_de_entrada.TXT'  lrecl=1 recfm=F missover dsd;
file 'C:\fichero_de_entrada_depurado.TXT'  lrecl=1 recfm=F;
input charASCII.;
if rank(char) = 13 /*SI ES WIN PONER EL 13*/ then char= "";
put char;
run;
```


Recomiendo no sobreescribir el fichero de texto y crear otro «depurado». Tendréis este problema cuando vuestro programa SAS os lea menos observaciones de las esperadas. Esto suele pasar cuando trabajamos con archivos de distintos sistemas operativos, como por ejemplo cuando leemos un archivo de texto unix con una máquina windows. Saludo.