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

He detectado que muchas búsquedas que llegan a **Análisis y Decisión** vienen por la palabra clave `CALL SYMPUT`. Por este motivo, me he decidido a escribir este rápido monográfico sobre esta instrucción. Con un par de ejemplos podemos familiarizarnos con su funcionamiento.

`CALL SYMPUT` es una rutina de SAS que nos permite crear macrovariables durante la ejecución de un paso `DATA`; digamos que es un mecanismo que comunica el compilador del lenguaje macro de SAS con el propio lenguaje SAS. El ejemplo prototípico de su uso: determinar el número de observaciones de un *dataset* que cumplen determinada condición:

```sas
* DATASET ALEATORIO;
data uno;
    do cliente = 1 to 1000;
        importe = ranuni(9) * 10000;
        output;
    end;
run;

* NUMERO DE CLIENTES CON IMPORTE > 2000;
data _null_;
    set uno (where=(importe > 2000)) end = final;
    if final then call symput('nobs', compress(put(_n_, 12.)));
run;

%put Número de observaciones: &nobs.;
```

Partimos de un *dataset* aleatorio con 1000 observaciones y necesitamos introducir en una macrovariable cuántas observaciones tienen un importe mayor a 2000. Vemos que generamos la macrovariable `nobs` a partir de la variable automática `_n_` en el momento en que se finaliza la lectura del *dataset* `uno`. Hay que tener especial cuidado con el formato que toman las macrovariables en la tabla de símbolos, ya que los espacios que deja a la izquierda pueden generarnos algún contratiempo; se recomienda usar `compress` y `put` como en el ejemplo.

Si deseamos introducir en tres macros los valores del mínimo, mediana y máximo, podemos emplear el `PROC UNIVARIATE` y `CALL SYMPUT`:

```sas
ods results off;
ods output Quantiles = cuan;
proc univariate data=uno;
    var importe;
run;
ods results on;

data _null_;
    set cuan;
    if quantile = "100% Max" then call symput('max', compress(put(estimate, 12.1)));
    if quantile = "0% Min" then call symput('min', compress(put(estimate, 12.1)));
    if quantile = "50% Median" then call symput('med', compress(put(estimate, 12.1)));
run;

%put Máximo: &max. Mínimo: &min. Mediana: &med.;
```

Es una forma práctica de trabajar con percentiles. Otro ejemplo de uso de `CALL SYMPUT` es la generación de *arrays* de macrovariables; por ejemplo, generar de `macro_1` a `macro_20` con valores aleatorios:

```sas
data _null_;
    do i = 1 to 20;
        call symput('macro_' || compress(put(i, 8.)), compress(put(ranuni(4), 12.4)));
    end;
run;

%put _user_;
```

Con estos ejemplos espero que se entienda su uso. En el trabajo diario con SAS, es una de las rutinas más utilizadas. Como siempre, si tenéis dudas o sugerencias… `rvaquerizo@analisisydecision.es`. Saludos.