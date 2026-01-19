---
author: rvaquerizo
categories:
- formación
- r
- trucos
date: '2011-01-07'
lastmod: '2025-07-13'
related:
- recodificar-el-valor-de-un-factor-en-r.md
- trucos-simples-para-rstats.md
- trabajando-con-factores-en-r-attach-frente-a-within.md
- truco-malo-de-r-leer-datos-desde-excel.md
- analisis-de-textos-con-r.md
tags:
- automatizar código
- eval
- parse
- paste
- r
- replicate
title: Truco R. Eval, parse y paste para automatizar código
url: /blog/truco-r-eval-parse-y-paste-para-automatizar-codigo/
---
La función _**paste**_ nos permite concatenar cadenas de texto con R:

`paste("Dato",rep(1:10),sep="")`

_**Parse**_ recoge una expresión pero no la evalúa:

`parse(text="sqrt(121)")`

Y por último _**eval**_ evalúa una expresión:

`eval(parse(text="sqrt(121)"))`

Interesantes funciones que nos pueden permitir automatizar códigos recursivos o códigos guardados como objetos en R. Imaginemos el siguiente ejemplo de R:

```r
ejemplo1 <- data.frame(replicate (20,rpois(20,10)))

nom <- paste("dato",1:20,sep="")

names(ejemplo1) <- nom

summary(ejemplo1)
```

Hemos automatizado los 20 nombres de un _data frame_ con datos aleatorios con una distribución de poissón de media 10 creado con la función _replicate_. Ahora imaginemos que deseamos transformar en factor sólo aquellos elementos del _data frame_ con un sufijo par (datos2, datos4, …). Podemos crear una función o podemos crear ejecuciones de código R del siguiente modo:

```r
ejecucion <- paste("ejemplo1dato",seq(2,20,by=2),"<-as.factor(ejemplo1dato",

seq(2,20,by=2),")",sep="")

ejecucion

[1] "ejemplo1dato2<-as.factor(ejemplo1dato2)"

[2] "ejemplo1dato4<-as.factor(ejemplo1dato4)"

[3] "ejemplo1dato6<-as.factor(ejemplo1dato6)"

[4] "ejemplo1dato8<-as.factor(ejemplo1dato8)"

[5] "ejemplo1dato10<-as.factor(ejemplo1dato10)"

[6] "ejemplo1dato12<-as.factor(ejemplo1dato12)"

[7] "ejemplo1dato14<-as.factor(ejemplo1dato14)"

[8] "ejemplo1dato16<-as.factor(ejemplo1dato16)"

[9] "ejemplo1dato18<-as.factor(ejemplo1dato18)"

[10] "ejemplo1dato20<-as.factor(ejemplo1dato20)"
```

Ahora tenemos que hacer que un objeto con instrucciones se ejecuten con _parse_ y _eval_ :

```r
eval(parse(text=ejecucion))

summary(ejemplo1)
```

Hemos transformado en factores los elementos con sufijo par. Esto puede realizarse con _sapply_ pero merece la pena que le echéis un vistazo a este proceso, lo ejecutéis y aprendáis una forma de automatizar código. En breve tendréis otro ejemplo de uso de esta metodología muy parecida a la que empleamos cuando programamos en otros lenguajes con menos futuro que R. Saludos.