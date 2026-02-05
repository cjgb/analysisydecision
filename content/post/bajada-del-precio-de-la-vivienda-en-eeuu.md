---
author: rvaquerizo
categories:
  - business intelligence
date: '2009-03-24'
lastmod: '2025-07-13'
noindex: true
related:
  - introduccion-a-la-estadistica-para-cientificos-de-datos-capitulo-13-regresion-lineal.md
  - bajar-los-tipos-a-la-japonesa-al-0.md
  - lecciones-de-economia-de-un-ignorante-solucion-trabajar-mas-y-cobrar-menos.md
  - a-mi-me-preocupa-el-pequeno-ahorrador.md
  - amanece-que-no-es-poco.md
tags:
  - dimensión geográfica
  - precio vivienda eeuu
  - vivienda
title: Bajada del precio de la vivienda en EEUU
url: /blog/bajada-del-precio-de-la-vivienda-en-eeuu/
---

Repasando algunos blogs imprescindibles, he visto en [En Silicio](http://www.ensilicio.com/2009/03/%C2%A1mas-datos-%C2%A1mas-datos.html) un curioso dato publicado en [Gurusblog](http://www.gurusblog.com/archives/el-precio-de-la-vivienda-en-eeuu-se-desmploma-un-182-en-el-ultimo-trimestre-del-2008/24/02/2009/): el precio de la vivienda en `EEUU` se desploma un 18%. Inmediatamente había que visitar la web de [Standard & Poor's](http://www2.standardandpoors.com/portal/site/sp/en/us/page.topic/indices_csmahp/0,0,0,0,0,0,0,0,0,1,1,0,0,0,0,0.html) para analizar el precio de la vivienda, la subida y posterior desplome; en principio me interesaban las fechas.

Pero me ha sorprendido una dimensión del análisis que no se está teniendo en cuenta a la hora de estudiar el precio de la vivienda en los `EEUU`: la **zona geográfica**. Mientras hay ciudades con una subida y posterior bajada muy pronunciada, hay otras donde esto se ha producido de forma más suave. Rápido gráfico en `Excel`:

![Vivienda en EEUU por ámbito geográfico](/images/2009/03/precio_vivienda_usa1.JPG "Vivienda en EEUU por ámbito geográfico")

He seleccionado seis zonas que me parecen representativas por la importancia que tienen dentro de la economía de los `EEUU` y por el ámbito geográfico que representan. De este modo, he seleccionado Los Ángeles (California), Washington (capital), Miami (inmigración), Chicago (industrial centro país), Nueva York (centro financiero) y Portland (noroeste y zona cultural). Miami, Los Ángeles y Washington son las ciudades más castigadas por la subida y el desplome; Chicago y Portland son las menos castigadas, e incluso Portland parece que mantiene precios por encima de los que tenía en 2005. Nueva York se sitúa en un término medio. Así que parece que el desastre va por barrios.

Por otro lado, es especialmente interesante analizar las fechas en las que comenzó a producirse el descenso de los precios. A finales de 2006, la pendiente comenzó a ser muy negativa. La crisis dio comienzo a finales de 2007. ¿Qué se hizo en ese año para evitar este desplome? ¿No éramos conscientes de la gravedad de este asunto? Parece que no. En este punto se me ocurre analizar el sueldo medio de los trabajadores estadounidenses; ¿qué sucedió con él? Gráfico rápido en `Excel`:

![Salario medio EEUU](/images/2009/03/salario_medio_usa.JPG "Salario medio EEUU")

Vale, un poco "cutre", pero ¿qué queréis en los 10 minutos que tengo para escribir…? En este caso, Nueva York encabeza la subida con un buen desplome, pero Los Ángeles es la estrella de la bajada brusca. Llama la atención que ni Miami ni Washington tuvieran una fuerte subida, pero sí han tenido desplome, situando los sueldos a la mitad en ocho años. De nuevo en la parte inferior está Portland, que duplicó sus sueldos y ahora está a niveles de 2001; por lo menos no está por debajo como las otras cinco ciudades que estoy estudiando. En este caso, el punto de cambio de la pendiente se sitúa en torno al verano de 2006. Otro excelente indicador de lo que se le venía encima a la economía norteamericana.

Ahora voy a hacer un ejercicio de falta de rigor, pero que puede resultar interesante. Si considero que un estadounidense por término medio tarda 30 años en pagar su hipoteca (inventado), podemos dividir el importe entre 30 y calcular el porcentaje que implica la vivienda sobre su sueldo. En total, una aproximación sobre cómo influye el precio de la vivienda a la economía doméstica de los estadounidenses. Por supuesto, gráfico rápido:

![Relación Salario Precio Vivienda EEUU](/images/2009/03/relacion_vivienda_salrio_eeuu.JPG "Relación Salario Precio Vivienda EEUU")

Es evidente la falta de rigor puesto que hay ciudades en las que la vivienda supone más del 200% del salario. Pero en este caso es Portland la ciudad en la que la vivienda supone un mayor esfuerzo para las familias. Miami se sitúa inmediatamente detrás; en esta ciudad la crisis tiene que estar cayendo como una losa. Este análisis afinado y riguroso puede resultar más interesante, pero nos ha servido para conocer un poco más qué está pasando con la crisis en los `EEUU`. Esperemos que esta situación mejore, por el bien de la economía globalizada. Saludos.