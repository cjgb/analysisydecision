---
author: rvaquerizo
categories:
- Formación
- SAS
- WPS
date: '2012-06-05T05:14:52-05:00'
lastmod: '2025-07-13T16:10:27.169537'
related:
- macros-sas-macro-split-para-partir-un-conjunto-de-datos.md
- truco-sas-crear-ficheros-excel-sin-proc-export-ii.md
- truco-sas-crear-ficheros-excel-sin-proc-export-i.md
- macros-sas-informe-de-un-dataset-en-excel.md
- truco-sas-proc-contents.md
slug: trucos-sas-particionar-y-exportar-a-texto-un-dataset
tags:
- csv
- exportar
title: Trucos SAS. Particionar y exportar a texto un dataset
url: /trucos-sas-particionar-y-exportar-a-texto-un-dataset/
---

Duda que plantea David. Exporta a csv una tabla SAS en varias partes. Ya habrá tiempo para comentarlo:

```r
*TABLA SAS DE EJEMPLO;

data total;

do i=1 to 10000;

importe=ranuni(8)*100;

output;

end;

run;
```

*MACRO QUE RECORRE LA TABLA, PARTE Y EXPORTA CADA PARTE  
NECESITA EL CONJUNTO DE DATOS Y EL TAMAÑO DE CADA PARTE;  
%macro parte(ds, tamanio);  
%do i = 1 %to 10000 %by &tamanio.;  
data parte;  
set &ds. (firstobs = &i. obs = %eval(&i. + &tamanio.));  
run;

PROC EXPORT DATA= WORK.Parte  
OUTFILE= "C:\TEMP\parte&i..csv"  
DBMS=CSV REPLACE;  
RUN;  
proc delete data=parte; quit;  
%end;  
%mend;

%parte(total, 1000);