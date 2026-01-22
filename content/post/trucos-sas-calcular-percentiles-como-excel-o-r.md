---
author: rvaquerizo
categories:
  - formación
  - sas
  - trucos
date: '2015-02-16'
lastmod: '2025-07-13'
related:
  - macros-faciles-de-sas-eliminar-outliers-en-una-variable.md
  - truco-sas-crear-ficheros-excel-sin-proc-export-i.md
  - las-cuentas-claras.md
  - truco-sas-crear-ficheros-excel-sin-proc-export-ii.md
  - monograficos-call-symput-imprescindible.md
tags:
  - formación
  - sas
  - trucos
title: Trucos SAS. Calcular percentiles como Excel o R
url: /blog/trucos-sas-calcular-percentiles-como-excel-o-r/
---

Alguna vez habréis calculado un percentil en `Excel` o en `R` y os saldrá distinto de `SAS`. Esto se debe a que [los métodos de cálculo son distintos ](http://en.wikipedia.org/wiki/Percentile)tanto `R` como `Excel` utilizan el mismo método consistente en una interpolación en función de la distancia entre los registros que dan la posición del percentil.[ `SAS` dispone de 5 métodos distintos para calcular el percentil](http://support.sas.com/documentation/cdl/en/procstat/63104/HTML/default/viewer.htm#procstat_univariate_sect028.htm) y por defecto emplea el número 5 y ninguno de los 4 métodos restantes es el que utilizan `R` o `Excel`. Pero podemos programar el método de un modo sencillo, cuesta más entender porque no lo implementa `SAS` que calcularlo. A continuación tenéis una sencilla `macro` que calcula el percentil con el método de `Excel`:

```sas
%macro percentil_excel(ds /*DATOS DE ENTRADA*/
	,varib     /*VARIABLE SOBRE LA QUE SE CALCULA*/
	,percentil /*PERCENTIL DESEADO*/);

%global pct;

proc sort data=&ds. (keep=&varib.) out=intermedio; by &varib.; run;

data _null_;
 	datossid=open('intermedio');
 	no=attrn(datossid,'nobs');
 	call symput ("obs",compress(no));
 	datossid=close(datossid);
run;

*POSICIÓN (P*(N-1)/100)+1;
data _null_;
pos = (&percentil.*(&obs.-1)/100)+1;
call symput ('entera',int(pos));
call symput ('decimal',mod(pos,1));
run;

*APROXIMACION X(p) = X[k] + d(X[k + 1] - X[k]);
data _1;
set intermedio;
if _n_=&entera. or _n_=&entera. + 1;
run;

proc transpose data=_1 out=_1; run;

data _1;
set _1;
d = col2 - col1;
percentil = col1 + &decimal. * (col2 - col1);
call symput('pct',round(percentil,0.0001));
run;

proc delete data=_1 intermedio; run;
%mend;

%percentil_excel(DATOS,x,0.5);

%put &pct.;
```

Una breve explicación. Creamos una tabla sólo con la variable que deseamos analizar, determinamos el número de observaciones de la tabla y la posición donde debe caer el percentil como (`percentil` * (`observaciones` – 1) entre 100 más uno. Sacamos justo los puntos k y k + 1 y realizamos la interpolación en función de la distancia de esos dos puntos para obtener la `macrovariable` `pct` que tiene el resultado que deseamos. Espero que os sea de utilidad. Saludos.
