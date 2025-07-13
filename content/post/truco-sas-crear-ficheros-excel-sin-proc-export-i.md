---
author: rvaquerizo
categories:
- SAS
- Trucos
date: '2008-04-02T08:29:11-05:00'
slug: truco-sas-crear-ficheros-excel-sin-proc-export-i
tags: []
title: Truco SAS. Crear ficheros Excel sin PROC EXPORT (I)
url: /truco-sas-crear-ficheros-excel-sin-proc-export-i/
---

No disponemos del módulo **ACCESS TO PC FILES** y necesitamos poner nuestra tabla SAS en Excel. Usaremos el **ODS** (Outpus Delivery System) de SAS. Junto con el _proc print_ crearemos un fichero HTML con extensión .XLS que podremos manejar perfectamente con Excel, insisto, no es un fichero Excel, es HTML pero que se manejará sin ningún problema en la hoja de cálculo y que podremos guardar como fichero Excel.

El primer paso para nuestro ejemplo será generar una tabla SAS con valores aleatorios que deseamos exportar a Excel:

```r
data uno;
do i=1 to 100;
j=ranpoi(23,3);
k=ranpoi(123,3);
l=ranpoi(2,3);
m=ranpoi(3,3);
n=l/j;
uno="hola";
y=ranuni(89)*100;
output;
end;
run;
```
 

Generamos un dataset aleatorio de 100 observaciones y 8 variables y si observamos el LOG:  

```r
NOTA: Division por cero en línea 34 columna 12.

NOTA: Division por cero en línea 34 columna 12.

NOTA: Division por cero en línea 34 columna 12.

NOTA: Division por cero en línea 34 columna 12.

NOTA: Division por cero en línea 34 columna 12.

NOTA: Division por cero en línea 34 columna 12.

NOTA: Division por cero en línea 34 columna 12.

i=101 j=5 k=4 l=2 m=9 n=0.4 uno=hola y=27.716842726 _ERROR_=1 _N_=1

NOTA: Operaciones matemáticas no realizadas en los siguientes lugares. Los resultados de las

operaciones aparecen como valores ausentes.

Cada lugar se introduce por: (Número de veces) en (Línea):(Columna).

7 en 34:12

NOTA: El conj. datos WORK.UNO tiene 100 observaciones y 8 variables.

NOTA: Sentencia DATA utilizado (Tiempo de proceso total):

tiempo real 0.01 segundos

tiempo de cpu 0.01 segundos
```

SAS nos advierte que hay divisiones con 0 y no se pueden realizar por lo que nuestra variable _n_ tendrá valores missing. Pues bien, el objetivo es exportar esta tabla SAS a una tabla de Excel sin disponer del módulo ACCESS TO PC FILES. Podremos exportarlo en csv y abrirlo con Excel:

```r
PROC EXPORT DATA= WORK.Uno
OUTFILE= "C:\Temp\borra.csv"
DBMS=CSV REPLACE;
RUN;
```
 

Con el proc export podemos exportar nuestra tabla SAS a un fichero separado por comas pero necesitamos importar el texto desde Excel y el manejo sería más lento. Del mismo modo sucedería si generamos un fichero de texto separado por tabuladores. Utilizando el ODS vamos a exportar nuestra tabla SAS al directorio C:\temp\ de forma que podamos abrirlo perfectamente con Excel:

```r
title; /*ELIMINAMOS EL TITULO*/
filename _temp_ "C:\temp\borra.xls"; /*ASIGNAMOS FILENAME TEMPORAL*/
ods noresults; /*NO QUEREMOS OUTPUT*/
ods listing close; /*CERRAMOS LISTING*/
ods html file=_temp_ rs=none style=minimal; /*SELECCIONAMOS HTML Y ASIGNAMOS UN ESTILO, ESTO SE PUEDE MODIFICAR*/
proc print data=uno noobs; /*SIMPLEMENTE REALIZAMOS UN PROC PRINT*/
run;
ods html close; /*REESTABLECEMOS LAS OPCIONES DEL ODS*/
ods results;
ods listing;
```
 

En la ubicación deseada disponemos de un fichero con extensión .XLS que podemos abrir y modificar sin ningún problema con Excel. Pero si lo abrimos tenemos algunas limitaciones:

i | j | k | l | m | n | uno | y | 1 | 2 | 2 | 1 | 6 | 0.50000 | hola | 19.6859  
---|---|---|---|---|---|---|---  
2 | 2 | 3 | 2 | 1 | 1.00000 | hola | 53.1031  
3 | 5 | 0 | 3 | 3 | 0.60000 | hola | 1.1549  
4 | 5 | 2 | 5 | 3 | 1.00000 | hola | 20.9673  
5 | 5 | 3 | 5 | 3 | 1.00000 | hola | 94.3154  
6 | 3 | 3 | 3 | 2 | 1.00000 | hola | 67.1307  
7 | 4 | 4 | 2 | 2 | 0.50000 | hola | 56.2188  
8 | 5 | 8 | 5 | 3 | 1.00000 | hola | 86.6032  
9 | 5 | 0 | 5 | 3 | 1.00000 | hola | 71.0829  
10 | 1 | 1 | 1 | 4 | 1.00000 | hola | 96.3705  
11 | 1 | 2 | 2 | 5 | 2.00000 | hola | 43.0195  
12 | 3 | 2 | 7 | 1 | 2.33333 | hola | 13.5442  
13 | 0 | 5 | 3 | 2 | . | hola | 55.2486  
  
Si nuestra conficuración regional es europea la parte decimal de nuestros valores numéricos estarán separados por un . en vez de por , además los valores missing SAS los marca como . cuando deberían estar vacíos. Hemos de modificar más opciones para generar nuestra tabla Excel:

```r
option missing=""; /*LOS VALORES PERDIDOS NO SE MARCAN*/
title; /*ELIMINAMOS EL TITULO*/
filename _temp_ "C:\temp\borra.xls"; /*ASIGNAMOS FILENAME TEMPORAL*/
ods noresults; /*NO QUEREMOS OUTPUT*/
ods listing close; /*CERRAMOS LISTING*/
ods html file=_temp_ rs=none style=minimal; /*SELECCIONAMOS HTML Y ASIGNAMOS UN ESTILO, ESTO SE PUEDE MODIFICAR*/
proc print data=uno noobs; /*SIMPLEMENTE REALIZAMOS UN PROC PRINT*/
format n y commax16.1;
run;
ods html close; /*REESTABLECEMOS LAS OPCIONES DEL ODS*/
ods results;
ods listing;
option missing=".";
```
 

El resultado ha mejorado mucho:

i | j | k | l | m | n | uno | y | 1 | 2 | 2 | 1 | 6 | 0,5 | hola | 19,7  
---|---|---|---|---|---|---|---  
2 | 2 | 3 | 2 | 1 | 1,0 | hola | 53,1  
3 | 5 | 0 | 3 | 3 | 0,6 | hola | 1,2  
4 | 5 | 2 | 5 | 3 | 1,0 | hola | 21,0  
5 | 5 | 3 | 5 | 3 | 1,0 | hola | 94,3  
6 | 3 | 3 | 3 | 2 | 1,0 | hola | 67,1  
7 | 4 | 4 | 2 | 2 | 0,5 | hola | 56,2  
8 | 5 | 8 | 5 | 3 | 1,0 | hola | 86,6  
9 | 5 | 0 | 5 | 3 | 1,0 | hola | 71,1  
10 | 1 | 1 | 1 | 4 | 1,0 | hola | 96,4  
11 | 1 | 2 | 2 | 5 | 2,0 | hola | 43,0  
12 | 3 | 2 | 7 | 1 | 2,3 | hola | 13,5  
13 | 0 | 5 | 3 | 2 |  | hola | 55,2  
  
El código SAS se presenta muy complejo. No compensa crearlo, pero si hacemos nuestra propia función para exportar ficheros a Excel entonces no sería necesario emplear todo el código que os he mostrado anteriormente. Pero esto lo veremos en sucesivas entregas de trucos. Quedaros bien con el uso del ODS que nos va a permitir crear hojas de cálculo con rapidez.

Por supuesto si tenéis cualquier duda o sugerencia podéis contactar conmigo en [rvaquerizo@analisisydecision.es](mailto:rvaquerizo@analisisydecision.es)