---
author: rvaquerizo
categories:
  - sas
  - trucos
date: '2010-06-16'
lastmod: '2025-07-13'
related:
  - trucos-sas-eliminar-etiquetas-en-los-conjunto-de-datos-sas.md
  - truco-sas-proc-contents.md
  - trucos-sas-union-de-multiples-tablas-sas-con-un-nombre-parecido.md
  - trucos-sas-ordenar-las-variables-de-un-dataset.md
  - trucos-sas-lista-de-datasets-en-macro-variable.md
tags:
  - change
  - proc datasets
  - sas procs
title: Trucos SAS. Modificar el nombre de una tabla con código
url: /blog/trucos-sas-modificar-el-nombre-de-una-tabla-con-codigo/
---

Dando un repaso a las entradas de Google me he encontrado repetida la frase: «cambiar el nobre de un dataset SAS». Imagino que desearán cambiar el nombre de un dataset con código sin realizar un paso DATA. Para hacer esta labor hemos de emplear el PROC DATASETS y la sentencia CHANGE. Veamos un código de ejemplo muy sencillo:

```sas
*DATASET ALEATORIO;

data sasuser.uno;
 do i=1 to 1000;
 aleat=ranuni(9);
 output;
 end;
run;

*CAMBIAMOS EL NOMBRE;

proc datasets lib=sasuser nolist;
change uno=borrar;
quit;

*ELIMINAMOS EL DATASET;

proc delete data=sasuser.borrar; quit;
```

El código es extremadamente sencillo. Imagino que las entradas que estaban llegando con esta duda buscaban algo parecido a esto. El PROC DATASETS es un gran desconocido.
