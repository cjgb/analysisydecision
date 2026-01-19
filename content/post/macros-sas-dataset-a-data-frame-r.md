---
author: rvaquerizo
categories:
  - formación
  - r
  - sas
  - trucos
date: '2010-09-28'
lastmod: '2025-07-13'
related:
  - comunicar-sas-con-r-creando-ejecutables-windows.md
  - truco-sas-crear-ficheros-excel-sin-proc-export-i.md
  - macros-sas-informe-de-un-dataset-en-excel.md
  - truco-sas-crear-ficheros-excel-sin-proc-export-ii.md
  - truco-sas-sas-y-dde-aliados-de-excel.md
tags:
  - batch
  - data.frame
  - dataset
  - script
  - windows
title: Macros SAS. Dataset a data frame R
url: /blog/macros-sas-dataset-a-data-frame-r/
---

Voy a presentaros la versión Beta de la macro de SAS que genera data frames a partir de una tabla SAS en Windows, la versión en Linux me la ahorraré hasta el día que pueda instalar SAS en mi máquina virtual. La macro la iré mejorando y evolucionando, probablemente estas mejoras no las colgaré y no retome el hilo hasta que tenga una V1. El tema es sencillo y anteriormente [ya hice mención a este método](https://analisisydecision.es/comunicar-sas-con-r-creando-ejecutables-windows/) pero ahora doy una vuelta de tuerca y directamente creamos data frames a partir de data sets. Os pongo el total del código y comentaré los pasos más interesantes, por supuesto es mejorable. Lo que no puedo asegurar es si funciona bajo WPS porque no me han renovado la licencia. Todo el código seguido:

```r
%macro SASaR(datos,directorio,nombre);

*MODIFICAMOS EL NOMBRE Y EL DIRECTORIO PARA R;

%let nombre=&nombre..Rdata;

%let directorio=%sysfunc(tranwrd(&directorio.,\,/));

*EXPORTACION A CSV DEL DS;

PROC EXPORT DATA= &datos.

OUTFILE= "&directorio./elimina.csv"

DBMS=CSV REPLACE;

PUTNAMES=YES;

RUN;

*CREAMOS UN PROGRAMA EN R QUE LEE EL CSV

 GENERADO Y LUEGO LO GUARDA;

filename pgm "&directorio./pgm.R";

*ESTABLECEMOS EL DIRECTORIO, LEEMOS Y GUARDAMOS;

data _null_;

file pgm;

put "setwd('&directorio.')";

put "df <- read.csv('elimina.csv')";

put " ";

int="save(df,file='"||"&nombre."||"')";

put int;

run;

*CREAMOS UN EJECUTABLE DE WINDOWS QUE ABRE R

 Y EJECUTA LA LECTURA DEL DF;

filename open "&directorio./ejecucion.bat";

data _null_;

file open;

put '"C:/Archivos de programa/R/R-2.10.1/bin/R.exe"'@@;

put ' CMD BATCH --no-save "'@@;

put "&directorio/pgm.R"@@;

put '"';

call sleep (150);

run;

*EJECUTAMOS EL BAT DE WIN;

options noxwait xsync;

x "cd %quote(&directorio.)";

x "ejecucion.bat";

*ELIMINAMOS LOS ARCHIVOS TEMPORALES;

x "del elimina.csv";

x "del pgm.R";

x "del ejecucion.bat";

*VEMOS EL RESULTADO DE LA IMPORTACION;

proc fslist fileref="&directorio.\pgm.Rout"; quit;

%mend;

*EJEMPLO DE USO;

%sasaR(sashelp.shoes,C:\temp\pruebas proceso,df1);
```

Ahí tenéis la macro que genera el script de Win. Analizamos lo más interesante paso a paso:

```r
*MODIFICAMOS EL NOMBRE Y EL DIRECTORIO PARA R;

%let nombre=&nombre..Rdata;

%let directorio=%sysfunc(tranwrd(&directorio.,\,/));
```

Un pequeño cambio a los nombres para evitar problemas con R y los directorios con barras \\.

```r
*EXPORTACION A CSV DEL DS;

PROC EXPORT DATA= &datos.

OUTFILE= "&directorio./elimina.csv"

DBMS=CSV REPLACE;

PUTNAMES=YES;

RUN;
```

Exportamos el conjunto de datos SAS a CSV, un fichero temporal que posteriormente borraremos.

```r
*CREAMOS UN PROGRAMA EN R QUE LEE EL CSV

 GENERADO Y LUEGO LO GUARDA;

filename pgm "&directorio./pgm.R";

*ESTABLECEMOS EL DIRECTORIO, LEEMOS Y GUARDAMOS;

data _null_;

file pgm;

put "setwd('&directorio.')";

put "df <- read.csv('elimina.csv')";

put " ";

int="save(df,file='"||"&nombre."||"')";

put int;

run;
```

El programa R realiza un _read.csv_ del temporal y guarda un objeto de R con el nombre que especificamos.

```r
*CREAMOS UN EJECUTABLE DE WINDOWS QUE ABRE R

 Y EJECUTA LA LECTURA DEL DF;

filename open "&directorio./ejecucion.bat";

data _null_;

file open;

put '"C:/Archivos de programa/R/R-2.10.1/bin/R.exe"'@@;

put ' CMD BATCH --no-save "'@@;

put "&directorio/pgm.R"@@;

put '"';

call sleep (150);

run;
```

Creamos un _batch_ de R con la opción **–no-save** para que no guarde cambios, ya guardamos nosotros con _save_. En este punto cada uno tendrá instalado R en distintos directorios, tendréis que modificar a mano el código. Este _batch_ llama al código R del programa pgm.R

```r
*EJECUTAMOS EL BAT DE WIN;

options noxwait xsync;

x "cd %quote(&directorio.)";

x "ejecucion.bat";

*ELIMINAMOS LOS ARCHIVOS TEMPORALES;

x "del elimina.csv";

x "del pgm.R";

x "del ejecucion.bat";

*VEMOS EL RESULTADO DE LA IMPORTACION;

proc fslist fileref="&directorio.\pgm.Rout"; quit;
```

En este punto si hay algo interesante, para evitar problemas las opciones de S.O. que recomiendo son _noxwait_ y _xsync_ para que se ejecuten las sentencias X una a una y no de golpe. Por último vemos el fichero de resultados de R con el PROC FSLIST, así podremos analizar los resultados obtenidos.

Creo que desgranando la macro todo queda más sencillo de comprender. Ahora ya podréis aprovechar R con SAS o SAS con R, eso no me queda tan claro aun. Saludos.
