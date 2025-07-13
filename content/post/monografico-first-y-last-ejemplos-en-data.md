---
author: rvaquerizo
categories:
- Formación
- Monográficos
- SAS
date: '2009-12-02T10:57:26-05:00'
slug: monografico-first-y-last-ejemplos-en-data
tags: []
title: Monográfico. FIRST. y LAST. ejemplos en DATA
url: /monografico-first-y-last-ejemplos-en-data/
---

[Ya trabajamos en un monográfico anterior con datos agrupados en SAS](https://analisisydecision.es/monografico-datos-agrupados-en-sas/). Cuando empleamos BY tenemos dos variables dentro del paso data con las que trabajaremos habitualmente FIRST. y LAST. A continuación vamos a plantear un ejemplo de uso para entender mejor su funcionamiento. Partimos de una simulación de una catera de una CIA asguradora que tiene 1.000 pólizas y está a nivel de póliza, renovación y suplemento. Para la realización de diversos análisis necesitamos marcar las pólizas de nueva producción, marcar la anualidad, determinar la prima en el momento anterior a la renovación y la prima que tienen a día de hoy.

Como hemos indicado lo primero será crear una tabla que simule nuestra cartera:

```r
*SIMULAMOS UNA CARTERA DE 1000 POLIZAS;

data simula;

drop n_:;

do poliza=1 to 1000;

prima=rand("uniform")*1000;

n_renovaciones=ranpoi(1,5);

do renovacion=0 to n_renovaciones;

do suplemento=0 to max(ranpoi(2,1)-1,0);

prima=prima+ranpoi(3,2)*rand("uniform");

output;

end; end; end;

run;
```

Estamos ante una tabla en forma POLIZA-RENOVACION-SUPLEMENTO con un dato PRIMA. Veamos como hacemos las tareas encargadas:

```r
proc sort data=simula;

by poliza renovacion suplemento;

data simula;

set simula;

by poliza renovacion suplemento;

*NUEVA PRODUCCION;

if first.poliza then nueva_produccion=1;

else nueva_produccion=0;

*ANUALIDAD;

if first.renovacion then anualidad=1;

else anualidad=0;

*PRIMA FINAL EN LA ANUALIDAD;

if last.renovacion and last.suplemento

then prima_anualidad=prima;

else prima_anualidad=0;

*PRIMA ACTUAL;

if last.poliza then prima_actual=prima;

else prima_actual=0;

run;
```

El primer paso es asegurarnos de que nuestra tabla esté ordenada por los campos sobre los que realizamos la agrupación. En BY hemos puesto los 3 campos que agrupan nuestra tabla. La nueva producción se marca como el primer momento en el que aparece la póliza, por supuesto empleamos FIRST.POLIZA Para marcar la anualidad de la póliza empleamos FIRST.RENOVACION, destacar que POLIZA no influye, nos olvidamos de esta agrupación y trabajamos sólo con la RENOVACION. Si deseamos calcular la prima en el último suplemento de la renovación tenemos que buscar el LAST.RENOVACION y el LAST.SUPLEMENTO. Si queremos la prima actual de la póliza tenemos que quedarnos con el valor de prima en LAST.POLIZA Estos 4 casos agrupan las principales casuísticas con las que nos podemos encontrar a la hora de trabajar con FIRST. y LAST. seguro que os habéis encontrado en situaciones en las que estas variables no han funcionado o empezábais a volveros locos con los valores que tomaban. Para esos casos recomiento crear una variable id que sea la concatenación de los campos que agrupan nuestra tabla:

```r
data smula;

set simula;

id=compress(put(poliza,5.)||put(renovacion,3.)||put(suplemento,3.));

data simula;

set simula;

by id;

run;
```