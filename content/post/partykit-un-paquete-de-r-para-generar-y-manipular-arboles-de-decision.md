---
author: cgbellosta
categories:
  - data mining
  - r
date: '2009-06-09'
lastmod: '2025-07-13'
related:
  - trucos-r-llevar-a-sas-las-reglas-de-un-arbol-de-decision.md
  - monografico-arboles-de-decision-con-party.md
  - sobre-la-historia-de-cart-y-rpart.md
  - noticias-del-congreso-de-usuarios-de-r.md
  - reunion-del-grupo-de-usuarios-de-r-en-madrid-el-28-de-enero.md
tags:
  - sin etiqueta
title: 'partykit: un paquete de R para generar y manipular árboles de decisión'
url: /blog/partykit-un-paquete-de-r-para-generar-y-manipular-arboles-de-decision/
---

Los usuarios de R disponen de una serie de algoritmos estándar para generar y manipular árboles de decisión. Los más habituales están contenidos en alguno de los siguientes paquetes:

- [rpart](http://cran.r-project.org/web/packages/rpart/index.html), tal vez mi favorito
- [RWeka](http://cran.r-project.org/package=RWeka), un paquete más genérico que permite realizar llamadas a funciones de [Weka](http://www.cs.waikato.ac.nz/ml/weka/) desde R
- [mvpart](http://cran.r-project.org/web/packages/mvpart/index.html)
- [party](http://cran.r-project.org/package=party)

Cada uno de ellos tiene un interfaz distinto y operaciones como las de realizar predicciones, dibujar los árboles, etc. exigen conocer funciones específicas. (Éste es, de hecho, un problema genérico de R derivado de su naturaleza cooperativa).

Pero la situación va a cambiar con el paquete [partykit](http://r-forge.r-project.org/projects/partykit/), todavía en fase de desarrollo, que, según sus autores, va a ofrecer «una representación unificada de los árboles, así como métodos `predict()`, `print()` y `plot()`«. Esto además de otras novedades, como una reimplementación del algoritmo CHAID y mejoras en la visualización de algunos de los tipos de árboles más habituales.

La presentación en sociedad del nuevo paquete va a realizarse en la [conferencia de usuarios de R ](http://www2.agrocampus-ouest.fr/math/useR-2009/)y es de esperar que, una vez dispongamos de una versión estable del paquete, cambie de manera sustancial la manera en que utilicemos esta familia de modelos tan importante en la práctica.
