---
author: rvaquerizo
categories:
  - formación
  - sas
  - trucos
date: '2009-02-05'
lastmod: '2025-07-13'
related:
  - macro-sas-variables-de-un-dataset-en-una-macro-variable.md
  - trucos-sas-union-de-multiples-tablas-sas-con-un-nombre-parecido.md
  - trucos-sas-eliminar-etiquetas-en-los-conjunto-de-datos-sas.md
  - trucos-sas-macrovariable-a-dataset.md
  - truco-sas-tablas-de-una-libreria-en-una-macro-variable.md
tags:
  - formación
  - sas
  - trucos
title: Trucos SAS. Lista de datasets en macro variable
url: /blog/trucos-sas-lista-de-datasets-en-macro-variable/
---

Un uso frecuente del proc sql es la generación de macro variables. En este ejemplo vamos a crear una macro variable con el nombre de los dataset de una librería SAS que empiecen por un determinado sufijo. También es un ejemplo bastante práctico del uso de las vistas de SASHELP. Creo que es un ejemplo bastante sencillo y sobre él iremos generando nuevos trucos que espero puedan serviros. Para entender mejor el truco vamos a generar 20 ficheros “ficticios” con variables aleatorias en el directorio c:\\temp de nuestro PC:

```r
*GENERAMOS 2 DATASETS ALEATORIOS;

%macro tablas_aleatorias;

%do i=1 %to 20;

data temp.aleat&i.;

do i=1 to 100;

persona=ranpoi(8,23);

importe1=int(rand("uniform")*1000);

importe2=int(rand("uniform")*1000);

tae=ranpoi(34,2)+round(rand("uniform"),.1);

output;

end;

drop i;

run;

%end;

%mend;
```

```r

```

`%tablas_aleatorias;`

Esta macro hace un bucle y genera 20 datasets aleatorios. A continuación necesitamos crear un dataset que sea la concatenación de los 20 generados anteriormente. Podríamos poner los 20:

```r
data aleat;

set temp.aleatorio1 temp.aleatorio2 temp.aleatorio3 temp.aleatorio4

temp.aleatorio5 temp.aleatorio6 temp.aleatorio7 temp.aleatorio8

temp.aleatorio9 temp.aleatorio10 temp.aleatorio11 temp.aleatorio12

temp.aleatorio13 temp.aleatorio14 temp.aleatorio15 temp.aleatorio16

temp.aleatorio17 temp.aleatorio18 temp.aleatorio19 temp.aleatorio20 ;

run;
```

Pero esto no es elegante porque somos profesionales que aprendemos trucos de SAS con Raúl. Para automatizar esto debemos hacer lo siguiente:

```r
*SELECCIONAMOS LOS DATASET QUE EMPIECEN POR ALEAT;

proc sql noprint ;

select compress(libname||"."||memname)

into: lista_tablas separated by " "

from sashelp.vtable

where memname like '%ALEAT%' and libname = "TEMP";

quit;
```

```r
*PODEMOS HACER UNA TABLA QUE SEA UNION DE TODOS LOS DATASET;

data aleat;

set &lista_tablas.;

run;
```

\`\`

La macro variable lista_tablas contiene todos los dataset de la librería temp que empiezan por el sufijo aleatorio. Evidentemente podemos modificar el sufijo e incluso la libería. Incluso podemos crear una macro a medida:

```r
%macro seleccion(sufijo,libreria);

proc sql noprint ;

select compress(libname||"."||memname)

into: lista_tablas separated by " "

from sashelp.vtable

where index(memname,upcase("&sufijo."))>0 and libname = upcase("&libreria.");

quit;

%mend;
```

```r

```

```r
%seleccion(aleat,temp);
```

Para la macro empleamos index en vez de like, si alguien intenta hacerlo con like entenderá este cambio de funciones.

Por supuesto, si alguien tiene dudas, sugerencias… rvaquerizo@analisisydecision.es
