---
author: rvaquerizo
categories:
- formación
- sas
- trucos
date: '2009-10-29'
lastmod: '2025-07-13'
related:
- macros-faciles-de-sas-busca-duplicados.md
- truco-sas-duplicar-registros-si-cumplen-una-condicion.md
- trucos-sas-porque-hay-que-usar-objetos-hash.md
- trucos-sas-union-de-multiples-tablas-sas-con-un-nombre-parecido.md
- trucos-sas-muestras-aleatorias-con-y-sin-reemplazamiento.md
tags:
- duplicados
- proc sql
- sas
- where
title: Trucos SAS. Identificar registros duplicados
url: /blog/trucos-sas-identificar-registros-duplicados/
---
Muy rápido, para identificar registros duplicados existen múltiples formas. Seguramente haré un monográfico sobre este tema pero de momento dejo una píldora:

```r
data aleatorio;

do i=1 to 100000;

id=ranpoi(23456,56781);

if ranuni(5)>=0.3 then output;

end;

run;

proc sql;

create table repes (where=(rep>1)) as select

id, count(id) as rep

from aleatorio

group by 1;

quit;

proc sql;

create table repes (where=(rep=1)) as select

id, count(id) as rep

from aleatorio

group by 1;

quit;
```

Contamos registros y empleamos where como opción de escritura. Muy fácil y perfectamente entendible. No puedo entretenerme más que mi hija me reclama…