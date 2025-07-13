---
author: rvaquerizo
categories:
- Excel
- Formación
- Trucos
date: '2015-12-01T05:20:39-05:00'
slug: truco-excel-funcion-para-identificar-el-color-de-una-celda
tags: []
title: Truco Excel. Función para identificar el color de una celda
url: /truco-excel-funcion-para-identificar-el-color-de-una-celda/
---

[En alguna entrada anterior ya vimos como identificar el color de una celda con Excel](https://analisisydecision.es/truco-excel-identificar-el-color-de-una-celda/). Recientemente me trasladaron una duda, se trataba de realizar una acción determinada si el color de la celda era distinto. Algo muy habitual cuando realizas alguna validación visual y marcas celdas con otro color. La solución es sencilla, se trata de crear nuestra propia función que identifique el color de la celda:

_Function color_celda(celda As Range)_  
_color_celda = celda.Interior.Color_  
_End Function_

En este caso podríamos realizar funciones del tipo =SI(color_celda(A1)<> 16777215; ACCION1; ACCION2) además podemos darle otra vuelta de tuerca y si deseamos ordenar por colores podemos hacer:

_Function color_orden(celda As Range)_  
_color_orden = celda.Interior.ColorIndex_  
_End Function_

Establecemos un orden de colores y podemos realizar más acciones. Un truco sencillo que puede ayudar a las intervenciones manuales sobre nuestros libros de Excel. Saludos.