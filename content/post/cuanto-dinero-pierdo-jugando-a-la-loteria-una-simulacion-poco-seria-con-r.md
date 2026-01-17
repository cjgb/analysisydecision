---
author: rvaquerizo
categories:
- Formación
- Monográficos
- R
date: '2012-09-18T14:36:37-05:00'
lastmod: '2025-07-13T15:55:36.000728'
related:
- monografico-arboles-de-clasificacion-con-rpart.md
- informes-con-r-en-html-comienzo-con-r2html-i.md
- evaluando-la-capacidad-predictiva-de-mi-modelo-tweedie.md
- sobremuestreo-y-pesos-a-las-observaciones-ahora-con-r.md
- introduccion-a-la-estadistica-para-cientificos-de-datos-capitulo-10-probabilidad-y-distribuciones.md
slug: cuanto-dinero-pierdo-jugando-a-la-loteria-una-simulacion-poco-seria-con-r
tags:
- simulación
title: Cuánto dinero pierdo jugando a la lotería. Una simulación poco seria con R
url: /blog/cuanto-dinero-pierdo-jugando-a-la-loteria-una-simulacion-poco-seria-con-r/
---

![](/images/2012/09/teletexto_loteria.png)

Esta pantalla es muy habitual en mi televisor todos los jueves por la noche. Son los resultados de la Lotería Nacional de España, el sorteo de los jueves. Mi mujer insiste en comprar lotería para dejar de ser pobres. No es una buena opción. Aunque por lo menos ahora compramos lotería nacional. Antes jugábamos a eso de la Bonoloto, las probabilidades de que te toque son menores que la cantidad de sustancias dopantes que le encontraron al gran Alberto Contador. Eso lo entendió, pero había que jugar. ¿Y cuánto nos cuesta jugar?

Pues empecemos con el número de semanas que deseamos simular, unos 5 años, unas 250 semanas y simulemos números entre 0 y 99999 y los correspondientes premios que son:

  * 30.000 € al primer premio
  * 10.000 € al segundo premio
  * Distintos importes en función de las terminaciones

```r
#Número de semanas que jugamos
numsimul = 250
########################################################

# Repartimos los premios #
primer_premio = trunc(runif(numsimul,0,99999))
segundo_premio = trunc(runif(numsimul,0,99999))

# A lo mejor se escapa algún premio
premio75.1 = trunc(runif(numsimul,0,9999))
premio75.2 = trunc(runif(numsimul,0,9999))
premio75.3 = trunc(runif(numsimul,0,9999))

#
premio15.1 = trunc(runif(numsimul,0,999))
premio15.2 = trunc(runif(numsimul,0,999))
premio15.3 = trunc(runif(numsimul,0,999))
premio15.4 = trunc(runif(numsimul,0,999))
premio15.5 = trunc(runif(numsimul,0,999))
premio15.6 = trunc(runif(numsimul,0,999))
premio15.7 = trunc(runif(numsimul,0,999))
premio15.8 = trunc(runif(numsimul,0,999))
premio15.9 = trunc(runif(numsimul,0,999))
premio15.10 = trunc(runif(numsimul,0,999))
premio15.11 = trunc(runif(numsimul,0,999))

#
premio6.1 = trunc(runif(numsimul,0,99))
premio6.2 = trunc(runif(numsimul,0,99))
premio6.3 = trunc(runif(numsimul,0,99))

#
premio3.1=trunc(primer_premio %% 10)
premio3.2 = trunc(runif(numsimul,0,9))
premio3.3 = trunc(runif(numsimul,0,9))
```


No es un código muy «profesional» pero si ilustrativo. Para todos aquellos que tienen miedo a programar con R, también se pueden hacer «chapuzas». No es tan difícil. Ahora que tenemos los resultados de todos los sorteos durante esos casi 5 años vamos a estudiar cuánto dinero nos ha tocado:

Vamos a jugar con el número 1. Las distintas terminaciones las comparamos con el resto de la división del múltiplo de 10 correspondiente. En este punto, sabiendo que jugamos el número 1 analizamos nuestros premios:

```r
#Este es el número que jugamos
numero = 1

premios <- data.frame(premio=integer())
#Buscamos si nos toca
for (i in 1:numsimul){
  p1 = ifelse(primer_premio[i]==numero, 30000,0)
  p2 = ifelse(segundo_premio[i]==numero, 3000,0)
  p75.1 = ifelse(numero %% 10000==premio75.1[i],  75, 0)
  p75.2 = ifelse(numero %% 10000==premio75.2[i],  75, 0)
  p75.3 = ifelse(numero %% 10000==premio75.3[i],  75, 0)
  p15.1 = ifelse(numero %% 1000==premio15.1[i],   15, 0)
  p15.2 = ifelse(numero %% 1000==premio15.2[i],   15, 0)
  p15.3 = ifelse(numero %% 1000==premio15.3[i],   15, 0)
  p15.4 = ifelse(numero %% 1000==premio15.4[i],   15, 0)
  p15.5 = ifelse(numero %% 1000==premio15.5[i],   15, 0)
  p15.6 = ifelse(numero %% 1000==premio15.6[i],   15, 0)
  p15.7 = ifelse(numero %% 1000==premio15.7[i],   15, 0)
  p15.8 = ifelse(numero %% 1000==premio15.8[i],   15, 0)
  p15.9 = ifelse(numero %% 1000==premio15.9[i],   15, 0)
  p15.10 = ifelse(numero %% 1000==premio15.10[i], 15, 0)
  p15.11 = ifelse(numero %% 1000==premio15.11[i], 15, 0)
  p6.1 = ifelse(numero %% 100==premio6.1[i], 6, 0)
  p6.2 = ifelse(numero %% 100==premio6.2[i], 6, 0)
  p6.3 = ifelse(numero %% 100==premio6.3[i], 6, 0)
  p3.1 = ifelse(numero %% 10==premio3.1[i],3,0)
  p3.2 = ifelse(numero %% 10==premio3.2[i],3,0)
  p3.3 = ifelse(numero %% 10==premio3.3[i],3,0)

  premio = p1+p2+p75.1+p75.2+p75.3+p15.1+p15.2+p15.3+p15.4+p15.5+
    p15.6+p15.7+p15.8+p15.9+p15.10+p15.11+p6.1+p6.2+p6.3+p3.1+
    p3.2+p3.3
  premios <- rbind.data.frame(premios,premio )
  remove(total,p1,p2,p75.1,p75.2,p75.3,p15.1,p15.2,p15.3,p15.4,p15.5,
           p15.6,p15.7,p15.8,p15.9,p15.10,p15.11,p6.1,p6.2,p6.3,p3.1,
           p3.2,p3.3)
}

sum(premios)/(numsimul*3)

### [1] 0.432
```


Un código aun más chapuzante. Lo habréis ejecutado. Que triste así no me hago rico. A mi me ha salido que, de cada € que juego, pierdo unos 0,60 céntimos. Creo que este no es el camino para enriquecerme. Me voy a dedicar a la política, tampoco, soy un tipo muy íntegro. Tendré que seguir trabajando...