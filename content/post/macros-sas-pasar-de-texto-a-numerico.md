---
author: rvaquerizo
categories:
- Formación
- SAS
date: '2012-10-10T09:37:56-05:00'
lastmod: '2025-07-13T16:01:08.986921'
related:
- transformar-variables-en-sas-caracter-a-numerico.md
- truco-sas-macro-buscar-y-reemplazar-en-texto.md
- macros-sas-calular-la-longitud-de-un-numero.md
- macros-faciles-de-sas-normaliza-un-texto-rapido.md
- macro-facil-de-sas-longitud-de-la-parte-decimal-de-un-numero.md
slug: macros-sas-pasar-de-texto-a-numerico
tags: []
title: Macros SAS. Pasar de texto a numérico
url: /macros-sas-pasar-de-texto-a-numerico/
---

“Pasar de texto a número en SAS”. Una de las búsquedas que más recibe esta web. Ya hay monográficos, trucos, artículos,… al respecto. Pero faltaba una macro que espero os ayude. Es una macro muy básica pero que permite pasar textos con números en formato europeo o en formato americano. La macro:

```r
%macro texto_numero(varib_ini=, varib_fin=,europeo=0);
vaux=&varib_ini.;
drop vaux;
%if &europeo. %then %do;
vaux = compress(vaux,".");
%end;

%if &europeo. %then %do;
vaux = tranwrd(vaux,",",".");
%end;

&varib_fin. = input(vaux * 1,best12.);
%mend;
```
 

Breve descipción. La variable inicial (parámetro varib_ini) será la cadena de texto que deseamos pasar a número. La variable final (parámetro varib_fin) será el nombre de la variable numérica. Si deseamos conservar el nombre tenemos que jugar con rename como opción de lectura o escritura del paso data. Estoy estudiando otra macro más avanzada para realizar este trabajo. El parámetro europeo=0 es el que nos indica si el número que transformamos tiene formato europeo o no. La macro necesita una variable auxiliar para realizar las transformaciones necesarias en el caso de ser un número en formato europeo. Una vez está el número en formato americano realizamos la transformación sobre la variable final con input, el formato que ponemos es best12.

Ejemplo de uso:

```r
data uno;
infile datalines dlm="@";
input dato1: 11. dato2:12.;
datalines ;
1.000,2@30000.2
3,3@3498.56
4,2@450.2334
5@5609.987
;run;

data uno;
set uno;
%texto_numero(varib_ini=dato1,varib_fin=dato_modif1,europeo=1 );
%texto_numero(varib_ini=dato2,varib_fin=dato_modif2);
run;
```
 

Espero que sea de utilidad. Saludos.