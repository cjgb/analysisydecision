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

El otro día Fernando comentó que los cruces de tablas más rápidos entre tablas grandes y tablas pequeñas son las sentencias condicionales sobre listas. Tiene razón. Es una práctica muy habitual en SAS cuando leemos tablas de `Oracle` la realización de listas; ésto derivará en otro truco SAS en breves días. El caso es que me gustaría que probarais este código:

```sas
* CONJUNTO DE DATOS GRANDE;
data grande;
    do i = 1 to 20000000;
        idcliente = int(ranuni(0) * 1000000);
        output;
    end;
    drop i;
run;

* CONJUNTO DE DATOS PEQUEÑO, SIN DUPLICADOS;
data pequenio;
    do i = 1 to 2000000;
        idcliente = int(ranuni(34) * 1000000);
        if mod(idcliente, 1132) = 0 then output;
    end;
    drop i;
run;

proc sort data=pequenio nodupkey; 
    by idcliente;
run;

* CREAMOS LA LISTA EN UNA MACROVARIABLE;
proc sql noprint;
    select idcliente into :lista separated by " "
    from pequenio;
quit;

* CRUCE MEDIANTE SENTENCIA IN;
data machea5;
    set grande;
    if idcliente in (&lista.);
run;
```

Bueno, el tiempo de ejecución de este cruce de tablas es de unos pocos segundos. Mejora a las soluciones planteadas el otro día y, sobre todo, es un código fácil, muy fácil. Se trata de crear listas de macrovariables y realizar un paso `DATA` con una sentencia condicional. 

Tiene un problema: el tamaño máximo que nos permite una macrovariable. Y en este punto continúa el truco SAS. ¿Cuál es el tamaño máximo que puede tener una macrovariable? **64K**, exactamente **65.534 caracteres**. Tenemos que evitar a toda costa este error: `ERROR: The length of the value of the macro variable LISTA (70356) exceeds the maximum length (65534). The value has been truncated to 65534 characters.` 

Para evitar este problema, podemos realizar el siguiente planteamiento: `65.000 / longitud_del_campo`. En el caso del ejemplo: `65.000 / 8 = 8.125` registros más o menos. Hacemos una prueba:

```sas
data pequenio;
    do i = 10000000 to 20000000;
        idcliente = int(ranuni(34) * 1000000);
        if ranuni(8) < 0.0008 then output;
    end;
    drop i;
run;

proc sort data=pequenio nodupkey; 
    by idcliente;
run;

proc sql noprint;
    select idcliente into :lista separated by " "
    from pequenio;
quit;
```

Ocho caracteres y unos 8.000 registros más o menos; no hemos obtenido ningún problema. Si tenemos 12 caracteres sería `65.000 / 12 = 5.416`. Realizamos una breve comprobación:

```sas
data pequenio;
    do i = 1 to 100000;
        idcliente = int(ranuni(34) * 100000000000);
        if ranuni(8) < 0.054 then output;
    end;
    drop i;
run;

proc sort data=pequenio nodupkey; 
    by idcliente;
run;

proc sql noprint;
    select idcliente into :lista separated by " "
    from pequenio;
quit;
```

Si alguien está ejecutando estos códigos, a lo mejor ha sentido la curiosidad de modificar la regla y habrá visto que si se excede el límite, SAS corta la macrovariable. El caso no es buscar el límite exacto, sino una regla que garantice que siempre se cumpla. En breve, una macro que realice estos cruces de forma automática. Saludos.