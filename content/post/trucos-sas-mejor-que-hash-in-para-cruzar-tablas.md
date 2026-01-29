---
author: rvaquerizo
categories:
  - formación
  - sas
  - trucos
date: '2010-09-06'
lastmod: '2025-07-13'
related:
  - trucos-sas-porque-hay-que-usar-objetos-hash.md
  - truco-sas-cruce-con-formatos.md
  - truco-sas-tablas-de-una-libreria-en-una-macro-variable.md
  - trucos-sas-lista-de-datasets-en-macro-variable.md
  - trucos-sas-macrovariable-a-dataset.md
tags:
  - formación
  - sas
  - trucos
title: Trucos SAS. Mejor que hash IN para cruzar tablas
url: /blog/trucos-sas-mejor-que-hash-in-para-cruzar-tablas/
---

El otro día Fernando comentó que los `cruce de tablas` más rápidos entre tablas grandes y tablas pequeñas son las sentencias condicionales sobre listas. Tiene razón. Es una práctica muy habitual en `SAS` cuando leemos tablas de `Oracle` la ralización de listas, esto derivará en otro truco `SAS` en breves días. El caso es que me gustaría que probárais este código:

```sas
data grande;

do i=1 to 20000000;

idcliente=int(ranuni(0)*1000000);

drop i;

output;

end;

run;

*CONJUNTO DE DATOS PEQUEÑO, NO TIENE

 REGISTROS DUPLICADOS;

data pequenio;

do i=1 to 2000000;

idcliente=int(ranuni(34)*1000000);

drop i;

if mod(idcliente,1132)=0 then output;

end;

run;

proc sort data=pequenio nodupkey; by idcliente;quit;

*;

proc sql noprint;

select idcliente into:lista separated by " "

from pequenio ;

quit;

*;

data machea5;

set grande;

if idcliente in (&lista.);

run;
```

Bueno, el tiempo de ejecución de este `cruce de tablas` es de 3 segundos. Mejora a las soluciones planteadas el otro día y sobre todo es un código fácil, muy fácil. Se trata de crear listas de macrovariables y realizar un paso data con una sentencia condicional. Tiene un problema, el tamaño máximo que nos permite una macrovariable. Y en este punto continúa el truco `SAS`. ¿Cuál es el tamaño máximo que puede tener una macrovariable? `64K`, `65534 characters`. Tenemos que evitar a toda costa este error: `ERROR: The length of the value of the macro variable LISTA (70356) exceeds the maximum length (65534). The value has been truncated to 65534 characters.` Para evitar este problema podemos realizar el siguiente planteamiento: `65.000/la longitud del campo de cruce`, en el caso del ejemplo: `65.000/8 = 8.000` más o menos. Hacemos una prueba:

```sas
data pequenio;

do i=10000000 to 20000000;

idcliente=int(ranuni(34)*1000000);

drop i;

if ranuni(8)<0.0008 then output;

end;

run;

proc sort data=pequenio nodupkey; by idcliente;quit;

proc sql noprint;

select idcliente into:lista separated by " "

from pequenio ;

quit;
```

`8 caracteres` y `8.000 registos` más o menos, no hemos obtenido ningún problema. Si tenemos `12 caracteres` sería `65.000/12 = 5.400`, realizamos una breve comprobación:

```sas
data pequenio;

do i=100000000000 to 100000100000;

idcliente=int(ranuni(34)*100000000000);

drop i;

if ranuni(8)<0.054 then output;

end;

run;

proc sort data=pequenio nodupkey; by idcliente;quit;

proc sql noprint;

select idcliente into:lista separated by " "

from pequenio ;

quit;
```

Si alguien está ejecutando estos códigos a lo mejor ha sentido la curiosidad de modificar la regla de `65.000/longitud` y obtiene que no hay problema, el caso no es buscar el límite, si no una regla que lo cumpla. En breve una macro que realice estos cruces.
