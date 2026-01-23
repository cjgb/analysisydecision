---
author: rvaquerizo
categories:
  - formación
  - monográficos
  - r
date: '2010-01-12'
lastmod: '2025-07-13'
related:
  - trucos-r-funcion-ddply-del-paquete-plyr.md
  - proc-sql-merge-set.md
  - capitulo-4-uniones-de-tablas-con-r.md
  - tres-fracasos-y-medio-con-r.md
  - data-management-con-dplyr.md
tags:
  - merge
  - r
  - sql
  - sqldf
title: Monografico. Paquete `sqldf`, si sabes `sql`, sabes `R`
url: /blog/monografico-paquete-sqldf-si-sabes-sql-sabes-r/
---

El paquete `sqldf` de `R` nos permite ejecutar sentencias de [SQL](http://en.wikipedia.org/wiki/SQL). Las cláusulas, las expresiones, los predicados,… son lasalvación para muchos tipos mediocres como el ahora escribiente. `sqldf` es un módulo imprescindible, hasta el novio de Falete es capaz de programar en `SQL`. Evidentemente no voy a enseñaros a hacer `queries` , pero si quiero mostraros algunas de las posibilidades que nos ofrece este paquete de `R`. Como siempre y como caracterizan la mayoría de los mensajes del blog trabajaremos con ejemplos. El primer paso es crear un `data.frame` :

```r
saldo1=runif(100,0,1)*1000

saldo2=runif(100,0,0.5)*10000

saldos=data.frame(cbind(saldo1,saldo2))

saldos$id_cliente=c(1:100)

saldos$alto=as.factor(ifelse(saldo1+saldo2>=4000,1,2))

summary(saldos)
```

Creamos una estructura con dos variables numéricas `saldo1` y `saldo2`, una variable `id_cliente` (autonumérica) y un factor que indica si los `saldos` son altos (1) o bajos (2). El primer paso es `summary` los `saldos` por el factor `alto`. Programando en `R` un tipo mediocre como yo emplearía la función `aggregate` :

```r
d1=aggregate(saldos$saldo1,list(saldos$alto),FUN="max")

names(d1)=c("alto" ,"max_saldo1")

d2=aggregate(saldos$saldo1,list(saldos$alto),FUN="min")

names(d2)=c("alto" ,"min_saldo1")

d3=aggregate(saldos$saldo2,list(saldos$alto),FUN="max")

names(d3)=c("alto" ,"max_saldo2")

d4=aggregate(saldos$saldo2,list(saldos$alto),FUN="min")

names(d4)=c("alto" ,"min_saldo2")

agr=cbind(d1,d2,d3,d4);rm(d1,d2,d3,d4)
```

No queda exactamente como debiera pero es un código rápido y sencillo sobre el que podemos crear una función y que es perfectamente parametrizable. Sin embargo Raúl Vaquerizo, alguien que cree Jonh Locke influyó más en Richard Alpert que en Hume, prefiere emplear `SQL` para `aggregate` datos:

```r
library(sqldf)

agr2=sqldf('

select alto,

max(saldo1) as max_saldo1,

min(saldo1) as min_saldo1,

max(saldo2) as max_saldo2,

min(saldo2) as min_saldo2

from saldos

group by alto;')
```

Sencillo código. Perfectamente entendible por aquellos menos avezados en `R`. Migrar de otra aplicación a `R` puede ser menos complicado de lo que nos creemos, podemos perder el miedo a una hipotética migración. Evidentemente también podemos realizar uniones (`joins`) entre tablas. Comparamos el código en `R` con el código análogo en `sqldf` y así aprendemos a usar la función `merge` :

```r
#Creamos una muestra aleatoria de 50 registros

muestra=data.frame(sample(c(1:100),50))

names(muestra)=c("muestra")

#En esta unión nos quedamos con las observaciones de muestra

saldos.muestra=merge(saldos,muestra,by.x="id_cliente",by.y="muestra",all.y)
```

Si esta unión la intenta alguien que cree que el experimento Philadelphia fue real, lo primero que hace es una mítica `left join` (`máxima` expresión del gestor de información ineficaz):

```r
saldos.muestra2=sqldf('

select b.*

from muestra a left join saldos b

on muestra=id_cliente;')
```

La `inner join` imprescindible en este monográfico:

```r
#Empleando merge:

muestra2=data.frame(sample(c(1:1000),100))

names(muestra2)=c("muestra")

saldos.muestra.21=merge(saldos,muestra2,by.x="id_cliente",

by.y="muestra",all.x)

#Empleando sqldf:

saldos.muestra.22=sqldf('

select a.*

from saldos a , muestra2 b

where id_cliente=muestra;')

summary(saldos.muestra.21);summary(saldos.muestra.22);
```

Y por último la `full join` :

```r
saldos.muestra.31=merge(saldos,muestra2,by.x="id_cliente",

by.y="muestra",all=TRUE)
```

No, no se me ha pasado poner el código análogo en para `sqldf`. Es que no es posible hacer `full join` o `right join` en `sqldf`, pero no me negaréis que el código en `R` es muy sencillo. Por favor corregidme si me equivoco y podemos hacer `full join` con `sqldf` y modifico el monográfico inmediatamente.

¿A qué estás esperando para usar `R` en la gestión de datos? Saludos.