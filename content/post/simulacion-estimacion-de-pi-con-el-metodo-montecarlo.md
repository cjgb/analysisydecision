---
author: rvaquerizo
categories:
- Formación
- Monográficos
- R
date: '2009-10-12T09:51:08-05:00'
lastmod: '2025-07-13T16:06:16.645559'
related:
- trucos-excel-area-bajo-la-curva-roc.md
- el-sobremuestreo-mejora-mi-estimacion.md
- como-salva-la-linealidad-una-red-neuronal.md
- el-parametro-gamma-el-coste-la-complejidad-de-un-svm.md
- atentos-a-los-intervalos-de-confianza.md
slug: simulacion-estimacion-de-pi-con-el-metodo-montecarlo
tags:
- Método Montecarlo
- números aleatorios
- simulación
title: Simulación. Estimación de pi con el método Montecarlo
url: /blog/simulacion-estimacion-de-pi-con-el-metodo-montecarlo/
---

La **simulación** es un campo que está tomando una gran importancia. Nos está permitiendo evaluar comportamientos extremos sin ningún tipo de riesgos. Casi nadie se imaginaba que el escenario económico actual podía cambiar con la velocidad que lo está haciendo. Imaginemos una modificación brusca de los ratios de morosidad implicará que las entidades bancarias tengan que modificar sus fondos de previsión. Esta misma morosidad puede afectar a las aseguradoras de crédito que tienen que estimar sus provisiones técnicas. Ahora mismo es necesario simular las condiciones más extremas para los datos futuros y la simulación nos permite experimentar para aproximarnos al problema.

El primer acercamiento a la simulación lo vamos a realizar mediante el método Montecarlo. Se trata de estimar el valor de pi. El área de la circunferencia es A=pi*radio**2 Si la circunferencia tiene su centro en el origen y el radio es 1 (_circunferencia goniométrica_) entonces A=pi y si nos centramos en el primer cuadrante A=pi/4. Conocemos el resultado, ahora se trata de generar valores aleatorios, puntos en el cuadrante (1,1) del plano que pueden caer o no dentro del área de la circunferencia. Caerán dentro de ese área si la distancia del punto aleatorio al origen es menor que 1.

Para este trabajo emplearemos R. Generamos un _data.frame_ con 10.000 observaciones que son nubes de puntos aleatorios (x,y) del plano:

```r
x=runif(10000,0,1)

y=runif(10000,0,1)

simul=data.frame(cbind(x,y))
```

Si la distancia al centro es mayor o 1 está dentro del primer cuadrante de la circunferencia:

```r
simuldist=sqrt(x**2+y**2)

simulok=as.factor((simul$dist>=1)*1)
```

Realizamos un análisis gráfico:

```r
plot(simulx,simuly,pch=c(1,2)[simulok],col=c(1,2)[simulok])

x=seq(0,1,by=0.05) #Vamos a añadir una línea con la circunferencia

y=sqrt(1-x**2)

circunferencia=data.frame(cbind(x,y))

lines(circunferencia,col="white",lwd=5)
```

[![estima-pi.jpeg](/images/2009/10/estima-pi.thumbnail.jpeg)](https://analisisydecision.es/simulacion-estimacion-de-pi-con-el-metodo-montecarlo/224/ "estima-pi.jpeg")

La probabilidad de caer dentro de la circunferencia del primer cuadrante será el número de casos aleatorios con distancia menor de 1 entre los casos totales generados, todos los casos aleatorios que caen dentro de la circunferencia nos darán su área:

```r
nrow(subset(simul,ok=="0"))/nrow(simul)
```

Esta probabilidad al final es el área del primer cuadrante de la circunferencia por lo que si multiplicamos este dato por los 4 cuadrantes del plano que componen la circunferencia con centro en el origen y radio 1 tendremos el área A=pi. Un caso prototípico de simulación que nos permite aproximarnos a una técnica de análisis imprescindible.