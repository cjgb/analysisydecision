---
author: rvaquerizo
categories:
- Formación
- SAS
- Trucos
date: '2010-08-05T06:49:04-05:00'
slug: trucos-sas-matrices-de-adyacencia-con-sas
tags:
- matrices
title: Trucos SAS. Matrices de adyacencia con SAS
url: /trucos-sas-matrices-de-adyacencia-con-sas/
---

SAS no está pensado para el cálculo matricial, pero hay ocasiones en las que hemos de trabajar con ellas. Uno de los casos típicos es la matriz de adyacencia. Se trata de partir de estos datos:

a b  
a e  
b c  
b e  
c e  
d a

Crear:  
a b c d e  
a 0 1 0 1 1  
b 1 0 1 0 1  
c 0 1 0 0 1  
d 1 0 0 0 0  
e 1 1 1 0 0

Yo planteo la siguiente metodología:

```r
*CONJUNTO DE DATOS DE PARTIDA;
data original;
input nodo1 nodo2;
datalines;
a b
a e
b c
b e
c e
d a
;run;
*A <-> B;
data original2;
set original original(rename=(nodo1=nodo2 nodo2=nodo1));
run;
*MAXIMOS DE PRESENCIA;
proc sql noprint ;
select distinct 'max(nodo2="'||compress(nodo2)||'") as '||compress(nodo2)||' '
into: instr separated by ","
from original2
order by 1;
*HACEMOS LOS MAXIMOS;
create table matriz as select
nodo1,
&instr.
from original2
group by 1;
quit;
```
 

Un método muy sencillo que busca en la matriz de partida el nodo de inicio y el nodo de fin. Creo que se entiende muy bien por eso, y porque estoy casi de vacaciones, no voy a entrar en detalles. Si alguien necesita esos detalles que contacte. Saludos.