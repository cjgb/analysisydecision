---
author: rvaquerizo
categories:
  - sas
  - trucos
date: '2008-04-02'
lastmod: '2025-07-13'
related:
  - truco-sas-crear-ficheros-excel-sin-proc-export-ii.md
  - el-ods-de-sas-ii-dataset-desde-output.md
  - el-ods-de-sas-i-elementos-del-output.md
  - el-ods-de-sas-iii-documentos-html-y-pdf-desde-sas.md
  - importar-a-sas-desde-otras-aplicaciones.md
tags:
  - sas
  - trucos
title: Truco SAS. Crear ficheros Excel sin PROC EXPORT (I)
url: /blog/truco-sas-crear-ficheros-excel-sin-proc-export-i/
---

No disponemos del módulo `ACCESS TO PC FILES` y necesitamos poner nuestra tabla SAS en `Excel`. Usaremos el `ODS` (*Output Delivery System*) de SAS. Junto con el `PROC PRINT`, crearemos un fichero `HTML` con extensión `.XLS` que podremos manejar perfectamente con `Excel`; insisto, no es un fichero `Excel`, es `HTML`, pero se manejará sin ningún problema en la hoja de cálculo y podremos guardarlo como fichero `Excel`.

El primer paso para nuestro ejemplo será generar una tabla SAS con valores aleatorios que deseamos exportar a `Excel`:

```sas
data uno;
    do i = 1 to 100;
        j = ranpoi(23, 3);
        k = ranpoi(123, 3);
        l = ranpoi(2, 3);
        m = ranpoi(3, 3);
        n = l / j;
        uno = "hola";
        y = ranuni(89) * 100;
        output;
    end;
run;
```

Generamos un *dataset* aleatorio de 100 observaciones y 8 variables; si observamos el LOG:

```text
NOTA: División por cero en línea 34 columna 12.
...
i=101 j=5 k=4 l=2 m=9 n=0.4 uno=hola y=27.716842726 _ERROR_=1 _N_=1
NOTA: Operaciones matemáticas no realizadas en los siguientes lugares. 
7 en 34:12
NOTA: El conj. datos WORK.UNO tiene 100 observaciones y 8 variables.
```

SAS nos advierte que hay divisiones por cero y no se pueden realizar, por lo que nuestra variable `n` tendrá valores *missing*. Pues bien, el objetivo es exportar esta tabla SAS a una tabla de `Excel` sin disponer del módulo `ACCESS TO PC FILES`. Podríamos exportarlo en `.csv` y abrirlo con `Excel`:

```sas
proc export data=work.uno
    outfile="C:\temp\borra.csv"
    dbms=csv replace;
run;
```

Con el `PROC EXPORT` podemos exportar nuestra tabla SAS a un fichero separado por comas, pero necesitamos importar el texto desde `Excel` y el manejo sería más lento. Del mismo modo sucedería si generamos un fichero de texto separado por tabuladores. Utilizando el `ODS`, vamos a exportar nuestra tabla SAS al directorio `C:\temp\` de forma que podamos abrirlo perfectamente con `Excel`:

```sas
title; /* ELIMINAMOS EL TITULO */
filename _temp_ "C:\temp\borra.xls"; /* ASIGNAMOS FILENAME TEMPORAL */
ods noresults; /* NO QUEREMOS OUTPUT */
ods listing close; /* CERRAMOS LISTING */
ods html file=_temp_ rs=none style=minimal; /* SELECCIONAMOS HTML Y ASIGNAMOS UN ESTILO */
proc print data=uno noobs;
run;
ods html close; /* REESTABLE CEMOS LAS OPCIONES DEL ODS */
ods results;
ods listing;
```

En la ubicación deseada disponemos de un fichero con extensión `.XLS` que podemos abrir y modificar sin ningún problema con `Excel`. Pero si lo abrimos, tenemos algunas limitaciones: la parte decimal de nuestros valores numéricos estará separada por un punto en vez de por una coma (si nuestra configuración regional es europea); además, los valores *missing* SAS los marca como un punto cuando deberían estar vacíos. Hemos de modificar más opciones para generar nuestra tabla `Excel`:

```sas
options missing=""; /* LOS VALORES PERDIDOS NO SE MARCAN */
title;
filename _temp_ "C:\temp\borra.xls";
ods html file=_temp_ rs=none style=minimal;
proc print data=uno noobs;
    format n y commax16.1; /* DAMOS FORMATO EUROPEO */
run;
ods html close;
options missing=".";
```

El resultado ha mejorado mucho. El código SAS se presenta algo complejo si se hace manualmente cada vez. No compensa crearlo repetidamente, pero si hacemos nuestra propia función para exportar ficheros a `Excel`, entonces no sería necesario emplear todo el código mostrado anteriormente. Pero esto lo veremos en sucesivas entregas de trucos. Quedaros bien con el uso del `ODS`, que nos va a permitir crear hojas de cálculo con rapidez.

Por supuesto, si tenéis cualquier duda o sugerencia podéis contactar conmigo en `rvaquerizo@analisisydecision.es`. Saludos.