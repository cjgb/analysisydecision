---
author: rvaquerizo
categories:
- Business Intelligence
- Excel
- Formación
- Trucos
date: '2015-07-28T06:48:42-05:00'
slug: truco-excel-graficos-de-dispersion-que-identifican-los-puntos
tags: []
title: Truco Excel. Gráficos de dispersión que identifican los puntos
url: /truco-excel-graficos-de-dispersion-que-identifican-los-puntos/
---

[![Gráfico Dispersión con colores Excel](/images/2015/07/grafico-dispersion-excel-300x212.png)](/images/2015/07/grafico-dispersion-excel.png)Gráfico Dispersión con colores Excel

Yo no sé hacer**gráficos de dispersión con Excel** en los que se identificaran los puntos mediante un color, es necesario programar en visual basic para hacerlo. Imagino que se podrá hacer de forma más elegante pero hoy quería mostraros que esa tarea se puede llevar a cabo mediante macros. Los datos que tenemos tienen un valor para X, un valor para Y y un valor que nos identifica el grupo de cada registro. En el ejemplo que os voy a adjuntar se identifican dentro de la nube de puntos aleatorios 2 grupos marcados con un 0 o un 1, por lo cual tendremos 2 colores para identificar esos puntos. ¿Cómo variamos los colores? Sencillo, una macro recorre punto a punto y pone otro color si pertenece al grupo 1, los que pertenezcan al grupo 0 tendrán el color por defecto. Este color por defecto será el negro y el color para los 1 será el rojo. El código de la macro es:

_Sub colores()_  
_‘_  
_‘ colores macro creada por www.analisisydecision.es_

_On Error GoTo noselecciona_

_‘Establecemos el color inicial_  
_ActiveChart.SeriesCollection(1).Select_  
_Selection.Format.Fill.ForeColor.RGB = RGB(50, 50, 50)_

_‘Modificamos aquellos puntos que tienen un 1_  
_para = 0_  
_fila = 2_  
_Do While para = 0_  
_If Cells(fila, 3) = 1 Then ActiveChart.SeriesCollection(1).Points(fila – 1).Format.Fill.ForeColor.RGB = RGB(250, 50, 0)_  
_If Cells(fila, 1) = «» Then para = 1_  
_fila = fila + 1_  
_Loop_

_noselecciona:_  
_If Err Then MsgBox («Ha de seleccionar el gráfico»)_

_End Sub_

[Descárgate el archivo](/images/2015/07/dispersion_excel.xlsm)

Hay un control de errores por si no tenemos ningún gráfico seleccionado. Una vez seleccionado el gráfico damos a toda la serie el color negro, se emplea escala RGB para asignar colores. Después vamos a recorrer punto por punto hasta que no haya datos y si encontramos un 1 en la variable grupo entonces el RGB será de color rojo. Cuando ya no hay más observaciones el proceso se detiene.

Como es habitual, os enseño a pescar, es evidente que se pueden hacer más grupos, que se pueden seleccionar los colores, etc. Creo que es bastante sencillo si buscamos en el blog y si entendemos esta simple macro. Saludos.