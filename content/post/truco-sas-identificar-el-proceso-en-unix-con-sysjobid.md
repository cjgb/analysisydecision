---
author: rvaquerizo
categories:
  - sas
  - trucos
date: '2009-08-26'
lastmod: '2025-07-13'
related:
  - truco-sas-sysecho-para-controlar-las-ejecuciones-en-enterprise-guide.md
  - trucos-sas-ejecutar-un-codigo-si-existe-una-tabla-o-un-fichero.md
  - truco-sas-observaciones-de-un-dataset-en-una-macro-variable.md
  - macros-faciles-de-sas-numero-de-obsevaciones-de-un-dataset.md
  - macros-faciles-de-sas-busca-duplicados.md
tags:
  - macro
  - sas
title: Truco SAS. Identificar el proceso en Unix con SYSJOBID
url: /blog/truco-sas-identificar-el-proceso-en-unix-con-sysjobid/
---

Un truco SAS muy rápido y que a algún compañero le ha venido muy bien y por eso lo pongo. La macrovariable `&SYSJOBID` nos identifica el *job* de `UNIX` que está corriendo en ese momento. Es una macro del sistema y se halla en el diccionario de macros de SAS. Tenemos una vista en `SASHELP.VMACRO` de cuáles son estas macros `AUTOMATIC`. Curiosead `SASHELP`, tiene algunas vistas muy interesantes; creo que ya he comentado algo sobre ellas.

Vuelvo con `&SYSJOBID.`: solo con poner `PUT &SYSJOBID.` podremos ver en el *log* el ID del proceso `UNIX` que se está ejecutando. De este modo podremos identificarlo para hacerle un `kill -9` en la máquina `UNIX` para parar un proceso colgado. También nos permite identificar qué proceso no vamos a matar. Este truco, que parece una tontería, nos ha librado a muchos de muchos disgustos.
