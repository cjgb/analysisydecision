---
author: rvaquerizo
categories:
  - business intelligence
  - consultoría
  - data mining
date: '2008-04-28'
lastmod: '2025-07-13'
related:
  - proyecto-text-mining-con-excel-iii.md
  - proyecto-text-mining-con-excel-iv.md
  - proyecto-text-mining-con-excel-i.md
  - google-mining-analisis-de-las-paginas-indexadas-i.md
  - proyecto-text-mining-con-excel-pasa-a-ser-google-mining.md
tags:
  - business intelligence
  - consultoría
  - data mining
title: Proyecto. Text mining con Excel (II)
url: /blog/proyecto-text-mining-con-excel-ii/
---

Sin una tabla no hay `Text mining`. Hay que idear la forma de tabular las búsquedas que realice en `Google`. Desde `Excel` puedo abrir cualquier web. En este caso abriré la búsqueda [«formación `business intelligence`»](http://www.google.es/search?hl=es&q=formacion+business+intelligence&meta=) con `Excel` y veré exactamente lo mismo que puedo ver con un explorador web pero en una hoja de cálculo y con una estructura determinada. Hay que aprender a leer esta estructura para tabular la información.

Abrimos nuestra búsqueda de `Google` con `Excel` y tenemos algo parecido a esto:

![Mineria de textos 1](/images/2008/04/pyt_1_abrir.JPG)

En las primeras líneas hay unas cabeceras que no nos interesan porque son las herramientas para realizar búsquedas. Pero después de los botones de tenemos una frase muy importante»Resultados 1 – 10 de aproximadamente 373.000 de formacion `business intelligence`. (0,08 segundos) «. Nuestra búsqueda nos ha devuelto 373.000 entradas. Este puede ser el primer indicador del número de observaciones con las que vamos a trabajar. No considero necesario tabular todas las observaciones. Hay que pensar un momento en el que `Google` no nos aporta mayor información, por lo menos en este piloto no será necesario generar una tabla con casi 400.000 observaciones. Como `Excel` está limitado a 65.000 registros creo que analizar 30.000 resultados puede ser suficiente para no ralentizar nuestras ejecuciones. Si este piloto nos aporta información mas «jugosa» de lo que esperamos entonces habrá que plantearse el uso de `Access`.

Bien, 30.000 registros a 10 resultados por página. 3.000 páginas de búsqueda. 3.000 páginas web que debemos abrir con `Excel`. Será necesario diseñar un proceso en `Visual Basic` que recorra estas 3.000 páginas y las añada a una hoja que será nuestra tabla _maestra_. Cada resultado nos genera aproximadamente 6 registros:

![mineria de textos 2 ](/images/2008/04/pyt_2_filas.JPG)

A la vez que abrimos nuestras webs de búsqueda, ¿será más óptimo transponer y generar un solo registro? Hay que afinar bien el proceso de carga ya que la intención es que el piloto funcione con una búsqueda, pero a lo largo del proceso esta búsqueda puede mejorarse o incluso cambiarse.

En sucesivos días hayque analizar el proceso de carga de información porque si es muy lento no se podrán realizar múltiples busquedas.
