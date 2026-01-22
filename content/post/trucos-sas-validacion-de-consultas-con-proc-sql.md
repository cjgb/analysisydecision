---
author: rvaquerizo
categories:
  - formación
  - monográficos
  - sas
  - trucos
date: '2011-04-06'
lastmod: '2025-07-13'
related:
  - trucos-sas-ejecutar-un-codigo-si-existe-una-tabla-o-un-fichero.md
  - trucos-sas-informes-de-valores-missing.md
  - curso-de-lenguaje-sas-con-wps-ejecuciones.md
  - trucos-sas-mejor-que-hash-in-para-cruzar-tablas.md
  - laboratorio-de-codigo-sas-comparativa-entre-if-y-where.md
tags:
  - noexec
  - proc sql
  - validate
  - sas procs
title: Trucos SAS. Validación de consultas con PROC SQL
url: /blog/trucos-sas-validacion-de-consultas-con-proc-sql/
---

Hay ocasiones en las que lanzamos consultas a las `BBDD` con `SAS` y necesitamos saber si son correctas. Quería plantearos un truco `SAS` para `PROC SQL` que valida las consultas antes de ser ejecutadas. Empiezo el truco en la línea habitual, creo un dataset de ejemplo y os presento como realizar la validación, de este modo vosotros podéis copiar y pegar el código en una sesión de `SAS` y comprobar su funcionamiento. Datos aleatorios de partida:

```sas
data datos;

array importe(5);

drop  j;

do id_cliente=1 to 10000;

do j=1 to 5;

importe(j) = rand("uniform")*10000;

end;

output;

end;

run;
```

10.000 observaciones y 6 variables. Hemos de realizar una consulta sobre esta tabla y primero hemos de validarla, uno de los medios para realizar esta tarea es la opción `NOEXEC` dentro de `PROC SQL`:

```sas
proc sql noexec;

create table datos1 as select

id_cliente,

importe1,

importe2

fron datos

where importe6 >= 5000;

quit;
```

`NOEXEC` no ha ejecutado la consulta y nos devuelve un error, está escrito `fron` en vez de `from`. Pero **NO HAY QUE EMPLEAR PARA VALIDAR LA OPCIÓN `NOEXEC`** , lo demuestro con el siguiente código:

```sas
proc sql noexec;

create table datos1 as select

id_cliente,

importe1,

importe2

from datos

where importe6 >= 5000;

quit;
```

Aparentemente la consulta no tiene ningún error. Sin embargo en la cláusula `where` tenemos `importe6` , una variable que no existe. Es decir, `NOEXEC` sólo nos ha validado la sintaxis, no la consulta. Así pues **nos olvidamos de `NOEXEC`**. Para realizar validaciones emplearemos la sentencia `VALIDATE`:

```sas
proc sql ;

validate

/*create table datos1 as*/ select

id_cliente,

importe1,

importe2

from datos

where importe6 >= 5000;

quit;
```

`VALIDATE` siempre precede a `SELECT` y no sólo nos valida la sintaxis de nuestra consulta sino que además nos valida los campos que incluimos en ella. En el ejemplo que os he puesto lo que hacemos es comentar `CREATE TABLE` y poner `VALIDATE`. Así podemos dejar lanzadas consultas a servidores en horario de menor concurrencia con la seguridad de que la ejecución es correcta, algo que puede provocar cierta inquietud. Saludos.
