---
author: rvaquerizo
categories:
  - formación
  - sas
  - trucos
date: '2008-12-23'
lastmod: '2025-07-13'
related:
  - trucos-sas-numero-de-dias-de-un-mes.md
  - bucle-de-fechas-con-sas-para-tablas-particionadas.md
  - monografico-funciones-intnx-e-intck-para-fechas-en-sas.md
  - trabajo-con-fechas-sas-funciones-fecha.md
  - trucos-sas-operar-con-fechas-yyyymm-tipicas-de-particiones-oracle.md
tags:
  - último día del mes
  - fechas sas
  - función intnx
  - primer día del mes
title: Macros SAS. Primer y último día del mes de una fecha SAS
url: /blog/macros-sas-primer-y-ultimo-dia-del-mes-de-una-fecha-sas/
---

Me debo a vosotros, mis lectores. He tenido visitas que buscaban cómo obtener el primer y el último día de un mes con SAS. Como Análisis y Decisión es una web personalizada, voy a dar respuesta a esas búsquedas.

Para ello, os planteo dos macros de SAS; además, nos servirán para entender mejor la función `INTNX` para operar con fechas. El siguiente ejemplo parte de la necesidad de obtener, dada una fecha, el primer y el último día de su mes:

```sas
data _null_;
    format x y z date9.;
    y = "12JUN08"d;
    
    * ULTIMO DÍA DEL MES EN FUNCION DE LA FECHA;
    x = intnx("month", y, 1) - 1;
    put "Último día: " x;
    
    * PRIMER DÍA DEL MES EN FUNCION DE LA FECHA;
    z = intnx("month", y, 0);
    put "Primer día: " z = ;
run;
```

Vemos que la función `INTNX` opera con base en meses. Para obtener el último día, sumamos un mes a nuestra fecha de referencia y le restamos un día. Es importante reseñar que `INTNX` (sin parámetros de ajuste) nos sitúa en el primer día del mes resultado de la operación. Con este razonamiento, si sumamos cero meses, nos pondrá en el primer día del mes en el que operamos. Curioso funcionamiento el de esta función…

Pues bien, ahora hemos de generar una función (una macro) que nos realice este cálculo; nos podría permitir obtener el número de días transcurridos del mes, por ejemplo. Las macros, muy sencillas, quedan:

```sas
%macro finmes(fec);
    (intnx("month", &fec., 1) - 1)
%mend;

%macro inimes(fec);
    (intnx("month", &fec., 0))
%mend;
```

Como ejemplo de uso:

```sas
data _null_;
    fecha = "06APR09"d;
    fin_mes = %finmes(fecha);
    ini_mes = %inimes(fecha);
    format fin_mes ini_mes ddmmyy10.;
    put fin_mes = ini_mes = ;
run;
```

«Mira qué es fácil», estaréis pensando muchos, y tenéis mucha razón. La función `INTNX` es lo que tiene. Como ejercicio, os propongo que hagáis esta función con meses en formato `AAAAMM` típicos de las tablas particionadas `Oracle`. Por supuesto, si tenéis dudas o un trabajo bien remunerado en una empresa capaz de afrontar un periodo de crisis… `rvaquerizo@analisisydecision.es`. Saludos.