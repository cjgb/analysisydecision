---
author: rvaquerizo
categories:
- Monográficos
- SAS
- Trucos
date: '2014-01-14T10:16:02-05:00'
slug: espacios-en-sas
tags:
- COMPBL
- compress
- strip
- Trim
- trimn
title: Espacios en SAS
url: /espacios-en-sas/
---

![](/images/2014/01/Blancos-en-SAS.png)

Las funciones SAS más habituales para eliminar blancos son las que tenéis en la figura de arriba. Para llegar a ese conjunto de datos SAS hemos ejecutado el siguiente paso data:

```r
data ejemplo;

st = "  Cuando  brilla   el sol    ";
l_st=length(st); output;

funcion="COMPRESS     "; st1 = compress(st);
l_st1=length(st1); output;

funcion="COMPBL";  st1 = compbl(st);
l_st1=length(st1); output;

funcion="TRIM";    st1 = trim(st);
l_st1=length(st1); output;

funcion="TRIMN";   st1 = trimn(st);
l_st1=length(st1); output;

funcion="STRIP";    st1 = strip(st);
l_st1=length(st1); output;

funcion="SRTIP+COMBBL"; st1 = strip(compbl(st));
l_st1=length(st1); output;

run;
```
 

Distintas formas de eliminar espacios dentro de una cadena de caracteres en SAS. Partimos de la variable string » Cuando brilla el sol » y empleamos las siguientes funciones:

  * COMPRESS: Elimina todos los espacios en blanco de la variable
  * COMPBL: Elimina aquellos espacios en blanco que considera innecesarios, ejemplo ‘ ‘ -> ‘ ‘
  * TRIM y TRIMN: En este caso no hacen nada, así lo recordamos
  * STRIP: Elmina los espacios en blanco innecesarios por la izquierda
  * STRIP + COMPL: Es un combo de funciones pero el mejor para nuestro caso

Espero que entendáis mejor estas funciones. En breve veremos porque existen TRIM y TRIMN. Saludos.