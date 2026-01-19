---
author: cgbellosta
categories:
  - data mining
date: '2009-06-05'
lastmod: '2025-07-13'
related:
  - porque-me-gusta-r.md
  - noticias-del-congreso-de-usuarios-de-r.md
  - contenidos-web-analisis-informacion.md
  - proyecto-text-mining-con-excel-i.md
  - machine-learnig-analisis-grafico-del-funcionamiento-de-algunos-algoritmos-de-clasificacion.md
tags:
  - data mining
title: Herramientas visuales y libres de minería de datos
url: /blog/herramientas-visuales-y-libres-de-mineria-de-datos/
---

El otro día me preguntó una amiga estadística qué herramienta visual de minería de datos _libre_ —imagino que también quería decir gratuita— le recomendaba. Pensaba que la respuesta a la pregunta era sobradamente conocida de los que nos movemos en nuestro estrecho mundillo. La constatación —sobre una muestra que he ampliado a todo un récord de dos individuos— de que lo cierto es lo contrario me ha empujado a redactar esta entrada en el _blog_.

Sin ánimo de exhaustividad y sin consultar otra cosa que mi disco duro, encuentro los siguientes:

- [Orange](http://www.ailab.si/Orange/), el único que está desarrollado en mi lenguaje generalista favorito: Python. Desafortunadamente, la última vez que lo probé —y ya hace tiempo— no me impresionaron ni su potencia ni su estabilidad. Tendré que volver a revisarlo.
- [Weka](http://www.cs.waikato.ac.nz/ml/weka/), un viejo conocido, tal vez el decano de la lista, del que nada más diré.
- [Knime](http://www.knime.org/), construido sobre Eclipse RCP, me causa muy buena impresión. Lo he utilizado para encapsular código de R —dispone de una extensión específica que funciona muy bien— dentro de una herramienta visual. Me parece sumamente eficiente e intuitivo.
- [Rapidminer](http://www.rapidminer.com), también implementado en Java. Tiene una curva de aprendizaje algo más acusada que el resto. De él he leído noticias francamente sorprendentes en cuanto su capacidad para solventar con éxito problemas de minería de texto y otros.

Personalmente, creo que el número de problemas, proyectos o usos de la minería de datos para los que se precisaría una herramienta tal vez —y subrayo el «tal vez»— más potente como Clementine, SAS EM, KXEN, Oracle Data Mining, o el IBM Intelligent Miner, es francamente pequeño. Vale recordar que, ordenados de mayor a menor criticidad, los factores de éxito de un proyecto de minería de datos son:

1. Personas y conocimiento
1. Disponibilidad de datos
1. Técnicas estadísticas y algoritmos
1. Herramientas de software
