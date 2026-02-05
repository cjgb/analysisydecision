---
author: rvaquerizo
categories:
  - formación
  - sas
  - trucos
date: '2009-05-11'
lastmod: '2025-07-13'
related:
  - numeros-aleatorios-con-sas.md
  - trucos-sas-muestreo-con-proc-surveyselect.md
  - trucos-sas-variables-dummy-de-una-variable-continua.md
  - trucos-sas-lista-de-datasets-en-macro-variable.md
  - trucos-sas-informes-de-valores-missing.md
tags:
  - aleatorios
  - rand
  - ranuni
  - while
title: Trucos SAS. Muestras aleatorias con y sin reemplazamiento
url: /blog/trucos-sas-muestras-aleatorias-con-y-sin-reemplazamiento/
---

Un ejemplo típico de SAS, pero que creo que puede ayudar a conocer algunas funciones interesantes. Los ejemplos que planteo a continuación crean un *dataset* con 10.000 observaciones y, sobre él, vamos a crear dos subconjuntos de datos: dos muestras aleatorias del *dataset* de partida, una muestra sin reemplazamiento y otra muestra con reemplazamiento. 

Como siempre, creo un *dataset* de forma aleatoria que me sirve de base para plantearos el truco:

```sas
data ejemplo;
    do id = 1 to 10000;
        importe = ranuni(8) * 1000;
        output;
    end;
run;
```

El *dataset* de partida tiene 10.000 observaciones y dos variables; una de ellas creada con la función `RANUNI()`, que genera aleatorios de una distribución uniforme (0,1) con una semilla. 

### Muestra aleatoria sin reemplazamiento

Vamos a realizar una muestra aleatoria de este conjunto de datos SAS de tamaño 300:

```sas
* MUESTRA ALEATORIA SIN REEMPLAZAMIENTO;
%let tamanio = 300;

data aleat1_prep;
    set ejemplo;
    aleat = rand("uniform");
run;

proc sort data=aleat1_prep; 
    by aleat; 
run;

data aleat1;
    set aleat1_prep;
    if _n_ > &tamanio. then stop;
    drop aleat;
run;
```

Creamos una variable aleatoria con la función `RAND()`, que no necesita semilla explícita (usa la del sistema si no se indica) para generar números aleatorios (en este caso, una uniforme (0,1)), ordenamos por ella y seleccionamos las primeras observaciones definidas por la macrovariable `tamanio`. 

### Muestra aleatoria con reemplazamiento

```sas
%let tamanio = 300;

* IDENTIFICAMOS EL NÚMERO DE OBSERVACIONES;
proc sql noprint;
    select count(*) into :num_obs from ejemplo;
quit;

* GENERAMOS 300 ÍNDICES ALEATORIOS;
data select_indices;
    do i = 1 to &tamanio.;
        select = ceil(rand("uniform") * &num_obs.);
        output;
    end;
    drop i;
run;

* ORDENAMOS ÍNDICES PARA EL MERGE;
proc sort data=select_indices; 
    by select; 
run;

* AÑADIMOS ÍNDICE A LA TABLA ORIGINAL;
data ejemplo_idx;
    set ejemplo;
    select = _n_;
run;

* CRUCE PARA OBTENER LA MUESTRA CON REEMPLAZAMIENTO;
data aleat2;
    merge select_indices (in=a) ejemplo_idx;
    by select;
    if a;
    drop select;
run;
```

Vemos que la metodología es distinta. En este caso, creamos una tabla con 300 registros que contiene 300 números aleatorios entre 1 y el número total de observaciones del *dataset* de partida. Como estos números aleatorios pueden repetirse, obtenemos el reemplazamiento deseado. Posteriormente hacemos el cruce con `MERGE` y ya tenemos nuestra muestra.

Sé de más de uno al que le será muy útil este truco. Por supuesto, si tenéis dudas o sugerencias… `rvaquerizo@analisisydecision.es`. Saludos.