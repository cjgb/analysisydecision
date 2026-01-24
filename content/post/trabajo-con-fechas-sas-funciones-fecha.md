---
author: rvaquerizo
categories:
  - monográficos
  - sas
date: '2008-11-17'
lastmod: '2025-07-13'
related:
  - curso-de-lenguaje-sas-con-wps-funciones-fecha.md
  - monografico-funciones-intnx-e-intck-para-fechas-en-sas.md
  - trabajo-con-fechas-sas-introduccion.md
  - trabajo-con-fechas-sas-formatos-de-fecha-sas-mas-utilizados.md
  - trucos-sas-numero-de-dias-de-un-mes.md
tags:
  - fechas sas
  - formatos sas
  - funciones sas
title: Trabajo con `fechas SAS`. Funciones `fecha`
url: /blog/trabajo-con-fechas-sas-funciones-fecha/
---

En las `entregas anteriores` del `monográfico` sobre `fechas SAS` hemos `estudiado` como `almacena` `internamente` las `fechas` el `sistema` y los `formatos` más `prácticos` que disponemos para `visualizarlas`. En esta última `entrega` veremos algunas de las `funciones` de `fecha hora` de las que dispone `SAS`. Las `funciones` las vamos a `dividir` en `4 grupos`:

- `Funciones` de `extracción` de `fecha`
- `Funciones` de `creación` de `fecha`
- `Funciones` de `duración`
- `Funciones` de `intervalo`

Las `funciones` de **`extracción`** de `fecha` nos `permiter` «`extraer`» `información` de `variables` de `fecha`/`hora`, veamos un `ejemplo` para `extraer` la `fecha` y la `hora` de una `variable fecha`/`hora`:

```sas
data _null_;

x="11NOV2008:03:15:00"dt;

*EXTRAEMOS LA FECHA DE UNA VARIABLE FECHA/HORA;

y=datepart(x); format y ddmmyy10.; put y=;

*EXTRAEMOS LA HORA DE UNA VARIABLE FECHA/HORA;

z=timepart(x); format z time10.; put z=;

run;
```

A partir de una `variable fecha` podemos obtener el `día` (`función DAY`), el `mes` (`función MONTH`) o el `año` (`función YEAR`), por `ejemplo`:

```sas
data _null_;

y=today();

format y ddmmyy10.; put y=;

*DIA;dia=day(y);

*MES;mes=month(y);

*AÑO;anio=year(y);

put dia "/" mes "/" anio;

run;
```

Y a partir de una `variable hora` podemos obtener la `hora` (`función HOUR`) el `minuto` (`función MINUTE`) y el `segundo` (`función SECOND`):

```sas
data _null_;

y=time();

format y time10.; put y=;

*HORA;hora=hour(y);

*MINUTO;minuto=minute(y);

*SEGUNDO;segundo=round(second(y));

put hora ":" minuto ":" segundo;

run;
```

El `número` de `segundos` nos lo pone con `decimales`, por ello se puede emplear la `función ROUND` para `redondear` el `valor` y `evitar` los `decimales`.

Las `funciones` de **`creación`** de `fecha` nos permiten `generar fechas SAS` a desde `datos numéricos`. Como siempre, `estudiemos` algunos `ejemplos`:

```sas
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

La `función MDY` genera `variables fecha` y le pasamos como `parámetros Mes Día` y `Year`. Para `DHMS` que nos genera `varaibles fecha`/`hora` los `parámetros` son `fecha` (en un `valor` que puede `leer SAS`) `Hora Minuto` y `Segundo`. Por último `HMS` recibe `Hora Minuto` y `Segundo`. Las `funciones` de **`duración`** son `DATDIF` y `YRDIF`:

```sas
data _null_;
x="01JAN1960"D;
y=today();
z=datdif(x,y,"ACT/ACT"); put z=;
m=datdif(x,y,"30/360"); put m=;
n=y-x; put n=;
o=yrdif(x,y,"ACT/ACT"); put o=;
p=yrdif(x,y,"30/360"); put p=;
run;
```

Observamos que estas `funciones` reciben `3 parámetros`, `fecha inicial`, `fecha final` y la `base`. La `Base` nos define en que forma deseamos calcular la `diferencia`, en `años` de `365-366 días` o en `años` con `meses` de `30 días` de `duración`. Si empleamos como `base` «`ACTUALLY`/`ACTUALLY`» la `diferencia` equivale a la `resta` de `ambas fechas`. Las `bases` las podemos `combinar` de forma «`ACT`/`360`» o «`360`/`ACT`».Las `funciones` de **`intervalo`** que vamos a estudiar serán `INTCK` e `INTNX`. La `primera` de ellas nos `determina` el `intervalo` entre dos `fechas` en función de una `base`, la `segunda determina` una `fecha` en función de un `intervalo` y una `base`, es decir, con `INTCK` obtenemos un `número` (ej: `número` de `meses` entre `01/02/2008` y `05/02/2008`) y con `INTNX` obtenemos una `fecha` (ej: `01/01/2007` más `30 meses`). En un `ejemplo` se comprenderá mejor:

```sas
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

En la `ayuda` de `SAS` podemos encontrar más `documentación` y `ejemplos` sobre estas `funciones`. Como `norma general` tendremos: `INTCK` devuelve `valores numéricos` e `INTNX` devuelve `fechas` (que también son `valores numéricos`).Espero que os sirva de ayuda este `monográfico` sobre las `fechas` en `SAS` y os `despeje` algunas `dudas` sobre el `funcionamiento` de las `constantes`, los `formatos` y las `funciones` y, por supuesto, si tenéis cualquier `duda`, `sugerencia` o `trabajo` bien `remunerado` `rvaquerizo@analisisydecision.es`
