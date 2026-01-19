---
author: rvaquerizo
categories:
  - inteligencia artificial
  - monográficos
  - opinión
  - r
date: '2020-05-27'
lastmod: '2025-07-13'
related:
  - el-debate-politico-o-como-analizar-textos-con-wps.md
  - noticias-del-congreso-de-usuarios-de-r.md
  - de-actuario-a-cientifico-de-datos.md
  - analisis-de-textos-con-r.md
  - el-modelo-multivariante-en-el-sector-asegurador-los-modelos-por-coberturas-v.md
tags:
  - latent semantic analysis
title: Latent semantic analysis y la importancia de las matemáticas
url: /blog/latent-semantic-analysis-y-la-importancia-de-las-matematicas/
---

Vivimos “días extraños”, tan extraños que en España se están planteando prescindir de la asignatura de matemáticas en la enseñanza obligatoria. Es evidente que las personas que gobiernan hoy (25/05/2020) España habrían suspendido matemáticas. Sin embargo, es curioso que haya pocos matemáticos ejerciendo cargos políticos, ¿puede ser que los matemáticos no tengan esa vocación por mejorar la vida de los demás? En fin, esta crítica a la ignorancia numérica y al egoísmo matemático me sirve de “extraña introducción” al Latent semantic analysis (LSA) como siempre los [aspectos teóricos los podéis encontrar en otros sitios](https://www.sciencedirect.com/topics/computer-science/latent-semantic-analysis). Y todo este conjunto de frases inconexas hilan con la entrada en el blog de mi amigo [J.L. Cañadas](https://twitter.com/joscani) en [muestrear no es pecado](https://muestrear-no-es-pecado.netlify.app/2020/05/24/factoriales/) porque, reducción de dimensionalidad, el lenguaje y la importancia de las matemáticas es en realidad el Latent Semantic Analysis.

Si preguntas a un estadístico ¿qué es la reducción de dimensionalidad? Te contará lo que dice Cañadas, «analizar la varianza total de los datos y obtener las combinaciones lineales mejores en el sentido de máxima varianza» esto es lo mismo que preguntar a una persona que se ha leído un libro, «hazme un resumen en un párrafo». En ese caso estás buscando una combinación de ideas que te permitan resumir un texto en el menor espacio posible, evidentemente asumes que te dejas cosas, estás asumiendo que las cosas varían, metes la menor variabilidad posible en un párrafo asumiendo toda la variación del texto. Entonces, todo ese follón de la reducción de dimensionalidad es algo parecido a un resumen objetivo de un texto algo que realiza cualquier persona cuando te describe un libro, un artículo o una anécdota. Las matemáticas pueden estructurar el conocimiento cognitivo que permite sintetizar un texto.

Programar el funcionamiento de un cerebro humano así a lo _mecagüen_ es complicado, pero tenemos proyectos en marcha que ya están trabajando con ello, uno de estos proyectos es el paquete LSAfun que es capaz de realizar este tipo de síntesis. La idea es usar espacios semánticos para modelar relaciones entre los conceptos de un texto, p[odríamos emplear para ello la Wikipedia (por ejemplo)](https://arxiv.org/pdf/1902.02173.pdf). Es caso es que voy a emplear el paquete LSAfun para que me resuma [la intervención de Pedro Sánchez en la última sesión del Congreso de los Disputados de España](http://www.congreso.es/portal/page/portal/Congreso/Congreso/Intervenciones?_piref73_1335415_73_1335414_1335414.next_page=/wc/servidorCGI&CMD=VERLST&BASE=IT14&FMT=INTTXLUS.fmt&DOCS=75-78&DOCORDER=FIFO&OPDEF=Y&QUERY=%28%22S%C3%A1NCHEZ+P%C3%A9REZ-CASTEJ%C3%B3N++PEDRO%22%29.ORAD.) () porque la homeopatía política que vivimos está sustentada en un lenguaje completamente insustancial y que es posible que pudiéramos resumir en una sola frase:

```r
#install.packages('LSAfun')

library(LSAfun)

ubicacion="c:\\temp\\intervencion.txt"
texto = read.table (ubicacion, sep="\r", encoding = 'UTF-8')
texto = toupper(texto)
genericSummary(texto, k=1, language="spanish", breakdown=T)
```

```r
[1] "    en particular  el ministro de sanidad ha aprobado tres ordenes para fortalecer nuestro sistema nacional de salud tanto desde el punto de vista de los medios humanos como de los recursos disponibles en unas circunstancias tan extraordinarias como las actuales  y  en concreto  ha ordenado las siguientes materias  se ha aprobado la prorroga de la contratacion de los medicos residentes en el ultimo ano de formacion de algunas especialidades medicas  y de enfermeria tambien  especialmente criticas en la lucha contra el covid     tales como la geriatria  la medicina intensiva  la microbiologia y la parasitologia  se han suspendido las rotaciones de los medicos residentes  para que estos puedan prestar servicios en aquellas unidades en las que se precise un refuerzo del personal  se podra trasladar a medicos residentes de una comunidad autonoma a otra que tenga mayores necesidades asistenciales para la redistribucion de la asistencia en todo el territorio  y se podra contratar de modo extraordinario y en algunos casos a personas con un grado o licenciatura en medicina aunque carezcan del titulo de especialista  podra reincorporarse a profesionales sanitarios jubilados  medicos y medicas  enfermeros y enfermeras menores de setenta anos  personal emerito y personal con dispensa absoluta para funciones sindicales  todo ello para contar con el mayor numero de profesionales sanitarios en esta crisis en caso de que las circunstancias asi lo requirieran  tambien se podra contratar de modo extraordinario a estudiantes de los grados de medicina y de enfermeria en su ultimo ano de formacion con el fin de realizar labores de apoyo y auxilio sanitario bajo la supervision de otros profesionales"
```

Afortunadamente la función genericSummary reconoce el lenguaje español aunque imagino que los espacios semánticos estarán menos desarrollados. Ahí tenemos todo un día de trabajo resumido en una frase que recoge las ideas clave de la sesión del Congreso. Aprovecho desde aquí para alentar a alguna compañía a realizar un análisis de las intervenciones desde el inicio de la democracia en España hasta ahora, sería una competición de datos (hackathon en lenguaje _soplapollístico_) muy interesante. Saludos.
