---
author: rvaquerizo
categories:
- Formación
- SAS
- Trucos
date: '2008-12-23T08:45:35-05:00'
lastmod: '2025-07-13T16:01:10.338856'
related:
- trucos-sas-numero-de-dias-de-un-mes.md
- bucle-de-fechas-con-sas-para-tablas-particionadas.md
- monografico-funciones-intnx-e-intck-para-fechas-en-sas.md
- trabajo-con-fechas-sas-funciones-fecha.md
- trucos-sas-operar-con-fechas-yyyymm-tipicas-de-particiones-oracle.md
slug: macros-sas-primer-y-ultimo-dia-del-mes-de-una-fecha-sas
tags:
- último día del mes
- fechas sas
- función INTNX
- primer día del mes
title: Macros SAS. Primer y último día del mes de una fecha SAS
url: /blog/macros-sas-primer-y-ultimo-dia-del-mes-de-una-fecha-sas/
---

Me debo a vosotros, mis lectores. Y he tenido visitas que buscaban como obtener el primer y el último día de un mes con SAS. Como Análisis y Decisión es una web personalizada voy a dar respuesta a esas búsquedas. Para ello tengo os planteo dos macros de SAS, además nos servirán para entender mejor la función INTNX para operar con fechas. El siguiente ejemplo parte de la necesidad de obtener, dada una fecha, el primer y último día del mes de la fecha dada:

``
```r
data _null_;

format x y z date9.;

y="12JUN08"d;

*ULTIMO DÍA DEL MES EN FUNCION DE LA FECHA;

x=intnx("month",y,1)-1;

put x;

PRIMER DÍA DEL MES EN FUNCION DE LA FECHA;

z=intnx("month",y,0);

put z=;

run;
```

Vemos que la función intnx opera como base en meses. Para obtener el último día sumamos un mes a nuestra fecha de referencia y le restamos un día. Es importante reseñar que intnx suma un mes, pero no suma días, es decir, nos sitúa en el primer día del mes siguiente a nuestra fecha. Con este razonamiento si sumamos 0 meses nos pondrá en el primer día del mes que operamos. Curioso funcionamiento el de esta función…

Pues bien, ahora hemos de generar una función, una macro que nos realice este cálculo, nos podría permitir obtener el número de días transcurridos del mes (por ejemplo). La macro, muy sencilla, queda:

```r
%macro finmes(fec);

intnx("month",&fec.,1)-1

%mend;
```

```r
%macro inimes(fec);

intnx("month",&fec.,0)

%mend;
```

Como ejemplo de uso:

``
```r
data _null_;

 fecha="06APR09"d;

 finmes=%finmes(fecha);

 inimes=%inimes(fecha);

 format finmes inimes ddmmyy10.;

 put finmes inimes;

run;
```

«Mira que es fácil» estaréis pensando muchos, y tenéis mucha razón. La función INTNX es lo que tiene. Como ejercicio os propongo que hagáis esta función con meses en formato AAAAMM típicos de las tablas particionadas Oracle. Por supuesto, si tenéis dudas o un trabajo bien remunerado en una empresa capaz de afrontar un periodo de crisis de 6 semestres… rvaquerizo@analisisydecision.es