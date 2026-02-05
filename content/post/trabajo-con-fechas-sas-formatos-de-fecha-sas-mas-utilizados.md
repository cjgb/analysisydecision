---
author: rvaquerizo
categories:
  - formación
  - monográficos
  - sas
date: '2008-11-10'
lastmod: '2025-07-13'
related:
  - trucos-sas-pasar-fecha-a-caracter-en-sas.md
  - trabajo-con-fechas-sas-introduccion.md
  - trabajo-con-fechas-sas-funciones-fecha.md
  - macros-sas-transformar-un-numerico-a-fecha.md
  - curso-de-lenguaje-sas-con-wps-variables.md
tags:
  - fechas sas
  - formatos sas
title: Trabajo con fechas SAS. Formatos de fecha SAS más utilizados
url: /blog/trabajo-con-fechas-sas-formatos-de-fecha-sas-mas-utilizados/
---

En esta nueva entrega del monográfico de fechas SAS, vamos a estudiar algunos **formatos**. Un formato es la forma en la que visualizamos una variable. El valor `17327` es un número sin significado aparente, pero el `20 de junio de 2007` es una fecha comprensible.

En la anterior entrega estudiamos cómo SAS guarda las fechas como variables numéricas (número de días transcurridos desde el 1 de enero de 1960). Las fechas-hora se guardan como el número de segundos transcurridos. Con los distintos formatos, nosotros podremos visualizar estas variables numéricas de SAS. Por ejemplo:

```sas
data borrar;
    x = 1; 
    y = 1; 
    z = 1; 
    m = 1;
    format x date9. y ddmmyy10. z datetime20. m time10.;
run;

proc print data=borrar noobs; 
run;
```

**Resultado:**
- `x` = `02JAN1960`
- `y` = `02/01/1960`
- `z` = `01JAN1960:00:00:01`
- `m` = `0:00:01`

Vemos cómo internamente el valor 1 toma distintos significados según el formato aplicado. Disponemos de la ayuda de SAS para conocer todos los formatos; en este capítulo nos centraremos en los más habituales.

### Formatos de fecha más utilizados

```sas
data borrar;
    x = "01JAN2008"d;
    y = x + 10;
    z = y + 100;
    m = z - 12;
    format x ddmmyy8. y ddmmyy10. z yymmddn8. m date7.;
run;

proc print data=borrar noobs; 
run;
```

**Resultado:**
- `x` = `01/01/08`
- `y` = `11/01/2008`
- `z` = `20080420`
- `m` = `08APR08`

El formato `DDMMYYw.` es la estrella. Los formatos `DATEw.` no son tan usados en español pero son útiles para parámetros. El `YYMMDDN8.` se usa mucho como numérico en bases de datos. Hay que tener cuidado con las longitudes permitidas (p. ej., `DDMMYY11.` daría error).

Otros ejemplos interesantes:

```sas
data borrar;
    x = "01JAN2008"d;
    y = x + 10;
    z = y + 100;
    m = z - 12;
    format x julian7. y EURDFDD10. z yymmn6. m worddate20.;
run;

proc print data=borrar noobs; 
run;
```

- `JULIAN7.` = `2008001` (habitual en sistemas antiguos).
- `EURDFDD10.` = `11.01.2008` (muy usado en Europa).
- `YYMMN6.` = `200804` (práctico para agrupaciones por mes).
- `WORDDATE20.` = `April 8, 2008` (formato largo).

### Transformación de variables con `PUT` e `INPUT`

A través de los formatos podremos «transformar» nuestras variables. La función `PUT` transforma una variable numérica a carácter:

```sas
data _null_;
    x = "01JAN2008"d;
    y = x - 12;
    
    * Creamos una constante de fecha para usar en macros;
    referencia = quote(put(y, date7.)) || "d";
    put referencia=;
    
    * Obtenemos el mes como número YYYYMM;
    mes = put(x + 19, yymmn6.) * 1;
    put mes=;
run;
```

Por otro lado, hay ocasiones en las que valores numéricos o carácter han de pasar a ser valores fecha (tipo fecha SAS):

```sas
data _null_;
    y = 20080501;
    z = 20070501;
    
    * x = y - z resultaría en 10000, no es la diferencia en días;
    
    * Transformación manual (un poco compleja);
    y1 = input(put(y, 8.), yymmdd8.);
    z1 = input(put(z, 8.), yymmdd8.);
    
    dif_dias = y1 - z1;
    put dif_dias=;
run;
```

No hay que asustarse con la transformación de numéricas a fecha, ya que en la siguiente entrega trabajaremos con funciones que nos facilitan mucho esta labor. Tanto la función `PUT` como `INPUT` tendrán su propio monográfico.

Como siempre, para cualquier duda o sugerencia… `rvaquerizo@analisisydecision.es`. Saludos.