---
author: rvaquerizo
categories:
- consultoría
- formación
date: '2010-05-26'
lastmod: '2025-07-13'
related:
- curso-de-lenguaje-sas-con-wps-ejecuciones.md
- curso-de-lenguaje-sas-con-wps-que-hace-el-paso-data.md
- curso-de-lenguaje-sas-con-wps-lectura-de-ficheros-de-texto.md
- curso-de-lenguaje-sas-con-wps-subconjuntos-de-variables-con-drop-y-keep.md
- curso-de-lenguaje-sas-con-wps-librerias-en-wps.md
tags:
- data
title: Curso de lenguaje SAS con WPS. El paso DATA
url: /blog/curso-de-lenguaje-sas-con-wps-el-paso-data/
---
El elemento estrella del código SAS es el paso DATA. Con data podemos leer y escribir conjuntos de datos SAS. Un conjunto de datos SAS es una tabla de datos que contiene información sobre las variables y los registros de la tabla. Data lo que hace es crear una estructura para la tabla y posteriormente añadir datos a esta estructura, es un bucle, no necesitamos indicarle al sistema como recorrer la tabla. En WPS ejecutaremos nuestras sentencias en el editor a través de scripts sobre los que podemos navegar en el _Proyect Explorer_. La sintaxis de un paso data es imposible resumirla pero se puede estructurar del siguiente modo:

  1. DATA <nombre conjunto de datos SAS> ; Crea 1 o n conjuntos de datos SAS
  2. Sentencias de lectura: SET MERGE INFILE CARDS DATALINES…;
  3. Sentencias de manipulación de registros o variables;
  4. RUN;

Lo primero que hace DATA es crear una estructura en función de los datos de lectura. Una vez creada esa estructura lee los datos de forma iterativa y cuando llega a RUN se vuelcan los datos a la estructura. Los primeros ejemplos que vamos a analizar son entradas manuales de datos:

```r
/*PROGRAMA 1*/

data uno;

input x $ y;

cards;

1 34

2 54

3 78

;

run;
```

Los comentarios en WPS se abren con /* y se cierran con */. DATA crea un conjunto de datos SAS, en este caso llamado uno. Todas nuestras sentencias SAS finalizarán con ; si lo omitimos SAS nos devolverá un error. Con INPUT le indicamos a SAS que cree dos variables, si la variable va precedida de $ entonces es una variable alfanumérica. SAS distingue dos tipos de variables, numéricas y alfanuméricas. Con CARDS introducimos los datos manualmente y tras introducirlos ponemos ;. Por último RUN finaliza la ejecución. Es imprescindible marcarle a SAS cuando finaliza la ejecución. Para ejecutar los programas en WPS empleamos el botón de play que tenemos en la barra de herramientas o botón derecho Run. Podemos ejecutar selecciones.

Para comprobar la correcta ejecución de los programas WPS tiene en la pestaña _Output Explorer_ el log que generan el total de los procesos que estamos ejecutando. En WPS es un elemento más de nuestros proyectos. El log es un debugger que sigue un código semafórico muy sencillo, si está azul es correcto, si es verde tenemos un warning y si está rojo… Cuando generemos conjuntos de datos SAS éstos podrán ser guardados en una libería temporal o en una libería permanente. Para indicar en el paso DATA que deseamos que WPS guarde un dataset en una libería permanente tendremos que poner _DATA LIB_PERM.DATASET_ ; vemos que sólo separamos con un punto. Si no ponemos nada por defecto se guardará en la librería WORK. En el ejemplo que hemos visto se guarda en la libería temporal. En sucesivas entregas iremos analizando más ejemplos y más sobre la forma en la que trabaja WPS.

El guiño comercial: Si estás interesado en recibir una formación a medida mi correo es rvaquerizo@analisisydecision.es
