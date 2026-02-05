---
author: rvaquerizo
categories:
  - consultoría
  - data mining
  - formación
  - monográficos
  - sas
date: '2012-03-26'
lastmod: '2025-07-13'
related:
  - sobremuestreo-y-pesos-a-las-observaciones-ahora-con-r.md
  - que-pasa-si-uso-una-regresion-de-poisson-en-vez-de-una-regresion-logistica.md
  - el-sobremuestreo-mejora-mi-estimacion.md
  - trucos-sas-medir-la-importancia-de-las-variables-en-nuestro-modelo-de-regresion-logistica.md
  - monografico-un-poco-de-proc-logistic.md
tags:
  - offset
  - proc logistic
  - sobremuestreo
  - sas procs
title: En la regresión logística ¿el sobremuestreo es lo mismo que asignar pesos a las observaciones?
url: /blog/en-la-regresion-logistica-c2bfel-sobremuestreo-es-lo-mismo-que-asignar-pesos-a-las-observaciones/
---

Hoy vamos a volver sobre el tema del sobremuestreo. Respondemos a un lector, Roberto, que hace mucho tiempo planteó una duda al respecto. La duda se puede resumir: en un modelo logístico, ¿equivale entrenar un modelo con las observaciones sobremuestreadas a entrenar el modelo poniendo un peso a cada observación? Esta cuestión nunca me la había planteado. Siempre había realizado un sobremuestreo de las observaciones adecuando la población de casos negativos a la población de casos positivos. Si estás habituado a trabajar con Enterprise Miner de SAS, es habitual asignar pesos a las observaciones para realizar el proceso de sobremuestreo. ¿Obtendremos distintos resultados?

Vamos a estudiar un ejemplo con SAS y analizar qué está pasando:

```sas
* REGRESION LOGISTICA PERFECTA;
data logistica;
  do i = 1 to 100000;
    x = rannor(8);
    y = rannor(2);
    prob = 1 / (1 + exp(-(-5.5 + 2.55 * x - 1.2 * y)));
    z = ranbin(8, 1, prob);
    output;
  end;
  drop i;
run;

title "Logística con un 5% aprox de casos positivos";
proc freq data=logistica;
  tables z;
run;
```

Tenemos un conjunto de datos SAS con 100.000 observaciones aleatorias y dos variables independientes ($x$ e $y$) con distribución normal, y creamos una variable dependiente $z$ que toma valores 0 o 1 en función de la probabilidad de un modelo logístico. Es decir, podemos modelizar una regresión logística perfecta con parámetros $\beta_0 = -5.5, \beta_1 = 2.55, \beta_2 = -1.2$. Esta distribución nos ofrece aproximadamente un $5\%$ de casos positivos. Al ser un modelo logístico perfecto, si realizamos la regresión sobre los datos obtendremos:

```sas
title "Ajuste de logística perfecto";
proc logistic data=logistica;
  model z = x y;
run;
```

![regresion_logistica1.PNG](/images/2012/03/regresion_logistica1.PNG)

Un modelo casi perfecto. Ahora vamos a realizar un proceso de sobremuestreo y analizar los parámetros:

```sas
* MUESTRA ALEATORIA CON REEMPLAZAMIENTO DE CASOS POSITIVOS;
proc surveyselect data=logistica (where=(z=1))
  out=unos method=urs n=50000 outhits;
run;

* MUESTRA ALEATORIA SIMPLE DE CASOS NEGATIVOS;
proc surveyselect data=logistica (where=(z=0))
  out=ceros method=srs n=50000;
run;

data logistica2;
  set unos (drop=numberhits) ceros;
run;

title "Ajuste a logística con sobremuestreo";
proc logistic data=logistica2;
  model z = x y;
run;
```

Con el `PROC SURVEYSELECT`, en un primer paso realizamos un muestreo con reemplazamiento para los casos positivos; posteriormente, realizamos un muestreo aleatorio simple para los casos sin evento. Unimos ambas tablas y realizamos el `PROC LOGISTIC` para la nueva tabla con proporción $50\%$ de unos y $50\%$ de ceros:

![regresion_logistica2.PNG](/images/2012/03/regresion_logistica2.PNG)

Sólo ha variado el término independiente, que se ha reducido (en valor absoluto) de forma considerable. Pero lo que más nos interesa es saber qué sucede si, en vez de realizar el sobremuestreo, asignamos pesos a las observaciones. ¡Ojo! No vamos a crear una variable *offset* en el modelo; vamos a asignar un peso a cada registro de la tabla. El proceso de creación de esta variable peso es muy sencillo:

```sas
* ASIGNAR PESOS A LAS OBSERVACIONES;
proc sql noprint;
  select sum(z)/count(*) into :pct
  from logistica;
quit;

data logistica3;
  set logistica;
  if z = 0 then peso = 0.5 / (1 - &pct.);
  else peso = 0.5 / &pct.;
run;

title "Ajuste a logística con pesos";
proc logistic data=logistica3;
  model z = x y;
  weight peso;
run;
```

El peso consiste en dividir el porcentaje que deseamos ($0.5$) entre el porcentaje real; así de sencillo. Al final, la suma del peso de las observaciones será igual al total de las observaciones. En el `PROC LOGISTIC` añadimos la sentencia `WEIGHT` para indicar qué variable contiene el peso. El resultado de este modelo es:

![regresion_logistica3.PNG](/images/2012/03/regresion_logistica3.PNG)

Prácticamente el mismo modelo que hemos obtenido con el proceso de sobremuestreo. Así que estamos en disposición de asegurar que asignar pesos a las observaciones y emplear estos pesos para realizar los modelos de regresión logística equivale a realizar el sobremuestreo. Reiterando: no es lo mismo que emplear una variable *offset* en el modelo. Con esto espero que, antes de realizar complejos procesos de muestreo para detectar patrones con modelos de regresión logística, asignéis pesos a los registros.

Ahora queda extrapolar estas conclusiones a otros modelos. Saludos.