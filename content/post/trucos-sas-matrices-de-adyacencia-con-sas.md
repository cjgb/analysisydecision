---
author: rvaquerizo
categories:
  - formación
  - sas
  - trucos
date: '2010-08-05'
lastmod: '2025-07-13'
related:
  - minimo-de-una-matriz-de-datos-en-sas.md
  - trucos-sas-operaciones-con-tablas-de-dimensiones-con-sas.md
  - trucos-sas-trasponer-con-sql-para-torpes.md
  - truco-sas-cruce-con-formatos.md
  - proc-sql-merge-set.md
tags:
  - matrices
title: Trucos SAS. Matrices de adyacencia con SAS
url: /blog/trucos-sas-matrices-de-adyacencia-con-sas/
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
```sas
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
