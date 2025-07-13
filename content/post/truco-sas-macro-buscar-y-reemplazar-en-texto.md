---
author: rvaquerizo
categories:
- SAS
- Trucos
date: '2008-09-02T03:23:38-05:00'
slug: truco-sas-macro-buscar-y-reemplazar-en-texto
tags:
- configuracion regional
- importar
- SAS
- Texto
title: Truco SAS. Macro buscar y reemplazar en texto
url: /truco-sas-macro-buscar-y-reemplazar-en-texto/
---

A veces hay problemas a la hora de importar un fichero de texto a SAS. Por ejemplo el fichero proviene de Access y tiene los números con formato europeo. El siguiente programa hace un buscar y reemplazar pero con SAS. Partimos de un fichero de texto ubicado en c:\temp\pepin.txt así:

4.497,31 2.776,50  
2.555,46 6.782,73  
3.752,77 8.791,32  
1.599,49 6.903,17  
8.584,16 7.050,30  
8.061,74 2.605,04  
3.666,99 7.319,29  
751,63 1.919,96  
5.635,12 4.795,78  
9.714,18 5.342,31  
9.160,85 9.752,27  
7.609,17 2.409,43  
1.855,36 8.768,07  
1.715,74 4.031,63  
8.775,23 7.256,52  
2.339,50 9.234,67  
6.268,95 1.531,50  
4.406,24 5.395,50

Y ejecutamos el siguiente código SAS:  

```r
*MACRO PARA PREPARAR FICHEROS DE TEXTO CON EL FORMATO MAS ADECUADO;
```

```r
%macro reemplazar(ubicacion,fich);

data _null_;

  length char 1.;

  infile "&ubicacion./&fich." lrecl=1 recfm=F missover dsd;

  file "&ubicacion./DEP_&fich." lrecl=1 recfm=F;

  input charASCII.;

  if char ="." then delete;

  else if char="," then char=".";/*LINEAS A VARIAR*/

  put char;

run;

%mend;
```

%reemplazar(c:\temp,pepin.txt);

Tras ejecutar este código en c:\temp tenemos DEP_pepin.txt con la siguiente información:

4497.31 2776.50  
2555.46 6782.73  
3752.77 8791.32  
1599.49 6903.17  
8584.16 7050.30  
8061.74 2605.04  
3666.99 7319.29  
751.63 1919.96  
5635.12 4795.78  
9714.18 5342.31  
9160.85 9752.27  
7609.17 2409.43  
1855.36 8768.07  
1715.74 4031.63  
8775.23 7256.52  
2339.50 9234.67  
6268.95 1531.50  
4406.24 5395.50

Esto es mucho más fácil de leer para SAS.

Muy práctico pero ¡OJO QUE SE CEPILLA COMAS Y PUNTOS EN VARIABLES DE TEXTO! Por supuesto para cualquier duda o mejora: rvaquerizo@analisisydecision.es