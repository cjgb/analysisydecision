---
author: rvaquerizo
categories:
- formación
- sas
date: '2011-08-27'
lastmod: '2025-07-13'
related:
- trucos-sas-muestras-aleatorias-con-y-sin-reemplazamiento.md
- parametro-asociado-a-una-poisson-con-sas.md
- trucos-sas-lista-de-datasets-en-macro-variable.md
- test-de-bondad-de-ajuste-con-sas.md
- trucos-sas-muestreo-con-proc-surveyselect.md
tags:
- números aleatorios
title: Números aleatorios con SAS
url: /blog/numeros-aleatorios-con-sas/
---
En un sólo paso DATA quiero mostraros las funciones más habituales para generar números aleatorios con SAS. Una entrada para que os copiéis el código y lo analicéis con SAS. Quiero que sirva de guía para que recordéis las funciones más empleadas, además será muy útil para los que se estén iniciando en el uso de SAS:

```r
data aleatorios;
drop a b raiz n p;
raiz=20;
do i=1 to 2000;
* DISTRIBUCIÓN UNIFORME;
uniforme = ranuni(raiz);
* ALEATORIO ENTRE 2 NUMEROS;
a=2; b=10;
aleatorio_entre = a+(b-a)*ranuni(raiz);
* NORMAL(0,1);
normal = rannor(raiz);
* NORMAL(a,b);
normal_a_b = b*rannor(raiz)+a;
* POISSON MEDIA a;
poisson = ranpoi(raiz,a);
*BINOMIAL TAMAÑO n Y PROBABILIDAD p;
n=10; p=0.5;
binomial_n_p = ranbin(raiz,n,p);
* EXPONENCIAL 1;
exponencial_1 = ranexp(raiz);
* GAMMA(a);
gamma_l = rangam(raiz,a);
* VALORES ALEATORIOS ENTRE 1 Y 5 CON PROBABILIDADES p1 p2 ...;
valores = rantbl(raiz,0.3,0.1,0.2,0.2,0.6);
output;
end;run;
```