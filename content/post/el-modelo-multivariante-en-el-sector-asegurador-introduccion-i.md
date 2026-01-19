---
author: rvaquerizo
categories:
- formación
- modelos
- seguros
date: '2010-04-14'
lastmod: '2025-07-13'
related:
- el-modelo-multivariante-en-el-sector-asegurador-los-modelos-por-coberturas-v.md
- el-modelo-multivariante-en-el-sector-asegurador-univariante-vs-multivariante-ii.md
- el-modelo-multivariante-en-el-sector-asegurador-la-variable-dependiente-iii.md
- introduccion-a-la-estadistica-para-cientificos-de-datos-capitulo-16-modelizacion-estadistica-conociendo-los-datos.md
- introduccion-a-la-estadistica-para-cientificos-de-datos-capitulo-17-modelizacion-estadistica-seleccionar-variables-y-modelo.md
tags:
- glm
- modelo multivariante
- tarificación
title: El modelo multivariante en el sector asegurador. Introducción (I)
url: /blog/el-modelo-multivariante-en-el-sector-asegurador-introduccion-i/
---
Con ese artículo comienza una serie que nos permitirá aproximarnos a los métodos estadísticos multivariantes empleados para la obtención de la **estructura óptima de la tarifa** en un el sector asegurador. No es un método novedoso. La práctica totalidad de las compañías aseguradoras cuentan con estos procesos en su operativa diaria. Desde el punto de vista de muchos expertos el sector asegurador tiene 4 escalones para adaptarse técnicamente a la realidad del mercado:

  * Modelo multivariante
  * Zonificación
  * Optimización de los precios del nuevo negocio. Posición competitiva
  * Optimización de los precios de renovación

En estos artículos nos vamos a centran en ese primer escalón. Insisto, no es nada innovador lo que se va a plantear en estas líneas. La mayoría de las compañías están pasando ya el segundo escalón, ya tienen la zonificación incluida en la estructura de sus tarifas. Esta serie de artículos serán un acercamiento a uno de los métodos de análisis multivariante que mayor éxito ha tenido en los últimos años.

El objetivo final de todo el proceso será encontrar para una prima base y una serie de multiplicadores que llamaremos **relatividades** que corrijan esta prima base en función de los comportamientos siniestrales esperados analizando nuestros datos históricos. Creamos grupos homogéneos de **riesgos** , segmentos, a los que les aplicaríamos la misma corrección para obtener la prima de riesgo que mejor ajusta al comportamiento esperado. Para comprender mejor todo el proceso se empleará como ejemplo la estructura de la tarifa de autos y nos centraremos en la garantía de responsabilidad civil que es la garantía con mayor peso dentro de la prima de autos.

Para nuestro ejemplo vamos a emplear fundamentalmente los siguientes riesgos:

**Datos del vehículo:**

  * Potencia
  * Combustible
  * Peso
  * Uso del vehículo (kilómetros y tipo)
  * Antigüedad del vehículo

**Datos del cliente:**

  * Edad
  * Sexo
  * Experiencia
  * Estado civil
  * Número de hijos
  * Antecedentes siniestrales
  * Provincia

**Otros datos:**

  * Forma de pago
  * Conductor ocasional
  * …

Para conocer la estructura de distintas compañías en todo nuestra serie de artículos utilizaremos el tarificador de [www.arpem.com](http://www.arpem.com/) web referencia del sector asegurador en España.