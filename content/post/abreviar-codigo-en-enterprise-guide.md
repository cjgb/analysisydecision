---
author: rvaquerizo
categories:
  - formación
  - sas
  - trucos
date: '2010-11-11'
lastmod: '2025-07-13'
related:
  - acercamiento-a-wps-migrando-desde-sas.md
  - truco-sas-crear-ficheros-excel-sin-proc-export-ii.md
  - trucos-sas-eliminar-etiquetas-en-los-conjunto-de-datos-sas.md
  - truco-sas-sysecho-para-controlar-las-ejecuciones-en-enterprise-guide.md
  - truco-sas-limpieza-de-tabuladores-con-expresiones-regulares.md
tags:
  - sas
title: Abreviar código en Enterprise Guide
url: /blog/abreviar-codigo-en-enterprise-guide/
---

En Enterprise Guide de SAS podemos ahorrarnos código empleando las abreviaturas del editor. Yo no lo recomiendo porque nuestros códigos sólo podrán ser ejecutados con nuestros equipos, pero Guide es una herramienta pensada para los usuarios y no para el desarrollo de código. Sobre un programa de Guide pulsamos sobre `Programas` -> `Añadir abreviaturas` y aparece la siguiente ventana:

![abreviatura_enterprise_guide.PNG](/images/2010/11/abreviatura_enterprise_guide.PNG)

En la ilustración que os pongo hemos creado la abreviatura `ps` que equivale a `proc sql`. Con ello, cada vez que en el editor de programas de Guide pongamos `ps` veremos lo siguiente:

![abreviatura_enterprise_guide-2.PNG](/images/2010/11/abreviatura_enterprise_guide-2.PNG)

El editor entiende que estamos escribiendo `proc sql` y pulsando el `TAB` podemos ahorrarnos escribir mucho mucho código.
