---
author: rvaquerizo
categories:
  - formación
  - sas
date: '2010-01-13'
lastmod: '2025-07-13'
related:
  - las-cuentas-claras.md
  - trucos-sas-trasponer-con-sql-para-torpes.md
  - proc-sql-merge-set.md
  - macros-sas-agrupando-variables-categoricas.md
  - trucos-sas-variables-dummy-de-una-variable-continua.md
tags:
  - case
  - proc sql
  - sas
  - sas procs
title: Uso de CASE en PROC SQL
url: /blog/uso-de-case-en-proc-sql/
---

Vamos a estudiar como funciona CASE en un PROC SQL. Son palabras que aparecen en las búsquedas de Google y también he observado que el número de visitas al blog ha descendido en los últimos días y no sólo es debido a las vacaciones navideñas. El 60% de los clicks a AyD vienen por temas de SAS y en los últimos días tengo muy olvidados los mensajes de esta categoría. Además en el plazo de 2 días voy a dejar de trabajar con esta herramienta por lo que, es posible, que se reduzcan aun más. En fin, a lo que voy, CASE en el PROC SQL. Case nos permite crear campos condicionales dentro del bloque SELECT de una query de PROC SQL:

```r
*DATASET ALEATORIO;

data aleatorio;

do i=1 to 200;

grupo1=1;

if mod(i,2)=0 then grupo1=2;

if mod(i,3)=0 then grupo1=3;

grupo2=rand("binomial",0.05,5);

normal=rand("normal");

uniforme=rand("uniform")*1000;

if grupo1=1 then uniforme=.;

poisson=ranpoi(34,25);

output;

end;

run;
```

Partimos de un dataset aleatorio de 200 observaciones con 2 variables de grupo y 3 variables aleatorias. Un ejemplo sencillo de uso en una consulta de selección:

```r
proc sql;

title "Ejemplo de uso de CASE 1";

select

grupo1,

case

when grupo2<=1 then "tipo 0-1"

else "tipo 2" end as nuevo_grupo2,

sum(distinct poisson) as suma_distintas_poisson

from aleatorio

group by 1,2;

quit;
```

La estructura es bien sencilla:

CASE
WHEN condición1 THEN valor1
…
WHEN condiciónN THEN valorN
ELSE valorN+1 END AS nombre

Las condiciones son excluyentes y necesitamos finalizar la sentencia con ELSE END AS . Es muy práctico para agrupar cualquier tipo de variable, las condiciones pueden incluir más variables tanto numéricas como carácter o mezcla de todas:

```r
proc sql;

title "Ejemplo de uso de CASE 2";

select

/*CONDICIONALES NUMERICAS*/

case

when normal<0 then "NEGATIVA"

else "POSITIVA" end as signo_normal,

/*MEZCLA DE CONDICIONALES*/

case

when poisson>30 then "TIPO x-30"

when grupo1<=2 then "TIPO 2-30"

else "TIPO 3-x" end as nuevo_grupo,

min(poisson) as min_poisson,

max(poisson) as max_poisson,

sum(uniforme) as suma_uniforme

from aleatorio

group by calculated signo_normal, calculated nuevo_grupo;

quit;
```

No sólo pueden ser variables agrupadoras, también se puede realizar sumarizaciones con CASE, un ejemplo forzado (y absurdo):

```r
proc sql;

title "Ejemplo de uso de CASE 3";

select

grupo1,

sum(

case

when grupo2=1 then poisson*10

when grupo2<=3 then poisson*5

else poisson*2 end) as multiplica

from aleatorio

group by 1

order by 2;

quit;
```

Espero que sea útil este breve mensaje. Pero sobre todo espero que perdáis el miedo a esta función, no es de uso muy habitual entre los programadores de SAS.
