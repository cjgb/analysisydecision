---
author: rvaquerizo
categories:
- Data Mining
- Formación
- Modelos
- Monográficos
- R
date: '2010-01-29T08:47:34-05:00'
lastmod: '2025-07-13T16:02:56.418141'
related:
- monografico-analisis-de-factores-con-r-una-introduccion.md
- monografico-un-poco-de-proc-logistic.md
- monografico-arboles-de-clasificacion-con-rpart.md
- interpretacion-de-los-parametros-de-un-modelo-glm.md
- introduccion-a-la-estadistica-para-cientificos-de-datos-capitulo-15-modelos-glm-regresion-logistica-y-regresion-de-poisson.md
slug: monografico-regresion-logistica-con-r
tags:
- data management
- modelos con R
- R
- regresión logística
title: Monográfico. Regresión logística con R
url: /blog/monografico-regresion-logistica-con-r/
---

Por fin nos metemos con la regresión logística en R. Nos meteremos con WPS (si es posible). Los modelos de regresión logística son los más utilizados en las áreas en las que el ahora escribiente ha trabajado. ¿Por qué tiene tanto «éxito»? Porque es el mejor ejemplo de modelo de variable linealmente dependiente de otras variables independientes. Pero sobre todo tiene éxito porque modelamos una probabilidad de un suceso (habitualmente dicotómico) en función de unos
factores que pueden ser discretos o continuos. Modelizamos probabilidades, insisto; por ejemplo, si clasificamos la variable comete fraude como 1 y no comete fraude como 0 podríamos realizar un modelo de regresión lineal del tipo fraude(0,1)=:término independiente:+:parámetro:*:independiente:. Matemáticamente es posible, pero si me dices que un cliente tiene un 1,34 de «potencial» de fraude entro en estado de shock. Peeero, si p es la probabilidad de cometer fraude podemos construir esta función Ln(p/(1-p)) y sobre esta función si hacemos: Ln(p/q)=:término independiente: + :parámetro:*:independiente:. O lo que es lo mismo: prob. fraude=1/(1+e**(-:término independiente:-:parámetro:*:independiente:)). Qué bonita función y que interesante propiedad de los logaritmos que transforman sumas en productos.

Ya os he contado toda la teoría que necesitáis para comenzar a trabajar. Imagino que os habéis leído 4 o 5 entradas de Google sobre el tema y estáis preparados para comenzar a trabajar con datos. En este caso vamos a emplear la regresión logística para describir. Al introduciros en este análisis he hablado de la probabilidad de presentar o no una característica. Sin embargo ahora le doy la vuelta y, sabiendo que pertenecen a un grupo quiero encontrar las interacciones entre las variables independientes. En este monográfico quiero analizar las poblaciones de España que tienen una tasa de paro para las mujeres un 90% más alta que la tasa de paro de los hombres. ¿Qué está pasando en estas poblaciones? ¿Qué factores socioecómicos son los más influyentes? ¿Cómo interactúan estos factores? Para ilustrar este ejemplo vamos a emplear los datos del anuario de «la Caixa» que os podéis bajar en [este link](http://www.anuarieco.lacaixa.comunicacions.com/java/X?cgi=caixa.le_DEM.pattern&CLEAR=YES). Seleccionamos todos los municipios y nos quedamos con las siguientes variables:

* Código INE
* Variación población 03-08 (Absoluta)
* Variación población españoles 03-08 (absoluta)
* Variación población extranjera 03-08 (absoluta)
* Variación población 03-08 (%)
* Variación población 96-01 (%)
* Extensión (Km2)
* Paro registrado en % s/población total 2008
* Paro registrado en % s/población total 2007
* Paro registrado en % s/población total 2006
* Paro registrado en % s/población total 2005
* Paro registrado en % s/población total 2004
* Paro registrado en % s/población total 2003
* Paro registrado en % s/población total 2002
* Paro registrado en % s/población total 2001
* Paro registrado en % s/población total 2000
* Paro registrado en % s/población total 1999
* Paro registrado en % s/población total 1998
* Paro registrado en % s/población total 1997
* Paro registrado en % s/población total 1996
* % Paro de varones
* % Paro de mujeres
* % Paro de 16 a 24 años
* % Paro de 25 a 49 años
* % Paro de 50 y más años
* Variación teléfonos fijos 03-08 (%)
* Líneas de banda ancha 2008
* Variación total vehículos de motor 03-08 (%)
* Variación oficinas bancarias 04-09 (Absoluta)
* Variación cooperativas de crédito 04-09 (Absoluta)
* Variación actividades industriales 03-08 (%)
* Variación actividades comerciales mayoristas 03-08 (%)
* Variación actividades comerciales minoristas 03-08 (%)
* Variación actividades de restauración y bares 03-08 (%)

Ahora tenemos que preparar el _data.frame_ para R. En mi caso prefiero modificar los nombres directamente en Excel y luego realizar la importación con Rcomander. Como sois unos tipos muy afortunados esta tarea tan aburrida ya la he realizado yo y la tenéis en el [siguiente link](/images/2010/01/sociodemo.RData "sociodemo.RData"). El objeto datos será nuestro _data.frame_ de trabajo, hacemos _str(datos)_ :

```r
'data.frame': 3324 obs. of 35 variables:

municipio : Factor w/ 3323 levels "Abadín","Abadiño",..: 8 11 17 83 174 207 261 282 469 517 ... ine : int 4001 4002 4003 4006 4011 4013 4016 4017 4024 4029 ...

var.pob : num 23 -25 2176 1018 471 ... var.pob.esp : num -57 -72 758 -562 191 625 23 60 670 298 ...

var.pob.ext : num 80 47 1418 1580 280 ... var.pob.03.08 : num 1.6 -1.8 10 9.8 14.5 ...

var.pob.96.01 : num -1.8 -2.9 5.2 3.6 3.1 -2.4 11.5 11.4 5.3 2.1 ... extension : num 45 84 90 168 26 296 99 66 17 217 ...

paro2008 : num 3.9 3.9 7.8 4 5.5 7.3 4.3 2.3 7.2 7.6 ... paro2007 : num 3.1 2.6 5.9 3.2 4.1 5.9 3.1 1.5 5.4 6.2 ...

paro2006 : num 4.3 3.1 6.2 3 3.8 5.9 2.6 1.6 4.8 4.9 ... paro2005 : num 3.8 3.4 5.7 2.6 4.8 5.1 2.9 1.5 4.5 4.5 ...

paro2004 : num 1.8 1.1 3.1 2.4 3.1 3.7 2.2 1.1 2.8 3.4 ... paro2003 : num 2.6 2.2 2.9 2.3 2.9 4 2 2.2 3.5 2.5 ...

paro2002 : num 2.6 1.8 2.5 2.5 2.9 4.1 1.3 2.1 3.4 2.8 ... paro2001 : num 1.8 1.5 3 2.8 3.2 4 2.1 2.5 3.3 2.6 ...

paro2000 : num 3.2 2.3 2.7 2.7 3.2 3.9 2.2 2.3 3.8 2.6 ... paro1999 : num 3 1.9 2.4 2.9 3.5 3.9 2.4 2.3 3.6 2.8 ...

paro1998 : num 3.1 3.2 2.6 3.3 3.2 4.8 2.2 3 4 2.9 ... paro1997 : num 3 3.8 2.8 3.5 3.3 5.2 2.8 3.8 4.3 2.8 ...

paro1996 : num 4.4 2.1 2.8 4.3 4.7 5.5 2.9 3.4 3.7 2.7 ... paro.hombres : num 4.7 5.7 7.3 4.5 4.3 6.9 3.7 2.9 6 7.2 ...

paro.mujeres : num 3.1 2.1 8.2 3.6 6.7 7.7 5 1.8 8.3 7.9 ... paro.16.24 : num 4.8 4.5 10.2 3 5.2 7 4.5 3.3 6.3 10.8 ...

paro.25.49 : num 5.9 7.3 12.4 6.5 9.3 11.5 7.7 6 11.8 11.6 ... paro.50 : num 3.2 1.9 4.2 3 3.8 5.7 2.3 1 4.9 4.7 ...

var.telef : num -5.4 -10.8 6.6 25.5 13.6 23.1 41.3 66.6 44.3 6.2 ... adsl : num 53 21 2766 1426 504 ...

var.motor : num 60.3 54.9 42.4 34.6 46.5 ... var.ofic.bancos: num 0 0 4 2 0 32 0 0 1 -1 ...

var.cooperativa: num 0 0 0 0 0 -3 0 0 0 -1 ... var.industria : num 16.7 8.3 -14.9 0.5 -8.3 17.5 2.2 16.7 -3.1 1.9 ...

var.mayorista : num 50 0 0 16.1 -14.3 23.3 25 87.5 0 2.8 ... var.minorista : num -10.3 -13.6 14.7 19.1 -18.5 16.4 5.4 -7.7 -25.4 10.9 ...

$ var.hosteleria : num -40 -10 19.3 16.1 -42.9 6.9 -40.9 -13.3 -44.4 17.5 ...
```

Comenzamos con el «data management» expresión que debéis conocer y utilizar si trabajáis en el sector, así pareceréis más profesionales. Lo primero que quiero destacar es que estos datos tienen un total por provincia y comunidad autónoma que hemos de eliminar:

```r
datos.1=subset(datos,(substr(municipio,1,10) != "Total Prov" &

substr(municipio,1,10) != "Total C.A."))

nrow(datos)-nrow(datos.1)

summary(datos.1)
```

Hemos eliminado las provincias y las comunidades autónomas. El campo INE tiene el código de la población, aportará mucho más un identificador de la provincia, también es necesario generar la variable dependiente:

```r
datos.1ine=as.factor(as.integer(datos.1ine/1000))

datos.1target=as.factor(ifelse((datos.1paro.mujeres/datos.1paro.hombres-1)>=0.9,1,0))

#Eliminamos las variables que generan el target

datos.1=subset(datos.1,select=-c(paro.hombres,paro.mujeres))

table(datos.1target)

summary(datos.1)
```

Ya estamos en disposición de comenzar a dar forma a nuestro modelo:

```r
modelo.1=glm(target~.,data=datos.1[,-1],family=binomial)

summary(modelo.1)
```

Parece que tenemos un problema con la variable _var.pob.ext_ , vamos a considerar que su aportación puede ser «prescindible». Muchas veces lo perfecto es enemigo de lo bueno y ponernos a estudiar el motivo por el cual esta variable no funciona puede ser un problema, además disponemos de la variación total de la población y la variación de la población no extranjera. Es necesario discernir entre lo que es útil y lo que es prescindible. Estamos realizando un modelo que nos ayuda a comprender, la vida de millones de pacientes no depende de nuestros datos, por ello obcecarse en el refinamiento de la información puede hacernos perder el tiempo. Espero que estas palabras las haya leído algún (i)responsable de equipos dedicado al retail y entienda que un beneficio de un 2% no puede implicar un gasto en horas del 50% (que a gusto me he quedado). En fin, eliminamos la variable y analizamos el modelo:

```r
datos.1=subset(datos.1,select=-c(var.pob.ext))

modelo.1=glm(target~.,data=datos.1[,-1],family=binomial)

summary(modelo.1)
```

Empezamos a tener datos interesantes. La probabilidad de rechazar la hipótesis nula la fijo en 0.05 y la primera en la frente; las variaciones de población son influyentes. Curiosamente la extensión también, mayor extensión mayor probabilidad de que el paro femenino casi duplique al masculino. Curiosamente los datos de paro a tener en cuenta serían desde 2006 con alguna rara excepción. En cuanto a la edad parece que la relación es menor en los rangos de edad más
bajos y mayor en los más altos. Curioso que las variaciones de vehículos a motor y ADSL sean negativas, ¿el sueldo de la mujer va al consumo en la unidad familiar? Estudiemos como entran al modelo las variables que participan en el estudio con la función step (esta ejecución lleva un rato):

```r
pasos.modelo.1=step(modelo.1)

#Un poco redundante pero se ve mejor

step(pasos.modelo.1)

summary(modelo.1)
```

Con este código podemos ver como entran las variables en el modelo. El criterio de AIC nos da una medida de cuanto perdemos si eliminamos la variable del modelo. Mide el ajuste. A modo de ejemplo se podría asegurar que las 10 variables más significativas son:

```r
- paro2008 1 2026.1 2070.1

- paro1998 1 2028.3 2072.3

- var.pob 1 2029.8 2073.8

- extension 1 2030.5 2074.5

- var.pob.esp 1 2032.5 2076.5

- paro2006 1 2033.3 2077.3

- paro2007 1 2034.8 2078.8

- var.motor 1 2037.5 2081.5

- var.pob.96.01 1 2042.9 2086.9

- adsl 1 2048.4 2092.4
```

Estos datos nos pueden servir para conocer mejor la realidad, no sólo sirven para clasificar o predecir. Ha quedado un monográfico muy largo y farragoso, pero con código que os será de mucha utilidad en vuestro trabajo, como es mi intención el análisis no es lo más importante, le doy más importancia al código empleado desde el uso de _str_ (imprescindible) a _subset, glm, step_ ,… Saludos-