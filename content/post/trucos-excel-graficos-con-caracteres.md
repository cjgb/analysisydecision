---
author: rvaquerizo
categories:
- Excel
- Formación
- Trucos
date: '2010-08-13T06:32:51-05:00'
lastmod: '2025-07-13T16:08:58.590794'
related:
- truco-excel-repetir-celdas-en-funcion-de-los-valores-de-otra-celda.md
- truco-excel-repetir-un-campo-a-partir-de-otro-que-define-el-numero-de-repeticiones.md
- trucos-excel-graficos-dot-plot-representando-un-ranking-graficamente.md
- trucos-excel-poner-etiquetas-en-graficos-de-dispersion.md
- trucos-excel-eliminar-referencias-del-tipo-importardatosdinamicos.md
slug: trucos-excel-graficos-con-caracteres
tags: []
title: Trucos Excel. Gráficos con caracteres
url: /blog/trucos-excel-graficos-con-caracteres/
---

![piramide-poblacional-excel.png](/images/2010/08/piramide-poblacional-excel.png)

Quería plantear hoy un truco Excel que no es un truco como tal, si no más bien una idea para que podáis hacer más vistosos vuestros informes con gráficos de caracteres, sobre todo para aquellos dinosaurios que hagáis muchos ranking o puntuaciones. La idea es muy sencilla se trata de emplear la función REPETIR de Excel pero «con talento». =REPETIR(«|»;E12) nos repite el pipe | tantas veces como le indiquemos en la casilla E12. Pero hay algo que si tiene importancia, la fuente que elijamos para el pipe:

![fuentes-pipe-excel.png](/images/2010/08/fuentes-pipe-excel.png)

Aquí tenéis algunos ejemplos de como veríamos el pipe en nuestros gráficos de caracteres. Yo recomiendo que no empleéis fuentes que sean más grandes que las que las usadas para escribir. Con este sencillo truco podemos hacer gráficos más complejos, siempre tenemos el motor de Excel, pero me parece interesante dar algunos apuntes. Si este método lo combinamos con formatos condicionales podemos obtener resultados muy interesantes. Espero que sea de utilidad.