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
title: Trabajo con fechas SAS. Funciones fecha
url: /blog/trabajo-con-fechas-sas-funciones-fecha/
---

En las entregas anteriores del monográfico sobre fechas SAS hemos estudiado cómo almacena internamente las fechas el sistema y los formatos más prácticos de los que disponemos para visualizarlas. En esta última entrega, veremos algunas de las funciones de fecha y hora de las que dispone SAS.

Las funciones las vamos a dividir en cuatro grupos:
- Funciones de **extracción** de fecha.
- Funciones de **creación** de fecha.
- Funciones de **duración**.
- Funciones de **intervalo**.

### Funciones de extracción de fecha

Nos permiten «extraer» información de variables de fecha/hora. Veamos un ejemplo para extraer la fecha y la hora de una variable fecha-hora (`datetime`):

```sas
data _null_;
    x = "11NOV2008:03:15:00"dt;
    
    * EXTRAEMOS LA FECHA DE UNA VARIABLE FECHA-HORA;
    y = datepart(x); 
    format y ddmmyy10.; put y=;
    
    * EXTRAEMOS LA HORA DE UNA VARIABLE FECHA-HORA;
    z = timepart(x); 
    format z time10.; put z=;
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
    
    put dia= mes= anio=;
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
    
    put hora= ":" minuto= ":" segundo=;
run;
```

### Funciones de creación de fecha

Nos permiten generar fechas SAS a partir de datos numéricos:

```sas
data _null_;
    dia = 1;
    mes = 1;
    anio = 1960;
    
    * CREACIÓN DE VARIABLE FECHA;
    y = mdy(mes, dia, anio); put y=;
    
    * CREACIÓN DE VARIABLE FECHA-HORA;
    z = dhms(y, 0, 0, 0); put z=;
    
    * CREACIÓN DE VARIABLE HORA;
    x = hms(1, 0, 0); put x=;
run;
```

`MDY` genera fechas y le pasamos como parámetros **Mes**, **Día** y **Año**. `DHMS` genera fecha-hora y requiere **fecha**, **hora**, **minuto** y **segundo**. `HMS` recibe **hora**, **minuto** y **segundo**.

### Funciones de duración

Destacan `DATDIF` y `YRDIF`:

```sas
data _null_;
    x = "01JAN1960"d;
    y = today();
    
    z = datdif(x, y, "ACT/ACT"); put "Días (ACT/ACT): " z;
    m = datdif(x, y, "30/360");  put "Días (30/360):  " m;
    
    o = yrdif(x, y, "ACT/ACT");  put "Años (ACT/ACT): " o;
    p = yrdif(x, y, "30/360");   put "Años (30/360):  " p;
run;
```

Estas funciones reciben la **fecha inicial**, la **fecha final** y la **base**. La base define cómo calcular la diferencia (en años de 365-366 días o en meses comerciales de 30 días).

### Funciones de intervalo

Estudiamos `INTCK` e `INTNX`. La primera determina el intervalo entre dos fechas; la segunda determina una fecha a partir de un intervalo y una base. Con `INTCK` obtenemos un número (ej: meses entre dos fechas) y con `INTNX` obtenemos una fecha (ej: sumar 30 meses a una fecha).

```sas
data _null_;
    x = "01JAN2008"d;
    y = today();
    
    z = intck("week", x, y);  put "Semanas: " z;
    k = intck("month", x, y); put "Meses:   " k;
    
    m = intnx("month", x, 11); put "Fecha + 11 meses: " m ddmmyy10.;
    n = intnx("day", x, 10);   put "Fecha + 10 días:  " n ddmmyy10.;
run;
```

En la ayuda de SAS podéis encontrar más documentación. Como norma general: `INTCK` devuelve valores numéricos (conteo de intervalos) e `INTNX` devuelve fechas. Espero que este monográfico os despeje dudas. Saludos.