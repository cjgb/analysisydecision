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
  - sin etiqueta
title: Curso de lenguaje SAS con WPS. Ejecuciones
url: /blog/curso-de-lenguaje-sas-con-wps-ejecuciones/
---

Hasta la fecha nos hemos aproximado al interfaz de WPS y hemos ejecutado algunos script para trabajar con conjuntos de datos SAS y sobre todo entender que hace el paso DATA, también hemos analizado que son y como trabajan las librerías WPS. En nuevas entregas nos seguiremos centrando en el trabajo con dataset temporales y permanentes. La intención es conocer bien que hace DATA y establecer una metodología de trabajo con WPS. SAS es un lenguaje orientado a la gestión de datos y las personas acostumbradas a programar en otros lenguajes pueden tener muchos problemas conceptuales. Al final, con este manual intentaremos ayudar a todos aquellos que trabajáis con SAS a crear un método que permita a nuestros procesos SAS que funcionen de la forma más óptima para ganar tiempo y espacio en disco los dos elementos más importantes cuando manejamos grandes volúmenes de datos.

Lo más habitual en SAS es la lectura de otros conjuntos de datos para crear subconjuntos de registros o de variables o crear y modificar variables. La sintaxis habitual para seleccionar datasets es:

```r
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

Con este programa asignamos al dataset _prueba2_ las mismas características del dataset _prueba_ creado como ejemplo con anterioridad. La instrucción _set_ lee las observaciones de uno**o varios** dataset que se indican a continuación en la sentencia. El paso data es el que genera o modifica los datasets que estemos empleando. Si deseamos crear una nueva variable dentro de un dataset la sintaxis sería:

```r
data prueba;

set prueba;

var_nueva=ranuni(5);

run;
```

No necesitamos declarar las nuevas variables. ¿Qué es lo que hace SAS en este caso?

- DATA crea un conjunto de datos SAS llamado _prueba_.
- SET indica a DATA que lee otro conjunto de datos SAS.
- En este punto crea una estructura para prueba con las mismas variables.
- Creamos una nueva variable resultado de emplear la función SAS ranuni.
- RUN indica el final del paso DATA y el punto en el que itera el bucle de lectura.

La ejecución del paso DATA es eso, estructura de tabla SAS (PDV) y bucle de lectura. El resultado de la ejecución lo podemos ver en el **log** de WPS al que podemos acceder desde el _output explorer_. El **log** es fundamental para trabajar con WPS. Es una ventana donde podemos seguir las ejecuciones de nuestros programas SAS. Es un depurador de código donde podremos analizar como han funcionado nuestros procesos. Sigue un código semafórico muy sencillo, si aparece en rojo tenemos un error, si aparece en verde tenemos un _warning_ y si aparece en azul nuestra ejecución es correcta. A la hora de ejecutar pasos DATA siempre tendremos un mensaje del tipo:

```r
12        data prueba2;

13        set prueba;

14        run;

NOTE: 5 observations were read from "WORK.prueba"

NOTE: Data set "WORK.prueba2" has 5 observation(s) and 3 variable(s)

NOTE: The data step took :

real time : 00:00:00.032

cpu time  : 00:00:00.000
```

Código ejecutado, notas sobre el proceso que nos permiten depurar el código y tiempo transcurrido para el proceso. Además de comprobar nuestras ejecuciones en la ventana log podemos hacer vistas de los conjuntos de datos SAS de nuestros proyectos, algo que nos ayudará a validar mejor si nuestro DATA ha funcionado correctamente. Para ello contamos con el _server explorer_ y podemos navegar por las _libraries_. Allí tenemos todas las librerías de nuestra sesión y dentro de cada librería de SAS tenemos los conjuntos de datos creados, si hacemos doble click sobre cualquiera de ellos tendremos una vista de los datos. Estas vistas no permiten gran cosa, podemos copiar y pegar en otras aplicaciones pero sin cabeceras, no nos permiten realizar modificaciones o consultas sobre las tablas. Para todas estas labores siempre tendremos el código.
