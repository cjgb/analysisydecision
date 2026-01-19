---
author: rvaquerizo
categories:
  - formación
  - sas
  - trucos
date: '2010-04-29'
lastmod: '2025-07-13'
related:
  - macros-faciles-de-sas-normaliza-un-texto-rapido.md
  - trucos-sas-eliminacion-de-espacios-en-blanco.md
  - truco-sas-funcion-para-contar-caracteres.md
  - macros-sas-contar-las-palabras-de-una-macro-variable.md
  - curso-de-lenguaje-sas-con-wps-funciones-en-wps.md
tags:
  - compress
  - substr
  - tranwrd
  - trim
title: Macros SAS. Limpiar una cadena de caracteres
url: /blog/macros-sas-limpiar-una-cadena-de-caracteres/
---

Macro de SAS que he utilizado hoy para limpiar caracteres en una cadena de texto. Está muy limitada y es muy sencilla pero puede serviros:

```r
%macro valida(in,out);

length escribe $55.;

escribe="";

do i=1 to length(&in.);

  j=substr(&in.,i,1);

 if j in ('A','B','C','D','E','F','G','H','I','J','K',

 'L','M','N','O','P','Q','R','S','T','U','V','W','X','Y','Z','Ñ') then escribe=trim(escribe)||j;

 else if substr(&in.,i,1)=" " then escribe=trim(escribe)||"-";

 else escribe=trim(escribe);

 drop i j escribe;

end;

&out.=tranwrd(compress(escribe),"-"," ");

%mend;
```

Es bastante mala y limitada, insisto. Si alguien aporta algo se agradecerá. El tema es que recorre una variable alfanumérica carácter a carácter y si no es una letra mayúscula se lo chimpunea sin ningún miramiento, aporta un poco más de talento cuando aparece un espacio en blanco. Ahí va el ejemplo de uso:

```r
data _null_;

y="ME.N9UDA@ CAGA--;DA vENIR";

%valida(upcase(y),x);

put x=;

run;
```

En fin, si la voy mejorando lo sigo comunicando. Por cierto, esto se puede hacer con WPS a la perfección. Si alguno de vosotros está interesado en WPS o tiene ya jornada de verano y necesitan consultoría que me escriba a rvaquerizo@analisisydecision.es
