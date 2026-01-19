---
author: rvaquerizo
categories:
  - r
  - trucos
date: '2010-01-31'
lastmod: '2025-07-13'
related:
  - macros-sas-hacer-0-los-valores-missing-de-un-dataset.md
  - truco-sas-transformaciones-de-variables-con-arrays.md
  - trucos-sas-lista-de-variables-missing.md
  - trucos-simples-para-rstats.md
  - trucos-sas-informes-de-valores-missing.md
tags:
  - missing values
  - sapply
title: Truco R. Valores perdidos a 0, ejemplo de uso de sapply
url: /blog/truco-r-valores-perdidos-a-0-ejemplo-de-uso-de-sapply/
---

Muy habitual partinos la cabeza con valores perdidos en R. Los NA pueden darnos algún quebradero de cabeza. Este truco es muy sencillo, transforma valores missing a 0 y nos sirve para aplicar funciones a _data.frame_ con la función _sapply_. Veamos el sencillo ejemplo:

```r
x=c(1,23,5,9,0,NA)

y=c(5,45,NA,78,NA,34)

dataf=data.frame(cbind(x,y))

mean(datafx,na.rm=TRUE)

mean(datafy,na.rm=TRUE)

#Podría interesarnos tener en cuenta los NAs

sum(datafx,na.rm=TRUE)/nrow(dataf)

sum(datafy,na.rm=TRUE)/nrow(dataf)
```

Tenemos un _data.frame_ con dos variables que contienen valores perdidos, deseamos crear una función que pase estos valores a 0 y aplicarlo al _data.frame_ de partida:

```r
haz.cero.na=function(x){

ifelse(is.na(x),0,x)}

dataf.2=data.frame(sapply(dataf,haz.cero.na))

dataf

dataf.2
```

Un ejemplo muy sencillo de aplicación de funciones con _sapply_ a _data.frames_ perfectamente extrapolable a matrices y vectores. [Erreros tiene una entrada al respecto](http://erre-que-erre-paco.blogspot.com/2009/12/aplicar-una-funcion-un-vector-o-una.html). Saludos.
