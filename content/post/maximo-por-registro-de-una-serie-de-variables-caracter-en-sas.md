---
author: rvaquerizo
categories:
- SAS
- Trucos
date: '2017-02-24T08:19:59-05:00'
lastmod: '2025-07-13T16:02:16.750916'
related:
- truco-sas-transformaciones-de-variables-con-arrays.md
- minimo-de-una-matriz-de-datos-en-sas.md
- macro-sas-variables-de-un-dataset-en-una-macro-variable.md
- trucos-sas-mejor-que-hash-in-para-cruzar-tablas.md
- trucos-sas-operaciones-con-tablas-de-dimensiones-con-sas.md
slug: maximo-por-registro-de-una-serie-de-variables-caracter-en-sas
tags:
- array
title: Máximo por registro de una serie de variables carácter en SAS
url: /maximo-por-registro-de-una-serie-de-variables-caracter-en-sas/
---

Un lector del blog preguntaba como obtener el valor máximo dentro de un registro, por fila, de una sucesión de variables caracter; evidentemente la función max no servía porque es específica para variables numéricas. La duda la planteaba del siguiente modo:

```r
Pero tengo una duda que no soy capaz de sacar y no veo ninguna cosa parecida para poder sacarlo, a ver si me puedes ayudar, o si no, pues me dices que no y no hay ningún problema.

Tengo un data de este estilo:
Nombre    Clave1    Clave2    Clave3
Ana             A            A            B
Pepe           H            M            C
Juan           A             A            A

El tema es que necesito calcular el máximo de todas las claves para cada persona, es decir,
Nombre    Clave1    Clave2    Clave3    Max
Ana             A            A            B         B
Pepe           H            M            C        M
Juan           A             A            A         A

Como son letras, no me funciona el max en el proc sql y tampoco sé ninguna función que pueda pasarme las letras a numéricas.
Está claro que la única manera que se me ocurre es transformando las letras a números con un case, hacer el máximo y después transformarlo otra vez a letras, pero es por si sabes alguna manera mejor de hacerlo.
```
 

La solución que le planteo se realiza con un array donde seleccionamos sólo las variables clave:

[sourcecode language=»SAS»]  
Data datos;  
input Nombre Clave1 Clave2 Clave3;  
datalines;  
Ana A A B  
Pepe H M C  
Juan A A A  
;run;

data datos;  
set datos;  
array cl (*) clave:;  
maximo=cl(1);  
do i=1 to dim(cl);  
if cl(i)>maximo then maximo=cl(i);  
end;  
drop i;  
run;[/sourcecode]

Inicializamos el máximo al primer elemento del array y vamos recorriendo las variables, si una es mayor que la otra se modifica el máximo. Espero que le sirva a algún otro lector. Saludos.