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
title: Curso de lenguaje SAS con WPS. Qué hace el paso DATA
url: /blog/curso-de-lenguaje-sas-con-wps-que-hace-el-paso-data/
---

El elemento principal del lenguaje SAS es el paso `DATA`. Este elemento crea, modifica y transforma conjuntos de datos SAS (*datasets*). El paso `DATA` se compone de dos fases: la **fase de compilación** y la **fase de ejecución**. 

En la fase de compilación, `DATA` crea una estructura de memoria conocida como *Program Data Vector* (`PDV`), con la estructura que SAS considera más adecuada para el conjunto de datos; paralelamente, crea toda una descripción de la información del *dataset*. Una vez creada la estructura de la tabla SAS, se pasa a la fase de ejecución, en la que SAS itera por cada registro haciendo "output" en el *dataset* cuando llega a la sentencia `RUN`. La iteración se lleva a cabo hasta que SAS detecta el final del archivo.

`DATA` trabaja con conjuntos de datos que, fundamentalmente, serán:

- **Entrada manual de datos** (`INFILE` + `INPUT` + `DATALINES`).
- **Ficheros de texto** (`INFILE` + `INPUT`).
- **Otros conjuntos de datos SAS/WPS** (`SET`, `MERGE`, `UPDATE`).
- **DBMS** (esto mejor no lo haremos con `DATA`…).

La entrada manual de datos en SAS no es muy cómoda, pero sirve para conocer cómo funciona el `PDV`. Sin embargo, ésto no es muy útil en nuestro trabajo diario; no tenemos tiempo de pararnos en aspectos teóricos. Por ésto, es preferible poner un ejemplo "que funciona siempre"; de este modo lo guardáis y, cuando tengáis que meter datos manualmente, lo recuperáis:

```sas
data manual;
    infile datalines dlm = ",";
    input nombre :$30. edad rango :$30.;
    datalines;
Jose Alberto, 34, Cabo Primero
Esteban, 25, Sarjento
Vicente, 56, Sarjento Primero
Laura, 45, Capitán
;
run;
```

Recomiendo recordar esta estructura. Comenzamos con `DATA` y el nombre del conjunto de datos SAS. La sentencia `INFILE` nos indica cómo va a ser la entrada de datos; `DATALINES` especifica que será manual y `DLM` tiene su importancia porque indica un delimitador de los datos; si empleamos delimitador, nos evitaremos muchos problemas. Después, la sentencia `INPUT` es fundamental porque es la que asigna la estructura al conjunto de datos. Estas estructuras estarán compuestas de variables; ya las analizaremos en profundidad. En este caso, tenemos tres variables: dos de texto (indicado con `$`) y una numérica (no pongo nada). Al final viene `DATALINES` sin más, que indica el punto en el que metemos el dato. Picamos los datos y separamos por comas; finalizamos con `RUN`. Ésta es la forma más sencilla y que mejor se entiende para introducir datos manualmente; nos evita muchas pegas con espacios en blanco, longitudes…

Para crear *datasets* desde ficheros de texto emplearemos una metodología distinta en `WPS` que la utilizada en SAS. `WPS` no tiene asistentes; por ello, lo mejor que podemos hacer es importar el fichero paso a paso para comprobar si lo hacemos correctamente. Para ilustrar el ejemplo, [podéis bajaros este archivo](/images/2008/03/grades.TXT) a vuestro equipo. Este fichero tiene las siguientes variables:

- ID del estudiante.
- Género.
- Clase.
- Puntuación de test.
- Puntuación del examen 1.
- Puntuación del examen 2.
- Puntuación de laboratorio.
- Puntuación del examen final.

Desde `WPS` podemos abrirlo para hacerle una vista y así poder dar una estructura correcta al conjunto de datos SAS. Vemos que tiene 28 líneas y está separado por espacios. Luego el paso `DATA` sería así:

```sas
data prueba;
    infile "C:\ruta\al\archivo\grades.txt";
    input id $ sexo $ clase Ptest P1 P2 Plab Ptotal;
run;
```

Recordamos: primero estructura, luego lee datos. Con `INFILE` le indicamos qué datos leemos y qué características tienen; con `INPUT` creamos la estructura, el vector de variables, el `PDV`. En este caso tenemos 8 variables: dos de ellas alfanuméricas (por ello empleamos `$`) y otras 6 numéricas (no ponemos nada). Éste es un caso extremo por lo simple. En la siguiente entrega leeremos ficheros de texto con `WPS` buscando casos más habituales.

Pero el 90% de las veces que utilicemos `DATA`, las lecturas serán de otros conjuntos de datos SAS:

```sas
data prueba2;
    set prueba;
run;
```

`DATA` crea una estructura y escribe, y `SET` indica cómo ha de ser esa estructura y dónde leer. Si hacemos lo siguiente:

```sas
data prueba_ampliada;
    set prueba;
    Pmedia = (P1 + P2) / 2;
run;
```

Estamos creando un nuevo *dataset* al que además le añadimos una nueva variable, un nuevo elemento a ese vector. Importante: no he indicado a `WPS` las características de ese nuevo elemento; selecciona las que él cree más adecuadas (no es necesario declarar variables explícitamente); ésto a veces resulta difícil de entender para los informáticos de otros lenguajes.

Lo dicho: siguiente entrega, importaciones de texto. `WPS` no tiene asistente y tenemos que escribir nosotros mismos el vector de variables. Saludos.