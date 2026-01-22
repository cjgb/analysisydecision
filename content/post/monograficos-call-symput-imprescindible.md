---
author: rvaquerizo
categories:
  - formación
  - monográficos
  - sas
date: '2009-02-16'
lastmod: '2025-07-13'
related:
  - macros-faciles-de-sas-eliminar-outliers-en-una-variable.md
  - truco-sas-observaciones-de-un-dataset-en-una-macro-variable.md
  - trucos-sas-variables-dummy-de-una-variable-continua.md
  - macros-sas-tramificar-en-funcion-de-una-variable-respuesta.md
  - trucos-sas-lista-de-datasets-en-macro-variable.md
tags:
  - formación
  - monográficos
  - sas
title: Monográficos. CALL SYMPUT imprescindible
url: /blog/monograficos-call-symput-imprescindible/
---

He detectado que muchas búsquedas que llegan a Análisis y Decisión vienen por la palabra clave `CALL SYMPUT`. Por este motivo me he decidido a escribir este rápido monográfico sobre esta instrucción. Con un par de ejemplos podemos familiarizarnos con su funcionamiento.`CALL SYMPUT` es una rutina de `SAS` que nos permite crear macro variables durante la ejecución de un paso `data`, digamos que es un mecanismo que comunica el compilador del `macro lenguaje SAS` con el propio lenguaje `SAS`. El ejemplo prototípico de su uso, determinar el número de observaciones de un dataset que cumplen determinada condición:

```sas
*DATASET ALEATORIO;

data uno;

 do cliente=1 to 1000;

 importe=ranuni(9)*10000;

 output;

 end;

run;
```

```sas
*NUMERO DE CLIENTES CON IMPORTE > 2000;

data _null_;

 set uno (where=(importe>2000)) end=final;

 if final then call symput('nobs',_n_);

run;
```

`%put _user_;`

Partimos de un dataset aleatorio con 1000 observaciones y necesitamos introducir en una macro variable cuantas observaciones tienen un importe mayor a 2000. Vemos que generamos la macro variable nobs a partir de la variable automática `_n_` en el momento en que se finaliza la lectura del dataset uno. Hay que tener especial cuidado con el formato que toman las macro variables en la tabla de símbolos ya que los espacios que deja a la izquierda pueden generarnos algún contratiempo, se recomienda dar formatos como hacemos en el siguiente ejemplo. Si deseamos introducir en 3 macros los valores del mínimo, mediana y máximo podemos emplear el `proc univariate` y `CALL SYMPUT`:

```sas
ods result;

ods output Quantiles = cuan;

proc univariate data=uno ;

var importe;

quit;
```

```sas
data _null_;

 set cuan;

 if quantile="100% Máx" then call symput ('max',compress(put(estimate,8.1)));

 if quantile="0% Mín" then call symput ('min',compress(put(estimate,8.1)));

 if quantile="50% Mediana" then call symput ('med',compress(put(estimate,8.1)));

run;
```

`%put _user_;`

Una forma práctica de trabajar con percentiles. Es importante que las macro variables tengan un formato adecuado. Otro ejemplo de uso de `CALL SYMPUT` es la generación de arrays de macro variables, por ejemplo generar `macro_1` a `macro_20` con valores aleatorios:

```sas
data _null_;

 do i=1 to 20;

 call symput ('macro'||compress("_"||put(i,8.)),ranuni(4));

 end;

run;
```

`%put _user_;`

Con estos ejemplos espero que se entienda su uso. En el trabajo diario con `SAS`, es una de las rutinas más utilizadas. Como siempre, si tenéis dudas, sugerencias o un trabajo bien retribuido mi dirección de correo es `r_vaquerizo@analisisydecision.es`
