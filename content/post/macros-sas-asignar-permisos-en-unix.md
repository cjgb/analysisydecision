---
author: rvaquerizo
categories:
  - formación
  - sas
  - trucos
date: '2009-01-13'
lastmod: '2025-07-13'
related:
  - macro-sas-variables-de-un-dataset-en-una-macro-variable.md
  - trucos-sas-lista-de-datasets-en-macro-variable.md
  - trucos-sas-eliminar-etiquetas-en-los-conjunto-de-datos-sas.md
  - macros-sas-informe-de-un-dataset-en-excel.md
  - trucos-sas-macrovariable-a-dataset.md
tags:
  - formación
  - sas
  - trucos
title: Macros SAS. Asignar permisos en Unix
url: /blog/macros-sas-asignar-permisos-en-unix/
---

Hoy os presento una macro especialmente útil para aquellos que trabajéis con SAS en arquitecturas `UNIX`. En ocasiones, generamos tablas SAS que han de ser modificadas por otros usuarios y éstos no disponen de los permisos adecuados para modificarlas. La siguiente macro lo que hace es un «*change mode*», un `chmod` que modifica los permisos de las tablas SAS de una librería.

Por defecto, la macro hace un `chmod 777`, lo que significa que *owner*, *group* y *others* tienen permiso de lectura, escritura y ejecución. Si pusiéramos `chmod 766`, significaría que el *owner* tiene todos los permisos y el *group* y *others* permiso de lectura y escritura. `chmod 744` significaría que el *owner* tiene todos los permisos y *group* y *others* únicamente permiso de lectura.

Los permisos son los tres dígitos que, de izquierda a derecha, designan los permisos del *owner*, *group* y *others*. El equivalente para las letras sería:

- `0` = `---` = Sin acceso.
- `1` = `--x` = Ejecución.
- `2` = `-w-` = Escritura.
- `3` = `-wx` = Escritura y ejecución.
- `4` = `r--` = Lectura.
- `5` = `r-x` = Lectura y ejecución.
- `6` = `rw-` = Lectura y escritura.
- `7` = `rwx` = Lectura, escritura y ejecución.

Con ésto, nuestra macro de SAS sería:

```sas
%macro chmod(libname, dataset, permis=777);
    proc sql noprint;
        * OBTENEMOS LA UBICACIÓN DE LA LIBRERÍA;
        select distinct path into :extpath 
        from dictionary.members
        where libname = "%upcase(&libname.)";

        * NÚMERO DE DATASETS DE LA LIBRERÍA;
        select count(*) into :cnt 
        from dictionary.members
        where libname = "%upcase(&libname.)";
    quit;

    * ESTE BUCLE ASIGNA LOS PERMISOS A CADA DATASET;
    %if &cnt. > 0 %then %do;
        filename do_chmod pipe "chmod &permis. %trim(&extpath.)/&dataset..sas7bdat";
        data _null_;
            file do_chmod;
            put;
        run;
        filename do_chmod clear;
    %end;
%mend;
```

**Ejemplo de uso:**

```sas
libname libref "/sas/datos";
%chmod(libref, *);
```

Vemos que por defecto la macro asigna permisos `777`; con `*` seleccionamos todos los *datasets* de la librería.

Espero que sea de utilidad. Por supuesto, si tenéis dudas, sugerencias o un trabajo muy bien remunerado… `rvaquerizo@analisisydecision.es`. Saludos.