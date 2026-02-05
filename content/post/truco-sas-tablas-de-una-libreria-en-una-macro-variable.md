---
author: rvaquerizo
categories:
  - formación
  - sas
  - trucos
  - wps
date: '2017-01-24'
lastmod: '2025-07-13'
related:
  - trucos-sas-lista-de-datasets-en-macro-variable.md
  - truco-sas-proc-contents.md
  - macros-sas-informe-de-un-dataset-en-excel.md
  - macro-sas-variables-de-un-dataset-en-una-macro-variable.md
  - trucos-sas-eliminar-etiquetas-en-los-conjunto-de-datos-sas.md
tags:
  - proc datasets
  - retain
  - trimn
  - sas
  - sas procs
title: Truco SAS. Tablas de una librería en una macrovariable
url: /blog/truco-sas-tablas-de-una-libreria-en-una-macro-variable/
---

Me plantean una duda: cómo crear un conjunto de datos con las tablas de una librería en SAS y, posteriormente, generar una macrovariable con ellos. [Ésta es una entrada análoga a otra del blog](https://analisisydecision.es/trucos-sas-lista-de-datasets-en-macro-variable/), pero sirve para recordar cómo funciona el `ODS` de SAS y el `PROC DATASETS`, un procedimiento que no he usado habitualmente pero que es muy potente.

Lo primero que vamos a hacer es observar qué resultados arroja el `PROC DATASETS` en su sintaxis más sencilla para ver los contenidos de una librería:

```sas
ods trace on;
proc datasets lib=datos;
run;
quit;
ods trace off;
```

Recordamos que `ODS` (*Output Delivery System*) `TRACE ON` nos permite ver en el *log* de SAS los elementos que se obtienen como resultado; en este caso, el más sencillo, tenemos:

```text
Output Added:
-------------
Name: Directory
Label: Directory Information
Template: Base.Datasets.Directory
Path: Datasets.Directory
-------------

Output Added:
-------------
Name: Members
Label: Library Members
Template: Base.Datasets.Members
Path: Datasets.Members
-------------
```

Evidentemente, nos interesa `Members` para poner en una tabla SAS todos los miembros de la librería:

```sas
ods output Members=tablas;
proc datasets lib=datos;
run;
quit;
```

Ahora tenemos que meter en una macrovariable todos los elementos del campo `Name` de la tabla SAS que hemos generado. Para ello, en vez de emplear el habitual `PROC SQL`, podemos usar una concatenación sobre los valores de `Name` que diera como resultado final la macrovariable con la lista de las tablas:

```sas
data _null_;
    length mv $2550.;
    set tablas end=fin;
    retain mv "";
    mv = trimn(mv) || ' ' || compress(name);
    if fin then call symput('lista_tablas', mv);
run;

%put &lista_tablas.;
```

En este paso `DATA` es interesante el uso de `LENGTH` al principio para garantizarnos un buen número de *bytes* para nuestra macrovariable y el uso de `RETAIN` para crear una sucesión de concatenaciones, donde es importante emplear `TRIMN` para evitar que los espacios en blanco nos generen problemas. En el ejemplo no se genera conjunto de datos SAS con `DATA _NULL_`, pero si queréis ver cómo se genera la variable escalonada que acumula a `Name`, generad una tabla SAS física y entenderéis mejor cómo funciona.

Habrá quien opine que estos pasos son más sencillos que los que puse en la entrada de 2009, pero yo personalmente prefiero el `PROC SQL`. Saludos.