---
author: rvaquerizo
categories:
- excel
- trucos
date: '2016-03-08'
lastmod: '2025-07-13'
related:
- truco-excel-transponer-una-fila-en-varias-columnas-con-desref.md
- trucos-excel-transponer-con-la-funcion-desref.md
- trucos-excel-repetir-filas-o-columnas-con-la-funcion-desref.md
- trucos-excel-repetir-filas-con-desref.md
- trucos-excel-trasponer-con-la-funcion-indirecto.md
tags:
- desref
title: DESREF para trasponer en Excel varias columnas
url: /blog/desref-para-trasponer-en-excel-varias-columnas/
---
[Hoy han planteado una duda en el blog que me ha parecido interesante](https://analisisydecision.es/trucos-excel-trasponer-con-la-funcion-indirecto/#comment-94010) porque es un buen ejemplo de uso de la **función DESREF de Excel** para trasponer filas en columnas con cierto criterio. La idea que planteaba es realizar una trasposición de 3 en 3 elementos como indica en la figura:

![ejemplo_trasponer_desref](/images/2016/03/ejemplo_trasponer_desref-300x193.png)

Para entender como funciona la función DESREF lo mejor es pensar en lo siguiente: fijado un punto nos movemos x-filas ; x-columnas. En el ejemplo concreto el punto inicial está en la celda A1;0;0 si nos desplazamos a la derecha haremos A1;1;0 es decir, nos movemos a la derecha +1 y siempre mantenemos la columna porque estamos trasponiendo filas en columnas. Las coordenadas de la fila para la trasposición en nuestro ejemplo quedarían:

+0 | +1 | +2
---|---|---
+3 | +4 | +5
+6 | +7 | +8
+9 | +10 | +11

En este caso se ha hecho:

[![ejemplo_trasponer_desref_2](/images/2016/03/ejemplo_trasponer_desref_2-300x95.png)](/images/2016/03/ejemplo_trasponer_desref_2.png)

La fórmula lee un dato que va de 3 en 3 a la izquierda y suma +1 o +2 si es el primer o el segundo elemento que deseamos en columna. Evidentemente esta fórmula es mejorable pero es un buen ejemplo de DESREF en Excel. Saludos.