---
author: rvaquerizo
categories:
  - data mining
  - formación
  - modelos
  - r
  - sas
  - trucos
date: '2011-06-10'
lastmod: '2025-07-13'
related:
  - arboles-de-decision-con-sas-base-con-r-por-supuesto.md
  - monografico-arboles-de-clasificacion-con-rpart.md
  - monografico-arboles-de-decision-con-party.md
  - monografico-un-poco-de-proc-logistic.md
  - resolucion-del-juego-de-modelos-con-r.md
tags:
  - árboles de decisión
  - party
  - rpart
title: Trucos `R`. Llevar a `SAS` las reglas de un `árbol de decisión`
url: /blog/trucos-r-llevar-a-sas-las-reglas-de-un-arbol-de-decision/
---

Vuelvo hoy con el uso de `rpart` para la creación de `árboles de decisión con R`. Pero hoy, además de realizar un modelo de `árbol` con `R` quiero presentaros una función que nos permite guardar las reglas generadas con nuestro modelo en un fichero de texto para su posterior utilización con `SAS`. Retomamos un [ejemplo visto con anterioridad en bitácora](https://analisisydecision.es/monografico-arboles-de-clasificacion-con-rpart/) con ligeras modificaciones:

```r
#Inventamos un objeto para realizar el modelo

#En una cartera de clientes nuestro modelo tiene que identificar

#cuales contratan un PVI

#

clientes=20000

saldo_vista=runif(clientes,0,1)*10000

saldo_ppi=(runif(clientes,0.1,0.2)*rpois(clientes,1))*100000

saldo_fondos=(runif(clientes,0.1,0.9)*(rpois(clientes,1)-1>0))*100000

edad=rpois(clientes,60)

datos_ini<-data.frame(cbind(saldo_vista,saldo_ppi,saldo_fondos,edad))

datos_inisaldo_ppi=(edad<=68)*datos_inisaldo_ppi

#Creamos la variable objetivo a partir de un potencial

datos_inipotencial=runif(1,0,1)+

(log(edad)/(log(68))/100) +

runif(1,0,0.001)*(saldo_vista>5000)+

runif(1,0,0.001)*(saldo_fondos>10000)+

runif(1,0,0.007)*(saldo_ppi>10000)-

runif(1,0,0.2)

datos_inipvi=as.factor((datos_inipotencial>=quantile(datos_inipotencial,

0.90))*1)

#

#Empleamos rpart para la realización del modelo

#

library(rpart)

arbol= rpart(as.factor(pvi)~edad+saldo_ppi+saldo_fondos,

data=datos_ini,method="anova",

control=rpart.control(minsplit=30, cp=0.0008) )
```

Tenemos un objeto `rpart` llamado `arbol`. En este punto necesitamos disponer de las reglas generadas por el modelo para `SAS`, donde el módulo específico para poder realizar determinados modelos tiene un precio muy alto. Buscando en Google encontraremos [este link](http://www.togaware.com/datamining/survivor/Convert_Tree.html). En él tenemos una genial función de `R` `list.rules.rpart` que nos permite identificar las reglas que ha generado el modelo. Modificamos ligeramente esta función para que nos sirva en nuestros propósitos:

```r
#Ubicación de salida del modelo

fsalida = "C:\\temp\\reglas_arbol1.txt"

#Función que identifica las reglas

reglas.rpart <- function(model)

{

frm <- model$frame

names <- row.names(frm)

cat("\n",file=fsalida)

for (i in 1:nrow(frm))

{

if (frm[i,1] == "<leaf>")

{

cat("\n",file=fsalida,append=T)

cat(sprintf("IF ", names[i]),file=fsalida,append=T)

pth <- path.rpart(model, nodes=as.numeric(names[i]), print.it=FALSE)

catal(sprintf(" %s\n", unlist(pth)[-1]), sep=" AND ",file=fsalida,append=T)

catal(sprintf("THEN NODO= "),names[i],";\n",file=fsalida,append=T)

}

}

}

#

reglas.rpart(arbol)
```

Esta función lo que nos permite es poner el contenido del objeto `rpart` en un archivo de texto. Cada una de las reglas comenzará con `IF` y finalizará con `THEN NODO`=`x`; lo que nos permitirá copiar y pegar directamente las reglas generadas en nuestro programa `SAS`. Ya que tenemos un archivo de texto con esta forma:

```
IF saldo_fondos< 5001

AND edad< 68.5

THEN NODO= 4 ;

IF saldo_fondos< 5001

AND edad>=68.5

THEN NODO= 5 ;

IF saldo_fondos>=5001

AND saldo_ppi< 5000

AND edad< 68.5

THEN NODO= 12 ;

IF saldo_fondos>=5001

AND saldo_ppi< 5000

AND edad>=68.5

AND edad< 77.5

THEN NODO= 26 ; ****
```

**Podemos emplear este código en nuestro programa `SAS` para `scorear` los datos**. No hemos necesitado ningún software caro y propietario para poder realizar `árboles` de regresión (en este caso). He estado trabajando con `party` para obtener lo mismo y no he obtenido resultados. Continuaré trabajando sobre ello. Sin embargo la siguiente entrada del blog será similar a esta pero desde el punto de vista del profesional que trabaja con `SAS`. Saludos.
