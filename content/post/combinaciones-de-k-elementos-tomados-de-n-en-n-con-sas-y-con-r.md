---
author: rvaquerizo
categories:
- Formación
- R
- SAS
- Trucos
date: '2010-04-10T09:12:53-05:00'
slug: combinaciones-de-k-elementos-tomados-de-n-en-n-con-sas-y-con-r
tags:
- ''
- combinaciones
title: Combinaciones de k elementos tomados de n en n. Con SAS y con R
url: /combinaciones-de-k-elementos-tomados-de-n-en-n-con-sas-y-con-r/
---

Me gustaría plantearos un problema que me ha ocurrido recientemente con SAS. Necesitaba todas las posibles combinaciones de 9 elementos tomados de n en n. Tenia que crear un dataset con todas estas combinaciones. Antes de ponerme a programar toca buscar en Google « _sas combinations_ » y tras un rato buscando encuentro el [siguiente link](http://www2.sas.com/proceedings/sugi23/Posters/p177.pdf). Este link contiene una macro de SAS que nos permite crear todas las combinaciones de k elementos tomados de n en n:

```r
%macro comb(dsout=_null_,n=,k=);

%local dsout n k start stop i;

%let start = 1;

%let stop = %eval(&n. - &k.);

data &dsout;

retain j 1;

%do i=1 %to &k;

%let stop=%eval(&stop.+1);

do varib&i = &start to &stop;

%let start=%str(%(varib&i + 1 %));

%end;

output ;

j + 1;

%do i=1 %to &k;

end;

%end;

run;

%mend comb;
```

Es un código bastante eficiente que, al final, es una forma de parametrizar un bucle. De todos modos **roza la genialidad**. Esta misma duda se planteo [en la lista de R](https://stat.ethz.ch/mailman/listinfo/r-help-es). Y me pare a pensar: ¿Cómo puede hacer esto mismo en R? Escribimos en Google «combinations R» y la segunda entrada es:

<https://stat.ethz.ch/pipermail/r-help/2002-November/026716.html> El paquete [gregmisc ](http://cran.r-project.org/web/packages/gregmisc/index.html)tiene la funcion combinations:

```r
combinations(4, 2)

[,1] [,2]

[1,]    1    2

[2,]    1    3

[3,]    1    4

[4,]    2    3

[5,]    2    4

[6,]    3    4
```

Es decir, solo tenemos que irnos al CRAN o poner _require(gregmisc)._ Ahora bien, ¿que sucede si lo que deseamos es crear combinaciones de un vector de valores? Por ejemplo, si tengo 9 variables para mi modelo cual es el mejor modelo posible tomando variables de 4 en 4. Os planteo como ejercicio hacer esto. A ver si os cuesta mas con R o con SAS. Es sencillo pinchad los link…