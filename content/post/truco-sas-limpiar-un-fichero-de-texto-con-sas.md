---
author: rvaquerizo
categories:
- Formación
- SAS
- Trucos
date: '2013-03-04T10:27:42-05:00'
slug: truco-sas-limpiar-un-fichero-de-texto-con-sas
tags: []
title: Truco SAS. Limpiar un fichero de texto con SAS
url: /truco-sas-limpiar-un-fichero-de-texto-con-sas/
---

El otro día me llegó al correo la siguiente cuestión acerca de caracteres extraños en un fichero de texto y la importación a SAS:

> >> Tengo un problema a la hora de importar a SAS un fichero txt.  
>  >> El caso es que tiene en algunos registros el carácter «flechita».  
>  >> Ejemplo: Calle Paseo de la Castellana «flechita» 60.  
>  >> Cuando lo importo como carácter para al llegar a la flechita.  
>  >> No se sí podrás ayudarme.  
>  >> Muchas gracias por adelantado.

Se me ocurrió un programa muy rápido que nos permitía leer carácter a carácter un fichero plano y eliminar aquellos caracteres que nos den problemas:

```r
%let directorio=;
%let archivo=;

data _null_;
  length char 1.;
  infile "&directorio.\archivo..txt" lrecl=1 recfm=F missover dsd;
  file "&directorio.\archivo._modificado.txt" lrecl=1 recfm=F;
  input charASCII.;
  if char not in  ('A','B','C','D','E','F','G','H','I','J','K',
 'L','M','N','O','P','Q','R','S','T','U','V','W','X','Y','Z','Ñ',
 '1','2','3','4','5','6','7','8','9','0') then char=" ";
  put char;
run;
```
 

Necesita un directorio, un archivo con extensión TXT y nos creará ese archivo con el sufijo _modificado y limpio de caracteres extraños, en este caso sólo con letras y números, ojo que podéis necesitar signos de puntuación. Creo que es muy sencillo y bastante práctico. Espero que os sea de utilidad, a la lectora que planteó la duda si lo fue. Saludos.