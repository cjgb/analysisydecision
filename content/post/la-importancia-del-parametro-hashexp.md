---
author: rvaquerizo
categories:
- formación
- monográficos
- sas
date: '2010-11-16'
lastmod: '2025-07-13'
related:
- laboratorio-de-codigo-sas-ordenaciones-con-hash-vs-proc-sort.md
- objetos-hash-para-ordenar-tablas-sas.md
- trucos-sas-porque-hay-que-usar-objetos-hash.md
- trucos-sas-mejor-que-hash-in-para-cruzar-tablas.md
- truco-sas-cruce-con-formatos.md
tags:
- hashexp
- objetos hash
title: La importancia del parámetro HASHEXP
url: /blog/la-importancia-del-parametro-hashexp/
---
La última entrada (de momento) sobre objetos HASH en SAS. Quiero analizar la importancia que tiene el parámetro _hashexp_ a la hora de crear el objeto _hash_ cuando deseamos ordenar un conjunto de datos. Para ello he realizado un experimento con SAS cuyo código podéis descargaros .[aquí](/images/2010/11/pruebas-hash-exponente.sas "pruebas-hash-exponente.sas"). Es un código de calidad muy baja pero que da como resultado el siguiente gráfico:

![ejecuciones-hashexp-distintas.png](/images/2010/11/ejecuciones-hashexp-distintas.png)

Se trata de un experimento en el que ordenamos un dataset con 7 variables y diferentes tamaños, se miden los tiempos de ordenación para exponentes 2, 5, 10 y 20. Se realizan 2 réplicas del experimento para evitar algún problema con el equipo (deberían hacerse más pero tarda mucho) y el resultado de la combinación entre tamaño-exponente nos da como resultado un tiempo de ejecución que graficamos. En el eje y del gráfico tenemos los tiempos de ejecución y en el eje x el tamaño en miles del dataset ordenado. Para cada combinación exponente-tamaño se han realizado dos ordenaciones y se han medido los tiempos. El resultado obtenido, como cabía esperar, indica que el exponente, el parámetro _hashexp_ , tiene mucha importancia a la hora de realizar ordenaciones mediante objetos _hash_ con SAS. En nuestro experimiento las diferencias las encontramos a partir de los 2 millones de registros y se van incrementando en función del tamaño del dataset, sin embargo en la última ejecución las diferencias parecen reducirse. Las líneas 2, 5 y 10 obtienen resultados muy similares siendo el exponente 20 el que mejores resultados ofrece.

No parece deducirse una norma para determinar el número de tablas que empleará el algoritmo a la hora de realizar la ordenación sin embargo si parece que en datasets medianos no es muy influyente y es en el momento en el que trabajamos con datasets muy grandes cuando debemos utilizar un mayor número de tablas.

El experimento hay que mejorarlo y analizar si la diferencia es significativa, eso se lo dejo a mis lectores ya que muchos de ellos disponen de potentes servidores y no dejan inútiles sus equipos cuando ejecutan este tipo de procesos.