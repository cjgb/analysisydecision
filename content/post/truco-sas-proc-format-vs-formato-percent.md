---
author: rvaquerizo
categories:
  - formación
  - sas
  - trucos
date: '2008-03-11'
lastmod: '2025-07-13'
related:
  - truco-sas-crear-ficheros-excel-sin-proc-export-i.md
  - intervalos-en-sas-con-proc-format.md
  - trucos-sas-calcular-percentiles-como-excel-o-r.md
  - macros-sas-pasar-de-texto-a-numerico.md
  - transformar-variables-en-sas-caracter-a-numerico.md
tags:
  - formación
  - sas
  - trucos
title: Truco SAS. Proc format VS formato percent
url: /blog/truco-sas-proc-format-vs-formato-percent/
---

El formato SAS _percent_ nos ofrece una apariencia poco habitual a la hora de realizar informes con SAS. Necesitamos emplear el _proc format_ ya que SAS no tiene un formato de porcentajes que se adecúe a los reportes de un buen gestor de la información. Para estudiar su uso emplearemos un ejemplo:

```r
data uno;
format valor percent.3;
do valor=-1 to 1 by 0.25;
output;
end;
run;
proc print data=uno; run;
```

La ejecución de este programa nos ofrece:

Obs | valor | 1 | (100%)
---|---
2 | ( 75%)
3 | ( 50%)
4 | ( 25%)
5 | .00%
6 | 25%
7 | 50%
8 | 75%
9 | 100%

Tenemos 3 problemas: 1. los valores negativos aparecen entre paréntesis 2. no empleamos la notación americana y nuestros decimales han de ir separados por una coma (,) 3. nos pone decimales en el 0. Debido a esta carencia de SAS necesitamos crear un formato a medida para que nuestros informes tengan un aspecto más profesional y empleen notación europea:

```r
proc format ;
picture porcen
low-0='0009,0%' (PREFIX="-" MULTIPLIER=1000)
0='9%'
0-high='0009,0%'(MULTIPLIER=1000);
run;

data uno;
do valor=-1 to 1 by 0.25;
output;
end;
format valor porcen.;
run;

proc print; run;
```

El resultado obtenido tras esta ejecución:

Obs | valor | 1 | -100,0%
---|---
2 | -75,0%
3 | -50,0%
4 | -25,0%
5 | 0%
6 | 25,0%
7 | 50,0%
8 | 75,0%
9 | 100,0%

En el proc format hemos empleado la instrucción _picture_ , con ella formateamos cualquier número. Para ello hemos de jugar con las opciones en cada rango del formato. En nuestro ejemplo tenemos 3 rangos, números negativos, 0 y números positivos.En nuestro primer rango del formato _low – 0_ especificamos con _0009,0%_ que los valores menores que 0 tengan 5 posiciones de las cuales la última será un %, tendremos un decimal separado con ,. Por otro lado añadimos opciones entre paréntesis para mejorar la apariencia de nuestro valor. Con prefix= especificamos que caracter queremos que preceda a nuestro formato, en este caso, para valores negativos, tendremos un -. Con multiplier=1000 hacemos que nuestros números sean multiplicados para tener la apariencia de -100,0 [= -1] Se multiplican por 1000 debido a que hemos reservado 3 posiciones para la parte entera del número y una posición para la parte decimal, las otras dos posiciónes son para el – y el %.

El segundo rango de nuestro formato es el número 0, a él simplemente le asignamos una posición al número y además es necesario que aparezca el %, no queremos parte decimal.Para el tercer y último rango, los números positivos, _0 – high_ empleamos las mismas opciones que en la parte negativa pero no ponemos un prefijo. También multiplicamos por 1000 para tener la apariencia 100,0 [=1].IMPORTANTE: Si tenemos porcentajes mayores de 1000% tendremos problemas con este formato, puede que no sea muy habitual pero es necesario tenerlo en cuenta y sería necesario modificar el formato.
