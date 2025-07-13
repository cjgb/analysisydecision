---
author: rvaquerizo
categories:
- Formación
- SAS
- Trucos
date: '2009-10-27T07:46:17-05:00'
lastmod: '2025-07-13T16:00:56.773255'
related:
- macro-facil-de-sas-longitud-de-la-parte-decimal-de-un-numero.md
- duda-de-sas-longitud-de-la-parte-decimal-de-un-numero.md
- macros-sas-contar-las-palabras-de-una-macro-variable.md
- macros-sas-pasar-de-texto-a-numerico.md
- macros-sas-limpiar-una-cadena-de-caracteres.md
slug: macros-sas-calular-la-longitud-de-un-numero
tags:
- compress
- funciones de texto SAS
- length
- macros SAS
title: Macros SAS. Calular la longitud de un número.
url: /macros-sas-calular-la-longitud-de-un-numero/
---

Ha llegado hoy una búsqueda que no ha permanecido en AyD ni 20 segundos. Quería calcular la longitud de un número con SAS. Como yo estoy aquí para compartir mis conocimientos y hay una persona que los necesita aquí está esta macro que espero o sea de utilidad:

```r
%macro largo(num);

length(compress(put(&num.,32.)))

%mend;
```

Esta macro recibe un parámetro que ha de ser un número y lo que hace es transformarlo a carácter comprimido y calcular su longitud. Veamos ejemplos de uso:

```r
data uno;

input x;

datalines;

1234

12345

123456

1234567

12345678

1

12

123456789

1234567890

;

run;
```

```r
data uno;

set uno;

y=%largo(x);

*NOS QUEDAMOS CON LA PRIMERA CIFRA;

z=int(x/(10**(%largo(x)-1)));

run;

proc print;

run;
```

Con este ejemplo vemos perfectamente su funcionamiento, además puede ir en operaciones matemáticas como el ejemplo en el que se queda con la primera cifra de un número. Espero que sea de utilidad y como siempre si tenéis dudas, sugerencias o un trabajo con un horario inferior o igual a 40 horas semanales reales podéis contactar conmigo en [rvaquerizo@analisisydecision.es](mailto:rvaquerizo@analisisydecision.es)