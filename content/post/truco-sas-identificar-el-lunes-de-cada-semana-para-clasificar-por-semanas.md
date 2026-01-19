---
author: rvaquerizo
categories:
- formación
date: '2015-11-10'
lastmod: '2025-07-13'
related:
- trucos-sas-pasar-fecha-a-caracter-en-sas.md
- bucle-de-fechas-con-sas-para-tablas-particionadas.md
- trucos-sas-numero-de-dias-de-un-mes.md
- macros-faciles-de-sas-dias-de-un-mes-en-una-fecha.md
- trabajo-con-fechas-sas-introduccion.md
tags:
- sin etiqueta
title: Truco SAS. Identificar el lunes de cada semana para clasificar por semanas
url: /blog/truco-sas-identificar-el-lunes-de-cada-semana-para-clasificar-por-semanas/
---
[El otro día una lectora preguntaba una duda](https://analisisydecision.es/monografico-datos-agrupados-en-sas/#comment-88631), quería encontrar el lunes dentro de un conjunto de fechas con el objetivo de clasificar semanas. Para realizar esta tarea contamos con la función **WEEKDAY** de SAS que nos permite numerar los días de la semana donde el domingo es el primer día de la semana. De este modo hay que restar los días necesarios para llegar al día 2 de la semana. Lo vemos con un ejemplo:

_DATA EJEMPLO;_
_FORMAT FECHA DDMMYY10.;_
_DROP I;_
_DO I=0 TO 100;_
_FECHA = «01SEP2015″d + I;_
_OUTPUT;_
_END;_
_RUN;_

_DATA EJEMPLO;_
_SET EJEMPLO;_
_FORMAT LUNES DDMMYY10.;_
_LUNES = FECHA – (WEEKDAY(FECHA)-2);_
_RUN;_

Un conjunto de datos SAS de ejemplo con los 100 días siguientes al 1 de septiembre de 2015 y definimos _LUNES_ como los días que nos hemos pasado del lunes menos la propia fecha. De este modo cada una de las fechas queda clasificada en su semana y la semana viene marcada por el lunes. Saludos.