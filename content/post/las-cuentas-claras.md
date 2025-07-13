---
author: danifernandez
categories:
- Data Mining
- Formación
- Monográficos
- SAS
date: '2010-05-22T04:59:34-05:00'
slug: las-cuentas-claras
tags: []
title: Las cuentas claras.
url: /las-cuentas-claras/
---

> Si hay alguna tarea o procedimiento indispensable y más repetitivo hasta la saciedad por excelencia a la hora de trabajar con bases de datos y tener que reportar alguna información por mínima que sea, esta es contar o contabilizar el número de casos (registros) que tenemos en total o en subtotales (por grupos) dentro de una tabla (los llamados ‘datasets’ en SAS).

Para dar mayor utilidad a este ‘tutorial’ sobre conteo, partiré de una tabla con 2 columnas (campos) tipo cadena, es decir tipo texto, de manera que podamos ver diferentes métodos para contar-contabilizar NO solo campos tipo texto sino también trucos que nos den una solución más ‘elegante’ de la combinación de ambos campos tipo cadena. Estos 2 campos se llamarán ‘grupo’ y ‘tipo’, muy empleados por muchos programadores, pero se podrían llamar tambien ‘familia’ y ‘familia_segmento’ o bien  
‘comunidad_1’ y ‘comunidad_2’ o bien ‘zona_tipo1’ y ‘zona_tipo2’ o bien ‘entorno_primario’ y ‘entorno_secundario’, o si el ejercicio tratase de contar el número de alumnos por sexo y color de ojos bastaría con ‘sexo’ y ‘color_ojos’, etc etc.

Este tutorial NO se adentrará en la sintaxis de cada método (veremos hasta 5 diferentes), solo alguna pinzelada de cada uno pues de lo contrario se nos haría demasiado largo. No obstante, explico un poco de cada método para ayudar a los menos entendidos en SAS.

Empezaremos primero por crear una tabla llamada ‘TEST’ de apenas 6 registros para poder destacar luego una particularidad del primer método que emplearemos, el PROC FREQ.

data test;  
do i=1 to 6;  
Grupo=char(‘AB’,ceil(ranuni(7) * 2));  
Tipo=char(‘XZ’,ceil(ranuni(1) * 2));  
output;  
end;  
drop i;  
run;

Cuya salida nos da:

Grupo Tipo  
A Z  
B Z  
A Z  
B Z  
A X  
B Z

Recordemos que el PROC FREQ, en vez de agrupar con la sentencia ‘BY’ o ‘CLASS’ (o bien el ‘GROUP BY’ de PROC SQL), lo hace mediante ‘TABLES’:

proc freq data=test noprint;  
tables Grupo*Tipo /out=METODO_1 (drop=percent );  
run;

Salida:

Grupo Tipo Count

A X 1  
A Z 2  
B Z 3

Veamos su particularidad: además de ser un procedimiento (‘procedure’) rico en realizar tests de bondad de ajuste, coeficientes de correlación, Chi-Cuadrado, etc etc para nuestro cometido de contabilizar registros nos facilita el conteo de valores inexistentes, es decir, para nuestro caso es capaz de identificar aquellas combinaciones no resueltas que si las tuvieramos que contar e informar en un questionario o formulario a mano serían zero. En nuestra tabla que llamamos ‘TEST’ NO tenemos ningun registro del campo ‘tipo’ con valor ‘X’ para el grupo ‘B’, pero si usamos la opción ‘SPARSE’ este nos informa de esta carencia de tal manera que ‘profesionaliza’ nuestro report hasta el máximo detalle (así tu jefe no te preguntará que es lo que sucede con ‘el grupo B – tipo X’) :

proc freq data=test noprint;  
tables Grupo*Tipo /out=METODO_1 (drop=percent ) SPARSE;  
run;

Grupo Tipo Count

A X 1  
A Z 2  
B X 0 /* <—- Inexistente !! */  
B Z 3

Vista esta particularidad curiosa de PROC FREQ, vayamos a lo grande, creamos una tabla con 30 millones de registros y cada cual que observe su ‘performance’ en su máquina (espero escuchar vuestras opiniones más adelante ! ).

data test;  
do i=1 to 30e6;  
Grupo=char(‘ABCDEFGH’,ceil(ranuni(200) * 8));  
Tipo=char(‘WXYZ’,ceil(ranuni(1999) * 5)); *creamos nulos!;  
output;  
end;  
drop i;  
run;

-MÉTODO 1-

Haciendo uso del PROC FREQ. Rápido y sencillo de programar.

proc freq data=test noprint;  
tables Grupo*Tipo /out=METODO_1 (drop=percent ) ;  
run;

Aqui NO hace falta usar la opción SPARSE al tratarse de una tabla tan grande con valores aleatorios distribuidos uniformemente por lo que la probabilidad de NO obtener una sola combinación de entre todas las combinaciones posibles entre ambos campos (‘grupo’ y ‘tipo’) expresados en esta tabla es ínfima. Pero tampoco pasa nada si añadimos esta opción (si encuentra tal remota carencia, nuestro conteo abarcará toda la gama de agrupaciones posibles y por ende NO tendremos que cuestionarnos que combinaciones NO se encontraban en la tabla).

-MÉTODO 2-

Usando el procedimiento PROC SUMMARY o bien el PROC MEANS. Ambos son primos hermanos, aunque no se cual el primo :-) Sea como sea, que cada uno use el que más le venga en gana, a veces es solo cuestión de hábitos. Yo suelo usar el PROC SUMMARY.

Algunos se preguntarán, ¿como voy a contar dichos registros si ambos campos son tipo cadena-texto en esta tabla?. Es por eso que desde el principio , cuando creé la tabla la hize lo más fea posible, de manera que NO fuera fácil usar un PROC SUMMARY o PROC MEANS donde bastase agrupar una variable texto con la sentencia ‘BY’ o ‘CLASS’ y llamar a la variable numérica que queramos contar. Aquí NO tenemos variable numérica. Aquí nos tenemos que olvidar de hacer esto:

proc summary data=test;  
class grupo tipo;  
var grupo tipo;  
output out = MALO (drop=_:) N()=;  
run;

..porque el LOG nos dirá:  
ERROR: Variable Grupo in list does not match type prescribed for this list.  
ERROR: Variable Tipo in list does not match type prescribed for this list.

SAS está esperando campos numéricos dentro de la sentencia ‘VAR’ para realizar una sencilla peración matemática como es contar , función ‘N’.

Bueno, existe la forma de hacerlo, un tanto arcaica y quasi-ridícula pero válida. Desde ahora, O olvidaremos que para usar el PROC SUMMARY necesitamos tener alguna variable numérica, de lo contrario o usamos otro método, como el anterior PROC FREQ, o tendremos que crear tal variable numérica sino:

data test2;  
set test;  
unos=1;  
run;

Una vez creada una variable numérica (ficticia en este caso porque solo la hacemos crear para nuestro propósito) llamada ‘unos’, tenemos 2 caminos a escoger:

-A-

Hacemos el clásico uso del criterio ‘BY’ para el cual necesitamos primero ordenar la tabla previamente con la misma lista de variables mediante un PROC SORT. SAS es tan sibarita que a veces hay que presentarle la tabla bien bonita para que le entre por los ojos frente al escaparate. Y la verdad es que esto consume tiempo:

proc sort data=test2 out=test3; BY grupo tipo; run;  
proc summary data=test3;  
BY grupo tipo;  
var unos;  
output out = METODO_2A (drop=_:) N()=;  
run;

-B-

Prescindimos de ordenarla previamente y nos ahorramos tiempo. Para ello debemos usar el ‘CLASS’ en vez del ‘BY’ como sigue:

proc summary data=test2; * <– la tabla ‘test2’ NO ha sido ordenada;  
CLASS grupo tipo;  
var unos;  
output out = METODO_2B (drop=_:) N()=;  
run;

La ventaja por añadidura (o desventaja si NO nos conviene) es que el ‘CLASS’ nos añadirá el total global de registros NO nulos y los respectivos totales de cada valor categórico de cada uno de los campos ‘grupo’ y ‘tipo’ por separado. Internamente SAS los agrupa por importancia jerárquica dentro de una variable artifial creada a propósito llamada ‘_TYPE_’, un molesto y engorroso sistema que NO recomiendo adentrarse a estudiar. Habitualmente elimino las variables artifiales _TYPE_ y _FREQ_ mediante el ‘ (drop= _: ) ‘ y por ello NO aparecen.

Repito, mediante el uso de ‘CLASS’ en vez de ‘BY’ obtenemos información más rica con su total global de registros NO nulos y totales agrupados; si queremos evitar que nos reporte dichos totales debemos usar la opción ‘NWAY’. No obstante seguimos teniendo un problema: el ‘CLASS’ descarta cualquier registro que contenga al menos un valor nulo o missing en uno de sus campos (por lo que no obtendremos el mismo resultado que usando el ‘BY’ del camino ‘A’ o bien el PROC FREQ que vimos o los siguientes métodos que seguirán a continuación), por lo que debemos usar la opción MISSING para que los cuente expresamente:

proc summary data=test2 NWAY;  
class grupo tipo /MISSING;  
var unos;  
output out = METODO_2B (drop=_: ) N()= ;  
run;

Ciertamente los procedimientos (‘PROCedures’) de SAS son como cajas negras, cada cual tiene su sintaxis, sus opciones y trucos por lo que NO hay más remedio que aprenderselos a fuerza de práctica y lectura de su documentación.

Ejemplo en PROC SUMMARY:  
Podemos insertar la opción ‘MISSING’ en la primera línea:

proc summary data=test2 NWAY MISSING;

…pero NO podemos insertar la opción ‘NWAY’ en la segunda línea:

class grupo tipo /MISSING NWAY; *NO funciona;

Resumiendo, el camino ‘B’ (con el uso del ‘CLASS’) ofrece 2 ventajas:  
-Nos ahorramos de ordenar previamente la tabla (el tiempo que ello conlleva).  
-Nos ofrece además el total global de NO nulos y respectivos totales de cada categoría agrupadora.Si queremos prescindir de estos totales bastará añadir la opción ‘NWAY’ y para que cuente expresamente los nulos añadiremos la opción ‘MISSING’ como el último ejemplo citado.

-MÉTODO 3-

El clásico PROC SQL. Sencillo pero lento a pesar de que NO requiere ordenar previamente la tabla.

proc sql ;  
create table METODO_3 as  
select Grupo, Tipo, count(*) as Count  
from test  
group by Grupo, Tipo;  
quit;

-MÉTODO 4-

Mediante la creación de un objeto ‘hash’. A partir de la version 9.0 SAS comenzó a introducir en los pasos data los objetos ‘hash’, algo nuevo para el típico programador SAS, pero ya conocido en otros lenguages como C++, .NET ,etc. Un objeto ‘hash’ es un ‘array’ temporal que mantiene y corre en memoria valores para cada variable clave asociada (‘associate keys’). Estas variables claves son como las que llamamos mediante ‘BY’ a la hora unir tablas en un data merge o bien cuando decimos ‘where a.idnum=b.idnum’ en un proc sql (siendo ‘idnum’ la variable clave de asociación).  
Para nombrar una o más variables clave estas las definimos bajo ‘definekey’, y definimos el ‘cuerpo’ de la ‘tabla interna hash’ que vamos a crear con todas sus variables bajo ‘definedata’. En definitiva, el objeto ‘hash’ quedará bautizado entre el ‘declare hash’ y el ‘definedone()’ siendo en este ejemplo ‘shu’ su nombre (hay quienes lo llaman con solo una consonante o dos para teclear menos código):

declare hash shu(hashexp:20 , ordered: ‘a’);  
shu.definekey (‘Grupo’,’Tipo’);  
shu.definedata (‘Grupo’,’Tipo’,’Count’);  
shu.definedone();

El ‘hashexp’ corresponde al exponente ‘n’ en base 2 de ‘hash buckets’ (nodos) que vamos a crear con este ‘array’, por cada ‘bucket’ se asigna un identificador de una/s clave/s asociada/s (los ‘definekey’), donde se ‘incrustan’ los ‘definekey’ con su/s correspondiente/s variable/s ‘satelite/s’ (en nuestro caso la variable ‘count’) en forma de árbol binario AVL (de sus creadores: Adelson-Velskii y Landis, lo que ellos llamaron ‘Un algoritmo para la organización de la información’ en 1962), este árbol binario permite agilizar la búsqueda de clave/s asociada/s, resolver colisiones de sus correspondientes variable/s ‘satelite/s’, eliminar duplicados etc etc. En la versión SAS 9.1 el exponente esta limitado a 16, todo número por encima por defecto se truncará a 16, y como una de las novedades de la versión SAS 9.2 es que su límite es ahora 20. Es decir, con exponente 5 estaríamos creando 32 ‘buckets’ (2**5= 32), con 20 crearíamos más de 1 millón de ‘buckets’ (2**20 = 1.048.576). NO por ello significa que cuantos más ‘buckets’ tengamos mejor será nuestro rendimiento operativo pues resultará en menores elementos por cada ‘bucket’ que SAS tendrá que ‘adentrarse a buscar’ y realizar menos comparaciones; es decir, el rendimiento operativo apenas mejora (o puede mermar) utilizando el máximo exponente permitido de nuestra versión SAS, ello depende más del factor de carga. De hecho, si escribieramos ‘hashexp=0’ (2**0 = 1) estaríamos creando un solo ‘bucket’ y funciona bastante bien; probando diferentes exponentes en esta tabla ‘test’ de 30 millones de registros, apenas mejora el rendimiento cuando usamos un exponente mayor de 5 o 6. Si no hacemos mención al ‘hashexp’ este funciona con exponente 8 por defecto.  
Cuando en mi ejemplo digo «ordered ‘a'», le hago saber que quiero que la salida este ordenada ascendentemente. La función ‘replace’ hace actualizar la variable satelite ‘count’ cada vez que la variables claves asociadas ‘grupo’ y ‘tipo’ son encontradas en el árbol binario del ‘bucket’. Por último, hago servir la función ‘output’ como nombre de tabla salida.

Explicar la funcionalidad, funciones y estilo de código de los ‘hash’ resulta tedioso, sin embargo resultan muy utiles para unir tablas sin estar ordenadas, manejar grandes volumenes de datos y todo en muy poco tiempo. Para un estudio más profundo para el lector más inquieto, recomiendo busque tutoriales de ‘SAS hash’,’Hsize’,’hash buckets’…

He aquí mi ‘hash’ en un paso data _null_. Aunque el código sea extenso, si se conoce, solo basta modificar 4 líneas para usarlo en otros casos donde necesitemos hacer cuentas agrupadas:

data _null_;  
if _n_= 1 then do;  
declare hash shu(hashexp:20 , ordered: ‘a’);  
shu.definekey (‘Grupo’,’Tipo’);  
shu.definedata (‘Grupo’,’Tipo’,’Count’);  
shu.definedone();  
call missing(count);  
end;  
do until (final);  
set TEST end=final;  
if shu.find() NE 0 then count=0;  
count + 1;  
shu.replace ();  
end;  
shu.output (dataset: ‘METODO_4’);  
run;

-MÉTODO 5-

Este último método, SÍ necesita forzosamente tener la tabla previamente ordenada, lo malo es que consume tiempo ordenar tablas tan grandes, pero si la tuvieramos ya ordenada en otros pasos anteriores (imaginemos que proviene de un ‘data merge’ anterior), no habría tal necesidad de ordenarla y se ejecutaría más rápido que cualquier procedimiento ‘PROC’ de SAS; digamos que es un paso Data, y los pasos Data son los reyes en SAS.

proc sort data=test out=test5; by grupo tipo; run;  
data METODO_5;  
set test5;  
by grupo tipo;  
if first.tipo then count=1;  
else count + 1;  
if last.tipo;  
run;

Un saludo,

Dani Fernández.

>