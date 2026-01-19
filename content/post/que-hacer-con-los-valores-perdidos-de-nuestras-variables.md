---
author: rvaquerizo
categories:
  - data mining
date: '2009-09-16'
lastmod: '2025-07-13'
related:
  - entrenamiento-validacion-y-test.md
  - macros-sas-hacer-0-los-valores-missing-de-un-dataset.md
  - trucos-sas-informes-de-valores-missing.md
  - truco-sas-transformaciones-de-variables-con-arrays.md
  - trucos-sas-lista-de-variables-missing.md
tags:
  - missing values
  - tratamiento
title: ¿Qué hacer con los valores perdidos de nuestras variables?
url: /blog/c2bfque-hacer-con-los-valores-perdidos-de-nuestras-variables/
---

Creo que casi todos los que han hecho modelos matemáticos alguna vez en su vida se han encontrado con la pregunta que titula este breve artículo. Aunque más que artículo es una reflexión y sobre todo espero que al final sea un pequeño foro de ideas y de métodos con los que hacer frente a este problema.

Lo primero que me planteraría yo es: ¿por qué perdemos datos? Podemos tener una imperfección a la hora de recoger la información y podría ayudarnos a mejorar el proceso. También un valor perdido puede ser un valor en si mismo. No es lo mismo tener un consumo de 0 euros con un teléfono móvil que no tener teléfono móvil, sin embargo si sabemos que tenemos teléfono móvil un valor perdido es un 0 ya que no aparece el consumo en nuestros sistemas; en la telefonía este es un caso prototípico de valor perdido. Otro ejemplo es la medición de un paciente que ha abandonado el estudio, en este caso el dato recogido es nulo, y debemos evaluar si tener en cuenta ese registro para nuestro estudio. El primer paso ante un análisis de los valores perdidos es definir «valor perdido».

Por otro lado podemos tener valores perdidos cuantitativos o cualitativos. Tiene hipoteca si o no, en caso de missing ¿qué ponemos? Importe de la hipoteca, en caso de missing ¿ponemos un 0? Para los valores categóricos podemos poner el valor más frecuente de nuestra muestra pero también puede resultar interesante una nueva categoría «desconocido». Para las variables continuas podemos quedarnos con la media pero hay que tener en cuenta que nos afecta a la aleatoriedad de los datos y a la consistencia de la información. Imaginaos: Tiene hipoteca: «desconocido» Importe de hipoteca: 150.000 Parece un poco incongruente. Además otro de los problemas que nos plantea la aparición de missing es cuantificar el valor de predicción de una variable con un gran número de valores perdidos, puede ser que no nos interese incluirla en el modelo.

En la práctica casi todos los paquetes estadísticos tienen implementados procesos que nos permiten sustituir los valores perdidos. También podemos plantearnos estudios más complejos como la utilización de árboles de decisión o análisis discriminante fijando como target «el ser valor perdido». Al final es muy probable que todo dependa de la finalidad de nuestro análisis, no es lo mismo una selección de clientes para una campaña de marketing en telefonía que una prueba médica.

Espero vuestras opiniones. Saludos.
