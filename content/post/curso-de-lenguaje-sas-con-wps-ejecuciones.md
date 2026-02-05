---
author: rvaquerizo
categories:
  - consultoría
  - formación
date: '2010-06-09'
lastmod: '2025-07-13'
related:
  - curso-de-lenguaje-sas-con-wps-el-paso-data.md
  - curso-de-lenguaje-sas-con-wps-que-hace-el-paso-data.md
  - curso-de-lenguaje-sas-con-wps-subconjuntos-de-variables-con-drop-y-keep.md
  - curso-de-lenguaje-sas-con-wps-lectura-de-ficheros-de-texto.md
  - curso-de-lenguaje-sas-con-wps-librerias-en-wps.md
tags:
  - consultoría
  - formación
title: Curso de lenguaje SAS con WPS. Ejecuciones
url: /blog/curso-de-lenguaje-sas-con-wps-ejecuciones/
---

Hasta la fecha nos hemos aproximado a la interfaz de `WPS` y hemos ejecutado algunos *scripts* para trabajar con conjuntos de datos SAS y, sobre todo, entender qué hace el paso `DATA`. También hemos analizado qué son y cómo trabajan las librerías `WPS`. 

En nuevas entregas nos seguiremos centrando en el trabajo con *datasets* temporales y permanentes. La intención es conocer bien qué hace `DATA` y establecer una metodología de trabajo con `WPS`. SAS es un lenguaje orientado a la gestión de datos, y las personas acostumbradas a programar en otros lenguajes pueden tener muchos problemas conceptuales. Al final, con este manual intentaremos ayudar a todos aquellos que trabajáis con SAS a crear un método que permita que vuestros procesos funcionen de la forma más óptima para ganar tiempo y espacio en disco, los dos elementos más importantes cuando manejamos grandes volúmenes de datos.

Lo más habitual en SAS es la lectura de otros conjuntos de datos para crear subconjuntos de registros o de variables, o crear y modificar variables. La sintaxis habitual para seleccionar *datasets* es:

```sas
data prueba;
    input var1 var2 var3;
    cards;
100 20 30
300 45 60
700 34 67
500 34 12
900 90 45
;
run;

data prueba2;
    set prueba;
run;
```

Con este programa asignamos al *dataset* `prueba2` las mismas características del *dataset* `prueba` creado con anterioridad. La instrucción `SET` lee las observaciones de uno **o varios** *datasets* que se indican a continuación en la sentencia. El paso `DATA` es el que genera o modifica los *datasets* que estemos empleando. Si deseamos crear una nueva variable dentro de un *dataset*, la sintaxis sería:

```sas
data prueba;
    set prueba;
    var_nueva = ranuni(5);
run;
```

No necesitamos declarar las nuevas variables. ¿Qué es lo que hace SAS en este caso?

1. `DATA` crea un conjunto de datos SAS llamado `prueba` (en este caso, lo sobrescribe).
2. `SET` indica a `DATA` que lea otro conjunto de datos SAS.
3. En este punto, crea una estructura para `prueba` con las mismas variables que el *dataset* de entrada.
4. Creamos una nueva variable resultado de emplear la función SAS `ranuni()`.
5. `RUN` indica el final del paso `DATA` y el punto en el que itera el bucle de lectura.

La ejecución del paso `DATA` es eso: **estructura de tabla SAS** (`PDV`) y **bucle de lectura**. El resultado de la ejecución lo podemos ver en el *log* de `WPS`, al que podemos acceder desde el **Output Explorer**. 

El *log* es fundamental para trabajar con `WPS`. Es una ventana donde podemos seguir las ejecuciones de nuestros programas SAS. Es un depurador de código donde podremos analizar cómo han funcionado nuestros procesos. Sigue un código semafórico muy sencillo: si aparece en **rojo** tenemos un error, si aparece en **verde** tenemos un *warning* y si aparece en **azul** nuestra ejecución es correcta. A la hora de ejecutar pasos `DATA`, siempre tendremos un mensaje del tipo:

```text
12        data prueba2;
13        set prueba;
14        run;

NOTE: 5 observations were read from "WORK.prueba"
NOTE: Data set "WORK.prueba2" has 5 observation(s) and 3 variable(s)
NOTE: The data step took :
real time : 00:00:00.032
cpu time  : 00:00:00.000
```

Código ejecutado, notas sobre el proceso que nos permiten depurarlo y tiempo transcurrido. Además de comprobar nuestras ejecuciones en la ventana *log*, podemos hacer vistas de los conjuntos de datos SAS de nuestros proyectos, algo que nos ayudará a validar mejor si nuestro `DATA` ha funcionado correctamente. Para ello contamos con el **Server Explorer** y podemos navegar por las **Libraries**. Allí tenemos todas las librerías de nuestra sesión y, dentro de cada librería de SAS, tenemos los conjuntos de datos creados; si hacemos doble clic sobre cualquiera de ellos, tendremos una vista de los datos. Estas vistas no permiten gran cosa: podemos copiar y pegar en otras aplicaciones (pero sin cabeceras), y no permiten realizar modificaciones o consultas sobre las tablas. Para todas estas labores siempre tendremos el código. Saludos.