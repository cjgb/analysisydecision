---
author: rvaquerizo
categories:
- Formación
- Seguros
date: '2010-04-19T02:36:21-05:00'
lastmod: '2025-07-13T15:57:01.694487'
related:
- el-modelo-multivariante-en-el-sector-asegurador-introduccion-i.md
- el-modelo-multivariante-en-el-sector-asegurador-los-modelos-por-coberturas-v.md
- introduccion-a-la-estadistica-para-cientificos-de-datos-capitulo-17-modelizacion-estadistica-seleccionar-variables-y-modelo.md
- el-modelo-multivariante-en-el-sector-asegurador-la-variable-dependiente-iii.md
- monografico-analisis-de-factores-con-r-una-introduccion.md
slug: el-modelo-multivariante-en-el-sector-asegurador-univariante-vs-multivariante-ii
tags: []
title: El modelo multivariante en el sector asegurador. Univariante vs multivariante
  (II)
url: /blog/el-modelo-multivariante-en-el-sector-asegurador-univariante-vs-multivariante-ii/
---

Hace mucho tiempo se empleaban resultados univariantes en la estructura de la tarifa. Los recargos y descuentos de la prima eran función de un análisis factor a factor, no se detectaban las interacciones entre ellos. **La política de tarificación no era segmentada** y no se ajustaba a la realidad y nos podíamos encontrar la situación prototípica siguiente:

![multivariante-sexo.JPG](/images/2010/04/multivariante-sexo.JPG)

En función del sexo debemos incrementar a los hombres un 30% la prima base.

![multivariante-edad.JPG](/images/2010/04/multivariante-edad.JPG)

Evidentemente a menor edad mayor incremento debe tener nuestra prima. Fijamos el 0 en 40 años. En futuras entregas veremos como fijar el 0 para decidir los recargos y descuentos de nuestra tarifa, habitualmente emplearemos la exposición pero en ocasiones los criterios comerciales hacen que modifiquemos este punto. Si cruzamos edad con sexo obtendríamos lo siguiente:

![multivariante-edad-sexo.JPG](/images/2010/04/multivariante-edad-sexo.JPG)

Existe una interacción entre la edad y el sexo que de forma univariante no podríamos detectar. Subimos demasiado la prima a mujeres jóvenes y poco a hombres jóvenes, por el contrario incrementamos un 30% a los hombres cuando en edades superiores a 40 años el comportamiento es el mismo que en las mujeres.

Se puede plantear una estructura tarifaria con interacciones entre pares de variables, pero una visión multivariante siempre ajustará mejor ya que nos permite analizar el efecto de cada factor de forma aislada (muy importante). Lo malo es que los resultados de los modelos pueden chocar con criterios comerciales, pero eso es harina de otro costal (también nos pasaba con los resultados univariantes y da muchos dolores de cabeza). En el ejemplo que nos ocupa, ¿se os ocurre alguna interacción más entre el sexo, la edad y algún otro factor? El tipo de vehículo, el número de hijos,… nos pueden indicar conductores secundarios encubiertos.

De todos modos el análisis univariante y el análisis bivariante ha de ser siempre el primer paso para nuestro modelo multivariante. Nos auditará la información disponible y nos ayudará a la **reclasificación de los factores** y nos permitirá una primera aproximación al comportamiento siniestral de nuestra cartera de clientes.