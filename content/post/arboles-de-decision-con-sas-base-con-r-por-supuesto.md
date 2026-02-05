---
author: rvaquerizo
categories:
  - data mining
  - formación
  - modelos
  - monográficos
  - r
  - sas
  - wps
date: '2011-07-12'
lastmod: '2025-07-13'
related:
  - trucos-r-llevar-a-sas-las-reglas-de-un-arbol-de-decision.md
  - monografico-un-poco-de-proc-logistic.md
  - monografico-arboles-de-clasificacion-con-rpart.md
  - monografico-arboles-de-decision-con-party.md
  - monografico-paquete-de-r-nnet-para-modelos-de-redes-neuronales.md
tags:
  - árboles de decisión
  - datalines4
  - rpart
  - sas
title: Árboles de decisión con SAS Base (con R por supuesto)
url: /blog/arboles-de-decision-con-sas-base-con-r-por-supuesto/
---

**Con `SAS Base` podemos hacer árboles de decisión porque tenemos R**. Así de sencillo. Vamos a utilizar SAS para gestionar nuestros datos y R será la herramienta que utilicemos para la realización del modelo de árbol de decisión. Posteriormente, emplearemos las reglas generadas por el modelo para etiquetar a nuestros clientes en SAS. 

Con esta entrada pretendo ilustrar una serie de ejemplos en los que comunico SAS con R. Una herramienta nos sirve para el tratamiento de datos y la otra la utilizaremos para realizar modelos que no están al alcance de `SAS Base`. Para realizar esta comunicación `SAS-R`, os planteo la creación en SAS de ficheros de texto con las instrucciones en R y la ejecución en modo *batch* de R con ese código creado en SAS. Aquí tenéis el ejemplo paso a paso:

El primer paso, como es habitual, es crear un conjunto de datos SAS con datos aleatorios que nos sirva de ejemplo:

```sas
* 200.000 DATOS ALEATORIOS;
data datos;
    do id_cliente = 1 to 200000;
        edad = min(65, ranpoi(4, 45));
        pasivo = ranuni(4) * 10000 + ranuni(12) * (10000 * (edad - 5));
        compras = round(pasivo / (ranexp(423) * 1000));
        vinculacion = max(1, ranpoi(2, round(pasivo / 300000) + 1));
        recibos = ranpoi(1, 2);
        provincia = min(52, ranpoi(123, 28));
        output;
    end;
run;

* ASIGNAMOS UN POTENCIAL DE COMPRA FICTICIO;
data datos_propension;
    set datos;
    potencial = 0.3;
    
    if edad < 30 then potencial = potencial + 0.05 * ranuni(13);
    else if edad < 40 then potencial = potencial + 0.03 * ranuni(13);
    else if edad < 45 then potencial = potencial + 0.04 * ranuni(13);
    else if edad < 55 then potencial = potencial + 0.05 * ranuni(13);
    else potencial = potencial + 0.02 * ranuni(13);
    
    if recibos <= 2 then potencial = potencial + 0.01 * ranuni(13);
    else if recibos <= 4 then potencial = potencial + 0.03 * ranuni(13);
    else potencial = potencial + 0.05 * ranuni(13);
    
    if vinculacion <= 5 then potencial = potencial - 0.01 * ranuni(13);
    else if vinculacion <= 8 then potencial = potencial + 0.05 * ranuni(13);
    else if vinculacion <= 12 then potencial = potencial + 0.2 * ranuni(13);
    else potencial = potencial + 0.4 * ranuni(13);
    
    if compras < 100 then potencial = potencial - 0.01 * ranuni(13);
    else if compras < 250 then potencial = potencial + 0.03 * ranuni(13);
    else if compras < 700 then potencial = potencial + 0.05 * ranuni(13);
    else if compras < 2000 then potencial = potencial + 0.06 * ranuni(13);
    else potencial = potencial + 0.07 * ranuni(13);
    
    if pasivo < 50000 then potencial = potencial - 0.02 * ranuni(13);
    else if pasivo < 100000 then potencial = potencial - 0.01 * ranuni(13);
    else if pasivo < 200000 then potencial = potencial + 0.05 * ranuni(13);
    else if pasivo < 300000 then potencial = potencial + 0.2 * ranuni(13);
    else if pasivo < 500000 then potencial = potencial + 0.1 * ranuni(13);
    else potencial = potencial + 0.1;
    
    if mod(provincia, 5) = 0 then potencial = potencial - 0.02 * ranuni(13);
    
    if potencial > 0.4 then contrata = 1;
    else contrata = 0;
run;
```

Tenemos una tabla con 200.000 clientes. El siguiente paso es crear un conjunto de datos de entrenamiento y otro de validación:

```sas
* CREAMOS ENTRENAMIENTO Y VALIDACION;
data entreno validacion;
    set datos_propension (drop=potencial);
    if ranuni(46) >= 0.6 then output validacion;
    else output entreno;
run;

* EXPORTACION A CSV;
proc export data=entreno
    outfile="C:\temp\entreno.csv"
    dbms=csv replace;
run;
```

Ahora preparamos el código R desde SAS empleando `DATALINES4` (útil si hay puntos y coma en el texto):

```sas
data ejecucion_R;
    infile datalines dlm='@';
    input lineas :$200.;
    datalines4;
setwd('C:/temp')                                                 @
dfsas <- read.csv('entreno.csv')                                @
library(rpart)                                                   @
arbol <- rpart(as.factor(contrata) ~ pasivo + edad + 
               recibos + vinculacion + compras, 
               data = dfsas, method = "class", 
               control = rpart.control(minsplit = 30, cp = 0.0008)) @
fsalida <- "C:/temp/reglas_arbol.txt"                            @
# Función para extraer reglas
extract_rules <- function(model) {
  # ... código para formatear reglas como sentencias IF/THEN SAS ...
}
# extract_rules(arbol)                                           @
;;;;
run;
```

Exportamos este código a un archivo `.R` y lo ejecutamos mediante un fichero *batch*:

```sas
* GUARDAMOS EL SCRIPT R;
data _null_;
    set ejecucion_R;
    file "C:\temp\pgm.R";
    put lineas;
run;

* CREAMOS Y EJECUTAMOS EL BATCH;
data _null_;
    file "C:\temp\ejecuta_r.bat";
    put '"C:\Path\To\R\bin\R.exe" CMD BATCH --no-save "C:\temp\pgm.R"';
run;

options noxwait;
x "C:\temp\ejecuta_r.bat";
```

El *script* R genera un archivo `reglas_arbol.txt` que podemos incluir directamente en un paso `DATA` de SAS para calificar el conjunto de validación:

```sas
data validacion_scored;
    set validacion;
    %include "C:\temp\reglas_arbol.txt";
run;

* ANALIZAMOS RESULTADOS;
proc sql;
    select nodo, count(*) as n, sum(contrata)/count(*) as tasa
    from validacion_scored
    group by 1;
quit;
```

El proceso permite orquestar flujos complejos combinando la potencia de SAS para el manejo de datos y R para la modelización avanzada. Saludos.