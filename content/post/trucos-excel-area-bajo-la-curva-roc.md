---
author: rvaquerizo
categories:
  - consultoría
  - data mining
  - excel
  - modelos
  - monográficos
date: '2011-01-13'
lastmod: '2025-07-13'
related:
  - seleccion-del-mejor-punto-de-diagnostico-en-una-prueba-diagnostica.md
  - simulacion-estimacion-de-pi-con-el-metodo-montecarlo.md
  - el-sobremuestreo-mejora-mi-estimacion.md
  - trucos-sas-calcular-percentiles-como-excel-o-r.md
  - en-la-regresion-logistica-el-sobremuestreo-es-lo-mismo-que-asignar-pesos-a-las-observaciones.md
tags:
  - curva roc
  - montecarlo
  - simulación
title: Trucos Excel. Área bajo la curva ROC
url: /blog/trucos-excel-area-bajo-la-curva-roc/
---

![Curva ROC](/images/2011/01/curva-roc.png)

¿Curva `ROC` y `Excel`? ¡Si no tiene nada que ver! No del todo. En ocasiones tenemos que pintar las curvas `ROC` y empleamos las herramientas específicas para ello, sin embargo es habitual que nuestros resultados sean presentados en `Excel` (demasiado habitual). En ese caso creamos nuestros datos para llevarlos a `Excel` y realizamos nuestro gráfico. Ya tenemos nuestra tabla y hacemos un algo muy parecido a lo que tenemos más arriba. La curva `ROC` es un mecanismo para evaluar nuestro modelo y compara la **`especificidad`** que es la probabilidad de clasificar mal un caso negativo frente a la **`sensibilidad`** que es la probabilidad de clasificar correctamente un caso positivo, es decir, falsos positivos frente a verdaderos positivos. El área bajo la curva `ROC` será un valor entre `0,5` y `1`. Cuanto más próximo a `1` mejor será nuestro modelo. Queda pendiente una revisión «en condiciones» de las curvas `ROC` y de los gráficos `lift` , mucho mejores cuando tienes que presentar resultados en un área de negocio.

Entonces, ya tenemos el gráfico en `Excel` y nos piden hayar el área bajo la curva `ROC`. ¿Cómo lo hacemos esto? Mediante una **simulación** **por método `Montecarlo`**. Creamos números aleatorios y si están por encima de la sensibilidad pues no valen. Posteriormente sumamos los que valen entre todos los que tenemos y hemos obtenido un valor muy próximo al área bajo la curva `ROC`. En realidad es un método para estimar el área de un póligono. Para entender mejor como se realiza el proceso os un documento de `Excel` con datos simulados:

[curva_roc con datos simulados](/images/2011/01/curva_roc1.xlsx). Veréis que es muy sencillo. No se puede ser más dinosaurio pero ya verás como a más de uno se le enciende la bombilla. Saludos.
