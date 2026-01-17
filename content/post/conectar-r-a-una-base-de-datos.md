---
author: apadrones
categories:
- Formación
date: '2008-07-22T11:09:55-05:00'
lastmod: '2025-07-13T15:55:14.264089'
related:
- tres-fracasos-y-medio-con-r.md
- porque-me-gusta-r.md
- noticias-del-congreso-de-usuarios-de-r.md
- el-futuro-del-analisis-de-datos-pasa-por-r.md
- evita-problemas-con-excel-desde-r-de-tocar-el-dato-a-un-proceso.md
slug: conectar-r-a-una-base-de-datos
tags: []
title: Conectar R a una base de datos
url: /blog/conectar-r-a-una-base-de-datos/
---

Cada día los softwares libres van ganando más y más terreno a los softwares comerciales, no sólo por su precio, si no porque incluyen procedimientos más vanguardistas que los comerciales. El mayor problema que tienen es el volumen de datos.

Cuando he preguntado a algún desarrollador de los principales softwares libres (R, Weka, Knime…) acerca de esta cuestión siempre me han respondido que depende de la capacidad de la máquina o servidor en la que se ejecuten los procesos. Es una respuesta ambigua, es cierto, pero es totalmente cierta. Si dispusiésemos de una máquina con recursos de memoria y almacenamiento ilimitados el software libre sería prácticamente perfecto. Podríamos decir entonces que la principal desventaja de los software libres frente a los comerciales es la gestión de los procesos (mucho más estudiada en los comerciales), además de una consola o interfaz más amigable.

Desde hace tiempo tengo la curiosidad de hacer una prueba con un volumen de datos enorme en R, en una máquina normalita (1GB de RAM), a ver si consigue acabar el proceso y cuánto tarda. Ahora que tengo un ratillo en el curro he decidido ponerme a ello, pero me he dado cuenta de que meterle un archivo plano con un comando read podía ser un poco pesado, y me planteé conectarlo directamente a la base de datos. Pensaba que no se podía hacer, pero me encontré esto:

<http://grass.itc.it/statsgrass/r_and_dbms.html>

Cuando tenga resultados de pruebas de capacidad de R en una máquina estándar las iré posteando. Ojalá me sorprenda y nos llevemos una gran alegría los usuarios de software libre.

Un saludo.