---
author: rvaquerizo
categories:
  - formación
  - sas
  - trucos
date: '2013-05-30'
lastmod: '2025-07-13'
related:
  - subconjuntos-de-variables-con-dropkeep.md
  - macros-sas-ordenar-alfabeticamente-las-variables-de-un-dataset.md
  - truco-sas-proc-contents.md
  - curso-de-lenguaje-sas-con-wps-subconjuntos-de-variables-con-drop-y-keep.md
  - trucos-sas-modificar-el-nombre-de-una-tabla-con-codigo.md
tags:
  - retain
title: Trucos SAS. Ordenar las variables de un dataset
url: /blog/trucos-sas-ordenar-las-variables-de-un-dataset/
---

Para cambiar el orden de las variables en un conjunto de datos SAS hemos de emplear RETAIN antes de SET. Este truco es la respuesta a una duda planteada en el blog. Un vistazo rápido al ejemplo entenderemos la sintaxis:

```sas
data datos;
do i=1 to 20;
importe1 = ranuni(8)*100;
importe2 = ranuni(3)*100;
importe3 = ranuni(1)*100;
id = put(i,z5_);
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
