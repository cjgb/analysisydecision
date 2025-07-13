---
author: rvaquerizo
categories:
- Formación
- SAS
- Trucos
date: '2009-05-11T11:01:29-05:00'
lastmod: '2025-07-13T16:10:17.454549'
related:
- numeros-aleatorios-con-sas.md
- trucos-sas-muestreo-con-proc-surveyselect.md
- trucos-sas-variables-dummy-de-una-variable-continua.md
- trucos-sas-lista-de-datasets-en-macro-variable.md
- trucos-sas-informes-de-valores-missing.md
slug: trucos-sas-muestras-aleatorias-con-y-sin-reemplazamiento
tags:
- aleatorios
- rand
- ranuni
- while
title: Trucos SAS. Muestras aleatorias con y sin reemplazamiento
url: /trucos-sas-muestras-aleatorias-con-y-sin-reemplazamiento/
---

Un ejemplo típico de SAS pero que creo que puede ayudar a conocer algunas funciones de SAS. Los ejemplos que planteo a continuación crean un dataset con 10.000 observaciones y sobre él vamos a crear dos subconjuntos de datos, dos muestras aleatorias del dataset de partida, una muestra sin reemplazamiento y otra muestra con reemplazamiento. Son dos ejemplos muy sencillos. Como siempre creo un dataset de forma aleatoria que me sirve de base para plantearos el truco:

```r
data ejemplo;

 do id=1 to 10000;

 importe=ranuni(8)*1000;

 output;

 end;

run;
```

El dataset de partida tiene 10.000 observaciones y dos variables una de ellas creada con la función _ranuni_ que genera aleatorios de uniforme (0,1) con una raiz. Ahora vamos a realizar una muestra aleatoria de este conjunto de datos SAS de tamaño 300 sin reemplazamiento:

``
```r
*MUESTRA ALEATORIA SIN REEMPLAZAMIENTO;

%let tamanio=300;
```

data aleat1;  
set ejemplo;  
aleat=rand("uniform");  
run;

proc sort data=aleat1; by aleat; run;

data aleat1;  
set aleat1;  
if _n_>&tamanio. then stop;  
drop aleat;  
run;

Creamos una variable aleatoria con la función _rand_ que no necesita raiz para generar números aleatorios en este caso uniform (0,1), ordenamos por ella y seleccionamos una muestra que nos define la macrovariable _tamanio_. Ahora la muestra aleatoria será con reemplazamiento:

```r
%let tamanio=300;
```

```r
data aleat2;

 set ejemplo;

 select=_n_;

run;
```

*NUMERO DE OBSERVACIONES DEL DATASET DE PARTIDA  
LONGITUD DEL NUMERO;  
proc sql noprint;  
select compress(put(count(*),best32.)) into:num_obs  
from ejemplo;  
quit;

data select;  
retain para;  
select=0;  
para=0;  
do while (para<&tamanio.);  
select=ceil(rand("uniform")*10**length(compress("&num_obs"))-1);  
if 1<=select<=&num_obs. then do;  
para=para+1;  
output;  
end;  
end;  
drop para;  
run;

proc sort data=select; by select; run;

data aleat2;  
merge aleat2 select (in=a);  
by select;  
if a;  
drop select;  
run;

Vemos que la metodología es distinta. En este caso creamos una tabla con 300 registros que contiene 300 números aleatorios entre 1 y el número de observaciones del dataset de partida que calculamos mediante un _proc sql_. Puede resultar interesante como se emplea la función _length_ para identificar las cifras de un número. Como este número aleatorio puede repetirse obtenemos el reemplazamiento deseado posteriormente hacemos el cruce con _merge_ y ya tenemos nuestra muestra aleatoria. El ejemplo es sencillo pero a los menos expertos puede ayudarles a conocer los bucles con _while_

Sé de más de uno al que le será muy útil este truco. Por supuesto, si tenéis dudas, sugerencias o un trabajo bien retribuido… rvaquerizo@analisisydecision.es