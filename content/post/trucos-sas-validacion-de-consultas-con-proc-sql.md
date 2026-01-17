---
author: rvaquerizo
categories:
- Formación
- Monográficos
- SAS
- Trucos
date: '2011-04-06T14:46:15-05:00'
lastmod: '2025-07-13T16:10:37.590767'
related:
- trucos-sas-ejecutar-un-codigo-si-existe-una-tabla-o-un-fichero.md
- trucos-sas-informes-de-valores-missing.md
- curso-de-lenguaje-sas-con-wps-ejecuciones.md
- trucos-sas-mejor-que-hash-in-para-cruzar-tablas.md
- laboratorio-de-codigo-sas-comparativa-entre-if-y-where.md
slug: trucos-sas-validacion-de-consultas-con-proc-sql
tags:
- noexec
- proc sql
- validate
title: Trucos SAS. Validación de consultas con PROC SQL
url: /blog/trucos-sas-validacion-de-consultas-con-proc-sql/
---

Hay ocasiones en las que lanzamos consultas a las BBDD con SAS y necesitamos saber si son correctas. Quería plantearos un truco SAS para **PROC SQL** que valida las consultas antes de ser ejecutadas. Empiezo el truco en la línea habitual, creo un dataset de ejemplo y os presento como realizar la validación, de este modo vosotros podéis copiar y pegar el código en una sesión de SAS y comprobar su funcionamiento. Datos aleatorios de partida:

```r
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

10.000 observaciones y 6 variables. Hemos de realizar una consulta sobre esta tabla y primero hemos de validarla, uno de los medios para realizar esta tarea es la opción _NOEXEC_ dentro de PROC SQL:

```r
proc sql noexec;

create table datos1 as select

id_cliente,

importe1,

importe2

fron datos

where importe6 >= 5000;

quit;
```

_NOEXEC_ no ha ejecutado la consulta y nos devuelve un error, está escrito _fron_ en vez de _from_. Pero _**NO HAY QUE EMPLEAR PARA VALIDAR LA OPCIÓN NOEXEC**_ , lo demuestro con el siguiente código:

```r
proc sql noexec;

create table datos1 as select

id_cliente,

importe1,

importe2

from datos

where importe6 >= 5000;

quit;
```

Aparentemente la consulta no tiene ningún error. Sin embargo en la cláusula _where_ tenemos _importe6_ , una variable que no existe. Es decir, _NOEXEC_ sólo nos ha validado la sintaxis, no la consulta. Así pues **nos olvidamos de NOEXEC**. Para realizar validaciones emplearemos la sentencia **VALIDATE** :

```r
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

_VALIDATE_ siempre precede a _SELECT_ y no sólo nos valida la sintaxis de nuestra consulta sino que además nos valida los campos que incluimos en ella. En el ejemplo que os he puesto lo que hacemos es comentar _CREATE TABLE_ y poner _VALIDATE_. Así podemos dejar lanzadas consultas a servidores en horario de menor concurrencia con la seguridad de que la ejecución es correcta, algo que puede provocar cierta inquietud. Saludos.