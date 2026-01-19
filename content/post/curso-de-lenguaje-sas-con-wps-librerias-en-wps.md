---
author: rvaquerizo
categories:
- formación
- monográficos
- sas
- wps
date: '2011-03-04'
lastmod: '2025-07-13'
related:
- curso-de-lenguaje-sas-con-wps-lenguaje-sas.md
- curso-de-lenguaje-sas-con-wps-ejecuciones.md
- curso-de-lenguaje-sas-con-wps-el-paso-data.md
- truco-sas-tablas-de-una-libreria-en-una-macro-variable.md
- sigo-migrando-de-sas-a-wps.md
tags:
- engine
- libname
title: Curso de lenguaje SAS con WPS. Librerías en WPS
url: /blog/curso-de-lenguaje-sas-con-wps-librerias-en-wps/
---
Sobre el trabajo con librerías en SAS se pueden escribir libros. Todas las personas que han aprendido SAS conmigo a lo largo de los años han oído el mismo duscurso. «Hay que tener mucho cuidado con las librerías en SAS. Tenemos que tener muy claro que tablas son temporales, cuales han de ser permanentes. El problema del trabajo con SAS reside en el espacio en disco». Ya son decenas las personas que ahora hacen lo que pueden con SAS que han escuchado estas palabras y que siguen llenando discos y más discos incluso de los servidores con SAS más potentes de España.

En WPS también tenemos que tener cuidado con las tablas que han de ser temporales o permanentes. Nuestra librería temporal será WORK, donde se guardan por defecto, además disponemos de la librería de usuario SASUSER y la librería de sistema SASHELP. Una librería es una o varias ubicaciones físicas de un disco donde almacenamos elementos de WPS, fundamentalmente tablas. La librería temporal WORK se pierde cuando cerramos nuestra sesión de WPS y se almacena en un directorio del tipo **User\WPS Temporary Data\\_TD3452** que se eliminará cuando cerremos WPS perdiendo todas las tablas almacenadas en él. Para crear librerías en WPS emplearemos la sentencia **libname** <nombre de librería> ‘<ubicación física de la librería>’;.

En SAS las librerías crean siempre conjuntos de datos SAS con extensión SAS7BDAT. Sin embargo en WPS tenemos la posibilidad de leer, modificar y crear tanto tablas SAS con extensión SAS7BDAT como tablas WPS con extensión WPD. Si disponemos de los módulos de acceso apropiados también podemos trabajar con Oracle, Posgres, Greenplum,… pero ese tema lo veremos más adelante. Por ello cuando empleemos **libname** con WPS tendremos:

**LIBNAME** <_NOMBRE_ > <_ENGINE_ > ‘<_UBICACIÓN FÍSICA DE LA LIBRERÍA_ >’;

(Me podéis corregir) El _engine_ es el motor de la librería. Puede ser SAS7BDAT, WPS (por defecto) o algún motor de BBDD. Veamos el típico ejemplo:

```r
libname lib1 sas7bdat "C:\temp\lib1";

libname lib2 "C:\temp\lib2";

************************************;

data lib1.datos;

infile datalines dlm=',';

input nombre: 30. edad rango:30.;

datalines;

Jose Alberto, 34, Cabo Primero,

Esteban, 25, Sarjento,

Vicente, 56, Sarjento Primero,

Laura, 45, Capitán,

;run;

************************************;

data lib2.datos;

infile datalines dlm=',';

input nombre: 30. edad rango:30.;

datalines;

Jose Alberto, 34, Cabo Primero,

Esteban, 25, Sarjento,

Vicente, 56, Sarjento Primero,

Laura, 45, Capitán,

;run;
```

**LIB1** nos permitirá leer y crear conjuntos de datos SAS (engine SAS7BDAT) y **LIB2** conjuntos de datos WPD. Como vemos en el ejemplo para crear conjuntos de datos hacemos <_librería_ >.<_conjunto de datos SAS_ > si no ponemos nada el conjunto de datos se creará en la librería WORK por defecto. Todo este planteamiento es muy importante para migrar nuestros procesos SAS a WPS. La idea sería depender cada día menos de SAS para trabajar 100% con WPS, pero necesitamos leer _datasets_ creados con SAS.

En el caso de querer trabajar con más de una ubicación fisica o más de una librería aunque sea un engine distinto podemos concatenar librerías SAS del modo: libname <librería> (<librería 1> <librería 2> <librería n>); En el ejemplo:

`libname lib3 (lib1 lib2);`

Con estas pautas ya podemos trabajar con librerías en WPS y facilitar la migración de procesos de SAS. Hasta el momento practicamente todo lo que hacemos con SAS lo podemos hacer con WPS y en esta entrega hemos visto como poder leer conjuntos de datos SAS, que son conjuntos de datos propietarios y que necesitaban de SAS para ser leidos.