---
author: rvaquerizo
categories:
- SAS
- Trucos
date: '2008-10-27T08:46:15-05:00'
slug: truco-sas-funcion-para-contar-caracteres
tags:
- contar caracteres
- funiones texto
- SAS
title: Truco SAS. Función para contar caracteres
url: /truco-sas-funcion-para-contar-caracteres/
---

Si deseamos contar cuantas veces aparece un caracter dentro de una cadena en SAS nos encontramos que no existe ninguna función de texto en SAS. Para ello podemos utilizar otras funciones de texto en SAS. La idea es determinar la longitud de la cadena con el caracter en cuestión y restarle la longitud de la cadena sin el caracter. Es decir, ¿cuántas A hay en la frase «Menuda crisis financiera»? Longitud con A y sin espacios= 22, longitud sin A y sin espacios=19, luego 22-19=3 aes. Para este ejemplo no se tienen en cuenta los espacios en blanco, veamos el programa en SAS:

**data _null_;v=«MEnUDA CRISIS FINaNCIERA»;**

***LO CALCULAMOS COMO DIFERENCIA DE LONGITUDES;****** y=length(compress(upcase(v))) – length(compress(compress(upcase(v)),«A»));put y=;**run ;**

Como diferencia de longitudes se obtiene el número, este programa no distingue entre mayúsculas y minúsculas, si deseamos que sea así sólo debemos eliminar el upcase. Mediante código macro podemos crearnos algo muy parecido a una función SAS:

********%macro** cuenta_car(variable,caracter);length(compress(upcase(&variable.)))- length(compress(compress(upcase(&variable.)),«%upcase(&caracter.)»)) **%mend ;** **

****  
data _null_;****

v=«MEnUDA CRISIS FINaNCIERA»;

y=%**_cuenta_car_**(v,a);

put y=;**run ;**

Recordemos que el código macro se compila antes que el programa SAS. De este modo podemos crear funciones como las que lleva SAS por defecto. Si teneís alguna duda o sugerencia sobre el funcionamiento: [rvaquerizo@analisisydecision.es](mailto:rvaquerizo@analisisydecision.es)