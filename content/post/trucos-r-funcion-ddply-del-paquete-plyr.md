---
author: rvaquerizo
categories:
- Formación
- R
- Trucos
date: '2010-04-19T11:41:43-05:00'
lastmod: '2025-07-13T16:09:36.094862'
related:
- monografico-paquete-sqldf-si-sabes-sql-sabes-r.md
- data-management-con-dplyr.md
- calcular-porcentajes-por-grupos-con-dplyr.md
- datos-agrupados-en-r-con-dplyr.md
- informes-con-r-en-html-comienzo-con-r2html-i.md
slug: trucos-r-funcion-ddply-del-paquete-plyr
tags:
- agregar
- ddply
- plyr
- sumarizar
title: Trucos R. Función ddply del paquete plyr
url: /blog/trucos-r-funcion-ddply-del-paquete-plyr/
---

El **paquete plyr de R** tiene unas funciones que nos permiten hacer sumarizaciones de forma muy rápida y sencilla. Hoy quería trabajar con la función **ddply**. Todos esos resúmenes y agregaciones que nos cuestan mucho código con la función **ddply** pasan a ser de lo más sencillo. Al tajo, o mejor dicho, al ejemplo, como siempre, creo que ilustrar ddply es mejor que entrar en su sintaxis, para eso está la ayuda. Creamos un _data.frame_ con datos inventados que tendrá duplicados por _id_cliente_ :

[source language=»R»]
saldo1=runif(100,0,1)*1000
saldo2=runif(100,0,0.5)*10000
saldos=data.frame(cbind(saldo1,saldo2))
#Voy a crear un id_cliente con duplicados
saldosid_cliente=rpois(100,10000)+rpois(100,9000)
#Asignamos edad a los id_cliente
edad=data.frame(cbind(unique(saldosid_cliente),
(rpois(length(unique(saldos$id_cliente)),40))))
names(edad)=c("id_cliente","edad")
#Nos evitamos una incongruencia de cliente con distinta edad
saldos=merge(saldos,edad,by.x="id_cliente",by.y="id_cliente")
[/source]

Tabla de saldos con 100 registros y por cada cliente dos saldos y la edad. La idea es hacer una tabla agregada a nivel de edad, necesitamos identificar los clientes duplicados, calcular máximos mínimos y medias. [Hace tiempo ya hice referencia al paquete sqldf](https://analisisydecision.es/monografico-paquete-sqldf-si-sabes-sql-sabes-r/). Hasta conocer ddply yo hacía:
[source language=»R»]
library(sqldf)
sqldf(‘select edad,
count(distinct id_cliente) as cli,
count(id_cliente) as reg,
max(saldo1) as max1,
max(saldo2) as max2,
avg(saldo1) as saldo1,
avg(saldo2) as saldo2
from saldos
group by edad;’)[/source]

No es un código complejo, como siempre he dicho si sabes SQL sabes R. Pero un buen día me crucé con el paquete plyr y la función ddply:
[source language=»R»]
library(plyr)
ddply(saldos,"edad",summarise,
cli=length(unique(id_cliente)),
reg=length(id_cliente),
max1=max(saldo1),
max2=max(saldo2),
saldo1=mean(saldo1),
saldo2=mean(saldo2))[/source]

¡Qué forma más sencilla y práctica de sumarizar datos con R! No negaréis que este código puede entenderlo hasta el novio de Falete. Una función simplemente genial.