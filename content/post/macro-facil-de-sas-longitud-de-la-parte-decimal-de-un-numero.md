---
author: rvaquerizo
categories:
- Formación
- SAS
- Trucos
date: '2012-08-23T16:19:42-05:00'
lastmod: '2025-07-13T16:00:40.469806'
related:
- macros-sas-calular-la-longitud-de-un-numero.md
- duda-de-sas-longitud-de-la-parte-decimal-de-un-numero.md
- macros-sas-pasar-de-texto-a-numerico.md
- macros-sas-contar-las-palabras-de-una-macro-variable.md
- macros-sas-limpiar-una-cadena-de-caracteres.md
slug: macro-facil-de-sas-longitud-de-la-parte-decimal-de-un-numero
tags: []
title: Macro (fácil) de SAS. Longitud de la parte decimal de un número
url: /macro-facil-de-sas-longitud-de-la-parte-decimal-de-un-numero/
---

Muy sencillo, vemos el programa y posteriormente lo transformamos en una macro de SAS:

```r
data aleat;

do i = 1 to 100;

aleatorio=ranuni(8)*1000;

largo_decimal = length(scan(put(aleatorio,best32.),2,"."));

output;

end;

run;
```

Sencillo, pasamos de número a carácter con PUT y buscamos el punto con SCAN, extraemos la segunda parte del carácter separado por punto y vemos su longitud. Esto pasado a una macro:

```r
%macro largo_decimal(num);

length(scan(put(&num.,best32.),2,"."))

%mend;

data aleat;

do i = 1 to 100;

aleatorio=ranuni(8)*1000;

largo_decimal = %largo_decimal(aleatorio);

output;

end;

run;
```

Sencillo, a mi hoy me ha sido útil. Saludos.