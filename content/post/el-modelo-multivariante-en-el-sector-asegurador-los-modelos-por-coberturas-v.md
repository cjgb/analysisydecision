---
author: rvaquerizo
categories:
- consultoría
- formación
- modelos
- monográficos
- seguros
date: '2010-12-27'
lastmod: '2025-07-13'
related:
- el-modelo-multivariante-en-el-sector-asegurador-introduccion-i.md
- el-modelo-multivariante-en-el-sector-asegurador-la-variable-dependiente-iii.md
- el-modelo-multivariante-en-el-sector-asegurador-univariante-vs-multivariante-ii.md
- internet-of-things-en-el-sector-asegurador.md
- modelos-tweedie-con-h2o-mutualizar-siniestralidad-en-base-a-factores-de-riesgo.md
tags:
- sin etiqueta
title: El modelo multivariante en el sector asegurador. Los modelos por coberturas
  (V)
url: /blog/el-modelo-multivariante-en-el-sector-asegurador-los-modelos-por-coberturas-v/
---
Debido a la pobre aceptación había dado de lado esta serie de monográficos sobre la **tarifa multivariante en el sector asegurador**. Pero tengo una lectora que si los seguía y como yo me debo a mis lectores continúo con la serie. Recapitulemos. Como v[ariables dependientes tenemos la frecuencia siniestral y el coste medio de los siniestros](https://analisisydecision.es/el-modelo-multivariante-en-el-sector-asegurador-la-variable-dependiente-iii/), las [variables independientes serán aquellas que compongan la estructura de nuestra tarifa](https://analisisydecision.es/el-modelo-multivariante-en-el-sector-asegurador-las-variables-independientes-iv/), como prototipo para determinar que variables forman parte de nuestro modelo empleamos el multitarificador de [ARPEM](http://www.arpem.com/). Con este planteamiento partimos de dos modelos: el **modelo de frecuencias** y el**modelo de costes medios**. Sin embargo a la hora de ajustar es muy importante plantear **un modelo para cada una de las garantías**. Parece lógico que el modelo multivariante para el contenido en una tarifa de hogar no ha de ser el mismo que el modelo para el continente. O centrándonos en el modelo de autos (sobre el que está girando nuestra serie) es necesario modelizar los siniestros de responsabilidad civil por un lado, los siniestros de daños propios por otro, defensa, robo,…

En el caso de automóviles las garantías a modelizar podrían ser:

• RC
• Daños con franquicia
• Daños sin franquicia
• Robo
• Incencio
• Defensa
• Asistencia
• Lunas
• Ocupantes

Esto es sólo una sugerencia/ejemplo estoy seguro de que algunos opinan que se pueden prescindir de algunas coberturas, pueden aparecer otras, en fin, son ideas personales y basadas en mi experiencia (que bonita expresión) no son axiomas y por tanto no me castiguéis por plantear esta estructura tarifaria para autos. También dependerá de los datos que dispongáis de siniestros. Puede ocurrir que no tengáis tipificada alguna garantía en los datos de siniestros, en ese caso puede complicaros esta o cualquier otra propuesta.

La combinación de estas garantías nos darán las modalidades de nuestro catálogo de productos por ejemplo:

![garantias-productos.png](/images/2010/12/garantias-productos.png)

Pasamos desde la modalidad más básica (incluso sin asistencia) hasta la más completa que es un todo riesgo con franquicia. La suma de las primas obtenidas para cada una de las garantías será la prima final resultante. Un inciso, también podemos jugar con los capitales de cada una de las garantías (en el caso de hogar y salud es imprescindible) y en función de los capitales tendremos unas relatividades distintas. Incluso la tendencia del mercado viene por la personalización de coberturas, si recordamos el siguiente anuncio del producto de hogar de Línea Directa Aseguradora:

[![Imagen de previsualización de YouTube](https://img.youtube.com/vi/Fiis4AQbXug/0.jpg)](http://www.youtube.com/watch?v=Fiis4AQbXug)

«Pagar por un alud en Sevilla no tiene mucho sentido». Este comentario va en la línea de la personalización de las tarifas como sucede con el producto [YCAR de Mapfre](http://www.mapfre.com/seguros/es/particulares/soluciones/seguros-coches-jovenes-ycar.shtml) o la [personalización del seguro de Clickseguros](http://www.clickseguros.es/seguros_de_coche/noticias_seguros_de_coche/Paginas/seguros-a-medida.aspx), esta última es muy peligrosa hacerla con un producto directo sin la asesoría de un experto. Estos productos personalizados requieren un mayor «esfuerzo actuarial y técnico» pero parece que el futuro pasa por ellos. La tarifa a medida.

Ahora muchos estáis alucinando sobre la gran cantidad de modelos que es necesario ejecutar, sobre la estructura que parece que voy sugiriendo y la complejidad que tiene. Muchos factores, muchas garantías y que incluso podemos personalizar, están complicando la tarifa que voy confeccionando, implementar esta propuesta en un sistema informático operacional puede ser una locura. Bien, pues ahora quiero tranquilizar al personal de sistemas. No todos los factores de riesgo influirán en todas las garantías por lo que la cosa pasa a ser más sencilla. Pero eso lo veremos en la siguiente entrega, y espero que ese nuevo capítulo y el **análisis de las interacciones** despierten el debate entre los actuarios que nos siguen.

Esta serie, ~~que no tiene mucha aceptación como ya os he comentado~~ , habla de un campo donde la matemática y el modelaje estadístico ha demostrado mejorar los resultados y los análisis univariantes. Uno de los mejores ejemplos de matemática aplicada y cuyos resultados son tangibles en nuestro día a día. Saludos.