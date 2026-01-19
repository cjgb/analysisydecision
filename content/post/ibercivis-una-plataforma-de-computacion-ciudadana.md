---
author: cgbellosta
categories:
  - data mining
date: '2009-12-17'
lastmod: '2025-07-13'
related:
  - introduccion-a-la-estadistica-para-cientificos-de-datos-con-r-capitulo-2-datos.md
  - noticias-del-congreso-de-usuarios-de-r.md
  - manual-curso-introduccion-de-r-capitulo-15-analisis-cluster-con-r-i.md
  - entender-una-blockchain-con-r.md
  - computer-vision-con-r-opencv-de-andar-por-casa.md
tags:
  - computación distribuida
  - ibercivis
  - seti
title: Ibercivis, una plataforma de computación ciudadana
url: /blog/ibercivis-una-plataforma-de-computacion-ciudadana/
---

Creo que es hecho conocido que existe el proyecto [SETI@home](http://es.wikipedia.org/wiki/SETI@Home "SETI@home"), una red de ordenadores que ceden voluntarios para analizar nosequé tipo de datos para la nosequé clase de esotéricos fines. Nunca me interesó el asunto en sí, aunque sí la plataforma.

Más que el ser capaces de robarle el _wifi_ a un marciano, el subproducto más intersante del proyecto ha sido [BOINC](http://es.wikipedia.org/wiki/Berkeley_Open_Infrastructure_for_Network_Computing "BOINC"), la plataforma de software que permite distribuir trabajos intensivos en uso de recursos computacionales a través de una red de ordenadores. Eso ha permitido la emergencia de [un buen número de proyectos](http://es.wikipedia.org/wiki/Proyectos_que_usan_BOINC "Proyectos que usan BOINC") que lo usufructan para fines más tangibles (aunque no universalmente más útiles).

Incluso existe uno, patrocinado por la Universidad de Zaragoza, en España: [Ibercivis](http://www.ibercivis.es "Ibercivis"). Tienen actualmente [seis o siete proyectos en marcha](http://www.ibercivis.es/index.php?module=public&section=channels&action=view&id_channel=3 "Proyectos Ibercivis") que me parecen muy interesantes. Por ejemplo, el de _docking_ de proteínas, busca medicamentos (moléculas, al fin y al cabo) que sean capaces de combinarse químicamente con una cierta proteína.

Retrotrayéndonos, las proteínas son los músculos de las células. La actividad de una célula puede medirse por el tipo de proteínas que tiene activas en su seno. Y los virus utilizan proteínas para penetrar en las células y alterar las cadenas de ADN, etc. Por eso es fundamental ser capaces de actuar específicamente sobre ellas para, por ejemplo, desactivarlas.

¿Cómo se hace eso? Con otras moléculas (medicamentos, vamos) que interaccionan con ellas, es decir; que se _pegan_ a su estructura.

¿Qué moléculas pueden _pegarse_ a una proteína dada? Es una cuestión de laboratorio, de intuición y de prueba y error. ¿Sólo? No. Existen otros métodos.

Para que una molécula se _pegue_ a una proteína hace falta que tengan _geometrías complementarias_ que permitan el enganche (a modo de mano y guante, vamos). El problema es pues, dada una proteína, encontrar una molécula con una forma geométrica dada.

Las moléculas candidatas están todas tabuladas en una base de datos que contiene, actualmente alrededor de cuatro millones de ellas. Uno puede recorrer la lista de moléculas y, una a una, con un programa informático, trasladarla, rotarla, etc. virtualmente en _todas_ las configuraciones posibles para ver si encaja.

¿Cuánto tarda esto en un ordenador _común_? Aparentemente, unos cinco minutos por molécula. ¿Y los cuatro millones de ellas? Pues unos 38 años.

Pero, ¿si esta labor se distribuyese entre, digamos, 10.000 ordenadores? Pues… día y medio. Es decir, en día y medio sería posible pasar a un laboratorio una serie de moléculas candidatas para ver si, efectivamente, son capaces o no de interactuar con una proteína dada. Y, posiblemente, crear un fármaco.

¿No creéis que vale la pena castigar un poquito la CPU del ordenador con fines similares a éste?
