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
title: Importar a SAS desde otras aplicaciones.
url: /blog/importar-a-sas-desde-otras-aplicaciones/
---
Una de las labores más comunes con SAS consiste en leer e importar ficheros provenientes de otras aplicaciones. Es muy habitual trabajar con tablas de Excel, Access, Lotus, Business Object, Microstrategy, SQL Server, SAP… Para ello SAS dispone de algunos módulos que no se disponen en todas las instalaciones debido a que pueden encarecer mucho la instalación final. Por este motivo voy a introduciros en una metodología muy habitual en el trabajo diario: Importación de textos delimitados con SAS.

Para importar desde SAS ficheros de texto debemos tener en cuenta lo siguiente:

• Delimitación del fichero
• Cabeceras del fichero
• Configuración regional
• Lectura de fechas
• Saltos de línea desde Unix

Desde SAS podemos leer archivos delimitados de cualquier tipo, sin embargo recomiendo trabajar con ficheros delimitados por tabuladores. De este modo cuando deseemos leer de Excel, Access, Business Objects,… lo primero que haremos será guardar como o exportar como archivo de texto delimitado por tabuladores, algo que contemplan todas estas aplicaciones.

En cuanto a las cabeceras es mejor tratarlas previamente a la creación del fichero de texto. SAS no admite espacios, signos de puntuación, tildes,.. Por ello puede ser más óptimo modificar los nombres antes de exportar. Si no realizamos este ejercicio tendremos que importar los datos con un paso data y modificar todos los nombres de las variables, en ningún caso debemos emplear el proc import con cabeceras inapropiadas o si directamente no tiene.

La configuración regional nos planteará muchos problemas a la hora de importar y exportar con SAS. La configuración de SAS por defecto es la americana, además no se puede modificar. Nosotros en nuestras máquinas tendremos la configuración europea de este modo cuando exportemos a texto tendremos números en formato 2.345,67 o 345,67 imposibles de leer en SAS. Para solucionar este problema podemos modificar eventualmente la configuración regional o trabajar con los formatos de entrada en los pasos DATA.

La lectura de fechas será otro de los grandes problemas con los que nos encontraremos. Por defecto SAS lee fechas en formato MM/DD/AAAA y obtendremos errores cuando leamos fechas DD/MM/AAAA ya que SAS lee los primeros 10 registros y sobre ellos asigna formatos de entrada.

Los saltos de línea en Unix pueden provocar errores de lectura de ficheros de texto proveniente de Windows, en este artículo no veremos ejemplos, si es este vuestro problema contactad en rvaquerizo@analisisydecision.es

Conociendo las limitaciones de SAS a la hora de importar textos planteo la metodología para importar tablas desde otras aplicaciones a SAS. Los pasos a seguir son:

1\. Crear el fichero de texto delimitado, si es necesario.
2\. Realizar una primera importación desde SAS, preferiblemente SAS Base no Enterprise Guide y comprobar que problemas plantea la importación.
3\. Analizar, si fuera necesario, el tipo de problema (delimitación, cabeceras, configuración, fechas) que plantea la importación.
4\. Recuperación y modificación del código SAS interno de importación.
5\. Importación y creación de la tabla SAS.

Para aprender esta metodología vamos a realizar una tarea muy habitual: importar una tabla Excel a SAS. Partimos de una tabla de Excel que te puedes descargar [aquí](/images/2008/07/libro.xls "libro.xls").

Lo primero que nos encontramos son cabeceras con espacios y tildes. SAS dará problemas. Recordemos que podemos modificar las cabeceras antes de exportar la tabla a texto o bien podemos mantenerlas para posteriormente modificarlas con SAS. En este caso modificaremos con SAS. Así pues guardamos esta tabla como texto (delimitado por tabuladores) *.txt en la carpeta C:\temp y le damos el nombre libro.txt

Ahora comenzamos el trabajo con SAS. En nuestro ejemplo partimos de una arquitectura SAS sin Access to PC Files por ello hemos creado un fichero de texto a partir de una tabla Excel y ahora importamos desde SAS. Valdría cualquier otra aplicación, lo principal es crear un fichero de texto preferiblemente delimitado por tabuladores. Aunque dispongamos de Enterprise Guide la importación se ha de llevar a cabo desde SAS Base. Con los menús hacemos Archivo-> Importar datos->Stantdart data source seleccionamos en el combo Fichero delimitado por Tab. SAS nos pide la ubicación, en nuestro ejemplo C:\temp\libro.txt Vemos que se nos marca el botón Options Si pulsamos sobre él podremos indicar si deseamos cabeceras o no. Aceptamos, siguiente y nos solicita el nombre de la tabla SAS, yo recomiendo hacer pruebas previas. Asignamos un nombre y nos solicita guardar el código, no guardamos, pulsamos Finalizar.

Analizamos el log y obtenemos múltiples errores. Además los nombres de las variables son extraños y si abrimos el fichero la variable importe tiene un formato no deseado. Hemos de modificar la entrada de datos, para ello nos ubicamos en el editor de texto y pulsamos F4 que realiza un recall, una rellamada del último código ejecutado y obtenemos arriba del editor:

```r
data WORK.p1 ;

  %let _EFIERR_ = 0; /* set the ERROR detection macro variable */

  infile 'C:\Temp\Libro.txt' delimiter='09'x MISSOVER DSD lrecl=32767 firstobs=2 ;

  informat Fecha_de_modificaci_ mmddyy10. ;

  informat Identificador_de_modificaci_ best32. ;

  informat Importe comma32. ;

  format Fecha_de_modificaci_ mmddyy10. ;

  format Identificador_de_modificaci_ best12. ;

  format Importe comma12. ;

  input

  Fecha_de_modificaci_

  Identificador_de_modificaci_

  Importe

  ;

  if _ERROR_ then call symput('_EFIERR_',1); /* set ERROR detection macro variable */

  run;
```

Este es el código que SAS ejecuta internamente. Debemos modificarlo para llevar a cabo la correcta importación de la tabla. Pero antes requiere una pequeña explicación de la estructura de este paso DATA. Generamos el temporal P1 que es resultado del fichero de entrada C:\temp\libro.txt delimitado por tabuladores e indicamos que es un fichero con cabeceras con firstobs=2. Para este paso DATA tenemos la macrovariable de control de errores _EFIERR_. Pasamos a indicar los formatos de entrada con INFORMAT, posteriormente los formatos de salida con FORMAT y en INPUT indicamos que variables se leen. Este paso habrá de ser modificado para leer correctamente la tabla, los problemas que se nos han presentado son:

• Nombres de variables
• Fechas como mmddyy10
• Campos con notación europea lo transforma a notación americana sin mucho sentido

Corregimos el paso DATA para evitar estos problemas:

```r
data WORK.libro ;

  %let _EFIERR_ = 0; /* set the ERROR detection macro variable */

  infile 'C:\Temp\Libro.txt' delimiter='09'x MISSOVER DSD lrecl=32767 firstobs=2 ;
```

```r
*FORMATOS DE ENTRADA;

  informat F_modificacion ddmmyy10. ;

  informat Id_modificacion best32. ;

  informat Importe commax32.2 ;

 *FORMATOS DE SALIDA;

  format F_modificacion ddmmyy10. ;

  format Id_modificacion best32. ;

  format Importe commax32.2 ;

  input

  F_modificacion

  Id_modificacion

  Importe

  ;

  if _ERROR_ then call symput('_EFIERR_',1); /* set ERROR detection macro variable */

  run;
```

Se han modificado los nombres de las variables, ahora son más manejables. Se han adaptado los formatos de las variables fecha de modificación e importe. La fecha de modificación ahora es ddmmyy10., es decir, dd/mm/yyyy y el importe tiene formato comax para leer la notación europea. Con estos cambios ya es posible leer el archivo de texto.

Resumamos la metodología:

1\. Exportar la tabla de la aplicación que estemos manejando a un fichero de texto
2\. Emplear el asistente para realizar una importación de prueba, es necesario tener especial cuidado con la delimitación del fichero, recomiendo trabajar con tabuladores y ficheros *.txt
3\. Analizar los problemas surgidos de la importación
4\. Recuperar el código interno SAS de la importación pulsando F4 en el editor, siempre aparece en la parte superior
5\. Modificar el paso data que genera la importación: Nombres de variables y formatos de entrada

Los problemas derivados de las importaciones siempre son los mismos pero hay que tener especial cuidado con los derivados de los formatos de entrada. Para cualquier duda o sugerencia estoy a vuestra disposición en rvaquerizo@analisisydecision.es