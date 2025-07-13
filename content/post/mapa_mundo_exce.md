---
author: rvaquerizo
categories:
- Consultoría
- Excel
- Formación
date: '2014-09-30T14:39:40-05:00'
slug: mapa_mundo_exce
tags:
- mapas excel
title: Mapa del mundo en Excel
url: /mapa_mundo_exce/
---

[![](/images/2014/09/mapa_mundo_excel-300x200.png)](/images/2014/09/mapa_mundo_excel.png)

Un**mapa del mundo en Excel** preparado para poner datos de la Base de Datos de la UNESCO. Está sacado de una web, cuando encuentre el link os lo pongo porque lo he perdido. Además al César lo que es del César. Sobre el fichero Excel que me descargué realicé diversas modificaciones para mejorar los resultados y darle simplicidad. Hay una hoja de datos que es donde debéis pegar los datos (preferiblemente) por otro lado está la hoja Mapa que contiene el mapa sobre el que podéis realizar las modificaciones. En esta hoja están los datos sobre los que se hace la jerarquía. La gama de colores que utiliza este mapa es de gris a rojo. Esto podéis cambiarlo vosotros mismos, [en esta web se han dado pistas sobre cómo hacerlo](https://analisisydecision.es/truco-excel-identificar-el-color-de-una-celda/). No es correcto darlo todo hecho pero jugando con formatos condicionales y con esas pistas podéis obtener un mapa espectacular.

[Aquí podéis descargar el mapa.](/images/2014/09/Mapa-mundo.xls)

Para actualizar los colores tenéis que ejecutar esta simple macro:

Sub cambia_color()  
Dim pais As String  
Dim i As Integer  
Dim color As Long  
Dim myShape As Shape  
For i = 2 To 190  
pais = Cells(i, 26)  
color = Cells(i, 30)  
Set myShape = Sheets(1).Shapes(pais)  
myShape.Fill.ForeColor.RGB = color  
Next i  
End Sub

En cuanto a los datos que se representan en el mapa. Tasa de mortalidad infantil en el mundo. Los países más oscuros o bien no disponen de datos o bien no han cruzado con los datos de la UNESCO. Se podrá mejorar el resultado. Algo más subjetivo, no sé como consentimos este rojo predominante en África. Será que sin ese rojo yo no podría escribir cosas como esta… Saludos.