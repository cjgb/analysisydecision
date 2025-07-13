---
author: rvaquerizo
categories:
- R
date: '2014-09-26T16:15:35-05:00'
slug: 6-grados-de-separacion-una-simulacion-poco-seria-con-r
tags:
- simulación
title: ¿6 grados de separación? Una simulación poco seria con R
url: /6-grados-de-separacion-una-simulacion-poco-seria-con-r/
---

Me pregunto si puedo demostrar la [teoría de los seis grados de separación](http://es.wikipedia.org/wiki/Seis_grados_de_separaci%C3%B3n). Tengo muy oxidados los bucles con R. Ganas de probar Amazon Web Services.Pues manos a la obra. ¿Es posible con R establecer que una persona esté enlazada con otra en menos de 6 pasos? Hoy no voy a probrar Amazon Web Services, me voy a limitar a mostraros que se me ha ocurrido para demostrar esta teoría.

Dentro de una población un individuo manda una carta. Creamos una red de cartas y buscamos en que punto de esa red le devuelven la carta. No me atrevo a determinar el número de amigos que puede tener un individuo. Tampoco tengo tiempo para realizar una simulación con los 5.000 millones de habitantes del planeta. Así que os planteo una simulación muy poco seria con R. Muy sencillo:  
######################################################  
#La población es de 5.000.000 personas  
poblacion = 5000000

grados <-c()

for (i in 1:100){  
#Seleccionamos a una persona  
individuo <\- sample( 1:poblacion , 1 )  
#Creamos unared de envíos  
red = sample( 1:poblacion, poblacion )

envio=1  
repeat  
{ if (individuo==red[envio]) break  
envio = envio + 1;  
}  
grados = cbind(grados,round(envio^(1/rpois(1,10))))  
}

5 millones de personas, hacemos un bucle for que nos permite realizar 100 simulaciones. Seleccionamos un individuo al azahar (como decía aquel) y creamos una red de envíos con todas las personas hasta el tamaño de la población. Esto seguramente se pueda mejorar. Si el individuo que ha mandado la carta aparece dentro de mi red ya puedo determinar el número de envíos. Y ahora viene lo menos riguroso. En función del número de envíos puedo determinar el número de grados de separación hasta que a mi individuo inicial le llega la carta. Los grados serían la raíz del número de amigos y en este caso determino que el número de amigos sigue una distribución de poisson de media 10. Vamos acumulando las simulaciones en un vector del que calculamos la mediana y obtenemos 5 grados de separación.

No sé si 6 grados será suficiente. A ver si arrancamos con AWS. Saludos.