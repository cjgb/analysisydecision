---
author: rvaquerizo
categories:
  - sas
  - trucos
date: '2008-10-27'
lastmod: '2025-07-13'
related:
  - macros-sas-contar-las-palabras-de-una-macro-variable.md
  - macros-sas-limpiar-una-cadena-de-caracteres.md
  - macros-sas-calular-la-longitud-de-un-numero.md
  - curso-de-lenguaje-sas-con-wps-funciones-en-wps.md
  - dividir-en-palabras-un-texto-con-sas.md
tags:
  - contar caracteres
  - funciones texto
  - sas
title: Truco SAS. Función para contar caracteres
url: /blog/truco-sas-funcion-para-contar-caracteres/
---

Si deseamos contar cuantas veces aparece un caracter dentro de una cadena en SAS nos encontramos que no existe ninguna función de texto en SAS. Para ello podemos utilizar otras funciones de texto en SAS. La idea es determinar la `length` de la cadena con el caracter en cuestión y restarle la `length` de la cadena sin el caracter. Es decir, ¿cuántas A hay en la frase "Menuda crisis financiera"? Longitud con A y sin espacios= 22, longitud sin A y sin espacios=19, luego 22-19=3 aes. Para este ejemplo no se tienen en cuenta los espacios en blanco, veamos el programa en SAS:

```sas
data _null_;v="MEnUDA CRISIS FINaNCIERA";
y=length(compress(upcase(v))) – length(compress(compress(upcase(v)),"A"));
put y=;
run ;
```

Como diferencia de longitudes se obtiene el número, este programa no distingue entre mayúsculas y minúsculas, si deseamos que sea así sólo debemos eliminar el `upcase`. Mediante código macro podemos crearnos algo muy parecido a una función SAS:

```sas
%macro cuenta_car(variable,caracter);
length(compress(upcase(&variable.)))- length(compress(compress(upcase(&variable.)),"%upcase(&caracter.)"))
%mend ;
```

Recordemos que el código macro se compila antes que el programa SAS. De este modo podemos crear funciones como las que lleva SAS por defecto. Si teneís alguna duda o sugerencia sobre el funcionamiento: `rvaquerizo@analisisydecision.es`
