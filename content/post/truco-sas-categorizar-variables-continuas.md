---
author: rvaquerizo
categories:
- sas
- trucos
date: '2008-06-05'
lastmod: '2025-07-13'
related:
- trucos-sas-variables-dummy-de-una-variable-continua.md
- macros-sas-tramificar-en-funcion-de-una-variable-respuesta.md
- macros-sas-agrupando-variables-categoricas.md
- trucos-sas-variables-dicotomicas-desde-factores.md
- trucos-sas-operaciones-con-tablas-de-dimensiones-con-sas.md
tags:
- sin etiqueta
title: Truco SAS. Categorizar variables continuas
url: /blog/truco-sas-categorizar-variables-continuas/
---
Si necesitamos crear grupos a partir de una variable continua podemos emplear una metodología muy sencilla para crear muestras proporcionales o muestras de un tamaño predeterminado a partir de un conjunto de datos SAS. El método de cálculo es bien sencillo. Si deseamos crear N grupos dividimos la observación entre el total y multiplicamos por los N grupos redondeando al entero más alto. Si deseamos grupos de tamaño M dividimos la observación entre M redondeando al entero más alto. En código SAS:

```r
*DATASET ALEATORIO;
data uno;
	do i=1 to 2000;
	importe=ranuni(0)*1000;
	if rand("uniform")>.34 then output;
	end;
run;

*MACRO PARA IDENTIFICAR EL NUMERO DE OBSERVACIONES DE UN DS;
%macro numobs(ds,mv);
	%global &mv.
	data _null_;
		datossid=open("&ds.");
		no=attrn(datossid,'nobs');
		call symput ("&mv.",compress(no));
		datossid=close(datossid);
	run;
%mend;

%numobs(uno,obs_de_uno);

*ESPECIFICAMOS EL NÚMERO Y EL TAMAÑO DE LOS GRUPOS;
%let numero_de_grupos=4;
%let tamanio_de_grupos=100;

*ORDENAMOS POR LA VARIABLE QUE DESEAMOS CATEGORIZAR;
proc sort data=uno; by importe; run;

*EN UN MISMO DATA CREAMOS LOS GRUPOS;
data uno;
	set uno;

	*CREAMOS N GRUPOS;
	rango1=ceil((_n_/&obs_de_uno.)*№_de_grupos.);

	*CREAMOS GRUPOS DE TAMAÑO M;
	rango2=ceil(_n_/&tamanio_de_grupos.);
run;

proc freq data=uno; tables rango:; quit;
```


Muy sencillo y más páctico. En el futuro crearé un proceso que divida las variables continuas en función de una variable dependiente.

Para dudas o sugerencias rvaquerizo@analisisydecision.es