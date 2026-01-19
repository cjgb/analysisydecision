---
author: rvaquerizo
categories:
- formación
- sas
- trucos
- wps
date: '2011-07-15'
lastmod: '2025-07-13'
related:
- truco-sas-uso-de-filename-y-pipe.md
- truco-sas-dataset-con-los-ficheros-y-carpetas-de-un-directorio.md
- curso-de-lenguaje-sas-con-wps-lectura-de-ficheros-de-texto.md
- trucos-sas-macrovariable-a-dataset.md
- importar-a-sas-desde-otras-aplicaciones.md
tags:
- infile
- input
- pipe
- scan
title: Trucos SAS. Más usos de INFILE y PIPE directorios en tablas SAS
url: /blog/trucos-sas-mas-usos-de-infile-y-pipe-directorios-en-tablas-sas/
---
Puede interesarnos tener **directorios y subdirectorios en tablas SAS**. Es decir, tabular el resultado de un _lm_ en Unix o poner en una tabla el resultado de un _dir_ de MS DOS / Windows. Ya tengo ejemplos publicados a este respecto:

  * <https://analisisydecision.es/truco-sas-uso-de-filename-y-pipe/>
  * <https://analisisydecision.es/macros-sas-asignar-permisos-en-unix/>

Pero no está mal volver a poner un truco para analizar las posibilidades del **INFILE + PIPE**. Vamos a hacer un DIR de todo nuestro C:\ y sacar los archivos de mayor tamaño.

```r
*ESTA ES LA INSTRUCCION DIR QUE EMPLEAMOS,

SUBDIRECTORIOS, AUTORES, ... (?dir);

filename df pipe "dir H:\ /S /O S /Q";

*CREAMOS UNA TABLA SAS CON EL RESULTADO DE

LA INSTRUCCIÓN MS DOS;

data ZZZ_ZZZ;

infile df pad;

input todo $300.;

if _n_=1 then delete;

run;
```

Tenemos una tabla SAS con el resultado de nuestro dir en una variable de texto todo de 300 bytes . Podemos extraer la información que deseamos trabajando con funciones de texto de SAS:

```r
data archivos;

keep fecha archivo GIGAS autor;

set zzz_zzz;

format fecha ddmmyy10.;

fecha=input(substr(todo,1,10),ddmmyy10.);

GIGAS=compress(scan(todo,3," "),".")*1;

GIGAS=GIGAS/(1024**3);

autor=scan(todo,4," ");

archivo=substr(todo,60,100);

if fecha=. then delete;

if GIGAS=. then delete;

run;
```

La variable fecha tiene el formato _ddmmyy10_. y es el resultado de transformar parte de nuestra variable de texto todo a número y con _input_ darle el formato de entrada adecuado, perfecto ejemplo de transformación de texto a fecha con SAS. El tamaño es la 3 parte de la cadena de texto que se obtiene con un _dir_ , pero como lo tenemos en bytes lo transformamos a gigas. Para extraer parte de una cadena de texto con SAS empleamos la función _SCAN_ , otro buen ejemplo es el autor que lo podemos encontrar en la cuarta posición. Recordamos: _SCAN(todo,4,” “)_ -> busca en todo la cadena de texto que esté en cuarta posición cuando el delimitador es “ “ un espacio en blanco. Por último tenemos el nombre del archivo que es la última parte de la cadena todo que genera el dir de MS-DOS.
Buen ejemplo para recordar un par de temas que provocan un gran número de visitas a esta web. Ahora os dejo deberes, tenéis que obtener el directorio en el que se aloja el fichero. No es baladí el tema. A ver si sois capaces, yo lo tengo hecho pero es muy complejo y “poco elegante”. Espero que a alguno de vosotros se os ocurra un mejor método.