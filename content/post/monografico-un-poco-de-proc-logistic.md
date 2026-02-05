---
author: rvaquerizo
categories:
  - banca
  - data mining
  - formación
  - modelos
  - monográficos
  - sas
date: '2010-06-24'
lastmod: '2025-07-13'
related:
  - arboles-de-decision-con-sas-base-con-r-por-supuesto.md
  - monografico-regresion-logistica-con-r.md
  - monografico-arboles-de-clasificacion-con-rpart.md
  - macros-sas-tramificar-en-funcion-de-una-variable-respuesta.md
  - monografico-paquete-de-r-nnet-para-modelos-de-redes-neuronales.md
tags:
  - proc logistic
  - regresión logística
  - sas procs
title: Monográfico. Un poco de PROC LOGISTIC
url: /blog/monografico-un-poco-de-proc-logistic/
---

El **`PROC LOGISTIC`** es un procedimiento de SAS que nos ha dado muchas satisfacciones a los dinosaurios como el ahora escribiente. La [regresión logística](http://es.wikipedia.org/wiki/Regresi%C3%B3n_log%C3%ADstica) es uno de los modelos de regresión más utilizados y es bien conocido por todos mis lectores. El problema es muy sencillo: hemos de clasificar una población dividida en dos partes a partir de unas variables independientes. Su aplicación es muy extensa: patrones de fuga, propensiones de compra, salud, fraude… 

Con este monográfico pretendo acercaros a las sentencias básicas en SAS para crear un modelo de regresión logística y proponer gráficos y validaciones. Partimos de una simulación y analizamos la sintaxis:

```sas
data datos;
    do id_cliente = 1 to 20000;
        edad = min(65, ranpoi(4, 45));
        pasivo = ranuni(4) * 10000 + ranuni(12) * (10000 * (edad - 5));
        compras = round(pasivo / (ranexp(423) * 1000));
        vinculacion = max(1, ranpoi(2, round(pasivo / 300000) + 1));
        recibos = ranpoi(1, 2);
        provincia = min(52, ranpoi(123, 28));
        output;
    end;
run;
```

Conjunto de datos SAS con 20.000 clientes de **Banca Personal** de una entidad bancaria. El equipo comercial se pone en marcha y es necesario determinar aquellos clientes que tienen una mayor probabilidad de contratar un depósito a plazo. Para ello, hemos de "inventarnos" qué clientes tienen un alto potencial de contratación:

```sas
* CREAMOS EL POTENCIAL DE COMPRA;
data datos_propension;
    set datos;
    potencial = 0.3;
    
    * EDAD;
    if edad < 30 then potencial = potencial + 0.05 * ranuni(13);
    else if edad < 40 then potencial = potencial + 0.03 * ranuni(13);
    else if edad < 45 then potencial = potencial + 0.04 * ranuni(13);
    else if edad < 55 then potencial = potencial + 0.05 * ranuni(13);
    else potencial = potencial + 0.02 * ranuni(13);
    
    * RECIBOS;
    if recibos <= 2 then potencial = potencial + 0.01 * ranuni(13);
    else if recibos <= 4 then potencial = potencial + 0.03 * ranuni(13);
    else potencial = potencial + 0.05 * ranuni(13);
    
    * VINCULACION;
    if vinculacion <= 5 then potencial = potencial - 0.01 * ranuni(13);
    else if vinculacion <= 8 then potencial = potencial + 0.05 * ranuni(13);
    else if vinculacion <= 12 then potencial = potencial + 0.2 * ranuni(13);
    else potencial = potencial + 0.4 * ranuni(13);
    
    * COMPRAS;
    if compras < 100 then potencial = potencial - 0.01 * ranuni(13);
    else if compras < 250 then potencial = potencial + 0.03 * ranuni(13);
    else if compras < 700 then potencial = potencial + 0.05 * ranuni(13);
    else if compras < 2000 then potencial = potencial + 0.06 * ranuni(13);
    else potencial = potencial + 0.07 * ranuni(13);
    
    * PASIVO;
    if pasivo < 50000 then potencial = potencial - 0.02 * ranuni(13);
    else if pasivo < 100000 then potencial = potencial - 0.01 * ranuni(13);
    else if pasivo < 200000 then potencial = potencial + 0.01 * ranuni(13);
    else if pasivo < 300000 then potencial = potencial + 0.03 * ranuni(13);
    else if pasivo < 500000 then potencial = potencial + 0.1 * ranuni(13);
    else potencial = potencial + 0.1;
    
    * PROVINCIA;
    if mod(provincia, 5) = 0 then potencial = potencial - 0.02 * ranuni(13);
    
    if potencial > 0.35 then contrata = 1;
    else contrata = 0;
run;
```

Ahí los tenemos. `contrata = 1` determina el cliente que adquiere ese producto (nuestro **target**). Hemos de realizar un modelo que nos clasifique a los clientes en función de su propensión a la compra. El primer paso es crear un conjunto de datos de entrenamiento y otro de validación:

```sas
* MUESTRA ALEATORIA;
data entreno validacion;
    set datos_propension;
    if ranuni(46) >= 0.6 then output validacion;
    else output entreno;
run;
```

Ahora nuestro trabajo se ha de centrar en el `PROC LOGISTIC`:

```sas
proc logistic data=entreno outmodel=model1;
    class provincia;
    model contrata(event='1') = edad provincia pasivo vinculacion recibos compras /
          selection=forward ctable;
run;
```

Ésta puede ser la sintaxis más sencilla. Especificamos qué variable(s) son categóricas con `CLASS`. Para hacer el modelo, empleamos la sentencia `MODEL` (Variable Dependiente = Variables Independientes). Usamos `selection=forward` para una selección por pasos y `CTABLE` para ver la tabla de **sensibilidad** y **especificidad** en función del *score*. Con `OUTMODEL` creamos un conjunto de datos SAS que nos permite aplicar el modelo (*scorear*) a otros *datasets*:

```sas
proc logistic inmodel=model1;
    score data=validacion out=validacion_scored;
run;
```

En este caso hemos aplicado el modelo a la tabla de validación. Otra forma es emplear la sentencia `SCORE` a la vez que realizamos el modelo. Para la validación, me gusta realizar una tabla de frecuencias acumuladas para ver la ganancia del modelo:

```sas
proc sql noprint;
    create table resumen as 
    select round(P_1, 0.1) as prob_contrata,
           sum(contrata) as contrata,
           count(*) as clientes
    from validacion_scored
    group by 1
    order by 1 desc;
quit;

data resumen_acumulado;
    set resumen;
    retain clientes_agr contrata_agr 0;
    clientes_agr + clientes;
    contrata_agr + contrata;
    
    pct_clientes = clientes_agr / (select sum(clientes) from resumen); /* Simplificado para el ejemplo */
    prob_acumulada = contrata_agr / clientes_agr;
run;
```

Las posibilidades gráficas son muy extensas si activamos `ODS GRAPHICS`:

```sas
ods graphics on;
proc logistic data=entreno plots(only)=all;
    class provincia;
    model contrata(event='1') = edad provincia pasivo vinculacion recibos compras /
          selection=backward;
    roc "Pasivo" pasivo;
    roc "Compras" compras;
    roc "Vinculación" vinculacion;
run;
quit;
ods graphics off;
```

Se han añadido a nuestra salida todos los gráficos posibles: diagnósticos de influencia, *leverage*, ajuste y las curvas `ROC`. La sentencia `ROC` nos permite ver, variable a variable, cómo es su comportamiento predictor. 

Bueno, pues hasta aquí este pequeño esbozo sobre el `PROC LOGISTIC`. Es evidente que paso por alto temas profundos como el muestreo o la validación cruzada, pero ésta es la base para empezar a trabajar con propensiones en SAS. Saludos.