---
author: rvaquerizo
categories:
- Consultoría
- Excel
- Formación
- Trucos
date: '2012-08-06T02:16:22-05:00'
lastmod: '2025-07-13T16:09:00.053981'
related:
- trucos-excel-poner-etiquetas-en-graficos-de-dispersion.md
- chart-tools-un-add-in-imprescindible-para-excel.md
- truco-excel-grafico-de-puntos-con-colores.md
- truco-excel-graficos-de-dispersion-que-identifican-los-puntos.md
- nuevo-y-muy-mejorado-mapa-de-espana-por-provincias-con-excel.md
slug: trucos-excel-graficos-dot-plot-representando-un-ranking-graficamente
tags:
- Dot plot
title: Trucos Excel. Gráficos dot plot, representando un ranking gráficamente
url: /trucos-excel-graficos-dot-plot-representando-un-ranking-graficamente/
---

Los gráficos de puntos son muy prácticos para representar de una forma visual rankings (por ejemplo). En Excel su realización no es inmediata como con otras herramientas (R por ejemplo). Para ilustrar el ejemplo se van a presentar los 20 primeros puestos de la [lista TIOBE ](http://www.tiobe.com/index.php/content/paperinfo/tpci/index.html)de mayo de 2012 (la entrada estaba en la nevera). Entramos en la lista y sin más copiamos y pegamos los datos de tabla HTML a tabla Excel:

[![](/images/2012/08/Dot_plot_excel1.jpg)](/images/2012/08/Dot_plot_excel1.jpg)

Es recomendable dar un formato más adecuado a los datos para representarlos, tened cuidado con la configuración regional, eliminad imágenes que pueden causar problemas, quedaros con los datos que deseáis representar,…

Cuando ya tenemos unas tablas adecuadas el siguiente paso es insertar un gráfico de dispersión con la posición y la medida que deseamos que aparezca en el gráfico, en este caso el rating de TIOBE:

[![](/images/2012/08/Dot_plot_excel2.jpg)](/images/2012/08/Dot_plot_excel2.jpg)

En el eje X ponemos la medida (el rating que le asigna a cada lenguaje de programación TIOBE). En el eje Y ponemos la posición dentro del ranking. Vemos que el ranking queda al revés y para ello la mejor y más rápida solución es cambiar los datos de mayor a menor respetando el orden del ranking:

[![](/images/2012/08/Dot_plot_excel3.jpg)](/images/2012/08/Dot_plot_excel2.jpg)

No os compliquéis mucho la vida con este tema, directamente cambiad el orden, evitará complicaciones. Ahora tenemos que poner las etiquetas en el eje Y, para ello necesitamos añadir una nueva serie al gráfico para que posteriormente podamos etiquetarlo, sólo será necesario añadirle la etiqueta:

[![](/images/2012/08/Dot_plot_excel4.jpg)](/images/2012/08/Dot_plot_excel2.jpg)

Ahora tenemos que etiquetar esos datos, para ello podemos emplear [JWalk Chart Tools](http://spreadsheetpage.com/index.php/file/j_walk_chart_tools_add_in/) un add-in de Excel que nos permite trabajar con las etiquetas de una forma muy sencilla, [en el blog podéis buscar una macro muy interesante ](https://analisisydecision.es/trucos-excel-poner-etiquetas-en-graficos-de-dispersion/)que programé hace años pero jWalk nos evita andar con macros:

[![](/images/2012/08/Dot_plot_excel5.jpg)](/images/2012/08/Dot_plot_excel2.jpg)

Hecha esta labor comenzamos a jugar con el formato del gráfico:

• Etiquetas de datos a la izquierda en la serie con los nombres  
• Eliminar marcadores  
• Ninguna etiqueta en el eje Y cuando demos formato  
• Ajustar la longitud del eje Y  
• Etiquetas de Y en la serie de los puntos  
• …

Esta parte es más sencilla y más al gusto de la persona que está realizando el gráfico. Y el resultado queda:

[![](/images/2012/08/Dot_plot_excel6.jpg)](/images/2012/08/Dot_plot_excel2.jpg)

Creo que las instrucciones han quedado claras pero si tenéis cualquier problema comentad el mensaje y lo resolveremos. Un comentario, en R estos gráficos son muy sencillos, en Excel ya véis que no son inmediatos.