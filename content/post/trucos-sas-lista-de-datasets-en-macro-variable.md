---
author: rvaquerizo
categories:
  - formación
  - sas
  - trucos
date: '2009-02-05'
lastmod: '2025-07-13'
related:
  - macro-sas-variables-de-un-dataset-en-una-macro-variable.md
  - trucos-sas-union-de-multiples-tablas-sas-con-un-nombre-parecido.md
  - trucos-sas-eliminar-etiquetas-en-los-conjunto-de-datos-sas.md
  - trucos-sas-macrovariable-a-dataset.md
  - truco-sas-tablas-de-una-libreria-en-una-macro-variable.md
tags:
  - formación
  - sas
  - trucos
title: Trucos SAS. Lista de datasets en macrovariable
url: /blog/trucos-sas-lista-de-datasets-en-macro-variable/
---

Un uso frecuente del `PROC SQL` es la generación de macrovariables. En este ejemplo, vamos a crear una macrovariable con el nombre de los *datasets* de una librería SAS que contengan un determinado patrón. También es un ejemplo bastante práctico del uso de las vistas de `SASHELP`.

Para entender mejor el truco, vamos a generar 20 ficheros ficticios con variables aleatorias en el directorio `C:\temp`:

```sas
libname temp "C:\temp";

* GENERAMOS 20 DATASETS ALEATORIOS;
%macro tablas_aleatorias;
    %do i = 1 %to 20;
        data temp.aleat&i.;
            do j = 1 to 100;
                persona = ranpoi(8, 23);
                importe1 = int(rand("uniform") * 1000);
                importe2 = int(rand("uniform") * 1000);
                tae = ranpoi(34, 2) + round(rand("uniform"), .1);
                output;
            end;
            drop j;
        run;
    %end;
%mend tablas_aleatorias;

%tablas_aleatorias;
```

Esta macro hace un bucle y genera 20 *datasets*. A continuación, necesitamos crear un *dataset* que sea la concatenación de los 20 generados anteriormente. Podríamos poner los 20 nombres a mano, pero esto no es elegante. Para automatizar esto debemos hacer lo siguiente:

```sas
* SELECCIONAMOS LOS DATASETS QUE CONTENGAN "ALEAT" EN EL NOMBRE;
proc sql noprint;
    select compress(libname || "." || memname)
    into :lista_tablas separated by " "
    from sashelp.vtable
    where memname like '%ALEAT%' and libname = "TEMP";
quit;

* CREAMOS UNA TABLA QUE SEA LA UNION DE TODOS LOS DATASETS;
data aleat_union;
    set &lista_tablas.;
run;
```

La macrovariable `lista_tablas` contiene todos los *datasets* de la librería `TEMP` que cumplen la condición. Podemos incluso crear una macro genérica para realizar esta tarea:

```sas
%macro seleccion(patron, libreria);
    %global lista_tablas;
    proc sql noprint;
        select compress(libname || "." || memname)
        into :lista_tablas separated by " "
        from sashelp.vtable
        where index(upcase(memname), upcase("&patron.")) > 0 
          and libname = upcase("&libreria.");
    quit;
%mend seleccion;

%seleccion(aleat, temp);

%put Listado de tablas: &lista_tablas.;
```

Para la macro empleamos `index()` en vez de `like` para facilitar la concatenación de comodines. Estas técnicas son fundamentales para automatizar procesos repetitivos en SAS.

Por supuesto, si alguien tiene dudas o sugerencias… `rvaquerizo@analisisydecision.es`. Saludos.