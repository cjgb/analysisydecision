---
author: rvaquerizo
categories:
- Formación
- SAS
- Trucos
date: '2008-11-20T06:17:54-05:00'
lastmod: '2025-07-13T16:01:13.029230'
related:
- trucos-sas-numero-de-dias-de-un-mes.md
- macros-faciles-de-sas-dias-de-un-mes-en-una-fecha.md
- trabajo-con-fechas-sas-formatos-de-fecha-sas-mas-utilizados.md
- trucos-sas-operar-con-fechas-yyyymm-tipicas-de-particiones-oracle.md
- bucle-de-fechas-con-sas-para-tablas-particionadas.md
slug: macros-sas-transformar-un-numerico-a-fecha
tags:
- fechas sas
- funciones sas
- macro sas
- numerico a fecha
title: Macros SAS. Transformar un numérico a fecha
url: /blog/macros-sas-transformar-un-numerico-a-fecha/
---

A continuación vamos a plantear una macro de SAS bastante sencilla que nos permitirá transformar valores numéricos del tipo 20080607, fechas en formato AAAAMMDD pero que son numéricas, a valores fecha en SAS que nos permitirán realizar operaciones. Siguiendo el sistema de todos los mensajes de AyD trabajaremos con ejemplos para estudiar su utilidad.

Partimos de dos fechas en formato AAAAMMDD y desamos realizar una diferencia entre ellas:

```r
data _null_;

 y=20070101;

 m=20080110;

 dif=m-y; put dif;

run;
```

En el log obtenemos que la diferencia entre estas 2 fechas es 10009, necesitamos transformarlas en variables numéricas pero del tipo fecha. Tenemos múltiples posibilidades para realizar esta transformación, pero en este caso voy a emplear la función de creación de fecha en SAS MDY(mes,día,año). Para conseguir del valor AAAAMMDD el mes, el día y el año emplearemos las funciónes MOD para calcular el módulo e INT para obtener la parte entera de una operación:

```r
data _null_;

 y=20080101;

 x=mdy(mod(int(y/100),100),mod(y,100),int(y/10000));

 put x= mmddyy10.;

run;
```

El mes es el resultado de quedarnos con el módulo 100 de AAAAMM, el día el módulo 100 de AAAAMMDD y el año es la parte entera de AAAAMMDD entre 10000, «muy sencillo». Ya tenemos nuestra variable numérica con valor de fecha. Nos queda transformar esta operación en una macro de SAS que podamos emplearla en nuestros programas sin necesidad de escribir toda la operación:

```r
%macro numfecha(num);

mdy(mod(int(&num./100),100),mod(&num.,100),int(&num./10000))

%mend;
```

```r
data _null_;

 y=20080101;

 x=%numfecha(y);

 put x= mmddyy10.;

run;
```

Una macro es «sustituir código SAS» por ello podemos emplear esta macro como una función más:

```r
data _null_;

 y=20070101;

 m=20080110;

 dif=%numfecha(m)-%numfecha(y); put dif;

run;
```

Espero que esta macro sea muy útil para el trabajo diario. Como siempre, si tenéis dudas, sugerencias o un trabajo bien retribuido… rvaquerizo@analisisydecision.es