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
- sin etiqueta
title: Macros SAS. Asignar permisos en Unix
url: /blog/macros-sas-asignar-permisos-en-unix/
---
Hoy os presento una macro especialmente útil para aquellos que trabajéis en con SAS en arquitecturas Unix. En ocasiones generamos tablas SAS que han de ser modificadas por otros usuarios y éstos no disponen de los permisos adecuados para modificarlas. La siguiente macro los que hace es un «change mode», un chmod que modifica los permisos de las tablas SAS de una librería. Por defecto la macro hace un chmod file 777 que significa que owner, group y others tienen permiso de lectura, escritura y ejecución. Si pusieramos chmod 766 significaría que el owner tiene permiso de lectura, escritura y ejecución, y el group y others permiso de lectura y escritura. Chmod 744 significaría que el owner tiene permisos de lectura, escritura y ejecución, y group y others unicamente permisos de lectura.

Los permisos son los 3 dígitos que de izquierda a derecha designan los permisos del owner, group y others. El equivalente para las letras sería:

0 = — = sin acceso
1 = –x = ejecución
2 = -w- = escritura
3 = -wx = escritura y ejecución
4 = r– = lectura
5 = r-x = lectura y ejecución
6 = rw- = lectura y escritura
7 = rwx = lectura, escritura y ejecución

Con esto nuestra macro de SAS sería:

```r
%macro chmod(libname,dataset,permis=777);

  proc sql noprint;

  * OBTENEMOS LA UBICACION DE LA LIBRERIA ;

  select path into: extpath from dictionary.members

  where libname="%UPCASE(&LIBNAME)";
```

```r
* NUMERO DE DATASETS DE LA LIBRERIA ;

  select count(path) into: cnt from dictionary.members

  where libname="%UPCASE(&LIBNAME)";
```

* ESTE BUCLE ASIGNA LOS PERMISOS A CADA DATASET, POR DEFECTO
LA MACRO TIENE 777;
%if &cnt > 0 %then %do;
filename chmod pipe "chmod &PERMIS %trim(&extpath)/&dataset..sas7bdat";
data _null_;
file chmod;
run;
%end;
%mend;

*EJEMPLO DE USO;
libname libref "/sas/datos";
%chmod(libref,*);

Vemos que por defecto la macro asigna permisos 777, con * seleccionamos todos los dataset de la librería.

Espero que sea de utilidad. Por supuesto si tenéis dudas, sugerencias o un trabajo muy bien remunerado… rvaquerizo@analisisydecision.es