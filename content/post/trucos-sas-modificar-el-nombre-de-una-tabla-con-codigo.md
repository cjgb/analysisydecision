---
author: rvaquerizo
categories:
- SAS
- Trucos
date: '2010-06-16T03:57:29-05:00'
slug: trucos-sas-modificar-el-nombre-de-una-tabla-con-codigo
tags:
- CHANGE
- proc datasets
title: Trucos SAS. Modificar el nombre de una tabla con código
url: /trucos-sas-modificar-el-nombre-de-una-tabla-con-codigo/
---

Dando un repaso a las entradas de Google me he encontrado repetida la frase: «cambiar el nobre de un dataset SAS». Imagino que desearán cambiar el nombre de un dataset con código sin realizar un paso DATA. Para hacer esta labor hemos de emplear el PROC DATASETS y la sentencia CHANGE. Veamos un código de ejemplo muy sencillo:

```r
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