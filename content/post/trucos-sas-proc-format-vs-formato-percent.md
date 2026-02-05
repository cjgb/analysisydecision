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
  - aleatorios
  - rand
  - ranuni
  - while
title: Trucos SAS. Proc format VS formato percent
url: /blog/truco-sas-proc-format-vs-formato-percent/
---

El formato `PERCENT.` de SAS nos ofrece una apariencia poco habitual a la hora de realizar informes. Necesitamos emplear el `PROC FORMAT`, ya que SAS no tiene un formato de porcentajes estándar que se adecúe perfectamente a los reportes de un buen gestor de la información europeo. Para estudiar su uso, emplearemos un ejemplo:

```sas
data uno;
    format valor percent8.2;
    do valor = -1 to 1 by 0.25;
        output;
    end;
run;

proc print data=uno; 
run;
```

La ejecución de este programa nos ofrece algo parecido a ésto:

| Obs | valor |
|---|---|
| 1 | (100.00%) |
| 2 | (75.00%) |
| 3 | (50.00%) |
| 4 | (25.00%) |
| 5 | 0.00% |
| 6 | 25.00% |
| 7 | 50.00% |
| 8 | 75.00% |
| 9 | 100.00% |

Tenemos tres problemas: 
1. Los valores negativos aparecen entre paréntesis.
2. No empleamos la notación americana, y nuestros decimales han de ir separados por una coma (`,`).
3. Nos pone decimales innecesarios en el cero. 

Debido a estas carencias de SAS, necesitamos crear un formato a medida para que nuestros informes tengan un aspecto más profesional y empleen notación europea:

```sas
proc format;
    picture porcen
        low-0  = '0009,0%' (prefix="-" multiplier=1000)
        0      = '9%'
        0-high = '0009,0%' (multiplier=1000);
run;

data dos;
    do valor = -1 to 1 by 0.25;
        output;
    end;
    format valor porcen.;
run;

proc print data=dos; 
run;
```

El resultado obtenido tras esta ejecución:

| Obs | valor |
|---|---|
| 1 | -100,0% |
| 2 | -75,0% |
| 3 | -50,0% |
| 4 | -25,0% |
| 5 | 0% |
| 6 | 25,0% |
| 7 | 50,0% |
| 8 | 75,0% |
| 9 | 100,0% |

En el `PROC FORMAT` hemos empleado la instrucción `PICTURE`; con ella formateamos cualquier número. Para ello, hemos de jugar con las opciones en cada rango del formato. En nuestro ejemplo tenemos tres rangos: números negativos, cero y números positivos.

En nuestro primer rango del formato, `low-0`, especificamos con `'0009,0%'` que los valores menores que 0 tengan cinco posiciones, de las cuales la última será un `%`; tendremos un decimal separado con `,`. Por otro lado, añadimos opciones entre paréntesis para mejorar la apariencia de nuestro valor. Con `PREFIX="-"` especificamos qué carácter queremos que preceda a nuestro formato; en este caso, para valores negativos, tendremos un "-". 

Con `MULTIPLIER=1000` hacemos que nuestros números sean multiplicados para tener la apariencia de -100,0 (= -1). Se multiplican por 1000 debido a que hemos reservado tres posiciones para la parte entera del número y una posición para la parte decimal; las otras dos posiciones son para el "-" y el "%".

El segundo rango de nuestro formato es el número 0; a él simplemente le asignamos una posición al número y además es necesario que aparezca el `%`; no queremos parte decimal.

Para el tercer y último rango (los números positivos), `0-high`, empleamos las mismas opciones que en la parte negativa, pero no ponemos un prefijo. También multiplicamos por 1000 para tener la apariencia `100,0` (= 1). 

**IMPORTANTE**: si tenemos porcentajes mayores del 1000%, tendremos problemas con este formato; puede que no sea muy habitual, pero es necesario tenerlo en cuenta y sería necesario modificar el tamaño del *template* en el `PICTURE`. Saludos.