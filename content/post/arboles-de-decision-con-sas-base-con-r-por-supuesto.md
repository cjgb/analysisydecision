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

**Con SAS Base podemos hacer árboles de decisión porque tenemos R**. Así de sencillo. Vamos a utilizar SAS para gestionar nuestros datos y R será la herramienta que utilicemos para la realización del modelo de árbol de decisión. Posteriormente emplearemos las reglas generadas por el modelo para etiquetar a nuestros clientes en SAS. Con esta entrada pretendo ilustrar una serie de ejemplos en los que comunico SAS con R. Una herramienta nos sirve para el tratamiento de datos y la otra la utilizaremos para realizar modelos que no están al alcance de SAS. Para realizar esta comunicación SAS-R os planteo la creación en SAS de ficheros de texto con las instrucciones en R y la ejecución en modo batch de R con ese código creado en SAS. Aquí tenéis punto por punto el ejemplo:

El primer paso, como es habitual, es crear un conjunto de datos SAS con datos aleatorios que nos sirva de ejemplo:

```r
*200000 DATOS ALEATORIOS;

data datos;

do id_cliente=1 to 200000;

edad=min(65,ranpoi(4,45));

pasivo=ranuni(4)*10000+ranuni(12)*(10000*(edad-5));

compras=round(pasivo/(ranexp(423)*1000));

vinculacion=max(1,ranpoi(2,round(pasivo/300000)+1));

recibos=ranpoi(1,2);

provincia=min(52,ranpoi(123,28));

output;

end;

run;

*VAMOS A ASIGNAR UN POTENCIAL DE COMPRA FICTICIO;

data sasuser.datos;

set datos;

potencial=0.3;

*MODIFICAMOS LIGERAMENTE EL POTENCIAL;

*EDAD;

if edad<30 then potencial=potencial+0.05*ranuni(13);

else if edad<40 then potencial=potencial+0.03*ranuni(13);

else if edad<45 then potencial=potencial+0.04*ranuni(13);

else if edad<55 then potencial=potencial+0.05*ranuni(13);

else potencial=potencial+0.02*ranuni(13);

*RECIBOS;

if recibos<=2 then potencial=potencial+0.01*ranuni(13);

else if recibos<=4 then potencial=potencial+0.03*ranuni(13);

else potencial=potencial+0.05*ranuni(13);

*VINCULACION;

if vinculacion<=5 then potencial=potencial-0.01*ranuni(13);

else if vinculacion<=8 then potencial=potencial+0.05*ranuni(13);

else if vinculacion<=12 then potencial=potencial+0.2*ranuni(13);

else potencial=potencial+0.4*ranuni(13);

*COMPRAS;

if compras<100 then potencial=potencial-0.01*ranuni(13);

else if compras<250 then potencial=potencial+0.03*ranuni(13);

else if compras<700 then potencial=potencial+0.05*ranuni(13);

else if compras<2000 then potencial=potencial+0.06*ranuni(13);

else potencial=potencial+0.07*ranuni(13);

*PASIVO;

if pasivo<50000 then potencial=potencial-0.02*ranuni(13);

else if pasivo<100000 then potencial=potencial-0.01*ranuni(13);

else if pasivo<200000 then potencial=potencial+0.05*ranuni(13);

else if pasivo<300000 then potencial=potencial+0.2*ranuni(13);

else if pasivo<500000 then potencial=potencial+0.1*ranuni(13);

else potencial=potencial+.1;

*PROVINCIA;

if mod(provincia,5)=0 then potencial=potencial-0.02*ranuni(13);

if potencial>0.4 then contrata=1;

else contrata=0;

run;
```

Tenemos una tabla con 200.000 clientes de una entidad bancaria con datos de edad, número de recibos domiciliados, grado de vinculación del cliente, importe en compras mensual, pasivo del cliente en la entidad y provincia. Después creamos un potencial de compra en función de las variables anteriores y si ese potencial de compra es mayor de 0,4 entonces el cliente ha comprado un determinado producto o servicio de nuestra entidad bancaria.

El siguiente paso es crear un conjunto de datos de entrenamiento y otro de test:

```r
*CREAMOS ENTRENAMIENTO Y VALIDACION;

data entreno validacion;

set sasuser.datos (drop=potencial);

if ranuni(46)>=0.6 then output validacion;

else output entreno;

run;

*EXPORTACION A CSV DEL DS;

PROC EXPORT DATA= entreno

OUTFILE= "c:\temp\elimina.csv"

DBMS=CSV REPLACE;

RUN;
```

Reservamos un 40% de las observaciones para validar el modelo. El conjunto de datos de entrenamiento lo exportamos en formato CSV al directorio de nuestro equipo _C:\\temp_. Por defecto trabajaremos siempre con ese directorio. Recomiendo crear uno específico donde alojemos de forma ordenada códigos, datos y resultados.

Ahora podemos realizar la ejecución en R:

```r
data ejecucion_R;

infile datalines dlm='@';

input lineas: 200.;

lineas = tranwrd(lineas,'names[i],"\n"','names[i],";\n"');

datalines4;

setwd('c:/temp')                                                 @

dfsas <- read.csv('elimina.csv')                           @

library(rpart)                                                         @

arbol=rpart(as.factor(contrata)~ pasivo + edad +     @

recibos + vinculacion + compras          ,                 @

data=dfsas,method="anova",                                       @

control=rpart.control(minsplit=30, cp=0.0008) )            @

arbolframe                                                            @

####################################################@

#Ubicación de salida del modelo                                  @

fsalida = "C:\\temp\\reglas_arbol.txt"                     @

#Función que identifica las reglas                         @

reglas.rpart <- function(model)                                  @

{frm <- model$frame                                                    @

names <- row.names(frm)                                          @

cat("\n",file=fsalida)                                           @

for (i in 1:nrow(frm))                                           @

{if (frm[i,1] == "")                                       @

{cat("\n",file=fsalida,append=T)                           @

cat(sprintf("IF ", names[i]),file=fsalida,                 @

append=T)                                                              @

pth <- path.rpart(model, nodes=as.numeric(names[i]),@

print.it=FALSE)                                                        @

cat(sprintf(" %s\n", unlist(pth)[-1]), sep=" AND ", @

file=fsalida, append=T)                                          @

cat(sprintf("THEN NODO= "),names[i],";\n",                 @

file=fsalida,append=T)}}}                                        @

####################################################@

reglas.rpart(arbol)                                                    @

;;;;

run;
```

Creamos un conjunto de datos SAS donde tenemos código R como observaciones. Empleamos **DATALINES4** porque tenemos un punto y coma en la entrada de datos SAS manual. [El código R escrito les será familiar a los lectores del blog](https://analisisydecision.es/trucos-r-llevar-a-sas-las-reglas-de-un-arbol-de-decision/). Ahora tenemos que exportar este código a un archivo de texto con extensión R:

```r
*ESTABLECEMOS EL DIRECTORIO, LEEMOS Y GUARDAMOS;

data _null_;

set ejecucion_R;

file "c:\temp\pgm.R";

put lineas;

run;
```

Esto se puede hacer con más elegancia, lo reconozco. Pero ‘necesito’ tener las ejecuciones en conjuntos de datos SAS, digamos que es una manía. El código R ha de ser ejecutado:

```r
data _null_;

file "c:\temp\ejecucion.bat";

*TENEMOS QUE TENER EN CUENTA DONDE ESTA R Y QUE VERSION

TENEMOS;

put '"C:\Archivos de programa\R\R-2.12.0\bin\R.exe"'@@;

put ' CMD BATCH --no-save "'@@;

put "c:\temp\pgm.R"@@;

put '"';

call sleep (150);

run;

*EJECUTAMOS EL PROCESO;

options noxwait;

x "C:\temp\ejecucion.bat";
```

En este punto tenemos que tener cuidado con la ubicación y la versión de R, hay que ejecutar el R.exe que llamará en modo batch al programa pgm.R que hemos generado con SAS. Ese código R ha generado un archivo de texto reglas_arbol.txt que contendrá las reglas resultantes del modelo y podemos emplearlo en código SAS:

```r
*EJECUTAMOS EL CODIGO GENERADO;

data validacion;

set validacion;

%include "C:\temp\reglas_arbol.txt";

run;

*PODEMOS ANALIZAR SU RESULTADO;

proc sql;

select nodo,

count(*) as cli,

sum(contrata)/count(*) as tasa

from validacion

group by 1;

quit;
```

El proceso puede parecer complejo. Imaginaos si creo parámetros, así que no me acuséis de chapuzante. El código os le podéis descargar en [este enlace ](/images/2011/07/arboles-regresion-con-sas-base.sas "arboles-regresion-con-sas-base.sas")para ejecutarlo directamente con SAS, así evitamos los**problemas de wordpress**. Como siempre lo que quiero plantearos una forma de trabajo más que interesante y que puede ahorrar muchos costes. Además ya anuncio una serie de entradas al blog de este tipo por lo que espero que os interesen.
