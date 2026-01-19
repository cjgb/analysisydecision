---
author: rvaquerizo
categories:
- opinión
- python
date: '2019-02-03'
lastmod: '2025-07-13'
related:
- monografico-regresion-logistica-con-r.md
- introduccion-a-la-estadistica-para-cientificos-de-datos-capitulo-7-descripcion-grafica-de-variables.md
- los-pilares-de-mi-simulacion-de-la-extension-del-covid19.md
- un-acercamiento-a-graph-ods-graphs-proc-sgplot.md
- el-modelo-multivariante-en-el-sector-asegurador-univariante-vs-multivariante-ii.md
tags:
- kdeplot
- seaborn
title: Las mujeres son más inteligentes pero no están en puestos directivos
url: /blog/las-mujeres-son-mas-inteligentes-pero-no-estan-en-puestos-directivos/
---
A raíz de una noticia sobre la reestructuración del consejo directivo de un gran banco en España donde sólo una mujer ha sido elegida entre los 12 puestos de dirección general me ha surgido la oportunidad para explicar que es una distribución de probabilidad, que es una distribución normal y que es la media y la desviación típica.

Aquí tenéis en python un código que simula el IC de los hombres y el IC de las mujeres, no me he complicado mucho la vida ni he buscado datos al respecto pero leyendo un poco creo que deben de parecerse mucho a esto:

```r
import numpy as np
import matplotlib.pyplot as plt
import seaborn as sns

hombres = np.random.normal(loc=60, scale=32, size=10000)
mujeres = np.random.normal(loc=70, scale=25, size=10000)

p1=sns.kdeplot(hombres, shade=True, color="r")
p1=sns.kdeplot(mujeres, shade=True, color="b")
sns.plt.show()
```
 ![](/images/2019/02/Density_plot_several_variables.png)

Bonito gráfico de densidades con varias variables hecho con seaborn y kdeplot de sintaxis sencilla que pone de manifiesto con unos datos simulados (con cierto talento) que en media la mujer es un 15% más inteligente que el hombre, pero la dispersión de la inteligencia del hombre es mayor, o como le he dicho a la persona que le he explicado que es la distribución normal, hay hombres muy tontos y hombres muy listos, muchos más que mujeres muy tontas y mujeres muy listas; así es la biología.

Pero ya os digo yo que la relación de hombres/mujeres inteligentes no es 1/12, así que esa importante entidad bancaria no está tomando decisiones correctas. Ellos verán lo que hacen pero no ha sido una medida inteligente, probablemente porque la ha tomado un hombre.