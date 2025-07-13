---
author: rvaquerizo
categories:
- Formación
- Monográficos
- WPS
date: '2011-01-23T08:59:27-05:00'
lastmod: '2025-07-13T15:55:46.885252'
related:
- trabajo-con-fechas-sas-funciones-fecha.md
- monografico-funciones-intnx-e-intck-para-fechas-en-sas.md
- trabajo-con-fechas-sas-formatos-de-fecha-sas-mas-utilizados.md
- trabajo-con-fechas-sas-introduccion.md
- trucos-sas-numero-de-dias-de-un-mes.md
slug: curso-de-lenguaje-sas-con-wps-funciones-fecha
tags:
- ''
- lenguaje SAS
title: Curso de lenguaje SAS con WPS. Funciones fecha
url: /curso-de-lenguaje-sas-con-wps-funciones-fecha/
---

Las fechas con SAS no están muy bien resueltas, con WPS pasa lo mismo. Era necesario un capítulo especial para hablar sobre fechas en WPS. [En este blog ya se habló del tema](https://analisisydecision.es/trabajo-con-fechas-sas-funciones-fecha/). Y ahora, con WPS, la entrada será análoga: **SAS = WPS**. . Las funciones las vamos a dividir en 4 grupos:

• Funciones de extracción de fecha  
• Funciones de creación de fecha  
• Funciones de duración  
• Funciones de intervalo

Las **funciones de extracción de fecha** nos permiter «extraer» información de variables de fecha/hora, veamos un ejemplo para extraer la fecha y la hora de una variable fecha/hora:

```r
data _null_;

x="11NOV2008:03:15:00"dt;

*EXTRAEMOS LA FECHA DE UNA VARIABLE FECHA/HORA;

y=datepart(x); format y ddmmyy10.; put y=;

*EXTRAEMOS LA HORA DE UNA VARIABLE FECHA/HORA;

z=timepart(x); format z time10.; put z=;

run;
```

A partir de una variable fecha podemos obtener el día (función DAY), el mes (función MONTH) o el año (función YEAR), por ejemplo:

```r
data _null_;

y=today();

format y ddmmyy10.; put y=;

*DIA;dia=day(y);

*MES;mes=month(y);

*AÑO;anio=year(y);

put dia "/" mes "/" anio;

run;
```

Y a partir de una variable hora podemos obtener la hora (función HOUR) el minuto (función MINUTE) y el segundo (función SECOND):

```r
data _null_;

y=time();

format y time10.; put y=;

*HORA;hora=hour(y);

*MINUTO;minuto=minute(y);

*SEGUNDO;segundo=round(second(y));

put hora ":" minuto ":" segundo;

run;
```

El número de segundos nos lo pone con decimales, por ello se puede emplear la función numérica ROUND para redondear el valor y evitar los decimales. Para generar fechas SAS a desde datos numéricos. Tenemos las siguientes funciones que vemos en ejemplos:

```r
data _null_;

dia=1;

mes=1;

anio=1960;

*CREACION DE VARIABLE FECHA;

y=mdy(mes,dia,anio); put y=;

*CREACION DE VARIABLE FECHA/HORA;

z=dhms(y,0,0,0); put z=;

*CREACION DE VARIABLES HORA;

x=hms(1,0,0); put x=;

run;
```

La función MDY genera variables fecha y le pasamos como parámetros Mes Día y Year y es la función que emplearemos para pasar números o string a fecha. Para DHMS que nos genera varaibles fecha/hora los parámetros son fecha (en un valor que puede leer SAS) Hora Minuto y Segundo. Por último HMS recibe Hora Minuto y Segundo. Las función de duración que emplearemos será DATDIF:

```r
data _null_;

x="01JAN1960"D;

y=today();

z=datdif(x,y,"ACT/ACT"); put z=;

m=datdif(x,y,"30/360"); put m=;

n=y-x; put n=;

run;
```

Observamos que DATDIF recibe 3 parámetros, fecha inicial, fecha final y la base. La Base nos define en que forma deseamos calcular la diferencia, en años de 365-366 días o en años con meses de 30 días de duración. Si empleamos como base «ACTUALLY/ACTUALLY» la diferencia equivale a la resta de ambas fechas. Las bases las podemos combinar de forma «ACT/360» o «360/ACT».

Las **funciones de intervalo** que vamos a estudiar serán **INTCK** e **INTNX**. La primera de ellas nos determina el intervalo entre dos fechas en función de una base, la segunda determina una fecha en función de un intervalo y una base, es decir, con INTCK obtenemos un número (ej: número de meses entre 01/02/2008 y 05/02/2008) y con INTNX obtenemos una fecha (ej: 01/01/2007 más 30 meses). Analicemos el ejemplo:

```r
data _null_;

x="01JAN2008"d;

y=today();

z=intck("week",x,y); put z=;

k=intck("month",x,y); put k=;

l=intck("hour",x,y); put l=;

m=intnx("month",x,11); put m=ddmmyy10.;

n=intnx("day",x,10); put n=ddmmyy10.;

p=intnx("year",x,-10); put p=ddmmyy10.;

run;
```

En la ayuda de SAS podemos encontrar más documentación y ejemplos sobre estas funciones. Como norma general tendremos: INTCK devuelve valores numéricos e INTNX devuelve fechas (que también son valores numéricos). Recalcar que disponemos prácticamente de las mismas funciones por lo que la documentación presente en internet, incluso en esta web, puede usarse con WPS. En la siguiente entrega crearemos subconjuntos de variables en conjuntos de datos.