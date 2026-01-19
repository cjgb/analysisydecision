---
author: rvaquerizo
categories:
  - excel
  - formación
  - monográficos
  - r
  - trucos
date: '2020-09-14'
lastmod: '2025-07-13'
related:
  - truco-malo-de-r-leer-datos-desde-excel.md
  - trucos-r-leer-de-excel-via-rodbc.md
  - seguimiento-del-coronavirus-en-espana-por-comunidad-autonoma-extraer-informacion-de-un-pdf-con-r.md
  - evita-problemas-con-excel-desde-r-de-tocar-el-dato-a-un-proceso.md
  - truco-sas-crear-ficheros-excel-sin-proc-export-ii.md
tags:
  - excel
  - formación
  - monográficos
  - r
  - trucos
title: Leer una tabla en PDF con Excel (a través de R)
url: /blog/leer-una-tabla-en-pdf-con-excel-a-traves-de-r/
---

Hay situaciones en las que tenemos datos en pdf y los necesitamos exportar a Excel para graficar o cruzar esos datos. En ocasiones es mejor meter esos datos a mano, otras veces disponemos de un software de pago que nos permite realizar esa tarea y también hay páginas web que nos permiten cambiar el formato del pdf. En nuestro caso simplemente necesitamos una tabla que está en formato pdf para disponer de esos datos en Excel, más sencillo, copiar del pdf y pegar en Excel esa tabla. Si está en texto el pdf se puede complicar y si está en modo imagen más. Si empleas windows en tu esta entrada puede ser de utilidad ya que usando de R podrás hacer está tarea de copiar pdf y pegar Excel de un modo más rápido, te cuento paso por paso en video.

El primer paso será la instalación de R y RStudio:

Una vez hemos disponemos de R y Rstudio en nuestro equipo descarga [este programa en R que te permitirá exportar una tabla a R](/images/2020/09/leer_pdf.R) con las instrucciones que resumo a continuación:

Esta entrada del blog quiero que sea dinámica, me gustaría mejorar el proceso porque tiene posibilidades de dar a conocer R a personas sin conocimientos de programación. Podemos crear desde una aplicación hasta leer url. Saludos.
