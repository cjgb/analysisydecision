---
author: rvaquerizo
categories:
- Formación
- Monográficos
- WPS
date: '2011-02-16T15:42:13-05:00'
lastmod: '2025-07-13T15:55:57.753656'
related:
- curso-de-lenguaje-sas-con-wps-subconjuntos-de-variables-con-drop-y-keep.md
- laboratorio-de-codigo-sas-comparativa-entre-if-y-where.md
- curso-de-lenguaje-sas-con-wps-el-paso-data.md
- curso-de-lenguaje-sas-con-wps-ejecuciones.md
- en-merge-mejor-if-o-where.md
slug: curso-de-lenguaje-sas-con-wps-sentencias-condicionales-if-then
tags:
- ''
- DELETE
- ELSE
- IF
- output
- THEN
title: Curso de lenguaje SAS con WPS. Sentencias condicionales IF THEN
url: /blog/curso-de-lenguaje-sas-con-wps-sentencias-condicionales-if-then/
---

Las sentencias**IF THEN** son básicas en la programación SAS y en todos los lenguajes. Su estructura es muy sencilla: IF <condición> THEN <acción>; ELSE <acción>. Todas estas sentencias empezarán con IF y como condición podemos poner una o varias. Para crearlas tenemos los operadores de comparación:

![operadores-de-comparacion.png](/images/2011/02/operadores-de-comparacion.png)
Para concatenar condiciones emplearemos los operadores lógicos:

![operadores-logicos.png](/images/2011/02/operadores-logicos.png)

Y aplicando la lógica realizaremos las condiciones en nuestra programación con WPS. Entre las acciones que se ejecutarán cuando se cumpla la condición podemos destacar:

**Eliminación de observaciones:**

```r
data aleatorio;

input id importe1 importe2 importe3 importe4 importe5;

cards;

1 894.4 389.1 218.5 488.2 203.2

2 63.6 299.2 323.8 820.7 183.7

3 235.9 716.0 761.7 800.4 706.7

4 425.5 180.6 867.5 665.3 226.1

5 249.9 360.9 91.4 435.2 194.8

6 853.3 566.3 759.0 78.9 559.4

7 738.2 322.1 660.2 55.0 682.4

8 961.4 891.1 680.2 863.4 824.2

9 31.3 610.8 840.7 399.9 878.4

10 359.5 440.8 57.5 562.9 886.1

11 73.5 305.4 277.4 348.4 739.0

12 962.9 609.8 285.9 409.2 89.3

13 691.2 569.2 203.6 345.9 196.1

14 737.5 582.0 691.4 558.0 978.2

15 91.0 263.8 820.7 434.6 709.0

;run;

*********************************;

data aleatorio1;

set aleatorio;

if importe1+importe2>1000 then delete;

run;
```

En el ejemplo eliminamos con la instrucción **DELETE** aquellas observaciones cuya suma de importe1 e importe2 es superior a 1000.

**Selección de observaciones:**

```r
data aleatorio2;

set aleatorio;

if importe1+importe2>1000 then output;

run;
```

En este caso con **OUTPUT** indicamos a WPS que nos saque las observaciones deseadas. En este caso podemos crear una o varias tablas SAS con un mismo paso DATA:

```r
data aleatorio_mas_1000 aleatorio_menos_1000;

set aleatorio;

if importe1+importe2>1000 then output aleatorio_mas_1000 ;

else output aleatorio_menos_1000;

run;
```

Un mismo paso data genera dos dataset. Con OUTPUT controlamos las observaciones que han de volcarse a cada conjunto de datos.

**Creación de nuevas variables en función de condiciones:**

```r
data aleatorio3;

set aleatorio;

if importe1 > 500 then rango1=1;

else rango1=2;

run;
```

En este caso IF genera una nueva variable que va en función de una condición. Es muy práctico realizar sentencias IF/THEN/ELSE anidadas:

```r
data aleatorio4;

set aleatorio;

if importe1 > 300 then rango1=1;

else if importe1 > 500 then rango1=2;

else if importe1 > 800 then rango1=3;

else rango1=4;

run;
```

En el ejemplo hemos anidado sentencias. Hemos generado condiciones excluyentes que finalizamos con ELSE. Esto nos facilita realizar código y sobre todo controlar mejor las condiciones ya que la primera excluye a la siguiente y del mismo modo a la sucesiva. Algunos consideraréis que no es necesario escribir sobre esto, pero si os contara lo que veo…

Hasta el momento una condición da lugar a una acción pero podemos generar más acciones. Para ello emplearemos «el bucle» **DO/END**. Se suele denominar bucle sin embargo consiste en crear conjuntos de instrucciones:

```r
data aleatorio5;

set aleatorio;

if importe1 > 500 and importe2 > 300 and importe3 > 500 then do;

importe1=importe1*1.1;

importe2=importe1*1.05;

importe3=importe1*1.15;

end;

else do;

importe1=importe1*0.95;

importe2=importe1*0.9;

importe3=importe1*0.99;

end;

run;
```

Una condición da lugar a una serie de acciones, para realizar esta serie empezamos con DO, ponemos las acciones necesarias y finalizamos con END. También lo podemos hacer con ELSE. Se denomina bucle porque DO también nos permite la realización de bucles como un FOR en otros lenguajes. Esto lo veremos en próximas entregas del curso. En la siguiente entrega trabajaremos con librerías en WPS, son sustancialmente distintas a las librerías en SAS ya que podemos generar conjuntos de datos SAS o conjuntos de datos WPS.