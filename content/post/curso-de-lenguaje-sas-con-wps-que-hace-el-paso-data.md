---
author: rvaquerizo
categories:
  - consultoría
  - formación
date: '2010-05-29'
lastmod: '2025-07-13'
related:
  - curso-de-lenguaje-sas-con-wps-lectura-de-ficheros-de-texto.md
  - curso-de-lenguaje-sas-con-wps-el-paso-data.md
  - curso-de-lenguaje-sas-con-wps-ejecuciones.md
  - curso-de-lenguaje-sas-con-wps-subconjuntos-de-variables-con-drop-y-keep.md
  - macros-sas-dataset-a-data-frame-r.md
tags:
  - consultoría
  - formación
title: Curso de lenguaje SAS con WPS. Que hace el paso DATA
url: /blog/curso-de-lenguaje-sas-con-wps-que-hace-el-paso-data/
---

El elemento principal del lenguaje `SAS` es el `paso DATA`. Este elemento crea, modifica y transforma conjunto de `datos SAS` (`datasets`). El `paso DATA` se compone de 2 fases, la `fase de compilación` y la `fase de ejecución`. En la `fase de compilación DATA` crea una estructura de `memoria`, conocida como `program data vector` (`PDV`), con la estructura que `SAS` considera más adecuada para el conjunto de `datos`, paralelamente crea toda una descripción de la información del `dataset`. Una vez creada la estructura de la `tabla SAS` se pasa a la `fase de ejecución` en la que `SAS` itera con cada registro haciendo “output” en el `dataset` cuando `SAS` llega a la sentencia `RUN`. La iteración se lleva a cabo hasta que `SAS` detecta el final del archivo.

`DATA` trabaja con conjuntos de `datos` que fundamentalmente serán:

- `Entrada manual de datos` (`INFILE + INPUT + DATALINES`)
- `Ficheros de texto` (`INFILE + INPUT`)
- `Otros conjuntos de datos SAS/WPS` (`SET MERGE UPDATE`)
- `DBMS` (Esto mejor no lo haremos con `data`…)

La `entrada manual de datos` en `SAS` no es muy cómoda pero sirve para conocer como funciona el `PDV` sin embargo eso no es mu útil en nuestro trabajo diario, no tenemos tiempo de pararnos en aspectos `teóricos`. Por esto es preferible poner un ejemplo «que funciona siempre» de este modo le guardáis y cuando tengáis que meter `datos` manualmente le recuperáis:

```sas
data manual;

infile datalines dlm=",";

input nombre: 30. edad rango:30.;

datalines;

Jose Alberto, 34, Cabo Primero,

Esteban, 25, Sarjento,

Vicente, 56, Sarjento Primero,

Laura, 45, Capitán,

;run;
```

Recomiendo recordar esta estructura. Comenzamos con `DATA` y el `nombre` del conjunto de `datos SAS`. La sentencia `INFILE` nos indica como va a ser la `entrada de datos`, `DATALINES` especifica que será manual y `DLM` tiene su importancia porque indica un `delimitador` de los `datos`, si empleamos `delimitador` nos evitaremos muchos problemas. Después la sentencia `INPUT` es fundamental porque es la que asigna la estructura al conjunto de `datos`. Estas estructuras estarán compuestas de `variables`, ya las `analisis`aremos en profundidad, en este caso tenemos 3 `variables` dos de texto indicado con `$` y una `numérica` (no pongo nada). Al fin viene `DATALINES` sin más que indica el punto en el que metemos `dato`. Picamos los `datos` y separamos por , finalizamos con `RUN`. Esta es la forma más sencilla y que mejor se entiende para introducir `datos` manualmente, nos evita muchas pegas con `espacios en blanco`, `longitudes`,…

Para crear `datasets` desde `ficheros de texto` emplearemos una `metodología` distinta en `WPS` que la utilizada en `SAS`. `WPS` no tiene `asistentes` por ello lo mejor que podemos hacer es importar el `fichero paso` a `paso` para comprobar si lo hacemos correctamente. Para ilustrar el ejemplo [podéis bajaros este archivo](`/images/2008/03/grades.TXT`) a vuestro equipo. Este fichero tiene las siguientes `variables`:

- `ID del estudiante`
- `genero`
- `clase`
- `puntuación de test`
- `puntuación del examen 1`
- `puntuación del examen 2`
- `puntuación de laboratorio`
- `puntuación del examen final`

Desde `WPS` podemos abrirlo para hacerle una `vista` y así poder dar una estructura correcta al conjunto de `datos SAS`. Vemos que tiene 28 `líneas` y está separado por `espacios`. Luego el `paso data` sería así:

```sas
data prueba;

infile "D:\raul\wordpress\curso sas\grades.txt";

input id sexo clase Ptest P1 P2 Plab Ptotal;

run;
```

Recordamos, primero estructura luego lee `datos`. Con `INFILE` le indicamos que `datos` leemos y que `características` tienen, con `INPUT` creamos la estructura, el `vector de variables`, el `PDV`. En este caso tenemos 7 `variables`, dos de ellas `alfanuméricas` por ello empleamos `$` y otras 5 `numéricas` (no ponemos nada). Este caso es un extremo, por lo simple. En la siguiente entrega leeremos `ficheros de texto` con `WPS` buscando `casos más habituales`.

Pero el 90% de las veces que utilicemos `DATA` las `lecturas` serán de otros conjuntos de `datos SAS`:

```sas
data prueba2;

set prueba;

run;
```

En los sucesivos `cursos` que he impartido todo el mundo entiende a la perfección lo siguiente: `DATA` crea una estructura y escribe y `SET` indica como ha de ser esa estructura y donde leer. Si hacemos lo siguiente:

```sas
data prueba;

set prueba;

Pmedia=(P1+P2)/2

run;
```

Estamos sobreescribiendo un `dataset` al que además le añadimos una nueva `variable`, un nuevo elemento a ese `vector`. Importante: No he indicado a `WPS` las `características` de ese nuevo elemento, selecciona las que él cree más adecuadas, no es necesario `declarar variables`; esto resulta difícil de entender para los `informáticos`.

Por último nos quedaría `analisis`ar como accede `WPS` a `BBDD` con `DATA`, pero mis `lectores` no tienen permitido hacer eso. Ya veremos el motivo.

Lo dicho, siguiente entrega, `importaciones` de texto. `WPS` no tiene `asistente` y tenemos que escribir nosotros mismos el `vector de variables`.

Saludos.