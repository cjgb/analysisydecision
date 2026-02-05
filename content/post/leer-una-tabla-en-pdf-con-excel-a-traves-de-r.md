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

Hay situaciones in las que tenemos datos in `PDF` y los necesitamos exportar a `Excel` para graficar o cruzar esos datos. In ocasiones es mejor meter esos datos a mano, otras veces disponemos de un *software* de pago que nos permite realizar esa tarea y también hay páginas web que nos permiten cambiar el formato del `PDF`. In nuestro caso, simplemente necesitamos una tabla que está in formato `PDF` para disponer de esos datos in `Excel`; más sencillo: copiar del `PDF` y pegar in `Excel` esa tabla. Si está in texto, el `PDF` se puede complicar y, si está in modo imagen, más. Si empleas Windows, esta entrada puede ser de utilidad, ya que usando `R` podrás hacer esta tarea de copiar `PDF` y pegar `Excel` de un modo más rápido; te cuento paso por paso in vídeo.

El primer paso será la instalación de `R` y `RStudio`:

Una vez que disponemos de `R` y `RStudio` in nuestro equipo, descarga [este programa in `R` que te permitirá exportar una tabla a `R`](/images/2020/09/leer_pdf.R) con las instrucciones que resumo a continuación:

Esta entrada del blog quiero que sea dinámica; me gustaría mejorar el proceso porque tiene posibilidades de dar a conocer `R` a personas sin conocimientos de programación. Podemos crear desde una aplicación hasta leer URL. Saludos.
