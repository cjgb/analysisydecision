---
author: svalle
categories:
  - sas
  - trucos
date: '2008-03-04'
lastmod: '2025-07-13'
related:
  - trucos-sas-porque-hay-que-usar-objetos-hash.md
  - laboratorio-de-codigo-sas-comparativa-entre-if-y-where.md
  - laboratorio-de-codigo-sas-ordenaciones-con-hash-vs-proc-sort.md
  - truco-sas-transponer-tablas-con-proc-transpose-data-o-proc-sql.md
  - laboratorio-de-codigo-sas-vistas-proc-means-vs-proc-sql.md
tags:
  - sas
  - trucos
title: Truco SAS. Cruce con PROC FORMAT
url: /blog/truco-sas-cruce-con-formatos/
---

Veremos un ejemplo de ahorro de tiempo haciendo un cruce con **formatos**.

Parece curioso que los formatos ahorren tiempo frente al `SORT/MERGE` y `SQL`, ya que básicamente no están hechos para esa finalidad, pero realmente podemos ahorrarnos más del 50% del tiempo. 

Lo más costoso de este método es la carga del formato, pero una vez que lo tenemos cargado, podemos hacer las selecciones de todos los grandes volúmenes de datos que necesitemos. Con el `SORT/MERGE`, tendríamos que ordenar el conjunto de datos SAS "grande" cada vez si no lo teníamos ya ordenado. Este método es realmente efectivo al cruzar tablas grandes frente a pequeñas.

### Ejemplo

Nuestro conjunto SAS de ejemplo es una base de datos de los clientes de una compañía, que contiene el número de `contrato` y `gasto` que han tenido en un periodo. Tenemos otro conjunto de datos SAS con 100.000 contratos; queremos seleccionar el gasto que han tenido estos contratos.

Para ello, tenemos que cruzar nuestra «SÚPER TABLA» con nuestra «TABLA PEQUEÑA».

#### Tabla de ejemplo:

```sas
data conjunto_LARGE;
    do i = 1 to 10000000;
        contrato = put(i, z10.);
        gasto = ranuni(12345) * 100;
        output;
    end;
    drop i;
run;

data conjunto_SMALL;
    set conjunto_LARGE (keep=contrato obs=100000);
run;
```

#### Procedimiento 1: `SORT / MERGE`

Con el `SORT / MERGE` tenemos que ordenar los dos conjuntos de datos.

```sas
proc sort data=conjunto_LARGE;
    by contrato;
run;

proc sort data=conjunto_SMALL;
    by contrato;
run;

data seleccion;
    merge conjunto_LARGE (in=a) conjunto_SMALL (in=b);
    by contrato;
    if a and b;
run;
```

**Tiempos aproximados:**
- Ordenar conjunto grande: 35.82 segundos.
- Ordenar conjunto pequeño: 0.25 segundos.
- Merge: 11.06 segundos.
- **Total: 47.13 segundos.**

#### Procedimiento 2: Cruce con formatos

1. En primer lugar, tengo que cargar los contratos de mi conjunto de datos pequeño a un formato.

```sas
data cruzo;
    set conjunto_SMALL;
    rename contrato = start;
    label = '*';
    fmtname = '$CONTRATO';
run;

proc sort data=cruzo nodupkey;
    by start;
run;

proc format cntlin=cruzo;
run;
```

La variable clave con la que vamos a cruzar la tenemos que renombrar a `START`. En `LABEL` podemos poner la etiqueta que queramos (por ejemplo, '*') y, por último, tenemos que dar un nombre al formato con `FMTNAME`.

2. Realizamos el cruce en el paso `DATA`:

```sas
data seleccion_formato;
    set conjunto_LARGE;
    if put(contrato, $contrato.) = '*';
run;
```

**Tiempos aproximados:**
- Carga del formato: 0.26 segundos.
- Cruce con formato: 8.53 segundos.
- **Total: 8.79 segundos.**

Frente a los 47.13 segundos del método tradicional.

Probad este método, contadnos el ahorro de tiempo y si tenéis alguna otra duda. Saludos.