---
author: rvaquerizo
categories:
  - formación
  - monográficos
  - sas
date: '2009-11-03'
lastmod: '2025-07-13'
related:
  - en-merge-mejor-if-o-where.md
  - laboratorio-de-codigo-sas-vistas-proc-means-vs-proc-sql.md
  - truco-sas-cruce-con-formatos.md
  - laboratorio-de-codigo-sas-ordenaciones-con-hash-vs-proc-sort.md
  - curso-de-lenguaje-sas-con-wps-sentencias-condicionales-if-then.md
tags:
  - formación
  - monográficos
  - sas
title: Laboratorio de código SAS. Comparativa entre IF y WHERE
url: /blog/laboratorio-de-codigo-sas-comparativa-entre-if-y-where/
---

Inicio hoy otra serie de mensajes para analizar el uso óptimo del código SAS. La intención es comparar distintas ejecuciones y obtener un pequeño reporte con la metodología y el tiempo empleado en su ejecución. Para evitar el efecto que pueda causar la concurrencia en un servidor con SAS, se realizarán múltiples ejecuciones. 

He intentado que el código que utilizo para comparar las ejecuciones sea lo más sencillo posible. Soy consciente de que se puede usar un código más "profesional", pero lo que planteo a continuación me parece una solución equilibrada. La idea es hacer una macro que haga $N$ ejecuciones para promediar el efecto de la concurrencia. Cada método tendrá una ejecución controlada con una macrovariable con la hora del sistema. Esta información se guardará en una tabla SAS junto con el nombre del método. Al final, lo más sencillo es ordenar por el tiempo de ejecución e imprimir el resultado.

Para iniciar esta serie, comenzamos con la comparativa entre `IF` y `WHERE`; ya hicimos algo parecido dentro de un `MERGE`, pero ahora vamos a hacerlo con y sin índices. Los métodos a emplear serán:

- **Método 1**: `IF` (subconjunto).
- **Método 1 BIS**: `IF` + `DELETE`.
- **Método 2**: `WHERE` como instrucción.
- **Método 3**: `WHERE` como opción de escritura.
- **Método 4**: `WHERE` como opción de lectura.

Partimos de una tabla SAS aleatoria con los registros que deseemos:

```sas
data uno;
    do i = 1 to 1000000;
        importe = rand("uniform") * 10000;
        output;
    end;
run;
```

A continuación, os planteo las macros creadas para realizar el experimento:

```sas
* ESTA MACRO AÑADE RESULTADOS AL DATASET DE TEST;
%macro aniade(descripcion);
    data borra;
        ejecucion = &i.;
        metodo = "&descripcion.";
        tiempo = time() - &inicio.;
        output;
    run;
    data test;
        set test borra;
    run;
    proc delete data=borra; 
    run;
%mend;

* MACRO QUE LANZA LA PRUEBA COMPARATIVA;
%macro test(ejecuciones);
    %do i = 1 %to &ejecuciones.;
        %let inicio = %sysfunc(time());

        * MÉTODO 1: EMPLEO DE IF;
        data dos;
            set uno;
            if importe < 5000;
        run;

        %if &i. = 1 %then %do;
            data test;
                ejecucion = &i.;
                length metodo $20.;
                metodo = "METODO 1";
                tiempo = time() - &inicio.;
                output;
            run;
        %end;
        %else %do;
            %aniade(METODO 1);
        %end;

        %let inicio = %sysfunc(time());
        * MÉTODO 1 BIS: EMPLEO DE IF + DELETE;
        data dos_prima;
            set uno;
            if importe >= 5000 then delete;
        run;
        %aniade(METODO 1 BIS);

        %let inicio = %sysfunc(time());
        * MÉTODO 2: EMPLEO DE WHERE COMO INSTRUCCION;
        data tres;
            set uno;
            where importe < 5000;
        run;
        %aniade(METODO 2);

        %let inicio = %sysfunc(time());
        * MÉTODO 3: EMPLEO DE WHERE COMO ESCRITURA;
        data cuatro(where=(importe < 5000));
            set uno;
        run;
        %aniade(METODO 3);

        %let inicio = %sysfunc(time());
        * MÉTODO 4: EMPLEO DE WHERE COMO LECTURA;
        data cinco;
            set uno (where=(importe < 5000));
        run;
        %aniade(METODO 4);
    %end;
    
    proc delete data=dos dos_prima tres cuatro cinco; 
    run;
%mend;

%test(4);
```

Ya sólo ordeno el *dataset* `test` y hago un `PROC PRINT`:

```sas
proc sort data=test; 
    by tiempo; 
run;

proc print data=test noobs; 
run;
```

Se observa habitualmente que el **Método 3** (`WHERE` como opción de escritura) suele ser menos eficiente que los demás en un paso `DATA` simple. Los métodos con `IF` y `WHERE` (como lectura o instrucción) suelen dar resultados similares en tablas sin indexar.

Seguiremos empleando estos códigos para comparar distintas formas de ejecutar código SAS. Por supuesto, si tenéis dudas, sugerencias o un trabajo interesante… `rvaquerizo@analisisydecision.es`. Saludos.