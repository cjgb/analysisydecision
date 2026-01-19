---
author: rvaquerizo
categories:
- formación
- sas
- trucos
date: '2008-10-01'
lastmod: '2025-07-13'
related:
- bucle-de-fechas-con-sas-para-tablas-particionadas.md
- trucos-sas-numero-de-dias-de-un-mes.md
- trabajo-con-fechas-sas-funciones-fecha.md
- macros-sas-primer-y-ultimo-dia-del-mes-de-una-fecha-sas.md
- trabajo-con-fechas-sas-formatos-de-fecha-sas-mas-utilizados.md
tags:
- sin etiqueta
title: Trucos SAS. Operar con fechas YYYYMM típicas de particiones Oracle
url: /blog/trucos-sas-operar-con-fechas-yyyymm-tipicas-de-particiones-oracle/
---
Este truco va orientado a programadores SAS que estén habituados a trabajar con Oracle. El SAS Tip de hoy nos permite parametrizar a la perfección la lectura de tablas históricas particionadas. En estos casos podemos crear parámetros con macrovariables de SAS para leer las tablas Oracle sin necesidad de modificar manualmente las fechas de partición. Un ejemplo:

1\. sin parametrizar:

```r
proc sql;

 create table maximo as select

 idcliente,

 max(importe) as importe_semestral

 from ora.tabla

 where f_particion in (200801,200806,200812);

quit;
```

2\. parametrizado:

```r
proc sql;

 create table maximo as select

 idcliente,

 max(importe) as importe_semestral

 from ora.tabla

 where f_particion in (&mes_menos_6.,&mes.,&mes_mas_6.);

quit;
```

Con este ejemplo queda claro nuestro objetivo. En el siguiente paso data veremos las funciones que vamos a emplear para trabajar con fechas de partición AAAAMM, las más habituales:

`%let mes=200808;``data _null_;`
```r
*PREPARAMOS LA FECHA DE LA PARTICION;

 mes= mod(&mes.,100);

 anio=int(&mes/100);

*USO DE FUNCIONES PUT PARA CONVERTIR A CARACTER Y MDY;

 fecha=put(mdy(mes,1,anio),ddmmyy10.);

*LA FUNCION INTNX OPERA CON FECHAS EN FUNCION DE UNA 'BASE'

 EN ESTE CASO LA BASE SERA MONTH;

 fecha_mas_1_mes=put(intnx('MONTH',mdy(8,1,2008),1),ddmmyy10.);
```

put fecha " con un mes mas: " fecha_mas_1_mes;
run;

Si ejecutamos este código en el log obtenemos 01/08/2008 con un mes mas: 01/09/2008 Las funciones principales que empleamos son MOD, INT para identificar mes y año de la fecha en formato AAAAMM y MDY e INTNX para crear fechas y operar en meses respectivamente. Identificadas las funciones (emplead la ayuda para conocerlas mejor) en otro paso data os fijo más el objetivo:

```r
%let mes=200711;
```

```r
data _null_;

y=2;

*AÑO DE SUMAR y MESES;

  anio=year(intnx('MONTH',mdy(mod(&mes.,100),1,int(&mes./100)),y));

*MESES DE SUMAR y MESES;

  mes=month(intnx('MONTH',mdy(mod(&mes.,100),1,int(&mes./100)),y));

  fecha=anio*100+mes;

 put "Si a &mes. le sumas " y " meses obtienes " fecha;

run;
```
`Operamos con la fecha AAAAMM y de ella obtenemos año y mes. Si este proceso lo pasamos a una macro podemos crear una función muy potente y práctica para trabajar con pariticiones:`

```r
/*MACRO PARA OPERAR CON MESES EN FORMATO AAAAMM*/

%macro operames(mesxx,operador);

  year(intnx('MONTH',mdy(mod(&mesxx.,100),1,int(&mesxx./100)),&operador.))*100+

  month(intnx('MONTH',mdy(mod(&mesxx.,100),1,int(&mesxx./100)),&operador.))

%mend operames;
```

Ejemplos de uso de esta función:

```%let mes=200808;`
```r
data _null_;

format fecha 6.;

fecha=%operames(&mes.,-1); call symput ('mes_menos_1',compress(fecha));

fecha=%operames(&mes.,-2); call symput ('mes_menos_2',compress(fecha));

fecha=%operames(&mes.,-3); call symput ('mes_menos_3',compress(fecha));

fecha=%operames(&mes.,-4); call symput ('mes_menos_4',compress(fecha));

fecha=%operames(&mes.,-5); call symput ('mes_menos_5',compress(fecha));

fecha=%operames(&mes.,-6); call symput ('mes_menos_6',compress(fecha));

fecha=%operames(&mes.,-7); call symput ('mes_menos_7',compress(fecha));

fecha=%operames(&mes.,-8); call symput ('mes_menos_8',compress(fecha));

fecha=%operames(&mes.,-9); call symput ('mes_menos_9',compress(fecha));

fecha=%operames(&mes.,-10); call symput ('mes_menos_10',compress(fecha));

fecha=%operames(&mes.,-11); call symput ('mes_menos_11',compress(fecha));

fecha=%operames(&mes.,-12); call symput ('mes_menos_12',compress(fecha));

fecha=%operames(&mes.,-21); call symput ('mes_menos_21',compress(fecha));

fecha=%operames(&mes.,-22); call symput ('mes_menos_22',compress(fecha));

fecha=%operames(&mes.,-23); call symput ('mes_menos_23',compress(fecha));
```

fecha=%operames(&mes.,1); call symput ('mes_mas_1',compress(fecha));
fecha=%operames(&mes.,2); call symput ('mes_mas_2',compress(fecha));
fecha=%operames(&mes.,3); call symput ('mes_mas_3',compress(fecha));
fecha=%operames(&mes.,4); call symput ('mes_mas_4',compress(fecha));
run;

%put _user_;

En log obtenemos:

```r
GLOBAL MES 200808

GLOBAL MES_MAS_1 200809

GLOBAL MES_MAS_2 200810

GLOBAL MES_MAS_3 200811

GLOBAL MES_MAS_4 200812

GLOBAL MES_MENOS_1 200807

GLOBAL MES_MENOS_2 200806

GLOBAL MES_MENOS_3 200805

GLOBAL MES_MENOS_4 200804

GLOBAL MES_MENOS_5 200803

GLOBAL MES_MENOS_6 200802

GLOBAL MES_MENOS_7 200801

GLOBAL MES_MENOS_8 200712

GLOBAL MES_MENOS_9 200711

GLOBAL MES_MENOS_10 200710

GLOBAL MES_MENOS_11 200709

GLOBAL MES_MENOS_12 200708

GLOBAL MES_MENOS_21 200611

GLOBAL MES_MENOS_22 200610

GLOBAL MES_MENOS_23 200609
```

Muy útil para no tener necesidad de modificar fechas en nuestros procesos mensuales. Y podemos crear una macro que nos genere las macrovariables automaticamente, además es un buen ejemplo de bucles con macros:

``
```r
%macro doit (inicio,fin);

%do i= &inicio. %to &fin.;

%let num=%sysfunc(abs(&i.));

data _null_;

 fecha=%operames(&mes.,&i.);

  %if &i. < 0 %then %do;

  %global mes_menos_&num.;

  call symput ("mes_menos_&num.",compress(fecha));

  %end;

  %else %do;

  %global mes_menos_&num.;

  call symput ("mes_mas_&num.",compress(fecha));

  %end;

run;

%end;

%mend;
```
`%doit(-24,3);`

Un código más avanzado para ir conociendo mejor la programación en macro.

Por supuesto para cualquier duda o sugerencia podéis poner comentarios o bien mandar un correo a rvaquerizo@analisisydecision.es