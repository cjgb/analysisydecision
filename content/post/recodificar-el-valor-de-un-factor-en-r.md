---
author: rvaquerizo
categories:
- Formación
- R
- Trucos
date: '2010-12-07T12:21:00-05:00'
slug: recodificar-el-valor-de-un-factor-en-r
tags:
- as.item
- bucle
- car
- memisc
- recode
title: Recodificar el valor de un factor en R
url: /recodificar-el-valor-de-un-factor-en-r/
---

Tras leer una duda planteada en la [lista de R-Help en español](https://stat.ethz.ch/mailman/listinfo/r-help-es) me he animado a crear una entrada acerca de la recodificación de factores en R. Así dejo recogido algún **código/truco** que puede serviros en vuestro trabajo con R y que este pequeño problema no afecte a vuestra productividad. Además os acerco a la función _recode_ del paquete _car_. Pero en primer lugar os planteo como recodificar factores empleando IF/ELSE:

```r
#Datos de ejemplo:

dt = rpois(200,3)

#Empleamos el bucle for

for (i in 1:length(dt)){

if (dt[i]<=1) {dt0[i]='Tipo 1'} else

if (dt[i]==2) {dt0[i]='Tipo 2'} else

if (dt[i]==3) {dt0[i]='Tipo 3'} else

{dt0[i]='Tipo 4'}}

table(dt0)
```

Realizamos un bucle FOR con R que recoge el objeto dt que hace de ejemplo. Este sería el método más habitual junto con el uso de la función _ifelse_. Pero el paquete _car_ contiene una función muy interesante y que nos permite ahorrar complicaciones y líneas de código:

```r
library(car)

dt1 = recode(dt,"c(0,1)='Tipo 1';2='Tipo 2';3='Tipo 3';else='Tipo 4'")

table(dt1)
```

Fácil de recordar. Podemos recodificar un factor (NA=0), un vector (c(0,1)=’Tipo 1′) o un rango de valores (4:max(dt)=’Tipo 4). Bajo mi punto de vista es la opción más recomendable cuando queremos reagrupar factores. También tenemos la función _as.item_ del paquete _memisc_ , no estoy acostumbrado a usarla pero os planteo el mismo ejemplo con ella:

```r
library(memisc)

dt2 = as.item(dt,labels=c( 'Tipo 1'=0, 'Tipo 1'=1, 'Tipo 2'=2, 'Tipo 3'=3,

'Tipo 4'=4, 'Tipo 4'=5,'Tipo 4'=6,'Tipo 4'=7,'Tipo 4'=8,'Tipo 4'=9,'Tipo 4'=10))

table(dt2)

summary(dt2)
```

Tras ejecutar el código entenderéis porque no la uso. Espero que haya respuestas a esta entrada con otras posibilidades o que alguien me justifique el empleo del _as.item_ , saludos.