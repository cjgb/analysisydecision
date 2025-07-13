---
author: rvaquerizo
categories:
- Formación
- SAS
- Trucos
date: '2010-07-29T02:58:29-05:00'
slug: trucos-sas-numero-de-dias-de-un-mes
tags:
- fechas sas
- INTNX
title: Trucos SAS. Número de días de un mes
url: /trucos-sas-numero-de-dias-de-un-mes/
---

Están entrando muchas visitas con las palabras «número de días de un mes en SAS». Y hoy vamos a dar respuesta a estas entradas con una macro y un truco de SAS. Si tenemos una fecha en formato AAAAMM numérica, típica de las particiones de Oracle, disponemos de la siguiente macro:

```r
%macro dias(mes);

*VARIABLES AÑO Y MES;

%let y=%sysfunc(int(&mes./100));

%let m=%sysfunc(mod(&mes.,100));

*TRATAMIENTO ESPECIAL PARA LOS DICIEMBRES;

%if &m.=12 %then %do;

%let m1=1;

%let y1=%eval(&y.+1);

%end;

%else %do;

%let m1=%eval(&m.+1);

%let y1=&y.;

%end;

*01/MES MAS 1 - 01/MES;

%let ini=%sysfunc(mdy(&m.,1,&y.));

%let fin=%sysfunc(mdy(&m1.,1,&y1.));

%let dias=%eval(&fin.-&ini.);

*AL FINAL LA MACRO SOLO DEVUELVE UN NUMERO;

&dias.;

%mend;

*EJEMPLO DE USO;

data _null_;

pepin=%dias(200402);

put pepin;

run;
```

Ejemplo muy sencillo de código macro y que se entiende muy facilmente, como siempre recomiendo que copiéis y peguéis en vuestro SAS y lo entenderéis enseguida. El caso es que calculo el número de días de un mes como la diferencia entre el día 1 del mes en estudio frente al día 1 del mes mas 1 en estudio. Si disponemos de una fecha SAS recomiendo usar la función INTNX para determinar el número de días del mes, ejemplo:

```r
data _null_;

fecha="02FEB2004"d;

fin_mes=intnx('month',fecha,0,'end');

dias=day(fin_mes);

put fin_mes dias;

run;
```

Buena referencia de uso de INTNX. Espero que os sirva de ayuda. Saludos.