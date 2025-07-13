---
author: rvaquerizo
categories:
- Formación
- SAS
- Trucos
date: '2013-05-30T05:48:16-05:00'
slug: trucos-sas-ordenar-las-variables-de-un-dataset
tags:
- retain
title: Trucos SAS. Ordenar las variables de un dataset
url: /trucos-sas-ordenar-las-variables-de-un-dataset/
---

Para cambiar el orden de las variables en un conjunto de datos SAS hemos de emplear RETAIN antes de SET. Este truco es la respuesta a una duda planteada en el blog. Un vistazo rápido al ejemplo entenderemos la sintaxis:

```r
data datos;
do i=1 to 20;
importe1 = ranuni(8)*100;
importe2 = ranuni(3)*100;
importe3 = ranuni(1)*100;
id = put(i,z5.);
output;
end;
drop i;
run;

data datos_reordenados;
retain id importe3;
set datos;
run;
```
 

Como vemos RETAIN nos permite reordenar las variables del dataset independientemente del tipo de variable que estemos manejando. También podríamos emplear algún otro tipo de sentencia, pero es recomendable usar RETAIN, como vemos no es necesario poner el total de las variables. Saludos.