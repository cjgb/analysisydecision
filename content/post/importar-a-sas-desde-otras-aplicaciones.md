---
author: rvaquerizo
categories:
  - formación
  - sas
date: '2008-07-28'
lastmod: '2025-07-13'
related:
  - curso-de-lenguaje-sas-con-wps-lectura-de-ficheros-de-texto.md
  - truco-sas-leer-datos-de-excel-con-sas-con-dde.md
  - ayudadme-importar-a-sas-texto-con-comillas.md
  - truco-sas-macro-buscar-y-reemplazar-en-texto.md
  - truco-sas-crear-ficheros-excel-sin-proc-export-i.md
tags:
  - access
  - excel
  - import
  - sas
  - texto
title: Importar a SAS desde otras aplicaciones
url: /blog/importar-a-sas-desde-otras-aplicaciones/
---

Una de las labores más comunes con SAS consiste en leer e importar ficheros provenientes de otras aplicaciones. Es muy habitual trabajar con tablas de `Excel`, `Access`, `Lotus`, `Business Objects`, `Microstrategy`, `SQL Server`, `SAP`… Para ello, SAS dispone de algunos módulos que no se encuentran en todas las instalaciones debido a su coste. Por este motivo, voy a introduciros en una metodología muy habitual en el trabajo diario: la importación de textos delimitados con SAS.

Para importar desde SAS ficheros de texto, debemos tener en cuenta lo siguiente:

- Delimitación del fichero.
- Cabeceras del fichero.
- Configuración regional.
- Lectura de fechas.
- Saltos de línea desde `UNIX`.

Desde SAS podemos leer archivos delimitados de cualquier tipo; sin embargo, recomiendo trabajar con ficheros delimitados por tabuladores. De este modo, cuando deseemos leer de `Excel`, `Access`, `Business Objects`…, lo primero que haremos será guardar como o exportar como archivo de texto delimitado por tabuladores, algo que contemplan casi todas estas aplicaciones.

En cuanto a las cabeceras, es mejor tratarlas previamente a la creación del fichero de texto. SAS no admite espacios, signos de puntuación, tildes… Por ello, puede ser más óptimo modificar los nombres antes de exportar. Si no realizamos este ejercicio, tendremos que importar los datos con un paso `DATA` y modificar todos los nombres de las variables; en ningún caso debemos emplear el `PROC IMPORT` con cabeceras inapropiadas o si directamente no tiene.

La configuración regional nos planteará muchos problemas a la hora de importar y exportar con SAS. La configuración de SAS por defecto es la americana y no siempre es fácil de modificar a nivel de sesión. Nosotros en nuestras máquinas tendremos la configuración europea; de este modo, cuando exportemos a texto, tendremos números en formato `2.345,67` o `345,67`, difíciles de leer en SAS sin los formatos adecuados. Para solucionar este problema, podemos trabajar con los formatos de entrada en los pasos `DATA`.

La lectura de fechas será otro de los grandes problemas. Por defecto, SAS puede intentar leer fechas en formato `MM/DD/AAAA` y obtendremos errores si los datos vienen como `DD/MM/AAAA`.

Conociendo las limitaciones de SAS a la hora de importar textos, planteo la metodología para importar tablas desde otras aplicaciones a SAS. Los pasos a seguir son:

1. Crear el fichero de texto delimitado, si es necesario.
2. Realizar una primera importación desde SAS, preferiblemente con el asistente de `SAS Base` (no `Enterprise Guide`), y comprobar qué problemas plantea la importación.
3. Analizar el tipo de problema (delimitación, cabeceras, configuración, fechas).
4. Recuperación y modificación del código SAS interno de importación.
5. Importación definitiva y creación de la tabla SAS.

Para aprender esta metodología, vamos a realizar una tarea muy habitual: importar una tabla `Excel` a SAS. Partimos de una tabla de `Excel` que te puedes descargar [aquí](/images/2008/07/libro.xls "libro.xls").

Lo primero que nos encontramos son cabeceras con espacios y tildes. SAS dará problemas. Recordemos que podemos modificar las cabeceras antes de exportar la tabla a texto o bien podemos mantenerlas para posteriormente modificarlas con SAS. En este caso, modificaremos con SAS. Así pues, guardamos esta tabla como texto (delimitado por tabuladores) `.txt` en la carpeta `C:\temp` y le damos el nombre `libro.txt`.

Ahora comenzamos el trabajo con SAS. En nuestro ejemplo, partimos de una arquitectura SAS sin `Access to PC Files`; por ello hemos creado un fichero de texto a partir de una tabla `Excel` y ahora importamos desde SAS. Valdría cualquier otra aplicación. Aunque dispongamos de `Enterprise Guide`, la importación inicial se puede llevar a cabo desde `SAS Base` para capturar el código. Con los menús hacemos **Archivo > Importar datos > Standard data source**, seleccionamos **Tab Delimited File**. SAS nos pide la ubicación (en nuestro ejemplo `C:\temp\libro.txt`). Vemos que se nos marca el botón **Options**; si pulsamos sobre él, podremos indicar si deseamos cabeceras o no. Aceptamos y asignamos un nombre a la tabla.

Analizamos el *log* y obtenemos errores. Hemos de modificar la entrada de datos; para ello nos ubicamos en el editor de texto y pulsamos `F4` (en `SAS Base`), que realiza un *recall* (rellamada) del último código ejecutado:

```sas
data WORK.p1;
    %let _EFIERR_ = 0; /* set the ERROR detection macro variable */
    infile 'C:\Temp\Libro.txt' delimiter='09'x MISSOVER DSD lrecl=32767 firstobs=2;
    
    informat Fecha_de_modificaci_ mmddyy10.;
    informat Identificador_de_modificaci_ best32.;
    informat Importe comma32.;
    
    format Fecha_de_modificaci_ mmddyy10.;
    format Identificador_de_modificaci_ best12.;
    format Importe comma12.;
    
    input
        Fecha_de_modificaci_
        Identificador_de_modificaci_
        Importe
    ;
    if _ERROR_ then call symput('_EFIERR_', 1);
run;
```

Éste es el código que SAS ejecuta internamente. Debemos modificarlo para llevar a cabo la correcta importación. Los problemas son: nombres de variables, fechas en formato erróneo y el importe con notación europea. Corregimos el paso `DATA`:

```sas
data WORK.libro;
    %let _EFIERR_ = 0;
    infile 'C:\Temp\Libro.txt' delimiter='09'x MISSOVER DSD lrecl=32767 firstobs=2;

    * FORMATOS DE ENTRADA;
    informat F_modificacion ddmmyy10.;
    informat Id_modificacion best32.;
    informat Importe commax32.2;

    * FORMATOS DE SALIDA;
    format F_modificacion ddmmyy10.;
    format Id_modificacion best32.;
    format Importe commax32.2;

    input
        F_modificacion
        Id_modificacion
        Importe
    ;
    if _ERROR_ then call symput('_EFIERR_', 1);
run;
```

Se han modificado los nombres de las variables y se han adaptado los formatos. La fecha ahora es `ddmmyy10.` y el importe tiene formato `COMMAX.` para leer la notación europea (coma decimal). Con estos cambios ya es posible leer el archivo correctamente.

Resumamos la metodología:
1. Exportar la tabla a un fichero de texto (.txt o .csv).
2. Emplear el asistente para realizar una importación de prueba.
3. Analizar los problemas surgidos.
4. Recuperar el código interno SAS pulsando `F4`.
5. Modificar el paso `DATA`: nombres de variables y formatos de entrada (`INFORMAT`).

Para cualquier duda o sugerencia, estoy a vuestra disposición en `rvaquerizo@analisisydecision.es`. Saludos.