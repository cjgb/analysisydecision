---
author: rvaquerizo
categories:
  - formación
  - monográficos
  - sas
  - trucos
date: '2010-11-12'
lastmod: '2025-07-13'
related:
  - laboratorio-de-codigo-sas-ordenaciones-con-hash-vs-proc-sort.md
  - la-importancia-del-parametro-hashexp.md
  - trucos-sas-porque-hay-que-usar-objetos-hash.md
  - truco-sas-cruce-con-formatos.md
  - trucos-sas-operaciones-con-tablas-de-dimensiones-con-sas.md
tags:
  - hash
title: Objetos hash para ordenar tablas SAS
url: /blog/objetos-hash-para-ordenar-tablas-sas/
---

A partir de la versión 9.1 de SAS se incluyeron los **objetos `hash`**. Hace [tiempo ya demostramos su eficiencia en el cruce de tablas](https://analisisydecision.es/trucos-sas-porque-hay-que-usar-objetos-hash/) y hoy quería mostraros cómo se programa una ordenación empleando `hash`. La verdad es que estoy saboreando mis últimos días con SAS v9.2; en breve volveré a una versión muy anterior. El código, en mi opinión, es muy sencillo y, como es habitual, tenemos un ejemplo ilustrativo:

```sas
* DATASET DE PRUEBA;
data uno;
    array v(10);
    do i = 1 to 5000000;
        importe = ranuni(mod(time(), 1) * 1000) * 10000;
        do j = 1 to 5;
            v(j) = ranuni(34) * 100;
        end;
        output;
    end;
    drop i j;
run;

* REALIZAMOS LA ORDENACION CON HASH;
data _null_;
    if 0 then set uno;
    declare hash obj (dataset: 'uno', hashexp: 20, ordered: 'a');
    obj.defineKey('importe');
    obj.defineData(all: 'YES');
    obj.defineDone();
    obj.output(dataset: 'dos');
    stop;
run;
```

**Importante**: sólo funciona en versiones posteriores a la 9.1.

Empleamos `DATA _NULL_` y una sentencia condicional (`if 0 then set uno;`) para que el paso `DATA` conozca la estructura del *dataset* que deseamos ordenar sin leerlo inicialmente. Con **`DECLARE`** creamos el objeto `hash` `obj` del *dataset* `uno` e indicamos que ha de estar ordenado ascendentemente (`ordered: 'a'`); podríamos ordenar descendentemente con `'d'`. 

El parámetro `HASHEXP` determina el número de "cubos" (*buckets*) en los que vamos a repartir la tabla `hash`; en este caso $2^{20}$. Es un parámetro muy importante para que este proceso sea eficiente. Definimos la **llave** con `defineKey` e indicamos el campo por el que realizaremos la ordenación. `defineData` indica las variables que se recogen en el objeto; en este caso empleamos `all: 'YES'` para quedarnos con todas. Finalizamos las definiciones con `defineDone()`. Por último, en **`output`** indicamos el conjunto de datos SAS que se genera.

Estas pocas líneas son una forma eficiente de ordenar conjuntos de datos SAS. Pero hay que analizar cuánto es de eficiente. Como ya he comentado, en breve volveré a versiones anteriores de SAS y no sé si podré seguir desarrollando pruebas con objetos `hash`, pero es muy importante estudiar el consumo de memoria y el consumo de espacio, y por supuesto compararlo con el **`PROC SORT`**.

Lo que sí puedo adelantar son algunas conclusiones: el `hash` consume más memoria, menos espacio en disco y suele tardar menos tiempo, pero hay que monitorizar el consumo de memoria con mucho detenimiento. Saludos.