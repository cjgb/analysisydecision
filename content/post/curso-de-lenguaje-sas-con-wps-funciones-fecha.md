---
author: rvaquerizo
categories:
  - formación
  - monográficos
  - wps
date: '2011-01-23'
lastmod: '2025-07-13'
related:
  - trabajo-con-fechas-sas-funciones-fecha.md
  - monografico-funciones-intnx-e-intck-para-fechas-en-sas.md
  - trabajo-con-fechas-sas-formatos-de-fecha-sas-mas-utilizados.md
  - trabajo-con-fechas-sas-introduccion.md
  - trucos-sas-numero-de-dias-de-un-mes.md
tags:
  - lenguaje sas
title: Curso de lenguaje SAS con WPS. Funciones fecha
url: /blog/curso-de-lenguaje-sas-con-wps-funciones-fecha/
---

Las fechas con SAS no están muy bien resueltas; con `WPS` pasa lo mismo. Era necesario un capítulo especial para hablar sobre fechas en `WPS`. [En este blog ya se habló del tema](https://analisisydecision.es/trabajo-con-fechas-sas-funciones-fecha/). Y ahora, con `WPS`, la entrada será análoga: `SAS = WPS`.

Las funciones las vamos a dividir en cuatro grupos:
- Funciones de **extracción** de fecha.
- Funciones de **creación** de fecha.
- Funciones de **duración**.
- Funciones de **intervalo**.

### Funciones de extracción de fecha

Nos permiten «extraer» información de variables de fecha/hora. Veamos un ejemplo para extraer la fecha y la hora de una variable fecha-hora:

```sas
data _null_;
    x = "11NOV2008:03:15:00"dt;
    
    * EXTRAEMOS LA FECHA DE UNA VARIABLE FECHA-HORA;
    y = datepart(x); format y ddmmyy10.; put y=;
    
    * EXTRAEMOS LA HORA DE UNA VARIABLE FECHA-HORA;
    z = timepart(x); format z time10.; put z=;
run;
```

A partir de una variable fecha, podemos obtener el día (`DAY()`), el mes (`MONTH()`) o el año (`YEAR()`):

```sas
data _null_;
    y = today();
    format y ddmmyy10.;
    
    dia = day(y);
    mes = month(y);
    anio = year(y);
    
    put dia "/" mes "/" anio;
run;
```

Y a partir de una variable hora, podemos obtener la hora (`HOUR()`), el minuto (`MINUTE()`) y el segundo (`SECOND()`):

```sas
data _null_;
    y = time();
    format y time10.;
    
    hora = hour(y);
    minuto = minute(y);
    segundo = round(second(y));
    
    put hora ":" minuto ":" segundo;
run;
```

El número de segundos nos lo pone con decimales; por ello se puede emplear la función numérica `ROUND()` para redondear el valor y evitarlos.

### Funciones de creación de fecha

Para generar fechas SAS a partir de datos numéricos disponemos de las siguientes funciones:

```sas
data _null_;
    dia = 1;
    mes = 1;
    anio = 1960;
    
    * CREACION DE VARIABLE FECHA;
    y = mdy(mes, dia, anio); put y=;
    
    * CREACION DE VARIABLE FECHA-HORA;
    z = dhms(y, 0, 0, 0); put z=;
    
    * CREACION DE VARIABLE HORA;
    x = hms(1, 0, 0); put x=;
run;
```

La función `MDY()` genera variables fecha y le pasamos como parámetros **Mes**, **Día** y **Año**; es la función que emplearemos para pasar números o *strings* a fecha. Para `DHMS()`, que nos genera variables fecha-hora, los parámetros son **fecha**, **hora**, **minuto** y **segundo**. Por último, `HMS()` recibe **hora**, **minuto** y **segundo**.

### Funciones de duración

La función de duración que emplearemos será `DATDIF()`:

```sas
data _null_;
    x = "01JAN1960"d;
    y = today();
    
    z = datdif(x, y, "ACT/ACT"); put z=;
    m = datdif(x, y, "30/360");  put m=;
    n = y - x; put n=;
run;
```

Observamos que `DATDIF()` recibe tres parámetros: **fecha inicial**, **fecha final** y la **base**. La base nos define en qué forma deseamos calcular la diferencia (en años de 365-366 días o en años con meses comerciales de 30 días). Si empleamos como base `"ACT/ACT"`, la diferencia equivale a la resta aritmética de ambas fechas. Las bases se pueden combinar como `"ACT/360"` o `"360/ACT"`.

### Funciones de intervalo

Las funciones de intervalo que vamos a estudiar serán `INTCK` e `INTNX`. La primera de ellas determina el **intervalo** entre dos fechas en función de una base; la segunda determina una **fecha** en función de un intervalo y una base. Es decir, con `INTCK` obtenemos un número (ej: número de meses entre dos fechas) y con `INTNX` obtenemos una fecha (ej: sumar 11 meses a una fecha).

```sas
data _null_;
    x = "01JAN2008"d;
    y = today();
    
    z = intck("week", x, y);  put z=;
    k = intck("month", x, y); put k=;
    l = intck("hour", x, y);  put l=;
    
    m = intnx("month", x, 11); put m= ddmmyy10.;
    n = intnx("day", x, 10);   put n= ddmmyy10.;
    p = intnx("year", x, -10); put p= ddmmyy10.;
run;
```

En la ayuda de SAS podemos encontrar más documentación y ejemplos sobre estas funciones. Como norma general tendremos: `INTCK` devuelve valores numéricos e `INTNX` devuelve fechas. Disponemos prácticamente de las mismas funciones en `WPS`.

En la siguiente entrega crearemos subconjuntos de variables en conjuntos de datos. Saludos.