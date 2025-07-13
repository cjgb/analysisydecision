---
author: rvaquerizo
categories:
- Consultoría
- Data Mining
- Excel
- Modelos
- Monográficos
date: '2011-01-13T16:11:29-05:00'
slug: trucos-excel-area-bajo-la-curva-roc
tags:
- curva ROC
- montecarlo
- simulación
title: Trucos Excel. Área bajo la curva ROC
url: /trucos-excel-area-bajo-la-curva-roc/
---

![curva-roc.png](/images/2011/01/curva-roc.png)

¿Curva ROC y Excel? ¡Si no tiene nada que ver! No del todo. En ocasiones tenemos que pintar las curvas ROC y empleamos las herramientas específicas para ello, sin embargo es habitual que nuestros resultados sean presentados en Excel (demasiado habitual). En ese caso creamos nuestros datos para llevarlos a Excel y realizamos nuestro gráfico. Ya tenemos nuestra tabla y hacemos un algo muy parecido a lo que tenemos más arriba. La curva ROC es un mecanismo para evaluar nuestro modelo y compara la **especificidad** que es la probabilidad de clasificar mal un caso negativo frente a la **sensibilidad** que es la probabilidad de clasificar correctamente un caso positivo, es decir, falsos positivos frente a verdaderos positivos. El área bajo la curva ROC será un valor entre 0,5 y 1. Cuanto más próximo a 1 mejor será nuestro modelo. Queda pendiente una revisión «en condiciones» de las curvas ROC y de los gráficos _lift_ , mucho mejores cuando tienes que presentar resultados en un área de negocio.

Entonces, ya tenemos el gráfico en Excel y nos piden hayar el área bajo la curva ROC. ¿Cómo lo hacemos esto? Mediante una **simulación** **por método Montecarlo**. Creamos números aleatorios y si están por encima de la sensibilidad pues no valen. Posteriormente sumamos los que valen entre todos los que tenemos y hemos obtenido un valor muy próximo al área bajo la curva ROC. En realidad es un método para estimar el área de un póligono. Para entender mejor como se realiza el proceso os un documento de Excel con datos simulados: 

[curva_roc con datos simulados](/images/2011/01/curva_roc1.xlsx). Veréis que es muy sencillo. No se puede ser más dinosaurio pero ya verás como a más de uno se le enciende la bombilla. Saludos.