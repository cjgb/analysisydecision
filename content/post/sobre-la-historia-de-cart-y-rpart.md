---
author: cgbellosta
categories:
- Data Mining
- Modelos
- R
date: '2009-06-25T05:26:26-05:00'
lastmod: '2025-07-13T16:06:19.953064'
related:
- trucos-r-llevar-a-sas-las-reglas-de-un-arbol-de-decision.md
- partykit-un-paquete-de-r-para-generar-y-manipular-arboles-de-decision.md
- monografico-arboles-de-decision-con-party.md
- porque-me-gusta-r.md
- recodificar-el-valor-de-un-factor-en-r.md
slug: sobre-la-historia-de-cart-y-rpart
tags:
- árboles de decisión
- CART
- R
title: Sobre la historia de CART y rpart
url: /sobre-la-historia-de-cart-y-rpart/
---

Hace unos días conversábamos Raúl y yo sobre árboles de clasificación. En particular, hablábamos de [CART](http://www.salfordsystems.com/cart.php), el algoritmo propietario de [Salford Systems](http://www.salfordsystems.com). Me intrigó saber cuál sería la diferencia entre dicho algoritmo y la alternativa existente en R, [rpart](http://cran.r-project.org/web/packages/rpart/index.html).

El autor de dicho paquete, [Terry Therneau](http://mayoresearch.mayo.edu/staff/therneau_tm.cfm), tuvo la gentileza de ofrecer una introducción histórica al particular de la que ofrezco algunos fragmentos que traduzco yo mismo a continuación:

[…]

Tanto el programa comercial CART como la función rpart() están basados en el libro [Classification and Regression Trees](http://www.amazon.com/Classification-Regression-Trees-Leo-Breiman/dp/0412048418). Como lector y revisor de alguno de sus primeros borradores, llegué a dominar la materia. CART comenzó como un enorme programa en Fortran que escribió Jerry Friedman y que sirvió para contrastar las ideas contenidas en el libro. Tuve el código durante un tiempo y realicé algunos cambios, pero me resultó demasiado frustrante el trabajar con él. Fortran no es el lenguaje adecuado para un algoritmo recursivo […]. Salford Systems adquirió los derechos de dicho código e ignoro si alguna de las líneas origininales permanecen en él todavía. Mantuve muchas conversaciones con su principal programador (hace 15 o 20 años) sobre procedimientos para hacerlo más eficiente, esencialmente un problema interesante de indexación óptima.

La versión original de rpart coincidía con CART de manera casi absoluta. La única diferencia reseñable estaba en los _surrogates_ : yo me decantaba por el _surrogate_ con el mayor número de coincidencias mientras que CART lo hacía por el que tenía mayor porcentaje de coincidencias. La consecuencia es que rpart favorece aquellas variables con menos _missings_. Desde entonces, ambos programas han evolucionado. Yo no he tenido tiempo de trabajar de manera sustancial en rpart durante los últimos diez años. No es de extrañar, por tanto, que los gráficos y la visualización hayan quedado algo anticuados; lo que es más sorprendente es que todavía subsistan.

Rpart se llama rpart porque los autores registraron comercialmente el término CART. Era la mejor alternativa que se me ocurrió entonces. Me parece curioso que una de las consecuencias de haber registrado «CART» es que ahora se utilice «particionamiento recursivo» mucho más a menudo que CART como nombre genérico para los métodos basados en árboles.

[…]

El lector queda invitado a extraer sus propias conclusiones.