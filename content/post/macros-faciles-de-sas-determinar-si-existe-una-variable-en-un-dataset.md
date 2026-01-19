---
author: rvaquerizo
categories:
  - formación
  - sas
  - trucos
date: '2011-02-25'
lastmod: '2025-07-13'
related:
  - macro-sas-variables-de-un-dataset-en-una-macro-variable.md
  - macros-sas-informe-de-un-dataset-en-excel.md
  - macro-sas-numero-de-observaciones-de-un-dataset-en-una-macro.md
  - macros-faciles-de-sas-busca-duplicados.md
  - trucos-sas-ejecutar-un-codigo-si-existe-una-tabla-o-un-fichero.md
tags:
  - '%upcase'
  - dictionary
  - scan
title: Macros (fáciles) de SAS. Determinar si existe una variable en un dataset
url: /blog/macros-faciles-de-sas-determinar-si-existe-una-variable-en-un-dataset/
---

Duda que me plantearon el otro día. ¿Es posible determinar si existe una variable en un conjunto de datos SAS? Pretendían crear una macro variable que tomara el valor 1 si existía o 0 si no existía. Resolví la duda pero me guardé la macro para ponerla en el blog y así la podéis utilizar todos. De eso se trata, de compartir mis conocimientos con todos de forma altruista por ello prefiero que planteéis las dudas en el blog, no por correo. Así, entre todos, las podemos resolver. En este caso la macro es muy sencilla y tiene pocas líneas:

```r
%macro existe_variable(datos,varib);
%global existe;

%if %index(&datos.,.)>0 %then %do;
%let library=%upcase(%scan("&datos.",1,"."));
%let ds=%upcase(%scan("&datos.",2,"."));
%end;

%else %do;
%let library=WORK;
%let ds=&datos.
%end;

proc sql noprint;
select count(*) into: existe
from dictionary.columns
where upcase(libname)="&library." and upcase(memname)="&ds." and
upcase(name)=%upcase("&varib.");
quit;

%mend;;
```

La macro merece algún comentario. Mediante %scan separamos la librería del dataset. Siempre trabajamos con mayúsculas. Realizamos una consulta a una de las tablas de dictionary de SAS, en concreto a columns. Contamos el número de veces que puede aparecer una variable, como mucho una y es el valor que toma la macro variable existe. Por supuesto acompaño de ejemplo de uso:

```r
data sasuser.uno;
do i=1 to 100;
do j=1 to 10;
output;
end;
end;
run;
**********************;
%existe_variable(sasuser.uno,j);
**********************;
data uno;
set sasuser.uno;
if &existe. then do;
drop j;
end;
run;
```

La verdad es que una vez realizado el proceso no le encuentro mucha utilidad pero ahí le tenéis por si le necesitáis en alguna ocasión. Saludos.
