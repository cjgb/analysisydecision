---
author: rvaquerizo
categories:
- Excel
- Formación
- Trucos
date: '2010-06-05T05:03:38-05:00'
lastmod: '2025-07-13T16:09:02.962601'
related:
- creando-un-mapa-en-excel-con-archivos-svg.md
- mapas-municipales-de-espana-con-excel-y-qgis.md
- mapas-de-municipales-de-espana-en-r-con-la-ayuda-de-excel.md
- trucos-excel-mapa-de-espana-por-provincias.md
- trucos-excel-mapa-de-mexico-por-estados.md
slug: trucos-excel-mapa-de-espana-por-comunidades-autonomas
tags:
- Inkscape
- Mapa
- metodología
title: Trucos Excel. Mapa de España por Comunidades Autónomas
url: /blog/trucos-excel-mapa-de-espana-por-comunidades-autonomas/
---

![Mapa final de España con Excel](/images/2010/06/mapa_espana_excel_2.JPG)

Vamos a mejorar muchos de nuestros informes con **mapas de España** realizados a través de Excel. Os contaré la metodología que empleo para realizarlos y a partir de ahí vosotros podréis mejorarlos. Voy a realizar un mapa de España por Comunidades Autónomas y le vamos a modificar en función del gasto en prestaciones por desempleo (<http://www.tt.mtin.es/periodico/laboral/201006/mayo.pdf>).Todo empieza por conocer los archivos [SVG ](http://es.wikipedia.org/wiki/Scalable_Vector_Graphics)y pasa por agradecer a los usuarios de la wikipedia que distribuyan todo tipo de mapas realizados por ellos mismos y de uso libre. En este caso buscamos un [mapa de España por Comunidades Autónomas ](http://es.wikipedia.org/wiki/Archivo:Comunidades_aut%C3%B3nomas_de_Espa%C3%B1a.svg). Necesitamos una aplicación libre para manejar estos mapas y la mejor, más adecuada y la que yo uso es [Inkscape ](http://www.inkscape.org/?lang=es)la conocí ayer por la mañana, después me harté de botellines, me fui a sembrar unas guindillas y a día de hoy ya hago mis pinitos con el portátil del trabajo, porque en el mío no funciona. Da problemas en Win 64 bits (¡si!, uso win, como tú que lees esto ya que es muy poco probable que pertenezcas al 3% que usa Mac o al 3% que usa Linux). Con esta aplicación tenemos a nuestro alcance ver perfectamente que es lo que hace el XMLy que espero termine en un paquete de R para hacer mapas de España.Bien, tenemos Inkscape y el mapa por Comunidades de Wikipedia y ahora viene un trabajo muy sencillo, muy aburrido y muy en la línea de un tipo mediocre como el que escribe ahora mismo. Voy a copiar en Inkscape y pegar en Excel cada Comunidad Autónoma, lo transformo en un objeto de Ms-Office para que me sea más sencillo modificarle las propiedades y le doy un nombre a cada figura. Tras 5 minutos haciendo un puzle tengo algo parecido a esto en Excel:

[![Mapa Excel pegado SVG](/images/2010/06/mapa_espana_excel.thumbnail.JPG)](/images/2010/06/mapa_espana_excel.JPG "Mapa Excel pegado SVG")

Cada comunidad es una forma, un shape. Ahora podemos jugar con los atributos de estas formas, fundamentalmente tenemos el siguiente código:

`ActiveSheet.Shapes(figura).Fill.ForeColor.SchemeColor = Col`

Activamos la figura que deseamos modificar y cambiamos el color. Todo esto lo tenéis en el documento Excel que he subido a modo de ejemplo y al que podéis acceder [desde este link](/images/2010/06/mapa-espana-excel-2007-vb.xls "mapa-espana-excel-2007-vb.xlsm") y que os permito utilizar con copias legales de MS Office. Al abrir el documento y la macro que tiene entenderéis perfectamente como creo mapas desde ficheros SVG. Se entiende perfectamente como poder mejorar y cambiar el mapa por Comunidades. De todos modos comentad en el blog los posibles problemas que os surjan.Desde este blog y otros blogs hermanos vamos a trabajar en la creación de mapas con R ya que hemos detectado una necesidad. Os mantendremos informados. Por otro lado si algún lector de México está interesado en realizar un mapa de este estilo para el estado mejicano que se ponga en contacto conmigo a través de [rvaquerizo@analisisydecision.es](mailto:rvaquerizo@analisisydecision.es)Y no me quería despedir sin pediros: **¡Ayudadme a buscar trabajo en Extremadura! ¡Qué bien estoy por aquí! ¡Yo me quedo!**