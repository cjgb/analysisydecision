---
author: rvaquerizo
categories:
- data mining
- formación
- modelos
- r
date: '2010-01-09'
lastmod: '2025-07-13'
related:
- monografico-arboles-de-clasificacion-con-rpart.md
- trucos-r-llevar-a-sas-las-reglas-de-un-arbol-de-decision.md
- arboles-de-decision-con-sas-base-con-r-por-supuesto.md
- monografico-un-poco-de-proc-logistic.md
- el-sobremuestreo-mejora-mi-estimacion.md
tags:
- árboles de decisión
- party
- rpart
title: Monografico. Arboles de decisión con party
url: /blog/monografico-arboles-de-decision-con-party/
---
Los árboles de clasificación son una de las técnicas de análisis más utilizadas. No requieren supuestos distribucionales, permite detectar interacciones entre variables y no es muy sensible a la presencia de valores perdidos y outliers. En resumen, es una técnica que no quita mucho tiempo al analista para hacer consultas carentes de valor para sus responsables y permite identificar tanto perfiles positivos como perfiles negativos. Además, sus resultados son muy fáciles de interpretar. Tan fáciles que, **INCLUSO** , las áreas de negocio pueden entender sus resultados. Por todo esto estamos ante una de las técnicas más extendidas. En el blog ya hicimos un [breve monográfico con _rpart_ de R](https://analisisydecision.es/monografico-arboles-de-clasificacion-con-rpart/) y nos quedaba realizar una revisión al paquete _party_. La metodología para esta rápida revisión será la habitual, planteamos un ejemplo y realizamos un análisis con las instrucciones de _party_.

Al igual que no hicimos para el monográfico de _Rpart_ simulamos la cartera de un banco con 20.000 clientes. Deseamos establecer perfiles de clientes propensos a contratar un plan vitalicio de pensión inmediata, las variables con las que contamos son:

* El saldo en vista
* El máximo saldo en planes de pensiones individuales en los últimos 3 años
* El saldo en fondos
* La edad del cliente

```r
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
```

Por supuesto cualquier parecido de estos clientes con la realidad es pura ficción. Cargamos la librería, ejecutamos el modelo con la función _ctree_ y creamos un archivo jpeg con la representación gráfica del mismo:

```r
library(party)

arbol=ctree(pvi~saldo_vista+saldo_ppi+saldo_fondos+edad,data=datos_ini)

jpeg('C:/arbol.jpg', quality = 100, bg = "white", res = 100, width=2500, height=768)

plot(arbol);text(arbol)

dev.off()
```

Particularmente gusto de hacer gráficas de árboles mucho «más anchas que largas», por ello genero un archivo jpeg de 2500×768, de este modo podemos ver bien la representación del árbol. Exploremos mejor los nodos generados con _party_ :

```r
arbol

table(where(arbol))

datos_ini=cbind(datos_ini,nodos=(where(arbol)))

summary(datos_ini)

table(datos_ininodos,datos_inipvi)

nodes(arbol,c(4,7)) #obtenemos los nodos que nos interesan
```

Prefiero _rpart_ para estos análisis pero no negaréis que la representación gráfica de los árboles es muy interesante, además _party_ nos permite emplear el algoritmo MOB (Multilevel Orthogonal Block) que veremos otro día, si termino de entender como funciona…