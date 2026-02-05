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
  - formación
  - sas
  - trucos
title: Trucos SAS. Operar con fechas YYYYMM típicas de particiones Oracle
url: /blog/trucos-sas-operar-con-fechas-yyyymm-tipicas-de-particiones-oracle/
---

Este truco va orientado a programadores SAS que estén habituados a trabajar con `Oracle`. El *SAS Tip* de hoy nos permite parametrizar a la perfección la lectura de tablas históricas particionadas. En estos casos, podemos crear parámetros con macrovariables de SAS para leer las tablas `Oracle` sin necesidad de modificar manualmente las fechas de partición.

### Un ejemplo

1. **Sin parametrizar:**

```sas
proc sql;
    create table maximo as 
    select idcliente, max(importe) as importe_semestral
    from ora.tabla
    where f_particion in (200801, 200806, 200812);
quit;
```

2. **Parametrizado:**

```sas
proc sql;
    create table maximo as 
    select idcliente, max(importe) as importe_semestral
    from ora.tabla
    where f_particion in (&mes_menos_6., &mes., &mes_mas_6.);
quit;
```

Con este ejemplo queda claro nuestro objetivo. En el siguiente paso `DATA` veremos las funciones que vamos a emplear para trabajar con fechas de partición `AAAAMM` (las más habituales):

```sas
%let mes = 200808;

data _null_;
    * PREPARAMOS LA FECHA DE LA PARTICIÓN;
    m = mod(&mes., 100);
    a = int(&mes. / 100);
    
    * USO DE FUNCIONES MDY PARA CONVERTIR A FECHA SAS;
    fecha = mdy(m, 1, a);
    
    * LA FUNCIÓN INTNX OPERA CON FECHAS EN FUNCIÓN DE UNA 'BASE';
    fecha_mas_1_mes = intnx('MONTH', fecha, 1);
    
    put fecha= ddmmyy10. " con un mes más: " fecha_mas_1_mes ddmmyy10.;
run;
```

Si ejecutamos este código, en el *log* obtenemos `01/08/2008` con un mes más: `01/09/2008`. Las funciones principales que empleamos son `MOD` e `INT` para identificar mes y año de la fecha en formato `AAAAMM`, y `MDY` e `INTNX` para crear fechas y operar en meses respectivamente.

Identificadas las funciones, en otro paso `DATA` os fijo más el objetivo:

```sas
%let mes = 200711;

data _null_;
    y = 2;
    * AÑO Y MES DE SUMAR 2 MESES A LA FECHA;
    fecha_sas = intnx('MONTH', mdy(mod(&mes., 100), 1, int(&mes. / 100)), y);
    
    anio = year(fecha_sas);
    mes = month(fecha_sas);
    
    fecha_final = anio * 100 + mes;
    
    put "Si a &mes. le sumas " y " meses obtienes " fecha_final;
run;
```

Operamos con la fecha `AAAAMM` y de ella obtenemos año y mes. Si este proceso lo pasamos a una macro, podemos crear una "función" muy potente para trabajar con particiones:

```sas
/* MACRO PARA OPERAR CON MESES EN FORMATO AAAAMM */
%macro operames(mesxx, operador);
    (year(intnx('MONTH', mdy(mod(&mesxx., 100), 1, int(&mesxx. / 100)), &operador.)) * 100 + 
     month(intnx('MONTH', mdy(mod(&mesxx., 100), 1, int(&mesxx. / 100)), &operador.)))
%mend operames;
```

### Ejemplos de uso de esta función:

```sas
%let mes = 200808;

data _null_;
    format fecha 6.;
    
    fecha = %operames(&mes., -1); call symput('mes_menos_1', compress(fecha));
    fecha = %operames(&mes., -6); call symput('mes_menos_6', compress(fecha));
    fecha = %operames(&mes., 1);  call symput('mes_mas_1', compress(fecha));
    fecha = %operames(&mes., 12); call symput('mes_mas_12', compress(fecha));
run;

%put _user_;
```

En el *log* obtenemos las macrovariables calculadas automáticamente. Muy útil para no tener necesidad de modificar fechas en nuestros procesos mensuales. Y podemos crear una macro que nos genere las macrovariables automáticamente empleando bucles:

```sas
%macro genera_meses(inicio, fin);
    %do i = &inicio. %to &fin.;
        %let num = %sysfunc(abs(&i.));
        %let val_mes = %operames(&mes., &i.);
        
        %if &i. < 0 %then %do;
            %global mes_menos_&num.;
            %let mes_menos_&num. = &val_mes.;
        %end;
        %else %if &i. > 0 %then %do;
            %global mes_mas_&num.;
            %let mes_mas_&num. = &val_mes.;
        %end;
        %else %do;
            %global mes_actual;
            %let mes_actual = &val_mes.;
        %end;
    %end;
%mend genera_meses;

%let mes = 200808;
%genera_meses(-24, 3);
```

Un código algo más avanzado para ir conociendo mejor la programación macro. Por supuesto, para cualquier duda o sugerencia, podéis poner comentarios o bien mandar un correo a `rvaquerizo@analisisydecision.es`. Saludos.