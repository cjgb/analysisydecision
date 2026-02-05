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

Voy a presentaros la versión Beta de la macro de SAS que genera `data.frames` a partir de una tabla SAS en Windows; la versión en Linux me la ahorraré hasta el día que pueda instalar SAS en mi máquina virtual. La macro la iré mejorando y evolucionando; probablemente estas mejoras no las colgaré y no retomaré el hilo hasta que tenga una V1. El tema es sencillo y anteriormente [ya hice mención a este método](https://analisisydecision.es/comunicar-sas-con-r-creando-ejecutables-windows/), pero ahora doy una vuelta de tuerca y directamente creamos `data.frames` a partir de *datasets*. Os pongo el total del código y comentaré los pasos más interesantes; por supuesto, es mejorable. Lo que no puedo asegurar es si funciona bajo WPS porque no me han renovado la licencia. Todo el código seguido:

```sas
%macro SASaR(datos, directorio, nombre);

  * MODIFICAMOS EL NOMBRE Y EL DIRECTORIO PARA R;
  %let nombre_r = &nombre..Rdata;
  %let directorio_r = %sysfunc(tranwrd(&directorio., \, /));

  * EXPORTACION A CSV DEL DATASET;
  proc export data=&datos.
    outfile="&directorio_r./elimina.csv"
    dbms=csv replace;
    putnames=yes;
  run;

  * CREAMOS UN PROGRAMA EN R QUE LEE EL CSV GENERADO Y LUEGO LO GUARDA;
  filename pgm "&directorio_r./pgm.R";

  * ESTABLECEMOS EL DIRECTORIO, LEEMOS Y GUARDAMOS;
  data _null_;
    file pgm;
    put "setwd('&directorio_r.')";
    put "df <- read.csv('elimina.csv')";
    put "save(df, file='&nombre_r.')";
  run;

  * CREAMOS UN EJECUTABLE DE WINDOWS QUE ABRE R Y EJECUTA LA LECTURA DEL DATA FRAME;
  filename open "&directorio./ejecucion.bat";
  data _null_;
    file open;
    put '"C:/Program Files/R/R-x.x.x/bin/R.exe"' @@; * MODIFICAR RUTA SEGUN VERSION;
    put ' CMD BATCH --no-save "' @@;
    put "&directorio_r./pgm.R" @@;
    put '"';
  run;

  * EJECUTAMOS EL BAT DE WINDOWS;
  options noxwait xsync;
  x "cd %quote(&directorio.)";
  x "ejecucion.bat";

  * ELIMINAMOS LOS ARCHIVOS TEMPORALES;
  x "del elimina.csv";
  x "del pgm.R";
  x "del ejecucion.bat";

  * VEMOS EL RESULTADO DE LA IMPORTACION;
  proc fslist fileref="&directorio.\pgm.Rout"; 
  run;

%mend SASaR;

* EJEMPLO DE USO;
%SASaR(sashelp.shoes, C:\temp\pruebas_proceso, df1);
```

Ahí tenéis la macro que genera el script de Windows. Analizamos lo más interesante paso a paso:

**Modificación de nombres y directorios**:
```sas
%let nombre_r = &nombre..Rdata;
%let directorio_r = %sysfunc(tranwrd(&directorio., \, /));
```
Un pequeño cambio a los nombres para evitar problemas con R y los directorios con barras invertidas (`\`).

**Exportación a CSV**:
Exportamos el conjunto de datos SAS a CSV, un fichero temporal que posteriormente borraremos.

**Programa en R**:
El programa R realiza un `read.csv` del temporal y guarda un objeto de R con el nombre que especificamos.

**Llamada a R en modo *batch***:
Creamos un archivo `.bat` que ejecuta R con la opción `--no-save` para que no guarde cambios globales (ya guardamos nosotros con `save()`). En este punto, cada uno tendrá instalado R en distintos directorios; tendréis que modificar a mano la ruta al ejecutable `R.exe`.

**Ejecución y limpieza**:
Para evitar problemas, las opciones de sistema operativo que recomiendo son `noxwait` y `xsync`, para que se ejecuten las sentencias `X` una a una y no de golpe. Por último, vemos el fichero de resultados de R (`.Rout`) con el `PROC FSLIST`; así podremos analizar los resultados obtenidos.

Creo que desgranando la macro todo queda más sencillo de comprender. Ahora ya podréis aprovechar R con SAS o SAS con R; eso no me queda tan claro aún. Saludos.