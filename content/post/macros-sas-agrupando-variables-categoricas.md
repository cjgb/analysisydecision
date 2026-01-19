---
author: rvaquerizo
categories:
  - formación
  - sas
  - trucos
date: '2010-06-14'
lastmod: '2025-07-13'
related:
  - las-cuentas-claras.md
  - truco-sas-categorizar-variables-continuas.md
  - trucos-sas-informes-de-valores-missing.md
  - trucos-sas-variables-dummy-de-una-variable-continua.md
  - macros-sas-tramificar-en-funcion-de-una-variable-respuesta.md
tags:
  - agrupar valores discretos
  - macros sas
  - proc freq
title: Macros SAS. Agrupando variables categóricas
url: /blog/macros-sas-agrupando-variables-categoricas/
---

Agrupar variables con SAS es una de las tareas más habituales. Las variables continuas las agrupamos según un criterio y las discretas, en principio, ya vienen agrupadas. El problema con las variables discretas es que pueden tomar muchos valores, muchos de ellos con poco valor que habitualmente agrupamos en un rango “OTROS”. Pues bien, hoy quería mostraros una macro muy sencilla que utilizo para crear ese cajón desastre. El código tiene algún aspecto muy interesante, es el que os pongo a continuación:

```r
%macro agrupa_frecuencias(entrada=,/*DS DE ENTRADA*/

vargrupo=,/*VARIABLE QUE AGRUPA*/

nombre=count,/*VARIABLE DE FRECUENCIAS*/

numgr=,/*NUMERO DE GRUPOS*/

resto=,/*CATEGORIA RESTO*/

salida=/*DS DE SALIDA*/);

*TABLA DE FRECUENCIAS CON TODOS LOS VALORES;

proc freq data=&entrada. noprint;

tables &vargrupo./list missing

out=&salida. (drop=percent rename=&vargrupo.=agr);

quit;

proc sort data=&salida. ; by descending count;

*EN FUNCION DEL TIPO DE VARIABLE CREAMOS EL RESTO;

data &salida. ;

set &salida. ;

&vargrupo.="&resto.";

if _n_<&numgr. then &vargrupo.=put(left(agr),$10.);

run;

*SUMARIZAMOS;

proc summary sum nway missing; class &vargrupo. ;

output out=&salida. (drop=_type_ _freq_) sum(count)=&nombre.;

quit;

%mend;
```

Breve explicación del mismo, es un código de ejecución muy rápida y no tiene una calidad de producción como casi todo lo que hacemos los que trabajamos sólo con BASE. Necesitamos más parámetros que código. Un DS de entrada, el nombre de la variable discreta que queremos agrupar, el nombre de la variable de conteo, el número de grupos total que deseamos, el nombre de la categoría resto aquí es importante destacar que la variable final siempre será alfanumérica, si deseáis que sea numérica es muy sencillo de modificar, el último parámetros es el DS de salida con la tabla de frecuencias.
La macro comienza con un PROC FREQ que genera una tabla con todos los valores de la variable y su conteo, ordenamos descendientemente por ese conteo y después hacemos un paso DATA que lee la tabla y si está por encima del número de categorías fijado lo etiquetamos con un resto. Al final tenemos que agregar los datos de esta tabla.
Como es habitual, ejemplo de uso:

```r
data uno;

letras="ABCDEFGHIJKLMNOPQRSTUVWXYZ"; drop letras;

do i=1 to 10000;

grupoM=ranpoi(3,16);

grupoK=char(letras,grupoM);

importe=ranuni(4)*10000;

output;

end;

run;

proc means data=uno;

class grupo1;

var importe;

quit;

proc means data=uno;

class grupo2;

var importe;

quit;
```

Dos variables de grupo con muchas categorías. Interesante el uso de la función CHAR. Deseamos crear una tabla de frecuencias que podamos manejar con facilidad:

```r
*VARIABLES NUMERICAS;

%agrupa_frecuencias(entrada=uno,vargrupo=grupoM,

nombre=clientes,numgr=15,resto=RESTO,salida=frec1);

*VARIABLES ALFANUMERICAS;

%agrupa_frecuencias(entrada=uno,vargrupo=grupoK,

nombre=clientes,numgr=8,resto=OTROS,salida=frec2);
```

Es un código muy sencillo sin mucha calidad y al que le podéis encontrar más de un problema, pero que podéis rehacer a vuestro antojo para mejorarlo. Yo lo uso bastante para la realización de tablas de autoría de datos.

Dani, Fernando, no he visto nada en FREQ, no vale usar el STAT, no lo tiene todo el mundo.

Saludos.
