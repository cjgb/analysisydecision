---
author: rvaquerizo
categories:
- Formación
- R
- SAS
- Trucos
date: '2017-10-19T03:51:18-05:00'
lastmod: '2025-07-13T16:04:18.050667'
related:
- monografico-datos-agrupados-en-sas.md
- datos-agrupados-en-r-con-dplyr.md
- monografico-first-y-last-ejemplos-en-data.md
- creacion-de-ranking-con-r.md
- data-management-con-dplyr.md
slug: pasando-de-sas-a-r-primer-y-ultimo-elemento-de-un-campo-agrupado-de-un-data-frame
tags:
- dplyr
title: Pasando de SAS a R. Primer y ultimo elemento de un campo agrupado de un data
  frame
url: /pasando-de-sas-a-r-primer-y-ultimo-elemento-de-un-campo-agrupado-de-un-data-frame/
---

Las personas que están acostumbradas a trabajar con SAS emplean mucho los elementos first, last y by, [en el blog hay ejemplos al respecto](https://analisisydecision.es/monografico-first-y-last-ejemplos-en-data/), en R podemos hacer este trabajo con la librería “estrella” dplyr de un modo relativamente sencillo. A continuación se presenta un ejemplo para entender mejor como funciona, creamos un conjunto de datos aleatorio:

```r
id <- rpois(100,20)
mes <- rpois(100,3)+1
importe <- abs(rnorm(100))*100

df <- data.frame(cbind(id,mes,importe))
```
 

Tenemos un identificador, una variable mes y un importe y deseamos obtener el menor importe por mes el primer paso a realizar es ordenar el data frame de R por ese identificador, el mes y el importe en orden descendente:

```r
df <- df[with(df,order(id,mes,-importe)),]
```
 

Una vez ordenado el data frame de R tenemos que seleccionar el último elemento por id para seleccionar aquellos clientes con menor importe:

```r
library(dplyr)
df_bajo_importe <- df %>% group_by(id) %>% filter(row_number()==n())
```
 

Si deseamos seleccionar el mayor importe hacemos lo mismo:

```r
library(dplyr)
df_bajo_importe <- df %>% group_by(id) %>% filter(row_number()==1)
```
 

Las funciones group_by unidas a filter(row_number) equivalen a esos first y last de SAS. Saludos.