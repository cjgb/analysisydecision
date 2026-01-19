---
author: rvaquerizo
categories:
- formación
- sas
- trucos
date: '2012-04-11'
lastmod: '2025-07-13'
related:
- trabajo-con-fechas-sas-formatos-de-fecha-sas-mas-utilizados.md
- trabajo-con-fechas-sas-funciones-fecha.md
- trabajo-con-fechas-sas-introduccion.md
- curso-de-lenguaje-sas-con-wps-funciones-fecha.md
- macros-sas-transformar-un-numerico-a-fecha.md
tags:
- fechas sas
- formatos
title: Trucos SAS. Pasar fecha a caracter en SAS
url: /blog/trucos-sas-pasar-fecha-a-caracter-en-sas/
---
Pasar números a carácter en SAS es un tema reiterativo tanto en entradas al blog como en búsquedas. Pero que se le puede dar otra vuelta de tuerca. Se trata de transformar fechas a variables alfanuméricas, pero en este caso vamos a poner las fechas en formato español. Ejecutad este ejemplo en SAS:

```r
data uno;

y = '30jan11'd;

c0 = put(y,ddmmyy10.);

c1 = upcase(put(y,ESPDFDD.));

c2 = upcase(put(y,ESPDFDE.));

c3 = upcase(put(y,ESPDFDN.));

c4 = upcase(put(y,ESPDFDT.));

c5 = upcase(put(y,ESPDFDWN.));

c6 = upcase(put(y,ESPDFMN.));

c7 = upcase(put(y,ESPDFMY.));

c8 = upcase(put(y,ESPDFWDX.));

c9 = upcase(put(y,ESPDFWKX.));

run;
```

Imagino que todos tenéis el [NLS de SAS](http://support.sas.com/documentation/cdl/en/nlsref/61893/PDF/default/nlsref.pdf) instalado y no tenéis problemas con estos formatos. Resumamos que nos ofrece cada una de estas transformaciones:

  * DDMMYY10 es el más habitual y nos genera 30/01/2011 podemos jugar con la longitud
  * ESPDFDD genera 30.01.2011 un formato que personalmente utilizo mucho
  * ESPDFDE genera 30ENE2011 probablemente el más habitual
  * ESPDFDN genera un 7, la semana del año
  * ESPDFDT genera un fecha-hora con formato español, en este caso no tiene mucho sentido
  * ESPDFDWN nos pone el día de la semana, domingo
  * ESPDFMN nos pone el mes, enero
  * ESPDFMY genera ENE11, práctico para sumarizaciones
  * ESPDFWDX genera 30 DE ENERO DE 2011
  * ESPDFWKX genera DOMINGO, 30 DE ENERO DE 2011 un formato que no he usado nunca

[Estos formatos SAS los conozco gracias a un lector del blog](https://analisisydecision.es/trabajo-con-fechas-sas-formatos-de-fecha-sas-mas-utilizados/). Al César lo que es del César. Aquí aprendemos todos. Es interesante recogerlos todos juntos para que esta entrada quede como una referencia de la transformación de fechas en textos en SAS. Saludos.