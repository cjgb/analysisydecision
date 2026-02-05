---
author: rvaquerizo
categories:
  - formación
  - sas
  - trucos
date: '2010-06-14'
lastmod: '2025-07-13'
related:
  - las-cuentas-claras.md
  - truco-sas-categorizar-variables-continuas.md
  - trucos-sas-informes-de-valores-missing.md
  - trucos-sas-variables-dummy-de-una-variable-continua.md
  - macros-sas-tramificar-en-funcion-de-una-variable-respuesta.md
tags:
  - agrupar valores discretos
  - macros sas
  - proc freq
  - sas procs
title: Macros SAS. Agrupando variables categóricas
url: /blog/macros-sas-agrupando-variables-categoricas/
---

Agrupar variables con SAS es una de las tareas más habituales. Las variables continuas las agrupamos según un criterio y las discretas, en principio, ya vienen agrupadas. El problema con las variables discretas es que pueden tomar muchos valores, muchos de ellos con poco peso que habitualmente agrupamos en un rango "OTROS".

Pues bien, hoy quería mostraros una macro muy sencilla que utilizo para crear ese cajón desastre. El código tiene algún aspecto muy interesante; es el que os pongo a continuación:

```sas
%macro agrupa_frecuencias(entrada=,  /* DS DE ENTRADA */
                          vargrupo=, /* VARIABLE QUE AGRUPA */
                          nombre=count, /* VARIABLE DE FRECUENCIAS */
                          numgr=,    /* NUMERO DE GRUPOS */
                          resto=,    /* CATEGORIA RESTO */
                          salida=    /* DS DE SALIDA */);

    * TABLA DE FRECUENCIAS CON TODOS LOS VALORES;
    proc freq data=&entrada. noprint;
        tables &vargrupo. / list missing out=&salida.(drop=percent rename=(&vargrupo.=agr));
    run;

    proc sort data=&salida. by descending count; 
    run;

    * EN FUNCION DEL NUMERO DE GRUPOS CREAMOS EL RESTO;
    data &salida.;
        set &salida.;
        length &vargrupo. $20;
        if _n_ < &numgr. then &vargrupo. = put(agr, $20.);
        else &vargrupo. = "&resto.";
    run;

    * SUMARIZAMOS;
    proc summary data=&salida. nway missing;
        class &vargrupo.;
        output out=&salida. (drop=_type_ _freq_) sum(count)=&nombre.;
    run;
%mend;
```

Breve explicación del mismo: es un código de ejecución muy rápida. Necesitamos parámetros como un *dataset* de entrada, el nombre de la variable discreta que queremos agrupar, el nombre de la variable de conteo, el número de grupos total que deseamos y el nombre de la categoría resto. Es importante destacar que la variable final en este ejemplo será alfanumérica.

La macro comienza con un `PROC FREQ` que genera una tabla con todos los valores de la variable y su conteo; ordenamos descendentemente por ese conteo y después hacemos un paso `DATA` que lee la tabla y, si la observación está por encima del número de categorías fijado, la etiquetamos como "resto". Al final, tenemos que agregar los datos de esta tabla con `PROC SUMMARY`.

Como es habitual, ejemplo de uso:

```sas
data uno;
    do i = 1 to 10000;
        grupoM = byte(65 + mod(ranpoi(2, 4), 26)); /* Genera letras A-Z */
        importe = ranuni(8) * 1000;
        output;
    end;
    drop i;
run;

* EJEMPLO DE USO;
%agrupa_frecuencias(entrada=uno, vargrupo=grupoM, nombre=clientes, numgr=8, resto=OTROS, salida=frec_agrupada);

proc print data=frec_agrupada; 
run;
```

Dos variables de grupo con muchas categorías. Es un código muy sencillo que podéis rehacer a vuestro antojo para mejorarlo. Yo lo uso bastante para la realización de tablas de auditoría de datos.

Saludos.