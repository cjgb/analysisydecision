---
author: rvaquerizo
categories:
  - formación
date: '2011-01-31'
lastmod: '2025-07-13'
related:
  - macro-sas-crear-variables-dummy-desde-una-variable-categorica.md
  - trucos-sas-variables-dummy-de-una-variable-continua.md
  - macros-sas-tramificar-en-funcion-de-una-variable-respuesta.md
  - truco-sas-categorizar-variables-continuas.md
  - macros-sas-agrupando-variables-categoricas.md
tags:
  - formación
title: Trucos SAS. Variables dicotómicas desde factores
url: /blog/trucos-sas-variables-dicotomicas-desde-factores/
---

El verbo `dumificar` es una invención propia y consiste en la acción de transformar una variable en una o n `variables dicotómicas` y eso es lo que os planteo en esta entrada, dumificar variables cualitativas con `SAS`. Partimos de una variable discreta o `factor` y hemos de transformarla en n variables, tantas como valores tome el factor, que toman valores 1 o 0 en función del grupo al valor que toma. Gráficamente:

![dummys-desde-factores.png](/images/2011/01/dummys-desde-factores.png "dummys-desde-factores.png")

Seguro que se os ocurren mil aplicaciones y seguro que pensáis que eso ya lo hace `SAS` en determinados modelos, pero tened este código bien guardado porque en ocasiones puede serviros. El método empleado para realizar este proceso es uno que ya habéis podido ver en esta web y consiste en crear instrucciones con `SAS` desde conjuntos de datos. La macro que he creado distingue entre números y caracteres a través de la función `VTYPEX` que tendrá una entrada propia en el blog. Aquí tenéis el código:

```sas
%macro dumifica(in=,out=,varib=);
proc freq data=&in noprint;
tables &varib / out=dum;
run;

data dum;
set dum;
instruccion = trim(left(varib))||" = 0;";
instruccion2 = trim(left(varib))||" = 0;";
run;

data _null_;
set &in;
if vtypex(&varib) then call symput('num','1');
else call symput('num','0');
stop;
run;

data dum;
set dum;
if &num then instruccion = "if "&varib" = "||trim(left(&varib))||" then dummy"||trim(left(_n_))||" = 1 ;";
else instruccion = "if "&varib" = '"||trim(left(&varib))||"' then dummy"||trim(left(_n_))||" = 1 ;";
run;

proc sql noprint;
select instruccion into : instr separated by " "
from dum;
quit;

data &out;
set &in;
%put &instr;
run;

proc datasets nolist;
delete dum;
quit;
%mend;
```

Realizamos una tabla de frecuencias para recoger los valores, si hay perdidos no se genera variable y necesita un trabajo previo. Creamos dos campos instrucción debido a que en unos casos podemos tener variables numéricas y en otro alfanuméricas. Ese tema lo controlamos con el data `_null_` siguiente que nos genera una macro variable local que toma valor 1 si trabajamos con variables numéricas. Después metemos la instrucción en una macro variable `instr` que se ejecuta en el posterior paso data. Finalizamos borrando la tabla de frecuencias. Es muy importante emplear la macro validar caracteres, nos evita factores con caracteres extraños. Por supuesto podéis ejecutar los siguientes ejemplos para analizar su funcionamiento:

```sas
data uno;

do i = 1 to 3000;

grp=min(ranpoi(1,2),4);

output;

end;

run;

*****************************;

%dumifica(in=uno,out=uno,varib=grp);

*****************************;

data uno;

do i=1 to 20000;

if ranuni(8)<=0.3 then grp="uno 1 ";

else if ranuni(3) <= 0.7 then grp="dos 2";

else grp="tres 3";

output;

end;

run;

******************************;

%dumifica(in=uno,out=uno,varib=grp);
```

Creo que el funcionamiento es muy sencillo y el proceso no tiene demasiado talento (de momento). Pero estoy seguro de que os será de utilidad. En algún momento sacaré tiempo para colocar muchas de estas macros ya compiladas en la web para que las podáis utilizar. Allí pondría versiones definitivas.
