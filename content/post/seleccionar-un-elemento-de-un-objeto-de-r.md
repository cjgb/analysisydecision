---
author: rvaquerizo
categories:
- Formación
- R
date: '2013-12-23T07:21:34-05:00'
lastmod: '2025-07-13T16:06:05.429981'
related:
- cuidado-con-el-p-valor-en-los-estudios-de-independencia.md
- trucos-r-llevar-a-sas-las-reglas-de-un-arbol-de-decision.md
- analisis-de-textos-con-r.md
- manual-curso-introduccion-de-r-capitulo-9-introduccion-a-la-regresion-lineal-con-r.md
- obteniendo-los-parametros-de-mi-modelo-gam.md
slug: seleccionar-un-elemento-de-un-objeto-de-r
tags:
- STR
title: Seleccionar un elemento de un objeto de R
url: /seleccionar-un-elemento-de-un-objeto-de-r/
---

Quedarnos con un elemento específico de un objeto en R. [Viene de una duda planteada por un lector](https://analisisydecision.es/truco-malo-de-r-leer-datos-desde-excel/) que surgía a raíz de un [post dedicado al p-valor y al tamaño muestral](https://analisisydecision.es/cuidado-con-el-p-valor-en-los-estudios-de-independencia/). Jose Ignacio desea almacenar en un objeto el p-valor asociado a un test de Wald para la independencia entre los niveles de un factor. Una sugerencia para poder trabajar con este elemento:

```r
y = c(rep(1,200),rep(0,100))
x = c(rep(1,32),rep(0,168),rep(1,15),rep(0,85))
datos = data.frame(cbind(y,x))
table(datos)

modelo.1=glm(y~x,data=datos,family=binomial)
summary(modelo.1)
```
 

Para la realización del test de Wald con R vamos a emplear la librería _lmtest_ :

```r
library(lmtest)
guarda = waldtest(modelo.1)
str(guarda)
```
 

Y ahora la “parte interesante” de esta entrada, cómo nos quedamos con el p-valor asociado al test de independencia de Wald que está en el objeto _guarda_ :

```r
pvalor_test = guarda[2,4]
```
 

Recordad siempre que _str_ es la clave cuando realizamos este tipo de tareas. Saludos.