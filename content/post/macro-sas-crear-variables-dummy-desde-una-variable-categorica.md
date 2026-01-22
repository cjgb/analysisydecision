---
author: rvaquerizo
categories:
  - formación
  - sas
  - trucos
  - wps
date: '2015-12-02'
lastmod: '2025-07-13'
related:
  - trucos-sas-variables-dummy-de-una-variable-continua.md
  - trucos-sas-variables-dicotomicas-desde-factores.md
  - macros-sas-tramificar-en-funcion-de-una-variable-respuesta.md
  - truco-sas-categorizar-variables-continuas.md
  - macro-sas-variables-de-un-dataset-en-una-macro-variable.md
tags:
  - formación
  - sas
  - trucos
  - wps
title: Macro SAS. Crear variables dummy desde una variable categórica
url: /blog/macro-sas-crear-variables-dummy-desde-una-variable-categorica/
---

[En alguna ocasión ya he conjugado el verbo dumificar](https://analisisydecision.es/trucos-sas-variables-dummy-de-una-variable-continua/) y preparando una segmentación he creado una macro `SAS` que genera variables `dummy` a partir de variables categóricas, es decir, si la variable A toma valores 1, 2 y 3 tendría que generar A_1 con valor 1 si A toma 1 y con valor 0 en caso contrario, A_2 tiene valor 1 si A es igual a 2 y A_3 tiene valor 1 si A es igual a 3, no es complicado de comprender, pasamos de una variable con 3 niveles a 3 variables con valores 0 o 1. Para esto podemos emplear `arrays` o la siguiente macro:

```sas
%macro dumificar(varib, grupos, mv);
%global &mv.;
data instruccion;
do i=1 to &grupos.;

instruccion=" &varib._"||compress(put(i,3.))||
"=0; IF &varib.="||put(i,3.)||" THEN &varib._"||compress(put(i,3.))||"=1";

output;
end;
run;

proc sql noprint ;
select instruccion into: &mv. separated by ";";
from instruccion;
quit;
proc delete data=instruccion;quit;
%mend;
```

La intención es crear de forma automática un código del tipo `_VARIABLE_1=0; IF VARIABLE = 2 THEN VARIABLE_1=1;` La macro tiene 3 parámetros, `VARIB` que es la variable que deseamos `dumificar`, `GRUPOS` que es el número de grupos de la variable que vamos a transformar en `dummies` y `MV` que es el nombre de la `macrovariable` que tiene el código `SAS` que generamos de forma automática. A modo de ejemplo de uso:

```sas
data aleatorios;
do i=1 to 1000 ;
datoA = min(ranpoi(2,4),9);
if datoA <= 3 then datoB = ranpoi(89,2);
else if datoA <= 5 then datoB = min(ranpoi(89,6),6);
else datoB = min(ranpoi(89,2),3);
output;
end;
drop i;
run;
```

```sas
%dumificar(datoA, 9, dumifica_datoA);
%dumificar(datoB, 8, dumifica_datoB);
```

```sas
data aleatorios;
set aleatorios;
&dumifica_datoA.;
&dumifica_datoB.;
run;
```

Espero que os sea de utilidad esta macro. Saludos.
