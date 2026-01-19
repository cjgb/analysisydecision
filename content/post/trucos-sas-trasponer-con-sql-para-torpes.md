---
author: rvaquerizo
categories:
  - formación
  - sas
  - trucos
  - wps
date: '2011-11-21'
lastmod: '2025-07-13'
related:
  - truco-sas-transponer-tablas-con-proc-transpose-data-o-proc-sql.md
  - trucos-sas-operaciones-con-tablas-de-dimensiones-con-sas.md
  - las-cuentas-claras.md
  - truco-sas-cruce-con-formatos.md
  - trucos-sas-variables-dummy-de-una-variable-continua.md
tags:
  - proc sql
  - trasponer
  - sas procs
title: Trucos SAS. Trasponer con SQL para torpes
url: /blog/trucos-sas-trasponer-con-sql-para-torpes/
---

[](/images/2011/11/trasponer_sql1.png "trasponer_sql1.png")

[![trasponer_sql1.png](/images/2011/11/trasponer_sql1.png)](/images/2011/11/trasponer_sql1.png "trasponer_sql1.png")

Trasponer datos con SAS es un tema que genera un gran número de consultas en Google, por lo tanto genera un gran número de visitas a este blog. Ya hay un monográfico al respecto pero hoy quería volver a contar la trasposición de datos con SQL y SAS pero a un nivel más bajo para que sea lo más sencillo posible. En el ejemplo partimos de una tabla con 3 variables, un id_cliente, un campo tipo y un campo precio. Cada tipo tiene un precio y necesitamos que nuestro dataset tenga un registro por id_cliente y 3 precios, uno por cada tipo. El ejemplo en código SAS:

```r
data datos;

input id_cliente $ tipo precio;

datalines;

A 1 100

A 2 150

A 3 120

B 1 200

B 2 250

B 3 220

C 1 300

C 2 350

C 3 320

D 1 400

D 2 450

D 3 420

;run;
```

Esta es nuestra tabla de partida, ahora vamos a generar tres variables en función de la variable tipo:

```r
data datos2;

set datos;

precio_1 = (tipo = 1) * precio;

precio_2 = (tipo = 2) * precio;

precio_3 = (tipo = 3) * precio;

run;
```

[![trasponer_sql2.png](/images/2011/11/trasponer_sql2.png)](/images/2011/11/trasponer_sql2.png "trasponer_sql2.png")

Si vemos la tabla resultante tiene una forma de matriz con precios y ceros en función de la variable tipo. Ahora si sumarizamos esas variables y agrupamos por el id_cliente la forma de la tabla resultante es el objetivo deseado:

```r
proc sql;

create table tdatos as select

id_cliente,

sum(precio_1) as precio_1,

sum(precio_2) as precio_2,

sum(precio_3) as precio_3

from datos2

group by 1;

quit;
```

Bien, pues esta es la “filosofía” de la trasposición con SAS en SQL. Pero esto lo podemos hacer en un solo paso:

```r
proc sql;

create table tdatos as select

id_cliente,

sum((tipo=1)*precio) as precio_1,

sum((tipo=2)*precio) as precio_2,

sum((tipo=3)*precio) as precio_3

from datos

group by 1;

quit;
```

Y así podemos trasponer de forma sencilla en SAS sin emplear el PROC TRASPOSE que tiene alguna que otra limitación. Y por supuesto nos sirve para trasponer siempre que utilicemos SQL, con ORACLE, POSTGRES,… Creo que esta vez es muy sencillo de entender. Saludos.
