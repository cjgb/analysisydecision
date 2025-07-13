---
author: rvaquerizo
categories:
- Inteligencia Artificial
- Machine Learning
- Modelos
- Monográficos
- R
date: '2019-07-16T06:28:01-05:00'
slug: inteligencia-arficial-frente-a-un-juego-de-ninos-la-particula-tonta-de-nicolas
tags: []
title: Inteligencia Arficial frente a un juego de niños. La partícula tonta de Nicolás
url: /inteligencia-arficial-frente-a-un-juego-de-ninos-la-particula-tonta-de-nicolas/
---

Pablo Picasso decía que en aprender a pintar como los pintores del renacimiento tardó unos años pero pintar como los niños le llevó toda la vida y en ocasiones creo que hacemos las cosas difíciles porque nos creemos que hacemos cosas difíciles y entonces llega un niño de nueve años y dice «Papá un punto que primero vaya a la izquierda y luego a la derecha no es tan difícil».  
Os pongo en antecedentes, el pasado 7 de mayo fui al AWS Summit de Madrid porque Sergio Caballero iba a contar uno de los casos de uso. Los de AWS no se deben ni imaginar de las maravillas que ha hecho Sergio en el Ayuntamiento de Alcobendas porque sólo dejaron que hablara 10 minutos, muy torpes ellos, su trabajo es mejor escaparate que el planteado por Mai-Lan Tomsen, un error en el planteamiento de la jornada. El caso es que había una «competición» de vehículos que circulaban por un circuito guiados por complicados algoritmos de inteligencia artificial. Vimos algún «bucanero serio» de alguno de los participantes, ya sabemos reinforcement learning, pero reinforcement reinforcement. Otros participantes más o menos honrosos, en fin, distraído. Viendo la competición me entraron ganas de participar y al llegar a casa me siento a preparar un algoritmo que recorriera el circuito del Jarama de Madrid, no un circuito cualquiera un circuito donde yo he visto ganar carreras a Jorge Martínez Aspar.

Portátil y R, empiezo mi trabajo con imager, busco en la Wikipedia el circuito, lo cargo, genero un data frame, selecciono puntos y comienzo a diseñar mi propia estrategia de reinforcement learning combinadas con técnicas de machine learning, algo como «SVM direccionables» se acerca por detrás mi hijo y me suelta «Papá un punto que primero vaya a la izquierda y luego a la derecha no es tan difícil». Bueno, pues en 20 minutos sale esto:

[![](/images/2019/05/prueba.gif)](/images/2019/05/prueba.gif)

De momento no funciona pero no me digáis que no es genial la idea, lo que hace con pocas líneas de código y una consulta en sql. En el [repositorio de analisisydecision](https://github.com/analisisydecision/wordpress) tenéis el código en R que realiza esta maravilla, he llamado al código partícula tonta y tiene aspectos interesantes en cuanto al uso de la librería imager de R para el tratamiento de imágenes y como transformo una imagen en un data frame de coordenadas y por supuesto la genial idea de Nicolás. 

Por cierto, al ver el resultado Nicolás dijo que no sólo derecha e izquierda, también era necesario un arriba y abajo. Tengo abandonado el proyecto, como muchos, pero la anécdota me ayudó en mi trabajo.