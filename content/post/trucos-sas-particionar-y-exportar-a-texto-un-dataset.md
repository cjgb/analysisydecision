---
author: rvaquerizo
categories:
  - formación
  - sas
  - wps
date: '2012-06-05'
lastmod: '2025-07-13'
related:
  - macros-sas-macro-split-para-partir-un-conjunto-de-datos.md
  - truco-sas-crear-ficheros-excel-sin-proc-export-ii.md
  - truco-sas-crear-ficheros-excel-sin-proc-export-i.md
  - macros-sas-informe-de-un-dataset-en-excel.md
  - truco-sas-proc-contents.md
tags:
  - csv
  - exportar
title: Trucos SAS. Particionar y exportar a texto un dataset
url: /blog/trucos-sas-particionar-y-exportar-a-texto-un-dataset/
---

Duda que plantea David: exportar a `.csv` una tabla SAS en varias partes. Aquí el código necesario:

```sas
* TABLA SAS DE EJEMPLO;
data total;
    do i = 1 to 10000;
        importe = ranuni(8) * 100;
        output;
    end;
run;

/* MACRO QUE RECORRE LA TABLA, PARTE Y EXPORTA CADA PARTE.
   NECESITA EL CONJUNTO DE DATOS Y EL TAMAÑO DE CADA PARTE */
%macro parte(ds, tamanio);
    %do i = 1 %to 10000 %by &tamanio.;
        data parte;
            set &ds. (firstobs = &i. obs = %eval(&i. + &tamanio. - 1));
        run;

        proc export data=work.parte
            outfile="C:\TEMP\parte&i..csv"
            dbms=csv replace;
        run;
        
        proc delete data=parte; 
        run;
    %end;
%mend;

%parte(total, 1000);
```

Ya habrá tiempo para comentarlo. Saludos.