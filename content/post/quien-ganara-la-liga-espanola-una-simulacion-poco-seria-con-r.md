---
author: rvaquerizo
categories:
- R
- Sin catergoría
date: '2012-02-04T18:19:27-05:00'
slug: '%c2%bfquien-ganara-la-liga-espanola-una-simulacion-poco-seria-con-r'
tags:
- ''
- simulación
title: ¿Quién ganará la liga española? Una simulación poco seria con R
url: /c2bfquien-ganara-la-liga-espanola-una-simulacion-poco-seria-con-r/
---

Está a punto de acabar un partido de futbol entre la Real Sociedad y el Barcelona y me temo que esta jornada vuelven a ganar los equipos que más dinero ganan por los derechos televisivos de la liga española. El Real Madrid está a 7 puntos del Barcelona. Está claro que el Barcelona ganará al Real en su campo. Si asumimos que los dos equipos tienen un 80% de posibilidades de ganar el partido, un 10% de empatarlo y un 10% de perderlo ¿cual es la probabilidad de que gane alguno de los dos equipos?

Pido disculpas por la «poca profesionalidad» del código pero últimamente pico poco código en R, de todas formas es muy sencillo de entender y no voy a entrar en profundidad:

`library(memisc)`

```r
final_madrid<-data.frame()

for (i in 1:1000){

madrid = runif(16)

madrid <- recode(madrid,

0 <- range(0,0.1),

1 <- range(0.1,0.2),

3 <- range(0.2,1))

final_madrid = rbind(final_madrid,sum(madrid,52))}
```

final_barcelona<-data.frame()  
for (i in 1:1000){  
barcelona = runif(16)  
barcelona <\- recode(barcelona,  
0 <\- range(0,0.1),  
1 <\- range(0.1,0.2),  
3 <\- range(0.2,1))  
final_barcelona = rbind(final_barcelona,sum(barcelona,45,3))}

resultado_liga = cbind(final_madrid,final_barcelona)  
names(resultado_liga)=c("madrid","barcelona")

resultado_ligacampeon = ifelse(resultado_ligamadrid>resultado_liga$barcelona,"Madrid","Barcelona")

`table(resultado_liga$campeon)`

He lanzado 1000 simulaciones y he obtenido unas probabilidades de 26% a favor del Barcelona y un 74% a favor del Madrid. ¿En las casas de apuestas está el resultado final 4 a 1? A ver que pasa, en unos meses volveré sobre esta entrada y espero decir que al final ganó la liga otro equipo, pero eso si que es improbable. Saludos.