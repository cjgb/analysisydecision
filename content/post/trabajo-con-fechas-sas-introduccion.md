---
author: rvaquerizo
categories:
  - monográficos
  - sas
date: '2008-11-07'
lastmod: '2025-07-13'
related:
  - trabajo-con-fechas-sas-formatos-de-fecha-sas-mas-utilizados.md
  - trabajo-con-fechas-sas-funciones-fecha.md
  - curso-de-lenguaje-sas-con-wps-funciones-fecha.md
  - curso-de-lenguaje-sas-con-wps-variables.md
  - trucos-sas-pasar-fecha-a-caracter-en-sas.md
tags:
  - monográficos
  - sas
title: Trabajo con fechas SAS. Introducción
url: /blog/trabajo-con-fechas-sas-introduccion/
---

Debido al gran número de búsquedas que llegan a AyD con el tema de las fechas y horas de `SAS` me he decidido a realizar un pequeño monográfico sobre estas variables en `SAS`. Principalmente se estudiará:

- Introducción a las fechas y horas `SAS`
- Formatos de fecha y hora en `SAS`
- Funciones de fecha y hora en `SAS`

En esta primera entrega del monográfico veremos como se guardan internamente las variables fecha en `SAS` y como hacemos referencia a ellas dentro de nuestros pasos data o procedimientos. En `SAS`, las variables o son `numéricas` o son `alfanuméricas`, en el caso de las variables fecha se almacenan como `numéricas` y son el número de días respecto al `1 de enero de 1960`. Las variables hora también son `numéricas` y se almacenan como el número de segundos transcurridos desde el `1 de enero de 1960` a las 0 horas. Ejecutemos el siguiente programa `SAS`:

```sas
data _null_;

y=0; x=0;

format x date9.;

put x=;

format y datetime19.;

put y=;

run;
```

Obtenemos en log:

```
x=01JAN1960

y=01JAN1960:00:00:00
```

Vemos que el `01JAN1960:00:00:00` Es el punto 0 de todas las fechas en `SAS`. Todas están limitadas a -138.061 (1 de enero 1582) y 6.589.335 (31 de diciembre 20000). Podemos realizar operaciones con ellas, analicemos un ejemplo que nos permitirá estudiar como se referencian fechas en código `SAS`:

```sas
data _null_;

*ESPECIFICAMOS UNA FECHA;

f1='01JAN2006'd;

*SIEMPRE 'DDMMMAAAA'd;

f2="31DEC2006"d;

dif=f2-f1;

put "La diferencia en días entre f1 y f2 es: " dif;

f3='01JAN2006:00:00:00'dt;

f4='01JAN2006:00:01:30'dt;

dif2=f4-f3;

put "La diferencia en segundos entre f3 y f4 es: " dif2;

f5='00:00:00't;

f6='01:00:00't;

dif3=f6-f5;

put "La diferencia en segundos entre f5 y f6 es: " dif3;

run;
```

Las fechas en `SAS` se referencian como `'DDMMMAA'd` o `'DDMMMAAAA'd` y las fechas hora se referencian como `'DDMMMAA:HH:MM:SS'dt` o `'DDMMMAAAA:HH:MM:SS'dt` las horas como `'HH:MM:SS't`. Podemos emplear tanto comillas simples como comillas dobles para referenciar las fechas. Es mu importante que, cada vez que trabajemos con fechas y horas en `SAS`, tengamos en cuenta la unidad de tiempo en la que estamos trabajando. Para fechas la unidad serán los días, para fechas y/o horas la unidad serán los segundos. Esto es muy importante si deseamos sumar o restar valores a fechas:

```sas
data _null_;

f1='01JAN2006'd;

suma1=f1+365; *SUMA EN DIAS;

Put suma1;

resta1=f1-365;

put resta1;

f2='01JAN2006:00:00:00'dt;

suma2=f2+86400; *SUMA EN SEGUNDOS;

put suma2;

resta2=f2-3600;

put resta2;

run;
```

En el log tenemos:

```
17167

16437

1451779200

1451689200
```

Estos son los números con los que guarda `SAS` internamente las fechas con las que hemos trabajado. En la siguiente entrega del monográfico veremos como asignar formatos de fecha a las variables `SAS` para permitirnos visualizar mejor estos campos como hicimos al inicio de este capítulo.
