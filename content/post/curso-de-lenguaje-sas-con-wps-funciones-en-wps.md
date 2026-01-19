---
author: rvaquerizo
categories:
- formación
- sas
- wps
date: '2011-01-15'
lastmod: '2025-07-13'
related:
- macros-sas-limpiar-una-cadena-de-caracteres.md
- curso-de-lenguaje-sas-con-wps-variables.md
- curso-de-lenguaje-sas-con-wps-lectura-de-ficheros-de-texto.md
- trucos-sas-eliminacion-de-espacios-en-blanco.md
- truco-sas-funcion-para-contar-caracteres.md
tags:
- sin etiqueta
title: Curso de lenguaje SAS con WPS. Funciones en WPS
url: /blog/curso-de-lenguaje-sas-con-wps-funciones-en-wps/
---
[](https://analisisydecision.es/david-gana-a-goliat-la-sentencia-del-caso-sas-frente-a-wps/)A la hora de trabajar con variables en WPS uno de los elementos fundamentales son las funciones. En WPS son completamente análogas a SAS. Además este capítulo quiero que nos sirva para familiarizarnos un poco más con el interfaz de WPS y con los elementos de WPS. Vamos a crear un _script_ , un programa SAS, dentro de nuestro proyecto. Nos ubicamos en el _Proyect Explorer_ pulsamos el botón derecho y _New — Other_ en la ventana que nos sale nos vamos a WPS y generamos un nuevo programa (_script_) al que damos el nombre de funciones:

!(/images/2011/01/wps-nuevo-script.png)

Poco a poco tomamos contacto con la herramienta y con los conceptos. El interfaz y el modo de trabajo se parece más al Enterprise Guide que al <SAS BASE>. Este script nos servirá para crear los ejemplos de uso de funciones en WPS. Las funciones las vamos a dividir en 4 clases en función del tipo de variable:

  1. Funciones numéricas
  2. Funciones de texto
  3. Funciones fecha
  4. Otras funciones

En esta entrega vamos a ver ejemplos de los dos primeros tipos de funciones. Las funciones fecha tendrán su propio capítulo, las otras funciones son referentes a I/O, arrays,… pertenecen a una programación más avanzada, irán saliendo a lo largo del curso algunas de esas funciones. WPS contiene una extensa ayuda sobre todas las funciones disponibles en el WPS Core (la base de WPS):

[](/images/2011/01/wps-ayuda.png "wps-ayuda.png")[](/images/2011/01/wps-ayuda.png "wps-ayuda.png")[](/images/2011/01/wps-ayuda.png "wps-ayuda.png")[](/images/2011/01/wps-ayuda.png "wps-ayuda.png")

!(/images/2011/01/wps-ayuda.thumbnail.png)

El problema es que no está correctamente documentada esta ayuda porque fue el único problema que tuvo WPS en el contencioso con SAS del que [ya hablamos en su momento](https://analisisydecision.es/david-gana-a-goliat-la-sentencia-del-caso-sas-frente-a-wps/). Hoy presentamos una serie de funciones de uso más habitual.

Funciones numéricas:

```r
data ejemplo1;

x=1; y=2; z=3;

maximo=max(x,y,z);put maximo=;

minimo=min(x,y,z);put minimo=;

suma=sum(1,2,.);put suma=;

absoluto=abs(x-y);put absoluto=;

redondea=round(z/y,1);put redondea=;

run;
```

Una muestra de algunas funciones para trabajar con variables numéricas, no es necesario comentarlas con detenimiento a excepción de la función SUM, muy importante cuando trabajamos con valores _missing_ :

```r
data _null_;

total=10+.; put total=;

total=sum(10,.); put total=;

run;
```

En la ventana log del output explorer tenemos:

```r
total=.

total=10

NOTE: The data step took :

  real time : 0.000

  cpu time : 0.000
```

Sumar un valor con missing produce un missing. Emplear SUM con un valor y un missing produce un valor, el missing toma valor 0. Es un tema importante y a tener en cuenta.

Funciones de texto:

COMPRESS Elimina un carácter específico
COUNT Cuenta el número de veces que aparece un carácter
INDEX Busca una cadena de caracteres
LEFT Alinea a la izquierda
LENGTH Obtiene la longitud de una variable carácter
LOWCASE Pone en minúsculas
MISSING Indica si la variable es missing
QUOTE Pone comillas
REVERSE Reversa de carácter
RIGHT Alinea a la derecha
SCAN Busca una cadena de caracteres dentro de otra cadena
SUBSTR Extrae partes de una cadena
TRANWRD Reemplaza o extrae dentro de una cadena
TRIMN Elimina espacios en blanco innecesarios
UPCASE Pone en mayúsculas

Ejemplos de uso:

```r
data _null_;

y = "Funciones de texto en WPS";

length x $30.;

x=compress(y); put x;

z=count(y,"e"); put z;

z=index(y,'tex'); put z;

x=left(y); put x;

z=length(y); put z;

x=lowcase(y); put x;

x=upcase(y); put x;

x=quote(y); put x;

x=reverse(y); put x;

x=right(y); put x;

x=scan(y,2,'de'); put x;

x=substr(y,1,3); put x;

x=tranwrd(y,"WPS","SAS"); put x;

x=trimn(y); put x;

run;
```

Lo primero que tenemos que hacer cuando trabajemos con variables de texto será pensar su longitud. En el ejemplo esto sucede y es el primer elemento del paso DATA. La longitud es muy importante en las variables de texto para que no tengamos problemas posteriormente. En el log tenemos:

```r
FuncionesdetextoenWPS

4

14

Funciones de texto en WPS

25

funciones de texto en wps

FUNCIONES DE TEXTO EN WPS

"Funciones de texto en WPS"

SPW ne otxet ed senoicnuF

Funciones de texto en WPS

s

Fun

Funciones de texto en SAS

Funciones de texto en WPS

NOTE: The data step took :

  real time : 0.000

  cpu time : 0.000
```

Hay funciones que nos devuelven números y otras que nos devuelven texto. Por ese motivo trabajamos con dos variables x es variable de texto y z es variable numérica. Muy importante: una variable SAS, cuando hemos definido su tipo (numérica o alfanumérica) este tipo es inamovible, una variable no puede modificar su tipo. Esto es muy importante, un alto porcentaje de las visitas que vienen a este blog vienen por ese motivo. En la siguiente entrega veremos las funciones fecha, esperadlo ansiosos.