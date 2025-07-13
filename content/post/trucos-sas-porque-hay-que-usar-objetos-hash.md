---
author: rvaquerizo
categories:
- Formación
- SAS
- Trucos
date: '2010-09-01T15:59:38-05:00'
slug: trucos-sas-porque-hay-que-usar-objetos-hash
tags:
- cruce de tablas SAS
- hash
title: Trucos SAS. Porque hay que usar objetos hash
url: /trucos-sas-porque-hay-que-usar-objetos-hash/
---

Quiero trabajar un poco con objetos hash en SAS. Pero antes quería demostraros con una comparativa de código muy sencilla y muy rápida la necesidad de trabajar con estos objetos en SAS. La problemática es muy habitual en nuestro trabajo diario. Tenemos una tabla SAS muy grande, con millones de registros y tenemos que cruzarla con otra tabla SAS muy pequeña para quedarnos sólo con los registros que aparezcan en la tabla pequeña. Tenemos unos clientes que han recibido un contacto comercial y hemos de quedarnos con sus saldos históricos en determinados productos. Veamos los distintos métodos que planteo para machear registros, conjuntos de datos de partida:

```r
options fullstimer;

*CONJUNTO DE DATOS GRANDE, EXISTE LA

POSIBILIDAD DE QUE TENGA DATOS REPETIDOS;

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
```

Tenemos que cruzar el dataset grande con el pequeño, 20 millones frente a unos miles. En mi larga (muy larga) experiencia trabajando con SAS casi todo el mundo (menos Sonia) con el que he coincidido haría:

```r
*OPCION 1: ORDENACION Y MERGE;

proc sort data=grande; by idcliente;

proc sort data=pequenio; by idcliente; run;

data machea;

merge grande (in=a) pequenio (in=b);

by idcliente;

if a and b;

run;
```

Ordenamos los dos conjuntos de datos SAS y realizamos un merge, también es habitual ver el outer join. Este tipo de cruces, con los datos empleados, en un equipo local poco potente tarda algo más de 1 minuto. Mi amiga Sonia y yo hasta hace unos meses hubiéramos hecho:

```r
*OPCION 2: CREACION DE FORMATOS;

proc sort data=pequenio out=selec nodupkey; by idcliente;

data  selec;

set selec;

fmtname="selec";

label="1";

start=idcliente;

run;

proc format cntlin=selec;quit;

proc delete data=selec;quit;

*********************************;

data machea2;

set grande;

if put(idcliente,selec.)="1";

run;
```

El empleo de formatos para los cruces de tablas SAS aumentó mi productividad exponencialmente y permitió que fuera una de las personas más productivas en una gran entidad bancaria. Este cruce tarda aproximadamente unos 10 segundos en realizarse. Tiene una limitación cuando realizamos cruces con valores repetidos, a ver si algún lector identifica el problema, poco habitual pero que limita este tipo de cruces. Por último quería acercaros al uso de objetos hash con SAS. Puede que escriba largo y tendido sobre el tema pero hoy sólo un ejemplo:

```r
*OPCION 3: MANEJO DE OBJETOS HASH;

data machea3 ;

set pequenio point = _n_ ;

declare hash objhh (dataset: 'pequenio') ;

objhh.DefineKey ( 'idcliente' ) ;

objhh.DefineDone () ;

do until ( fin ) ;

set grande end = fin ;

if objhh.find () = 0 then output ;

end ;

stop ;

run ;
```

Con el mismo equipo este proceso tarda en ejecutarse 4 segundos. ¿Merece o no la pena aprender a trabajar con objetos hash? Podéis ser aun más productivos, algo que en algunos casos no repercute en vuestra calidad laboral, si eres más productivo y más riguroso tendrás más trabajo, si no eres productivo y fallas constantemente mejor haces poco trabajo, eso sí, tu hora de salida siempre ha de ser posterior a la del responsable. En fin, dudas, sugerencias, salir a las 15 horas en rvaquerizo@analisisydecision.es