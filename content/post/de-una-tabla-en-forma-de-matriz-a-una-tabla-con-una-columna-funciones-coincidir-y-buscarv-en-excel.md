---
author: rvaquerizo
categories:
  - excel
  - formación
  - trucos
date: '2023-01-18'
lastmod: '2025-07-13'
related:
  - truco-excel-repetir-celdas-en-funcion-de-los-valores-de-otra-celda.md
  - truco-excel-pasar-un-rango-de-varias-columnas-a-una.md
  - truco-excel-transponer-una-fila-en-varias-columnas-con-desref.md
  - trucos-excel-trasponer-con-la-funcion-indirecto.md
  - desref-para-trasponer-en-excel-varias-columnas.md
tags:
  - excel
  - formación
  - trucos
title: De una tabla en forma de matriz a una tabla con una columna. Funciones COINCIDIR y BUSCARV en Excel
url: /blog/de-una-tabla-en-forma-de-matriz-a-una-tabla-con-una-columna-funciones-coincidir-y-buscarv-en-excel/
---

En Excel nos encontramos con la necesidad de transformar matrices a columnas. El tema de la transposición con Excel ya se ha visto en el blog con anterioridad, siendo [el pasar de varias columnas a una con código](https://analisisydecision.es/truco-excel-pasar-un-rango-de-varias-columnas-a-una/) una de las entradas con más visitas de este sitio. El caso es que, en este caso, no es tan importante la transposición como la búsqueda de la celda mediante `BUSCARV`. La tarea que se expone es la siguiente:

![Tabla matricial a tabla con una columna](/images/2023/01/wp_editor_md_32b17e49e2dd219a103913c1d722fad7.jpg)

Los datos están en forma matricial y es necesario pasar a una sola columna a la vez donde hay dos campos clave: el `cliente` y el `mes`. Es necesario buscar el elemento. En Excel, cuando se busca una columna, se emplea `BUSCARV`, donde necesitamos el elemento a buscar (en este caso el `cliente`), el rango donde buscar (que es la tabla a nivel de `cliente` con distintas columnas por `mes`) y, adicionalmente, buscamos el `mes` que está en columna, por lo que éste debe ser el tercer parámetro que requiere `BUSCARV`. Para ello empleamos `COINCIDIR` junto con `BUSCARV`. Veamos cómo sería la función:

![Funciones COINCIDIR y BUSCARV en Excel](/images/2023/01/wp_editor_md_7698bffe54555b200b8424e1cbcc1e13.jpg)

Se trata de buscar el segundo campo clave de nuestra tabla en forma de columna dentro de las columnas de la matriz, y `COINCIDIR` nos dice qué columna es la que cruza. Hay que reseñar que empieza en 1 y es posible que no coja la columna correcta, por lo que debemos añadir otro elemento a `COINCIDIR` o bien sumar 1 (como se ve en la imagen anterior, si la primera columna de la matriz es la etiqueta de fila). En este caso, el segundo campo clave de mi cruce ya me indica la columna de la matriz, por lo que se puede buscar por fila y columna.

Espero que sea de utilidad.